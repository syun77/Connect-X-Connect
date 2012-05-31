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

/**
 * 状態
 */
enum eState {
    eState_Standby,
    eState_Fall,
    eState_VanishCheck,
    eState_VanishExec,
    eState_End,
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
    
    // 変数の初期化
    m_State = eState_Standby;
    m_Timer = 0;
    m_TouchState = eState_Standby;
    m_TouchX = 0;
    m_TouchY = 0;
    m_ChipX  = 0;
    
    
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

- (void)_updateStandby {
    
//    InterfaceLayer* interface   = [self _getInterfaceLayer];
    TokenManager*   mgrBlock    = [self _getManagerBlock];
    Layer2D*        layer       = [FieldMgr getLayer];
    Cursor*         cursor      = [SceneMain sharedInstance].cursor;
    
    m_ChipX = [self touchToChip:m_TouchX];
    if (m_TouchState == eTouchState_Press) {
        
        [cursor setDraw:YES chipX:m_ChipX];
    }
    else {
        [cursor setDraw:NO chipX:m_ChipX];
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
        [layer dump];
        
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

- (int)_checkVanish2:(int)x y:(int)y dx:(int)dx dy:(int)dy val:(int)val cnt:(int)cnt {
    
    x += dx;
    y += dy;
    
    if ([self.layerVanish get:x y:y] != 0) {
        
        // チェック済み・領域外
        return cnt;
    }
    
    Layer2D* layer = [FieldMgr getLayer];
    
    
    int v = [layer get:x y:y];
    if (v == val) {
        
        // 指定の番号に一致した
        [self.layerVanish set:x y:y val:val];
        cnt++;
        cnt = [self _checkVanish2:x y:y dx:-1 dy: 0 val:val cnt:cnt];
        cnt = [self _checkVanish2:x y:y dx: 0 dy:-1 val:val cnt:cnt];
        cnt = [self _checkVanish2:x y:y dx:+1 dy: 0 val:val cnt:cnt];
        cnt = [self _checkVanish2:x y:y dx: 0 dy:+1 val:val cnt:cnt];
        
        if (cnt >= val) {
            
            // 消去可能
            [self.layerVanish set:x y:y val:val];
        }
        else {
            
            // 消去できないのでクリアする
            [self.layerVanish set:x y:y val:0];
        }
        return cnt;
    }
    
    // 繋がっていなかった
    return cnt;
}

- (int)_checkVanish1:(int)x y:(int)y dx:(int)dx dy:(int)dy val:(int)val cnt:(int)cnt {
    
    x += dx;
    y += dy;
    
    if ([self.layerVanish get:x y:y] != 0) {
        
        // チェック済み・領域外
        return cnt;
    }
    
    // 開始ポイント
    cnt++;
    
    // チェック済みにしておく
    [self.layerVanish set:x y:y val:val];
    
    cnt = [self _checkVanish2:x y:y dx:-1 dy: 0 val:val cnt:cnt];
    cnt = [self _checkVanish2:x y:y dx: 0 dy:-1 val:val cnt:cnt];
    cnt = [self _checkVanish2:x y:y dx:+1 dy: 0 val:val cnt:cnt];
    cnt = [self _checkVanish2:x y:y dx: 0 dy:+1 val:val cnt:cnt];
    
    if (cnt >= val) {
        
        // 消去可能
        //[self.layerVanish set:x y:y val:val];
    }
    else {
        
        // 消去できないのでクリア
        [self.layerVanish set:x y:y val:0];
    }
    
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
            
            int val = [layer get:i y:j];
            if (val > 0) {
                
                // ブロックが存在する
                int cnt = [self _checkVanish1:i y:j dx:0 dy:0 val:val cnt:0];
                
                if (cnt >= val) {
                    
                    // 消去できた
                    nVanish++;
                }
            }
        }
    }
    
//    [self.layerVanish dump];
    if (nVanish == 0) {
        
        // 消去できるものはない
        m_State = eState_Standby;
        
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
