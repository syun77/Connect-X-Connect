//
//  BlockMgr.mm
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/05/30.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BlockMgr.h"

#import "SceneMain.h"

/**
 * ブロック管理クラス実装
 */
@implementation BlockMgr

// 落下要求を送る
+ (void)requestFall {
    
    TokenManager* mgr = [SceneMain sharedInstance].mgrBlock;
    
    for (Block* b in mgr.m_Pool) {
        
        if ([b isExist] == NO) {
            continue;
        }
        
        // 落下要求を送る
        [b requestFall];
    }
}

@end
