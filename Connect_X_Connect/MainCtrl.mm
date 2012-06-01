//
//  MainCtrl.mm
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/05/31.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
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
    eState_AddBlock,    // ブロック追加
    eState_Standby,     // 待機中
    eState_Fall,        // 落下中
    eState_VanishCheck, // 消去チェック
    eState_VanishExec,  // 消去実行
    eState_End,         // おしまい
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
    m_State = eState_Standby;
    m_Timer = 0;
    m_TouchState = eState_Standby;
    m_TouchX = 0;
    m_TouchY = 0;
    m_ChipX  = 0;
    
    m_BlockHandler = -1;
    
    
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

// タッチ開始コールバック
- (void)cbTouchStart:(float)x y:(float)y {
    
    // タッチ中
    m_TouchState = eTouchState_Press;
    m_TouchX = x;
    m_TouchY = y;
    
}

// タッチ移動中
- (void)cbTouchMove:(float)x y:(float)y {
    
    m_TouchX = x;
    m_TouchY = y;

}

// タッチ終了コールバック
- (void)cbTouchEnd:(float)x y:(float)y {
    
    // タッチを離した
    m_TouchState = eTouchState_Release;
    m_TouchX = x;
    m_TouchY = y;

}


- (InterfaceLayer*)_getInterfaceLayer {

    return [SceneMain sharedInstance].interfaceLayer;
}
- (TokenManager*)_getManagerBlock {
    
    return [SceneMain sharedInstance].mgrBlock;
}

- (void)_updateAddBlock {
    
    // ブロック追加
    int num = Math_RandInt(1, 5);
    
    Block* b = [Block addFromChip:num chipX:4 chipY:10];
    
    m_BlockHandler = [b getIndex];
    
    m_State = eState_Standby;
}

- (void)_updateStandby {
    
//    InterfaceLayer* interface   = [self _getInterfaceLayer];
    TokenManager*   mgrBlock    = [self _getManagerBlock];
    Layer2D*        layer       = [FieldMgr getLayer];
    Cursor*         cursor      = [SceneMain sharedInstance].cursor;
    
    [cursor setDraw:NO chipX:m_ChipX];
    m_ChipX = [self touchToChip:m_TouchX];
    if (m_TouchState == eTouchState_Press) {
        
        // ブロック移動
        [cursor setDraw:YES chipX:m_ChipX];
        Block* b = (Block*)[mgrBlock getFromIdx:m_BlockHandler];
        [b setPosFromChip:m_ChipX chipY:[b getChipY]];
    }
    else if(m_TouchState == eTouchState_Release) {
        
        // タッチを離した
        m_TouchState = eTouchState_Standby;
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
        [layer random:6];
        [layer set:2 y:5 val:5];
        [layer set:2 y:2 val:3];
        [layer set:1 y:0 val:1];
//        [layer dump];
        
        for (int i = 0; i < FIELD_BLOCK_COUNT_MAX; i++) {
            int v = [layer getFromIdx:i];
            if (v > 0) {
                [Block addFromIdx:v idx:i];
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
//        m_State = eState_Standby;
        m_State = eState_AddBlock;
        
        // ブロックを待機状態にする
        [BlockMgr changeStandbyAll];
        return;
    }
    
    
    // 消去実行
    for (int j = 0; j < FIELD_BLOCK_COUNT_Y; j++) {
        
        for (int i = 0; i < FIELD_BLOCK_COUNT_X; i++) {
        
            int val = [layerVanish get:i y:j];
            if (val > 0) {
                // 消去要求を出す
                [BlockMgr requestVanish:i y:j];
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

// -----------------------------------------------------
// public
/**
 * 更新
 */
- (void)update:(ccTime)dt {
    
    switch (m_State) {
            
        case eState_AddBlock:
            [self _updateAddBlock];
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
