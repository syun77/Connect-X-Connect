//
//  Block.h
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/05/29.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Token.h"
#import "AsciiFont.h"

/**
 * ブロック
 */
@interface Block : Token {
    
    AsciiFont*  fontNumber;     // 数字フォント
    int         m_nNumber;      // 数値
    int         m_Timer;        // 汎用タイマー
    int         m_State;        // 状態
    BOOL        m_ReqFall;      // 落下要求フラグ
    BOOL        m_ReqVanish;    // 消滅要求フラグ
}

@property (nonatomic, retain)AsciiFont* fontNumber;

// 番号を設定する
- (void)setNumber:(int)number;

// 番号を取得する
- (int)getNumber;

// チップ座標の取得 (X座標)
- (int)getChipX;

// チップ座標の取得 (Y座標)
- (int)getChipY;

// チップ座標の取得 (インデックス)
- (int)getChipIdx;

// 落下要求を送る
- (void)requestFall;

// 落下停止中かどうか
- (BOOL)isFallWait;

// 消去要求を送る
- (void)requestVanish;

// 消滅演出中かどうか
- (BOOL)isVanishing;

// ブロックを追加する
+ (Block*)add:(int)number x:(float)x y:(float)y;

// ブロックを追加する (インデックス指定)
+ (Block*)addFromIdx:(int)number idx:(int)idx;

@end
