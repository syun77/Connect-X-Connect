//
//  MyCocos2DClass.h
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/05/30.
//  Copyright 2012年 2dgame.jp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Block.h"
#import "Layer2D.h"

@interface FieldMgr : NSObject {
    int m_Timer;
}

/**
 * フィールドレイヤーを取得する
 * @return レイヤー
 */
+ (Layer2D*)getLayer;

/**
 * ブロック管理オブジェクトを取得
 * @return ブロック管理オブジェクト
 */
+ (TokenManager*)getManager;

/**
 * 他のブロックに当たっているかどうか調べる
 */
+ (BOOL)isHitBlock:(Block*)block;

/**
 * 下が領域外かどうか
 */
+ (BOOL)isBottomOut:(Block*)block;

/**
 * １つ下にブロックがあるかどうか調べる
 */
+ (BOOL)isBlockBottom:(Block*)block;

/**
 * 指定の座標にブロックがあるかどうか 
 * @param idx インデックス
 * @return ブロックがあれば「YES」
 */
+ (BOOL)isBlock:(int)idx;

/**
 * ブロックの情報をレイヤーにコピーする
 * @param nSpecial スペシャルブロックの数
 */
+ (void)copyBlockToLayer:(int)nSpecial;


@end