//
//  test.m
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/06/03.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Vec.h"

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
void Vec2d_GetBezierCurve(float x0, float y0, float x1, float y1, float x2, float y2, float x3, float y3, Vec2D* pList, int size) {
    
    for (int i = 0; i < size; i++) {
        float u = i * 1.0 / (size - 1);
        float mP0 =               (1 - u) * (1 - u) * (1 - u);
        float mP1 = 3 * u *       (1 - u) * (1 - u);
        float mP2 = 3 * u * u *   (1 - u);
        float mP3 =     u * u * u;
        
        pList[i].x = x0 * mP0 + x1 * mP1 + x2 * mP2 + x3 * mP3;
        pList[i].y = y0 * mP0 + y1 * mP1 + y2 * mP2 + y3 * mP3;
    }
}