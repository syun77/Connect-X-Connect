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

#define SIMGLE_FALL_ENABLE // １つずつ落下させるモード

// HPの最大値
static const int HP_MAX = 100;

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
    m_Hp = HP_MAX;
    m_TouchState = eState_Standby;
    m_TouchX = 0;
    m_TouchY = 0;
    m_ChipX  = 0;
    m_ChipXPrev = 0;
    
    m_BlockHandler1 = -1;
    m_BlockHandler2 = -1;
    
    
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
- (HpGauge*)_getHpGauge {
    
    return [SceneMain sharedInstance].hpGauge;
}

// タッチ座標をチップ座標に変換する
- (int)touchToChip:(float)p {
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
    
    TokenManager*   mgrBlock    = [self _getManagerBlock];
#ifndef SIMGLE_FALL_ENABLE
    Layer2D*        layer       = [FieldMgr getLayer];
#endif
    
    // ブロック１
    Block* b1 = (Block*)[mgrBlock getFromIdx:m_BlockHandler1];
    [b1 setPosFromChip:m_ChipX chipY:BLOCK_APPEAR_Y1];
    
#ifndef SIMGLE_FALL_ENABLE
    // ブロック２
    Block* b2 = (Block*)[mgrBlock getFromIdx:m_BlockHandler2];
    chipX = m_ChipX;
    int chipY = BLOCK_APPEAR_Y2;
    
    if ([layer get:chipX y:chipY] != 0) {
        
        // ブロックが重なっている
        if (m_ChipX - m_ChipXPrev > 0) {
            
            // 以前の移動方向が＋
            chipX -= 1;
        }
        else {
            
            // 以前の移動方向がー
            chipX += 1;
        }
        chipY += 1;
    }
    
    [b2 setPosFromChip:chipX chipY:chipY];
#endif
}

// タッチ開始コールバック
- (void)cbTouchStart:(float)x y:(float)y {
    
    switch (m_State) {
        case eState_Standby:
            // タッチ中
            m_TouchState = eTouchState_Press;
            
            [self setTouchPos:x y:y];
            break;
            
        default:
            break;
    }
    
}

// タッチ移動中
- (void)cbTouchMove:(float)x y:(float)y {

    switch (m_State) {
        case eState_Standby:
            [self setTouchPos:x y:y];
            break;
            
        default:
            break;
    }

}

// タッチ終了コールバック
- (void)cbTouchEnd:(float)x y:(float)y {
    
    switch (m_State) {
        case eState_Standby:
            // タッチを離した
            m_TouchState = eTouchState_Release;
            
            [self setTouchPos:x y:y];
            break;
            
        default:
            break;
    }

}

- (void)_updateInit {
    
    HpGauge* hpGauge = [self _getHpGauge];
    [hpGauge initHp:[self getHpRatio]];
    
    m_State = eState_Standby;
    
}

- (void)_updateAppearBottomCheck {
    
    // TODO: 下から出現チェック
    Layer2D* layer = [FieldMgr getLayer];
    if ([layer count:0] < 5 * 5) {
        // TODO: 色々埋まっていたら出現しない
        m_Timer = 1;
    }
    
    
    if (m_Timer > 0) {
        
        // 出現しないので、ブロック出現
        m_State = eState_AppearBlock;
        m_Timer = 0;
        return;
    }
    
    // 下から出現
    for(int i = 0; i < FIELD_BLOCK_COUNT_X; i++)
    {
        int number = Math_RandInt(1, 4);
        Block* b = [Block addFromChip:number chipX:i chipY:-1];
        if (b) {
            [b setShield:1];
        }
    }
    
    [BlockMgr changeFallWaitAll];
    
    m_State = eState_AppearBottomExec;
    m_Timer = 0;
}

- (void)_updateAppearBottomExec {
    
    [BlockMgr shiftUpAll:2];
    m_Timer += 2;
    
    if (m_Timer >= BLOCK_SIZE) {
        
        // 消滅チェック
        [FieldMgr copyBlockToLayer];
        m_State = eState_VanishCheck;
    }
}

#ifdef SIMGLE_FALL_ENABLE
- (void)_updateAppearBlock {
    
    // ブロック追加
    int num1 = Math_RandInt(2, 4);
    
    m_ChipXPrev = 0;
    
    Block* b1 = [Block addFromChip:num1 chipX:BLOCK_APPEAR_X chipY:BLOCK_APPEAR_Y1];
    
    m_BlockHandler1 = [b1 getIndex];
    
    [self setTouchPos:GameCommon_ChipXToScreenX(BLOCK_APPEAR_X) y:0];
    
    // ブロックを待機状態にする
    [BlockMgr changeStandbyAll];
    
    [FieldMgr copyBlockToLayer];
    
    m_State = eState_Standby;
}
#else
- (void)_updateAppearBlock {
    
    // ブロック追加
    int num1 = Math_RandInt(2, 5);
    int num2 = Math_RandInt(2, 5);
    
    m_ChipXPrev = 0;
    
    Block* b1 = [Block addFromChip:num1 chipX:BLOCK_APPEAR_X chipY:BLOCK_APPEAR_Y1];
    Block* b2 = [Block addFromChip:num2 chipX:BLOCK_APPEAR_X chipY:BLOCK_APPEAR_Y2];
    
    m_BlockHandler1 = [b1 getIndex];
    m_BlockHandler2 = [b2 getIndex];
    
    [self setTouchPos:GameCommon_ChipXToScreenX(BLOCK_APPEAR_X) y:0];
    
    // ブロックを待機状態にする
    [BlockMgr changeStandbyAll];
    
    m_State = eState_Standby;
}
#endif

- (void)_updateStandby {
    
//    InterfaceLayer* interface   = [self _getInterfaceLayer];
    TokenManager*   mgrBlock    = [self _getManagerBlock];
    Layer2D*        layer       = [FieldMgr getLayer];
    Cursor*         cursor      = [SceneMain sharedInstance].cursor;
    
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
    
    static int s_cnt = 0;
    s_cnt++;
  
    if (NO) {
//    if ([interface isTouch]) {
        
        // すべて消す
        [mgrBlock vanishAll];
        
        s_cnt = 0;
    }
    
    if (s_cnt == 1) {
        
        // ブロック生成テスト
        [layer random:5];
        [layer set:2 y:5 val:5];
        [layer set:2 y:2 val:3];
        [layer set:1 y:0 val:1];
//        [layer dump];
        
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

- (void)_updateVanishCheck {
    
    [FieldMgr copyBlockToLayer];
    
    // 消去判定
    [layerVanish clear];
    Layer2D* layer = [FieldMgr getLayer];
    
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
                }
            }
        }
    }
    
    [self.layerVanish dump];
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
    
    if ([BlockMgr isEndVanishingAll]) {
        
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
        m_Hp -= cnt * 10;
        
        HpGauge* hpGauge = [self _getHpGauge];
        [hpGauge setHp:[self getHpRatio]];
        return;
    }
    
    // ブロック出現 (下) チェック
    m_State = eState_AppearBottomCheck;
    
}

/**
 * ダメージ実行
 */
- (void)_updateDamageExec {

    if ([BlockMgr isEndVanishingAll]) {
        
        // ブロック出現 (下) チェック
        m_State = eState_AppearBottomCheck;
        
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
 * HPを取得する
 * @return HP
 */
- (int)getHp {
    return m_Hp;
}

/**
 * HPの割合を取得する
 */
- (float)getHpRatio {
    
    return (float)m_Hp / HP_MAX;
}

@end
