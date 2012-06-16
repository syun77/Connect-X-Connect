//
//  MainCtrl.mm
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/05/31.
//  Copyright 2012年 2dgame.jp. All rights reserved.
//

#import "MainCtrl.h"
#import "SceneMain.h"
#import "BlockMgr.h"
#import "FieldMgr.h"
#import "Math.h"
#import "FixedArray.h"

static const int TIMER_ENEMY_VANISH = 60;

/**
 * 状態
 */
enum eState {
    eState_Init,                // 初期化
    eState_AppearBottomCheck,   // ブロック出現（下から）チェック
    eState_AppearBottomExec,    // ブロック出現（下から）実行
    eState_AppearBlock,         // ブロック出現
    eState_Standby,             // 待機中
    eState_Fall,                // 落下中
    eState_VanishCheck,         // 消去チェック
    eState_VanishExec,          // 消去実行
    eState_DamageCheck,         // ダメージチェック
    eState_DamageExec,          // ダメージ実行
    eState_WinLoseCheck,        // 勝敗チェック
    eState_EnemyAI,             // 敵のAI実行
    eState_Win,                 // 勝利演出
    eState_Lose,                // 敗北演出
    eState_Gameover,            // ゲームオーバー
    eState_End,                 // おしまい
};

/**
 * タッチ状態
 */
enum eTouchState {
    eTouchState_Standby,    // タッチしていない
    eTouchState_Press,      // タッチ中
    eTouchState_Release,    // タッチを離した
};

/**
 * ゲームメインのコントローラー実装
 */
@implementation MainCtrl

@synthesize layerVanish;
@synthesize layerTmp;

/**
 * コンストラクタ
 */
- (id)init {
    
    self = [super init];
    if (self == nil) {
        
        return self;
    }
    
    self.layerVanish = [[[Layer2D alloc] init] autorelease];
    [self.layerVanish create:FIELD_BLOCK_COUNT_X h:FIELD_BLOCK_COUNT_Y];
    self.layerTmp = [[[Layer2D alloc] init] autorelease];
    [self.layerTmp create:FIELD_BLOCK_COUNT_X h:FIELD_BLOCK_COUNT_Y];
    
    // 変数の初期化
    m_StatePrev = eState_Init;
    m_State = eState_Init;
    m_Timer = 0;
    m_TouchState = eTouchState_Standby;
    m_TouchStartY = 0;
    m_TouchX = 0;
    m_TouchY = 0;
    m_ChipX  = 0;
    m_ChipXPrev = 0;
    
    m_BlockHandler1 = -1;
    
    m_NumberPrev = 1;
    
    m_nBlockLevel = 1;
    
    m_nLevel = 1;
    
//    for (int i = 0; i < BLOCK_NEXT_COUNT; i++) {
//        
//        // 出現ブロックをキューに積んでおく
//        m_Queue.push(Math_RandInt(2, m_nBlockLevel));
//    }
    
    m_bCombo = NO;
    m_nCombo = 0;
    m_nTurn = 0;
    m_bChainCheck = NO;
    
    Sound_PlayBgm(@"alyssum.mp3");
    
    return self;
}

/**
 * デストラクタ
 */
- (void)dealloc {
    
    self.layerVanish = nil;
    
    [super dealloc];
}

// -----------------------------------------------------
// private
- (NSString*)_getState:(eState)s {
    switch (s) {
        case eState_Init: { return @"Init"; }                // 初期化
        case eState_AppearBottomCheck: { return @"AppearBottomCheck"; }   // ブロック出現（下から）チェック
        case eState_AppearBottomExec: { return @"AppearBottomExec"; }    // ブロック出現（下から）実行
        case eState_AppearBlock: { return @"AppearBlock"; }         // ブロック出現
        case eState_Standby: { return @"Standby"; }             // 待機中
        case eState_Fall: { return @"Fall"; }                // 落下中
        case eState_VanishCheck: { return @"VanishCheck"; }         // 消去チェック
        case eState_VanishExec: { return @"VanishExec"; }          // 消去実行
        case eState_DamageCheck: { return @"DamageCheck"; }         // ダメージチェック
        case eState_DamageExec: { return @"DamageExec"; }          // ダメージ実行
        case eState_WinLoseCheck: { return @"WinLoseCheck"; }        // 勝敗チェック
        case eState_EnemyAI: { return @"EnemyAI"; } // 敵のAI実行
        case eState_Win: { return @"Win"; }                 // 勝利演出
        case eState_Lose: { return @"Lose"; }                // 敗北演出
        case eState_Gameover: { return @"Gameover"; }            // ゲームオーバー
        case eState_End: { return @"End"; }                 // おしまい
        default:
            assert(0);
            return @"None";
    }
}

