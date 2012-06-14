//
//  Particle.h
//  Test7
//
//  Created by OzekiSyunsuke on 12/03/31.
//  Copyright 2012年 2dgame.jp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "Token.h"

/**
 * パーティクルの種類
 */
enum eParticle {
    eParticle_Ball,     // 球体
    eParticle_Ring,     // 輪っか
    eParticle_Blade,    // 刃
    eParticle_Rect,     // 矩形
    eParticle_Circle,   // 円
};

@interface Particle : Token {
    eParticle   m_Type;     // 種別
    BOOL        m_bBlink;   // 点滅して消える
    int         m_Timer;    // タイマー
    float       m_Val;      // 汎用パラメータ
}

// 種別の設定
- (void)setType:(eParticle)type;

// タイマーの設定
- (void)setTimer:(int)timer;

// 要素の追加
+ (Particle*)add:(eParticle)type x:(float)x y:(float)y rot:(float)rot speed:(float)speed;

// ダメージエフェクト再生
+ (void)addDamage:(float)x y:(float)y;

// 死亡エフェクト再生
+ (void)addDead:(float)x y:(float)y;

// シールド破壊エフェクトを生成
+ (void)addShieldBreak:(float)x y:(float)y;

// ブロック出現エフェクトを生成
+ (void)addBlockAppear:(float)x y:(float)y;

@end
