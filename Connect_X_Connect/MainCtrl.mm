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

/**
 * コンストラクタ
 */
- (id)init {
    
    self = [super init];
    if (self == nil) {
        
        return self;
    }
    
    m_State = eState_Standby;
    m_Timer = 0;
    
    return self;
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

- (void)_updateVanishCheck {
    
}

- (void)_updateVanishExec {
    
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