- (void)_changeState:(eState)s {
    
//    NSLog(@"ChangeState %@ -> %@", [self _getState:(eState)m_State], [self _getState:s]);
    
    m_StatePrev = m_State;
    m_State = s;
//    m_Timer = 0;
}

- (InterfaceLayer*)_getInterfaceLayer {
    
    return [SceneMain sharedInstance].interfaceLayer;
}
- (TokenManager*)_getManagerBlock {
    
    return [SceneMain sharedInstance].mgrBlock;
}
- (Player*)_getPlayer {
    return [SceneMain sharedInstance].player;
}
- (Enemy*)_getEnemy {
    return [SceneMain sharedInstance].enemy;
}
- (Back*)_getBack {
    return [SceneMain sharedInstance].back;
}
- (AsciiFont*)_getFontLevelup {
    return [SceneMain sharedInstance].fontLevelup;
}
- (Chain*)_getChain {
    return [SceneMain sharedInstance].chain;
}
- (Combo*)_getCombo {
    return [SceneMain sharedInstance].combo;
}
- (BlockLevel*)_getBlockLevel {
    return [SceneMain sharedInstance].blockLevel;
}

- (void)_initChain {
    m_nChain  = 0;
    m_nVanish = 0;
    m_nKind   = 0;
}

// タッチ座標をチップ座標に変換する
- (int)touchToChip:(float)p {
    
    if (m_TouchY > 320) {
        
        // 非選択状態にする
        m_TouchState = eTouchState_Standby;
    }
    
    int v = (int)(p - FIELD_OFS_X);
    int n = v / BLOCK_SIZE;
    int d = v - n * BLOCK_SIZE;
    if (d > BLOCK_SIZE/2) {
        n += 1;
    }
    
    if (n > FIELD_BLOCK_COUNT_X-1) {
        n = FIELD_BLOCK_COUNT_X-1;
    }
    
    return n;
}

// タッチ座標を更新
- (void)setTouchPos:(float)x y:(float)y {
    
    m_TouchX = x;
    m_TouchY = y;
    
    int chipX = [self touchToChip:m_TouchX];
    if (m_ChipX != chipX) {
        
        // タッチしている座標を更新
        m_ChipXPrev = m_ChipX;
        m_ChipX = chipX;
    }
    
    // ブロック１
    Block* b1 = [BlockMgr getFromIndex:m_BlockHandler1];
    [b1 setPosFromChip:m_ChipX chipY:BLOCK_APPEAR_Y1];
    
}

// タッチ開始コールバック
- (void)cbTouchStart:(float)x y:(float)y {
    
    m_TouchStartY = y;
    
    switch (m_State) {
        case eState_Standby:
            // タッチ中
            m_TouchState = eTouchState_Press;
            
            [self setTouchPos:x y:y];
            break;
            
        case eState_Gameover:
            m_TouchState = eTouchState_Press;
            break;
            
        default:
            break;
    }
    
}

// タッチ移動中
- (void)cbTouchMove:(float)x y:(float)y {

    switch (m_State) {
        case eState_Standby:
            if (m_TouchState == eTouchState_Press) {
                
                [self setTouchPos:x y:y];
            }
            break;
            
        default:
            break;
    }
    

}

// タッチ終了コールバック
- (void)cbTouchEnd:(float)x y:(float)y {
    
    switch (m_State) {
        case eState_Standby:
            
            if (m_TouchState == eTouchState_Standby) {
                
                // 非選択状態の場合何もしない
                break;
            }
            
            // タッチを離した
            m_TouchState = eTouchState_Release;
            
            [self setTouchPos:x y:y];
            break;
            
        case eState_Gameover:
            if (m_TouchState == eTouchState_Press) {
                
                m_TouchState = eTouchState_Release;
            }
            break;
            
        default:
            break;
    }

}

/**
 * 更新・初期化
 */
