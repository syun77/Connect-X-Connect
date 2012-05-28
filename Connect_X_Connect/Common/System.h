//
//  System.h
//  Test7
//
//  Created by OzekiSyunsuke on 12/04/08.
//  Copyright 2012年 2dgames.jp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

enum eBlend {
    eBlend_Normal,  // 通常合成 (透過・α付き)
    eBlend_Add,     // 加算合成
    eBlend_Sub,     // 減算合成
    eBlend_Mul,     // 乗算合成
    eBlend_Reverse, // 反転合成
    eBlend_Screen,  // スクリーン合成
    eBlend_XOR,     // 排他的論理和
};

// システムの初期化を行う
void System_Init();

// Retinaディスプレイかどうか
BOOL System_IsRetina();

// ウィンドウサイズを取得する
CGSize System_Size();

// ウィンドウの幅を取得する
float System_Width();

// ウィンドウの高さを取得する
float System_Height();

// 中心座標(X)を取得する
float System_CenterX();

// 中心座標(Y)を取得する
float System_CenterY();

// 当たり判定を描画するかどうか
bool System_IsDispCollision();

// ブレンドモードの設定
void System_SetBlend(eBlend mode);

// メモリ残量を取得する (Byte単位)
float System_GetAvailableBytes();
