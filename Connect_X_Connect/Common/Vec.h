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

#endif // __JP_2DGAMES_VEC_H__