- (void)_updateInit {
    
    // 出現ブロック設定
    BlockLevel* level = [self _getBlockLevel];
    [level setLevel:m_nBlockLevel];
    
    for (int i = 0; i < BLOCK_NEXT_COUNT; i++) {
        
        // 出現ブロックをキューに積んでおく
        m_Queue.push([level getNumber]);
//        m_Queue.push(Math_RandInt(2, m_nBlockLevel));
    }
    
    // 連鎖数初期化
    [self _initChain];
    
    // HPの初期化
    Player* player = [self _getPlayer];
    [player initialize];
    
    Enemy* enemy = [self _getEnemy];
    [enemy setLevel:m_nLevel];
    [enemy initialize];
    
    [self _changeState:eState_AppearBlock];
    
    // TODO: テスト
    if (NO)
    {
        // 初期化に戻る
        Layer2D* layer = [FieldMgr getLayer];
        
        // ブロック生成テスト
        [layer random:6];
        
        for (int i = 0; i < FIELD_BLOCK_COUNT_MAX; i++) {
            int v = [layer getFromIdx:i];
            if (v > 0) {
                Block* b = [Block addFromIdx:v idx:i];
                
                if (Math_Rand(5) == 0) {
                    [b setShield:2];
                }
            }
        }
        
        // 落下要求を送る
        [BlockMgr requestFall];
        
        
        // 落下状態へ遷移
        [self _changeState:eState_Fall];
    }
}

/**
 * 上から出現
 */
- (void)_appearUpper {
    
    // 出現位置をランダムに決める
    FixedArray arr;
    for (int i = 0; i < FIELD_BLOCK_COUNT_X; i++) {
        arr.push(i);
    }
    arr.shuffle();
    
    int count = m_ReqParam.count;
    if (count >= FIELD_BLOCK_COUNT_X) {
        
        count = FIELD_BLOCK_COUNT_X;
    }
    
    BlockLevel* level = [self _getBlockLevel];
    
    for (int i = 0; i < count; i++) {
        
        // ブロック発生
        int x = arr.get(i);
//        int number = Math_RandInt(2, m_nBlockLevel);
        int number = [level getNumber];
        Block* b = [Block addFromChip:number chipX:x chipY:FIELD_BLOCK_COUNT_Y];
        if (m_ReqParam.nShield > 0) {
            
            // シールド設定
            [b setShield:m_ReqParam.nShield];
        }
        
        float rRnd = Math_Randf(1);
        if (rRnd < m_ReqParam.rSkull) {
            
            // ドクロブロック
            [b setSkull];
        }
        
        // 出現エフェクト生成
        [Particle addBlockAppear:b._x y:b._y];
        
    }
    
    // 配置した分だけ減らす
    m_ReqParam.count -= count;
    if (m_ReqParam.count <= 0) {
        
        // 全て配置したら敵の攻撃終了
        // 敵の攻撃終了
        m_ReqParam.clear();
        Enemy* enemy = [self _getEnemy];
        [enemy endTurn];
    }
}


/**
 * ブロックが下から出現 (チェック)
 */
- (void)_updateAppearBottomCheck {
    
    if (m_ReqParam.isRequest()) {
        
        // 落下リクエストあり
        if (m_ReqParam.type == eReqBlock_Upper) {
            
            // 上から出現
            [self _appearUpper];
            
            Sound_PlaySe(@"encount.wav");
            
            // 落下要求を送る
            [BlockMgr requestFall];
            
            // 落下状態へ遷移
            [self _changeState:eState_Fall];
            
            return;
        
        }
        else { //if(m_ReqParam.type == eReqBlock_Bottom)
            
            // 下から出現
//            [self _appearBottom];
            BlockLevel* level = [self _getBlockLevel];
            
            for(int i = 0; i < FIELD_BLOCK_COUNT_X; i++)
            {
//                int number = Math_RandInt(1, m_nBlockLevel);
                int number = [level getNumberBottom];
                Block* b = [Block addFromChip:number chipX:i chipY:-1];
                if (b) {
                    [b setShield:1];
                }
            }
            
            // 要求ライン数を減らす
            m_ReqParam.nLine--;
            
            if (m_ReqParam.nLine <= 0) {
                
                // 全て配置したら敵の攻撃終了
                // 敵の攻撃終了
                m_ReqParam.clear();
                Enemy* enemy = [self _getEnemy];
                [enemy endTurn];
            }
            
            [BlockMgr changeFallWaitAll];
            
            [self _changeState:eState_AppearBottomExec];
            m_Timer = 0;
            
            return;
        }
        
    }
    
    // 出現要求なし
    // ブロック出現
    [self _changeState:eState_AppearBlock];
    m_Timer = 0;
    return;
    
}

