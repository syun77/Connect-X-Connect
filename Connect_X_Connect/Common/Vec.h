//
//  Vec.h
//  Test3
//
//  Created by OzekiSyunsuke on 12/03/15.
//  Copyright (c) 2012年 2dgame.jp. All rights reserved.
//

#ifndef __JP_2DGAMES_VEC_H__
#define __JP_2DGAMES_VEC_H__

#include "Math.h"


/**
 * 2次元ベクトル
 */
struct Vec2D
{
    float x; // 座標(X)
    float y; // 座標(Y)
    
    // 初期化
    Vec2D(float x=0.0f, float y=0.0f)
    {
        Set(x, y);
    }
    
    // 設定
    void Set(float x, float y)
    {
        if (isnan(x) || isnan(y)) {
            assert(0);
        }
        this->x = x;
        this->y = y;
    }
    
    // 加算
    Vec2D operator +(Vec2D v)
    {
        return Vec2D(x + v.x, y + v.y);
    }
    // 減算
    Vec2D operator -(Vec2D v)
    {
        return Vec2D(x - v.x, y - v.y);
    }
    
    // 加算代入
    void operator +=(Vec2D v)
    {
        x += v.x;
        y += v.y;
    }
    
    void IAdd(float x, float y)
    {
        this->x += x;
        this->y += y;
    }
    
    // 減算代入
    void operator -=(Vec2D v)
    {
        x -= v.x;
        y -= v.y;
    }
    
    void ISub(float x, float y)
    {
        this->x -= x;
        this->y -= y;
    }
    
    // 乗算代入
    void operator *=(float a)
    {
        this->x *= a;
        this->y *= a;
    }
    
    // 減算代入
    void operator /=(float a)
    {
        if(a == 0.0f) { return; }
        this->x /= a;
        this->y /= a;
    }
    
    // 距離の２乗
    float LengthSq()
    {
        return (x * x) + (y * y);
    }
    
    // 距離
    float Length()
    {
        return Math_Sqrt(LengthSq());
    }
    
    // 正規化
    void Normalize()
    {
        float a = Length();
        if(a == 0.0f) { return; }
        
        x /= a;
        y /= a;
    }
    
    // 角度
    float Rot()
    {
        return Math_Atan2Ex(y, x);
    }
};

/**
 * ベジェ曲線を取得する
 * @param x0 始点 (X)
 * @param y0 始点 (Y)
 * @param x1 制御点１ (X)
 * @param y1 制御点１ (Y)
 * @param x2 制御点２ (X)
 * @param y2 制御点２ (Y)
 * @param x3 終点 (X)
 * @param y3 終点 (Y)
 * @param *pList Vec2Dの配列
 * @param size 配列のサイズ (分解度)
 */
void Vec2d_GetBezierCurve(float x0, float y0, float x1, float y1, float x2, float y2, float x3, float y3, Vec2D* pList, int size);

#endif // __JP_2DGAMES_VEC_H__
