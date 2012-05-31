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
    
    m_State = eState_Standby;
    m_Timer = 0;
    
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

- (void)_updateStandby {
    
    InterfaceLayer* interface   = [self _getInterfaceLayer];
    TokenManager*   mgrBlock    = [self _getManagerBlock];
    Layer2D*        layer       = [FieldMgr getLayer];
    
    static int s_cnt = 0;
    s_cnt++;
    
    if ([interface isTouch]) {
        
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
    
    for (int j = 0; j < FIELD_BLOCK_COUNT_Y; j++) {
        
        for (int i = 0; i < FIELD_BLOCK_COUNT_X; i++) {
            
            int val = [layer get:i y:j];
            if (val > 0) {
                
                // ブロックが存在する
                [self _checkVanish1:i y:j dx:0 dy:0 val:val cnt:0];
            }
        }
    }
    
    [self.layerVanish dump];
    
    
    // 消去実行
    for (int j = 0; j < FIELD_BLOCK_COUNT_Y; j++) {
        
        for (int i = 0; i < FIELD_BLOCK_COUNT_X; i++) {
        
            // 消去要求を出す
            //[BlockMgr requestVanish:i y:j];
        }
    }
    
    m_State = eState_VanishExec;
}

- (void)_updateVanishExec {
    
    if ([BlockMgr isEndVanishingAll]) {
        
        // 消滅演出完了
        if (NO) {
            
            // TODO: 再チェックをする
        }
        
        // TODO: とりあえず待機状態に戻す
        m_State = eState_Standby;
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
