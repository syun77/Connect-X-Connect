//
//  InterfaceLayer.h
//  Test7
//
//  Created by OzekiSyunsuke on 12/03/22.
//  Copyright 2012年 2dgame.jp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Token.h"
#import "IScene.h"

/**
 * 入力受け取りレイヤー
 */
@interface InterfaceLayer : CCLayer {
    BOOL  m_isTouch;    // タッチしているかどうか
    float m_StartX;     // タッチ開始座標(X)
    float m_StartY;     // タッチ開始座標(Y)
    float m_X;          // タッチしている座標(X)
    float m_Y;          // タッチしている座標(Y)
    float m_MoveX;      // 移動距離 (X)
    float m_MoveY;      // 移動距離 (Y)
    NSMutableArray* m_CBArray;  // コールバックで呼び出すオブジェクト(Token)
}

@property (nonatomic, retain)NSMutableArray* m_CBArray;

- (void)addCB:(id)token;
- (void)delCB;

// タッチしているかどうか
- (BOOL)isTouch;

// タッチ開始座標
- (float)startX;
- (float)startY;

// タッチ開始座標をリセットする
- (void)resetStartPos;

// タッチしている座標を取得
- (float)getPosX;
- (float)getPosY;

// 移動距離を取得
- (float)getMoveX;
- (float)getMoveY;
- (float)getMoveLength;
- (void)resetMove;

@end
