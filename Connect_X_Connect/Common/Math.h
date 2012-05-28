//
//  Vec.h
//  Test3
//
//  Created by OzekiSyunsuke on 12/03/15.
//  Copyright (c) 2012年 2dgame.jp. All rights reserved.
//

#ifndef __JP_2DGAMES_MATH_H__
#define __JP_2DGAMES_MATH_H__

#include "math.h"

// 数学関数の初期化
void Math_Init();

// 度をラジアンに変換する
float Math_Deg2Rad(float deg);

// ラジアンを度に変換する
float Math_Rad2Deg(float rad);

// コサインを求める
float Math_Cos(float rad);

// サインを求める
float Math_Sin(float rad);

// 平方根を求める
float Math_Sqrt(float a);

// コサインを求める（度）
float Math_CosEx(float deg);

// サインを求める（度）
float Math_SinEx(float deg);

// アークタンジェントを求める
float Math_Atan2(float y, float x);

// アークタンジェントを求める（度）
float Math_Atan2Ex(float y, float x);

// 乱数の取得
int Math_Rand(int range);

// 乱数の取得 (float 指定)
float Math_Randf(float range);

// 乱数の取得（範囲指定 a〜b）
int Math_RandInt(int a, int b);

// 乱数の取得（範囲指定 a〜b) (float 指定)
float Math_RandFloat(float a, float b);

// 指定の角度に近づくにはどれだけ回すのかを計算する
float Math_GetNearestRot(float next, float now);

// 当たり判定チェック
BOOL Math_IsHitRect(CGRect rect, CGPoint p);

#endif // __JP_2DGAMES_MATH_H__
