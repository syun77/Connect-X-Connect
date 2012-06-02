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
        
        if (block._y < b._y) {
            
            // 下にいたら判定不要
            continue;
        }
        
        int x1 = b._x;
        int x2 = block._x;
        int y1 = block._y - block._r;   // 下を見る
        int y2 = b._y + b._r;           // 上を見る
        int y3 = block._y + block._r;   // 上を見る
        int y4 = b._y - b._r;           // 下を見る

        if (x1 == x2 && y1 <= y2 && y3 >= y4) {
            
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

// 指定の座標にあるブロックに消去要求を送る
+ (void)requestVanish:(int)x y:(int)y {
    
    TokenManager* mgr = [BlockMgr _getTokenManager];
    
    for (Block* b in mgr.m_Pool) {
        
        if ([b isExist] == NO) {
            
            // 存在しないのでチェックしない
            continue;
        }
        
        int px = [b getChipX];
        int py = [b getChipY];
        
        if (px == x && py == y) {
            
            // 消去要求を送る
            [b requestVanish];
            
            break;
        }
    }
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

// 待機状態にする
+ (void)changeStandbyAll {
    
    TokenManager* mgr = [BlockMgr _getTokenManager];
    
    for (Block* b in mgr.m_Pool) {
        
        if ([b isExist] == NO) {
            
            continue;
        }
        
        // 待機状態にする
        [b changeStandby];
    }
}

// 全て落下後の待機状態にする
+ (void)changeFallWaitAll {
    
    TokenManager* mgr = [BlockMgr _getTokenManager];
    
    for (Block* b in mgr.m_Pool) {
        
        if ([b isExist] == NO) {
            
            continue;
        }
        
        // 落下待機状態にする
        [b changeFallWait];
    }
}

/**
 * フィールド外にあるブロックを削除する
 * @return 削除した数
 */
+ (int)vanishOutOfField {
    
    int ret = 0;
    TokenManager* mgr = [BlockMgr _getTokenManager];
    
    for (Block* b in mgr.m_Pool) {
        
        if ([b isExist] == NO) {
            
            continue;
        }
        
        if ([b getChipY] >= FIELD_BLOCK_COUNT_Y-1) {
            
            // 領域外
            [b requestVanish];
            ret++;
        }
    }
    
    return ret;
}

// チップ座標を指定してブロックを取得する
+ (Block*)getFromChip:(int)chipX chipY:(int)chipY {
    
    TokenManager* mgr = [BlockMgr _getTokenManager];
    
    for (Block* b in mgr.m_Pool) {
        
        if ([b isExist] == NO) {
            
            continue;
        }
        
        if ([b getChipX] == chipX && [b getChipY] == chipY) {
            return b;
        }
    }
    
    // 該当のブロックはなし
    return nil;
}

// 全てのブロックを上に移動する
+ (void)shiftUpAll:(int)dy {
    
    TokenManager* mgr = [BlockMgr _getTokenManager];
    
    for (Block* b in mgr.m_Pool) {
        
        if ([b isExist] == NO) {
            
            continue;
        }
        
        // 座標を移動させる
        b._y += dy;
    }
}

@end
