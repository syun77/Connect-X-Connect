//
//  MyCocos2DClass.h
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/05/30.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Block.h"
#import "Layer2D.h"

@interface FieldMgr {
}

/**
 * フィールドレイヤーを取得する
 * @return レイヤー
 */
+ (Layer2D*)getLayer;

/**
 * 指定の座標にブロックがあるかどうか 
 * @param idx インデックス
 * @return ブロックがあれば「YES」
 */
+ (BOOL)isBlock:(int)idx;

@end