/**
 * ブロックが下から出現 (実行)
 */
- (void)_updateAppearBottomExec {
    
    [BlockMgr shiftUpAll:2];
    m_Timer += 2;
    
    if (m_Timer >= BLOCK_SIZE) {
        
        // 消滅チェック
        [FieldMgr copyBlockToLayer];
        [self _changeState:eState_VanishCheck];
    }
}

/**
 * インデックスに対応する次のブロックを取得する
 * @param idx インデックス
 * @return 次のブロック
 */
- (BlockNext*)_getNextBlock:(int)idx {
    
    SceneMain* scene = [SceneMain sharedInstance];
    switch (idx) {
        case 0:
            return scene.blockNext1;
            
        case 1:
            return scene.blockNext2;
            
        case 2:
        default:
            return scene.blockNext3;
            break;
    }
}

/**
 * 足りないブロックを積んでおく
 */
- (void)_pushBlockNext {
    
    BlockLevel* level = [self _getBlockLevel];
    int cnt = BLOCK_NEXT_COUNT - m_Queue.count();
    
    // 足りない分を積んでおく
    for (int i = 0; i < cnt; i++) {
        
//        int v = Math_RandInt(2, m_nBlockLevel);
        int v = [level getNumber];
        
        m_Queue.push(v);
    }
    
    // フォントに反映
    for (int i = 0; i < BLOCK_NEXT_COUNT; i++) {
        
        int v = m_Queue.getFromIndex(i);
        BlockNext* next = [self _getNextBlock:i];
        
        [next setParam:i nNumber:v];
    }
    
}

/**
 * 操作ブロック出現
 */
- (void)_updateAppearBlock {
    
    // 色々初期化
    {
        // ターン数を加算
        m_nTurn++;
        
        // 敵のターンを進める
        Enemy* enemy = [self _getEnemy];
        [enemy doTurn];
        
        AsciiFont* font = [SceneMain sharedInstance].fontTurn;
        [font setText:[NSString stringWithFormat:@"Turn:%d", m_nTurn]];
        
    }
    
    {
        // コンボチェック済みフラグを下げる
        m_bCombo = NO;
    }
    
    // ブロック追加
    [self _pushBlockNext];
    
    // キューから取り出し
    int num1 = m_Queue.pop();
    
    [self _pushBlockNext];
    
    
    // 出現番号を保存
    m_NumberPrev = num1;
    
    m_ChipXPrev = 0;
    
    Block* b1 = [Block addFromChip:num1 chipX:BLOCK_APPEAR_X chipY:BLOCK_APPEAR_Y1];
    
    m_BlockHandler1 = [b1 getIndex];
    
    [self setTouchPos:GameCommon_ChipXToScreenX(BLOCK_APPEAR_X) y:0];
    
    // ブロックを待機状態にする
    [BlockMgr changeStandbyAll];
    
    // 操作状態にする
    [b1 changeSlide];
    
    [FieldMgr copyBlockToLayer];
    
    // タッチ状態をクリア
    m_TouchState = eTouchState_Standby;
    
    // タッチ入力待ちへ
    [self _changeState:eState_Standby];
}

/**
 * 更新・待機中
 */
- (void)_updateStandby {
    
    Cursor* cursor = [SceneMain sharedInstance].cursor;
    
    [cursor setDraw:NO chipX:m_ChipX];
    if (m_TouchState == eTouchState_Press) {
        
        // ブロック移動
        [cursor setDraw:YES chipX:m_ChipX];
        
    }
    else if(m_TouchState == eTouchState_Release) {
        
        // タッチを離した
        m_TouchState = eTouchState_Standby;
        
        // 下にブロックがなければ置ける
        // 操作中のブロックを待機状態にする
        Block* b = [BlockMgr getFromIndex:m_BlockHandler1];
        [b changeStandby];
        
        // 落下要求を送る
        [BlockMgr requestFall];
        
        Sound_PlaySe(@"sa.wav");
        
        
        // 落下状態へ遷移
        [self _changeState:eState_Fall];
            
    }
    else {
        
    }
    
}

