//
//  AsciiFont.h
//  FontTest
//
//  Created by OzekiSyunsuke on 12/04/01.
//  Copyright 2012年 2dgame.jp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Token.h"
#import "TokenManager.h"

/// ASCII文字のサイズ
//#define ASCII_SIZE (16)
#define ASCII_SIZE (14)
#define ASCII_SIZE_REAL (16)

/// ASCII文字の横の数
#define ASCII_X_COUNT (16)

/// 描画プライオリティ
#define PRIO_ASCIIFONT (100)

/// 文字の描画種別
typedef enum {
    eFontAlign_Left,   /// 左寄せ
    eFontAlign_Center, /// 中央揃え
    eFontAlign_Right,  /// 右寄せ
} eFontAlign;

/**
 * フォントオブジェクト
 */
@interface AsciiObj : Token {    
}

/**
 * 文字に対応する矩形を取得
 * @param char c 文字
 * @return 文字に対応する矩形
 */
- (CGRect)getRectWithChar:(char)c;

// 文字を設定する
- (void)setChar:(char)c;

@end

// -----------------------------------------------------------------------------
/**
 * ASCIIフォント管理
 */
@interface AsciiFont : TokenManager {
    float       m_Scale;    // 拡大縮小率
    int         m_Length;   // 文字列長
    float       m_X;        // 描画座標(X)
    float       m_Y;        // 描画座標(Y)
    eFontAlign  m_Align;    // 描画種別
}

/**
 * フォントの生成
 * @param CCLayer 描画レイヤー
 * @param NSInteger 文字列長
 */
- (void)createFont:(CCLayer *)layer length:(NSInteger)length;

// フォントの１文字あたりのサイズを取得する
- (float)getLetterSize;

// 描画種別
- (void)setAlign:(eFontAlign)align;

// 色を設定する
- (void)setColor:(ccColor3B) color;

// α値を設定する (0〜255)
- (void)setAlpha:(int) alpha;

// 拡縮する
- (void)setScale:(float)scale;

// 文字を設定する
- (void)setText:(NSString*)pText;

// 文字列長を取得する
- (int)getLength;

// 描画座標を設定する (フォント座標)
- (void)setPos:(float)x y:(float)y;

// 描画座標を設定する (スクリーン座標)
- (void)setPosScreen:(float)x y:(float)y;

// 表示・非表示を設定する
- (void)setVisible:(BOOL)b;

@end

