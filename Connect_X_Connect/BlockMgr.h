//
//  BlockMgr.h
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/05/30.
//  Copyright 2012年 2dgame.jp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Block.h"

/**
 * ブロック管理クラス
 */
@interface BlockMgr : NSObject {
    int     m_Timer;
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

// 待機状態にする
+ (void)changeStandbyAll;

// 全て落下後の待機状態にする
+ (void)changeFallWaitAll;

/**
 * フィールド外にあるブロックを削除する
 * @return 削除した数
 */
+ (int)vanishOutOfField;

// チップ座標を指定してブロックを取得する
+ (Block*)getFromChip:(int)chipX chipY:(int)chipY;

// インデックス指定でブロック取得
+ (Block*)getFromIndex:(int)index;

// 全てのブロックを上に移動する
+ (void)shiftUpAll:(int)dy;

// 存在するブロックの数を取得する
+ (int)count;

@end
