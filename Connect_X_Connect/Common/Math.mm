//
//  Vec.h
//  Test3
//
//  Created by OzekiSyunsuke on 12/03/15.
//  Copyright (c) 2012年 2dgame.jp. All rights reserved.
//

#include "Math.h"
#import "cocos2d.h"

static const float PI = 3.1415927;

// 数学関数の初期化
void Math_Init()
{
    // 乱数を初期化する
    struct timeval t;
    gettimeofday(&t, nil);
    unsigned int i;
    i = t.tv_sec;
    i += t.tv_usec;
    srandom(i);    
}

// 度をラジアンに変換する
float Math_Deg2Rad(float deg)
{
    return deg * PI / 180.0f;
}

// ラジアンを度に変換する
float Math_Rad2Deg(float rad)
{
    return rad * 180.0f / PI;
}

// コサインを求める
float Math_Cos(float rad)
{
    return cosf(rad);
}

// サインを求める
float Math_Sin(float rad)
{
    return sinf(rad);
}

// 平方根を求める
float Math_Sqrt(float a)
{
    return sqrt(a);
}

// コサインを求める(度指定)
float Math_CosEx(float deg)
{
    return Math_Cos(Math_Deg2Rad(deg));
}

// サインを求める(度指定)
float Math_SinEx(float deg)
{
    return Math_Sin(Math_Deg2Rad(deg));
}

// アークタンジェントを求める
float Math_Atan2(float y, float x)
{
    return atan2f(y, x);
}

// アークタンジェントを求める（度）
float Math_Atan2Ex(float y, float x)
{
    return Math_Rad2Deg(Math_Atan2(y, x));
}

// 乱数の取得
int Math_Rand(int range)
{
    return random() % range;
}

// 乱数の取得 (float 指定)
float Math_Randf(float range)
{
    return CCRANDOM_0_1() * range;
}

// 乱数の取得（範囲指定 a〜b）
int Math_RandInt(int a, int b)
{
    if ((b - a) <= 0) {
        return 0;
    }
    int d = b - a;
    return Math_Rand(d + 1) + a;
}

// 乱数の取得（範囲指定 a〜b) (float 指定)
float Math_RandFloat(float a, float b)
{
    if ((b - a) <= 0.0f) {
        return 0.0f;
    }
    float d = b - a;
    return Math_Randf(d) + a;
}


/**
 * 指定の角度に近づくにはどれだけ回すのかを計算する
 * @param next 目標の角度
 * @param now 現在の角度
 * @return 回す角度
 */
float Math_GetNearestRot(float next, float now) {
    
    while (next < 0) {
        // 0〜360になるようにする
        next += 360;
    }
    
    while (now < 0) {
        // 0〜360になるようにする
        now += 360;
    }
    
    float dRot = next - now;
    if (dRot > 180) {
        return dRot - 360;
    }
    if (dRot < -180) {
        return dRot += 360;
    }
    return dRot;
}

// 当たり判定チェック
BOOL Math_IsHitRect(CGRect rect, CGPoint p) {
    
    float x1 = rect.origin.x;
    float y1 = rect.origin.y;
    float x2 = rect.origin.x + rect.size.width;
    float y2 = rect.origin.y + rect.size.height;
    
    if (p.x < x1) {
        return NO;
    }
    if (p.y < y1) {
        return NO;
    }
    if (p.x > x2) {
        return NO;
    }
    if (p.y > y2) {
        return NO;
    }
    
    return YES;
}
