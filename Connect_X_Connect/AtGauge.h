//
//  AtGauge.h
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/06/12.
//  Copyright 2012年 2dgames.jp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Token.h"

/**
 * アクティブタイムゲージ
 */
@interface AtGauge : Token {
    
    int     m_BaseX;    // 基準座標 (X)
    int     m_BaseY;    // 基準座標 (Y)
    
    int     m_State;    // 増え方状態
    int     m_tPast;    // 経過時間
    int     m_Timer;    // タイマー
    float   m_Now;      // 現在のHP
    float   m_Prev;     // 以前のHP
    float   m_Max;      // 最大値
}

// 描画座標を設定
- (void)setPos:(int)x y:(int)y;

// AT初期値の設定
- (void)initAt:(float)v;

// ATを設定 (上昇用)
- (void)setAt:(float)v;

// ATを設定 (減少用)
- (void)damageAt:(float)v;

@end
