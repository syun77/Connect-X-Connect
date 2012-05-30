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

// ブロックの当たり判定をチェックする
+ (BOOL)checkHitBlock:(Block*)block;

@end