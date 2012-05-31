//
//  Layer2D.h
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/05/28.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


/**
 * ２次元配列管理クラス
 */
@interface Layer2D : NSObject {
    int                     m_Out;      // 領域外の値
    int                     m_Width;    // 幅
    int                     m_Height;   // 高さ
    int*                    m_pData;    // データ
}

// 生成
- (void)create:(int)w h:(int)h;

// 破棄
//- (void)destroy;

// コピー
- (void)copyWithLayer2D:(Layer2D*)layer;

// 幅を取得
- (int)getWidth;

// 高さを取得
- (int)getHeight;

// インデックスの最大値を取得
- (int)getIdxMax;

// インデックスに変換する
- (int)getIdx:(int)x y:(int)y;

// 領域内かどうか
- (BOOL)isRange:(int)x y:(int)y;

// 領域内かどうか (インデックス指定)
- (BOOL)isRangeFromIdx:(int)idx;

// 値の設定
- (void)set:(int)x y:(int)y val:(int)val;

// 値の設定 (インデックス指定)
- (void)setFromIdx:(int)idx val:(int)val;

// 値の取得
- (int)get:(int)x y:(int)y;

// 値の取得 (インデックス指定)
- (int)getFromIdx:(int)idx;

// 領域外の値を取得する
- (int)getOut;

// 初期値で初期化する
- (void)clear;

// 指定の値で全部埋める
- (void)fill:(int)v;

// 指定の値がどれだけあるかをカウントする
- (int)count:(int)v;

// ランダムで値を埋める
- (void)random:(int)range;

// デバッグ出力
- (void)dump;

// テストデータ作成
- (void)test;

@end
