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
    m_State = eState_Init;
    m_Timer = 0;
    m_TouchState = eState_Standby;
    m_TouchStartY = 0;
    m_TouchX = 0;
    m_TouchY = 0;
    m_ChipX  = 0;
    m_ChipXPrev = 0;
    
    m_BlockHandler1 = -1;
    
    m_NumberPrev = 1;
    
    m_ReqAppearBottom = NO;
    m_nBlockLevel = 5;
    
    
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

// タッチ座標をチップ座標に変換する
- (int)touchToChip:(float)p {
    
    int s = BLOCK_SIZE/2;
    if (p < FIELD_OFS_X - s || p > FIELD_OFS_X + FIELD_BLOCK_COUNT_X * BLOCK_SIZE - s) {
        
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
    
    TokenManager* mgrBlock = [self _getManagerBlock];
    
    // ブロック１
    Block* b1 = (Block*)[mgrBlock getFromIdx:m_BlockHandler1];
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
    
    // HPの初期化
    Player* player = [self _getPlayer];
    [player initHp];
    
    Enemy* enemy = [self _getEnemy];
    [enemy initHp];
    
    m_State = eState_Standby;
    
    // TODO: テスト
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
        m_State = eState_Fall;
    }
}

/**
 * ブロックが下から出現 (チェック)
 */
- (void)_updateAppearBottomCheck {
    
    if (m_ReqAppearBottom == NO) {
        
        // 出現要求なし
        // ブロック出現
        m_State = eState_AppearBlock;
        m_Timer = 0;
        return;
    }
    
    // 下から出現
    m_ReqAppearBottom = NO;
    for(int i = 0; i < FIELD_BLOCK_COUNT_X; i++)
    {
        int number = Math_RandInt(1, m_nBlockLevel);
        Block* b = [Block addFromChip:number chipX:i chipY:-1];
        if (b) {
            [b setShield:1];
        }
    }
    
    [BlockMgr changeFallWaitAll];
    
    m_State = eState_AppearBottomExec;
    m_Timer = 0;
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
        m_State = eState_VanishCheck;
    }
}

/**
 * 操作ブロック出現
 */
- (void)_updateAppearBlock {
    
    // ブロック追加
    int num1 = Math_RandInt(2, m_nBlockLevel);
    
    // 出現番号を保存
    m_NumberPrev = num1;
    
    m_ChipXPrev = 0;
    
    Block* b1 = [Block addFromChip:num1 chipX:BLOCK_APPEAR_X chipY:BLOCK_APPEAR_Y1];
    
    m_BlockHandler1 = [b1 getIndex];
    
    [self setTouchPos:GameCommon_ChipXToScreenX(BLOCK_APPEAR_X) y:0];
    
    // ブロックを待機状態にする
    [BlockMgr changeStandbyAll];
    
    [FieldMgr copyBlockToLayer];
    
    // タッチ状態をクリア
    m_TouchState = eTouchState_Standby;
    
    // タッチ入力待ちへ
    m_State = eState_Standby;
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
        // 落下要求を送る
        [BlockMgr requestFall];
        
        
        // 落下状態へ遷移
        m_State = eState_Fall;
            
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
        m_State = eState_VanishCheck;
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
    int nVanish = 0;
    
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
                    
                    nVanish++;
                    
                    // HPを増やす
//                    int v = cnt * val / 3 + 1;
//                    [player addHp:v];
                    
                    // 敵にダメージを与える
                    BezierEffect* eft = [BezierEffect addFromChip:i chipY:j];
                    if (eft) {
                        
                        int frame  = BEZIEREFFECT_FRAME + Math_RandInt(-10, 10);
                        int damage = cnt * val;
                        
                        [eft setParamDamage:eBezierEffect_Enemy frame:frame damage:damage];
                    }
                    
                }
            }
        }
    }
    
    if (nVanish == 0) {
        
        // 消去できるものはない
        // ダメージチェックへ
        m_State = eState_DamageCheck;
        return;
    }
    
    
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
                        
                        // シールドを減らす
                        [b decShield];
                    }
                }
            }
        }
    }
    
    // 消去演出中
    m_State = eState_VanishExec;
}

- (void)_updateVanishExec {
    
//    if ([BlockMgr isEndVanishingAll]) {
    if ([BezierEffect countExist] == 0) {
        
        Enemy* enemy = [self _getEnemy];
        if ([enemy isDead]) {
            
            // TODO: 勝利演出へ
            
        }
        
        // 待機状態にする
        [BlockMgr changeStandbyAll];
        
        // 落下要求を送る
        [BlockMgr requestFall];
        
        
        // 落下状態へ遷移
        m_State = eState_Fall;
    }
}

/**
 * ダメージチェック
 */
- (void)_updateDamageCheck {
    
    int cnt = [BlockMgr vanishOutOfField];
    
    if (cnt > 0) {
        
        // ダメージあり
        m_State = eState_DamageExec;
        
        return;
    }
    
    // ブロック出現 (下) チェック
    m_State = eState_AppearBottomCheck;
    
}

/**
 * ダメージ実行
 */
- (void)_updateDamageExec {

    if ([BlockMgr isEndVanishingAll] && [BezierEffect countExist] == 0) {
        
        Player* player = [self _getPlayer];
        if ([player isDead]) {
            
            // ゲームオーバーへ
            m_State = eState_Gameover;
            m_TouchState = eTouchState_Standby;
            [[SceneMain sharedInstance].fontGameover setVisible:YES];
            return;
        }
        
        // ブロック出現 (下) チェック
//        m_State = eState_AppearBottomCheck;
        // 待機状態にする
        [BlockMgr changeStandbyAll];
        
        // 落下要求を送る
        [BlockMgr requestFall];
        
        
        // 落下状態へ遷移
        m_State = eState_Fall;
 
        
    }
}

- (void)_updateGameover {
    
    if (m_TouchState == eTouchState_Release) {
        
        [[SceneMain sharedInstance].fontGameover setVisible:NO];
        
        // すべて消す
        TokenManager* mgrBlock = [self _getManagerBlock];
        [mgrBlock vanishAll];
        
        // HPの初期化
        Player* player = [self _getPlayer];
        [player initHp];
        
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
        m_State = eState_Fall;
    }
}

// -----------------------------------------------------
// public
/**
 * 更新
 */
- (void)update:(ccTime)dt {
    
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

@end
