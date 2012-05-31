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

+ (TokenManager*)_getTokenManager {
    
    return [SceneMain sharedInstance].mgrBlock;
}

// 落下要求を送る
+ (void)requestFall {
    
    TokenManager* mgr = [BlockMgr _getTokenManager];
    
    for (Block* b in mgr.m_Pool) {
        
        if ([b isExist] == NO) {
            continue;
        }
        
        // 落下要求を送る
        [b requestFall];
    }
}

// 落下が全て完了したかどうか
+ (BOOL)isFallWaitAll {
    
    TokenManager* mgr = [BlockMgr _getTokenManager];
    
    for (Block* b in mgr.m_Pool) {
        
        if ([b isExist] == NO) {
            
            // 存在しないのでチェック不要
            continue;
        }
        
        if ([b isFallWait]) {
            
            // 落下待ちになっている
            continue;
        }
        
        // 落下待ちになっていない
        return NO;
    }
    
    // 全て落下待ちになった
    return YES; 
}

// ブロックの当たり判定をチェックする
+ (BOOL)checkHitBlock:(Block*)block {
    
    TokenManager* mgr = [BlockMgr _getTokenManager];
    
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

// 消滅処理が全て完了したかどうか
+ (BOOL)isEndVanishingAll {
    
    TokenManager* mgr = [BlockMgr _getTokenManager];
    
    for (Block* b in mgr.m_Pool) {
        
        if ([b isExist] == NO) {
            
            // 存在しないのでチェック不要
            continue;
        }
        
        if ([b isVanishing]) {
            
            // 消滅演出中のものがある
            return NO;
        }
        
    }
    
    // 消滅演出完了
    return YES; 
 
}

@end