/**
 * 更新・落下中
 */
- (void)_updateFall {
    
    if ([BlockMgr isFallWaitAll]) {
        
        // 消去判定
        [self _changeState:eState_VanishCheck];
    }
}

- (void)_setLayerVanish {
    
    for (int j = 0; j < FIELD_BLOCK_COUNT_Y; j++) {
        
        for (int i = 0; i < FIELD_BLOCK_COUNT_X; i++) {
            
            int val = [self.layerTmp get:i y:j];
            if (val > 0) {
                
                // 消去対象に入れておく
                [self.layerVanish set:i y:j val:val];
            }
        }
    }
}

/**
 * 再帰で消去チェック
 */
- (int)_checkVanish:(int)x y:(int)y dx:(int)dx dy:(int)dy val:(int)val cnt:(int)cnt {
    
    x += dx;
    y += dy;
    
    if ([self.layerVanish get:x y:y] != 0) {
        
        // 消去対象 or 領域外
        return cnt;
    }
    
    if ([self.layerTmp get:x y:y] != 0) {
        
        // チェック済み
        return cnt;
    }
    
    Layer2D* layer = [FieldMgr getLayer];
    
    
    int v = [layer get:x y:y];
    if (v != val) {
        
        // 消去対象とならない
        return cnt;
    }
        
    // 指定の番号に一致した
    // 消去対象に入れておく
    [self.layerTmp set:x y:y val:1];
    cnt++;
    cnt = [self _checkVanish:x y:y dx:-1 dy: 0 val:val cnt:cnt];
    cnt = [self _checkVanish:x y:y dx: 0 dy:-1 val:val cnt:cnt];
    cnt = [self _checkVanish:x y:y dx:+1 dy: 0 val:val cnt:cnt];
    cnt = [self _checkVanish:x y:y dx: 0 dy:+1 val:val cnt:cnt];
    
    return cnt;
}

/**
 * 更新・消去チェック
 */
- (void)_updateVanishCheck {
    
    [FieldMgr copyBlockToLayer];
    
    // 消去判定
    [layerVanish clear];
    Layer2D* layer = [FieldMgr getLayer];
//    Player* player = [self _getPlayer];
    
    // 消去できた数
    int nVanish  = 0;
    int nKind    = 0;
    int nConnect = 0;
    
    for (int j = 0; j < FIELD_BLOCK_COUNT_Y; j++) {
        
        for (int i = 0; i < FIELD_BLOCK_COUNT_X; i++) {
            
            [layerTmp clear];
            int val = [layer get:i y:j];
            if (val > 0) {
                
                // ブロックが存在する
                int cnt = [self _checkVanish:i y:j dx:0 dy:0 val:val cnt:0];
                
                if (cnt >= val) {
                    
                    // 消去できた
                    [self _setLayerVanish];
                    
                    // 消去数アップ
                    nVanish += cnt;
                    
                    // 消去グループ数アップ
                    nKind++;
                    
                    // 接続数アップ
                    if (nConnect < cnt) {
                        nConnect = cnt;
                    }
                    
                    // 敵にダメージを与える
                    BezierEffect* eft = [BezierEffect addFromChip:i chipY:j];
                    if (eft) {
                        
                        int frame  = BEZIEREFFECT_FRAME + Math_RandInt(-10, 10);
                        
                        // ダメージは後で計算する
                        int damage = 0;
                        
                        [eft setParamDamage:eBezierEffect_Enemy frame:frame damage:damage];
                    }
                    
                }
            }
        }
    }
    
    if (nVanish == 0) {
        
        // 消去できるものはない
        // 連鎖チェック完了
        m_bChainCheck = NO;
        
        if (m_nChain == 0) {
            
            // 連鎖なしでコンボ回数リセット
            m_nCombo = 0;
            Combo* combo = [self _getCombo];
            [combo end];
        }
        
        // ダメージチェックへ
        [self _changeState:eState_DamageCheck];
        return;
    }
    
    // 消去できたので連鎖回数アップ
    m_nChain++;
    m_nConnect = nConnect;
    m_nVanish = nVanish;
    m_nKind = nKind;
    
    if (m_nChain == 1) {
        
        // 最初の連鎖でコンボ回数を増やす
        m_nCombo++;
        Combo* combo = [self _getCombo];
        [combo begin:m_nCombo];
        
        // 連鎖チェック開始
        m_bChainCheck = YES;
    }
    
    // 連鎖エフェクト表示
    Chain* chain = [self _getChain];
    [chain requestAppear:m_nChain];
    
    // エフェクト出現位置は全消去ブロックの平均
    
    // 消去実行
    for (int j = 0; j < FIELD_BLOCK_COUNT_Y; j++) {
        
        for (int i = 0; i < FIELD_BLOCK_COUNT_X; i++) {
        
            int val = [layerVanish get:i y:j];
            if (val > 0) {
                // 消去要求を出す
                [BlockMgr requestVanish:i y:j];
                
                // 上下左右にあるブロックのシールドを減らす
                int tblX[] = { -1,  0, 1, 0 };
                int tblY[] = {  0, -1, 0, 1 };
                for (int k = 0; k < 4; k++) {
                    int dx = tblX[k];
                    int dy = tblY[k];
                    
                    Block* b = [BlockMgr getFromChip:i+dx chipY:j+dy];
                    if (b) {
                        
                        if ([b isShield]) {
                            
                            // シールドを減らす
                            [b decShield];
                        }
                        else if([b isSkull]) {
                            
                            // ドクロなら消滅
                            [BlockMgr requestVanish:i+dx y:j+dy];
                        }
                    }
                }
            }
        }
    }
    
    Sound_PlaySe(@"swing.wav");
    
    // 消去演出中
    [self _changeState:eState_VanishExec];
}

