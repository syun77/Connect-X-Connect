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

// ブロックの当たり判定をチェックする
+ (BOOL)checkHitBlock:(Block*)block {
    
    TokenManager* mgr = [SceneMain sharedInstance].mgrBlock;
    
    for (Block* b in mgr.m_Pool) {
        
        if ([b isExist] == NO) {
            continue;
        }
        
        if ([b getIndex] == [block getIndex]) {
            
            // 同じブロック
            continue;
        }
        
        if ([b isHit2:block]) {
            
            // 当たった
            block._vy = 0;
            
            if ([b isFallWait]) {
                
                // 停止する
                return YES;
            }
            
            // 止まるだけ
            break;;
        }
    }
    
    // 当たっていない
    return NO;
}

@end
