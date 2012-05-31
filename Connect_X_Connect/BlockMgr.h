//
//  BlockMgr.h
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/05/30.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Block.h"

/**
 * ブロック管理クラス
 */
@interface BlockMgr {
    
}

// 落下要求を送る
+ (void)requestFall;

// 落下が全て完了したかどうか
+ (BOOL)isFallWaitAll;

// ブロックの当たり判定をチェックする
+ (BOOL)checkHitBlock:(Block*)block;

// 指定の座標にあるブロックに消去要求を送る
+ (void)requestVanish:(int)x y:(int)y;

// 消滅処理が全て完了したかどうか
+ (BOOL)isEndVanishingAll;

@end