- (void)_updateVanishExec {
    
    if ([BlockMgr isEndVanishingAll] == NO) {
        
        // 消滅演出が終わっていない
        return;
    }
    if ([BezierEffect countExist] > 0) {
        
        // ダメージエフェクトが残っている
        return;
    }
        
    // 敵にダメージを与える
    int v = GameCommon_GetScore(m_nVanish, m_nConnect, m_nKind, m_nChain, m_nCombo);
    Enemy* enemy = [self _getEnemy];
    [enemy damage:v];
    
    [self _changeState:eState_WinLoseCheck];
}

/**
 * ダメージチェック
 */
- (void)_updateDamageCheck {
    
    int cnt = [BlockMgr vanishOutOfField];
    
    if (cnt > 0) {
        
        // ダメージあり
        [self _changeState:eState_DamageExec];
        
        Sound_PlaySe(@"swing.wav");
        return;
    }
    
    // 勝敗チェック
    [self _changeState:eState_WinLoseCheck];
    
}

/**
 * ダメージ実行
 */
- (void)_updateDamageExec {

    if ([BlockMgr isEndVanishingAll] && [BezierEffect countExist] == 0) {
        
        // 勝利敗北判定へ
        [self _changeState:eState_WinLoseCheck];
        
    }
}

/**
 * 勝利・敗北判定
 */
- (void)_updateWinLoseCheck {
    
    Player* player = [self _getPlayer];
    Enemy* enemy = [self _getEnemy];
    
    if ([player isDead]) {
        
        // 敗北処理へ
        [self _changeState:eState_Lose];
        [player destroy];
        return;
    }
    
    if ([enemy isDead]) {
        
        // 勝利処理へ
        [self _changeState:eState_Win];
        m_Timer = TIMER_ENEMY_VANISH;
        [enemy destroy];
        AsciiFont* font = [self _getFontLevelup];
        [font setVisible:YES];
        
        // レベルを増やす
        m_nLevel++;
        
        
        return;
    }
    
    if (m_bChainCheck) {
        // 連鎖チェックが必要
        // 待機状態にする
        [BlockMgr changeStandbyAll];
        
        // 落下要求を送る
        [BlockMgr requestFall];
        
        
        // 落下状態へ遷移
        [self _changeState:eState_Fall];
        
        return;
    }
    
    // 連鎖回数などを初期化
    [self _initChain];
    
    // 敵のAI実行へ
    [self _changeState:eState_EnemyAI];
    
}

/**
 * 更新・敵のAI実行
 */
