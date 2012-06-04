//
//  HpGauge.h
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/06/02.
//  Copyright 2012年 2dgame.jp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Token.h"

/**
 * HPゲージ描画オブジェクト
 */
@interface HpGauge : Token {
    
    int     m_BaseX;    // 基準座標 (X)
    int     m_BaseY;    // 基準座標 (Y)
    
    int     m_tPast;    // 経過時間
    int     m_Timer;    // タイマー
    float   m_Now;      // 現在のHP
    float   m_Prev;     // 以前のHP
}

// HP初期値の設定
- (void)initHp:(float)v;

// HPを設定 (ダメージ用)
- (void)setHp:(float)v;

// HPを設定 (回復用)
- (void)setHpRecover:(float)v;

@end