- (void)_updateEnemyAI {
    
    Enemy* enemy = [self _getEnemy];
    if ([enemy isAttack]) {
        
        // 攻撃開始
        [enemy doAttack];
    }
    
    // ブロック出現 (下) チェック
    [self _changeState:eState_AppearBottomCheck];
    
}

/**
 * 更新・勝利演出
 */
- (void)_updateWin {
    
    if (m_Timer > 0) {
        m_Timer--;
        return;
    }
    
    // レベルアップ演出を消す
    AsciiFont* font = [self _getFontLevelup];
    [font setVisible:NO];
    
    Enemy* enemy = [self _getEnemy];
    
    // 敵出現開始
    [enemy setLevel:m_nLevel];
    [enemy initialize];
    
    // 待機状態にする
    [BlockMgr changeStandbyAll];
    
    // 落下要求を送る
    [BlockMgr requestFall];
    
    // 落下状態へ遷移
    [self _changeState:eState_Fall];
}

/**
 * 更新・敗北演出
 */
- (void)_updateLose {
    
    // ゲームオーバ処理へ
    m_TouchState = eTouchState_Standby;
    [[SceneMain sharedInstance].fontGameover setVisible:YES];
    
    [self _changeState:eState_Gameover];
}

/**
 * 更新・ゲームオーバー
 */
- (void)_updateGameover {
    
    if (m_TouchState == eTouchState_Release) {
        
        
        // TODO: テスト用に無限プレイ
        [[SceneMain sharedInstance].fontGameover setVisible:NO];
        
        // すべて消す
        TokenManager* mgrBlock = [self _getManagerBlock];
        [mgrBlock vanishAll];
        
        // HPの初期化
        Player* player = [self _getPlayer];
        [player initialize];
        
        // 初期化に戻る
        Layer2D* layer = [FieldMgr getLayer];
        
        // ブロック生成テスト
        [layer random:6];
        
        for (int i = 0; i < FIELD_BLOCK_COUNT_MAX; i++) {
            int v = [layer getFromIdx:i];
            if (v > 0) {
                Block* b = [Block addFromIdx:v idx:i];
                
                if (Math_Rand(5) == 0) {
                    [b setShield:2];
                }
            }
        }
        
        // 落下要求を送る
        [BlockMgr requestFall];
        
        
        // 落下状態へ遷移
        [self _changeState:eState_Fall];
    }
}

// -----------------------------------------------------
// public
/**
 * 更新
 */
- (void)update:(ccTime)dt {
    
    {
        Back* back = [self _getBack];
        
        if ([BezierEffect countExist] > 0) {
            
            // ベジェエフェクトがあれば背景を暗くする
            [back beginDark];
        }
        else {
            
            [back beginLight];
        }
    }
    
    
    switch (m_State) {
            
        case eState_Init:
            [self _updateInit];
            break;
            
        case eState_AppearBottomCheck:
            [self _updateAppearBottomCheck];
            break;
            
        case eState_AppearBottomExec:
            [self _updateAppearBottomExec];
            break;
            
        case eState_AppearBlock:
            [self _updateAppearBlock];
            break;
            
        case eState_Standby:
            [self _updateStandby];
            break;
            
        case eState_Fall:
            [self _updateFall];
            break;
            
        case eState_VanishCheck:
            [self _updateVanishCheck];
            break;
            
        case eState_VanishExec:
            [self _updateVanishExec];
            break;
            
        case eState_DamageCheck:
            [self _updateDamageCheck];
            break;
            
        case eState_DamageExec:
            [self _updateDamageExec];
            break;
            
        case eState_WinLoseCheck:
            [self _updateWinLoseCheck];
            break;
            
        case eState_EnemyAI:
            [self _updateEnemyAI];
            break;
            
        case eState_Win:
            [self _updateWin];
            break;
            
        case eState_Lose:
            [self _updateLose];
            break;
            
        case eState_Gameover:
            [self _updateGameover];
            break;
            
        default:
            break;
    }
}

/**
 * 終了したかどうか
 * @return 終了していれば「YES」
 */
- (BOOL)isEnd {
    
    return m_State == eState_End;
}

/**
 * ブロック落下要求を送る
 * @param req リクエストパラメータ
 */
- (void)reqestBlock:(ReqBlock)req {
    
    m_ReqParam = req;
}

@end
