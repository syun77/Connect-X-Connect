//
//  Block.h
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/05/29.
//  Copyright 2012年 2dgame.jp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Token.h"
#import "AsciiFont.h"

/**
 * ブロック
 */
@interface Block : Token {
    
    int         m_tPast;        // 経過時間
    int         m_nNumber;      // 数値
    int         m_bSkull;       // ドクロかどうか
    BOOL        m_bSpecial;     // スペシャルブロックかどうか
    int         m_tCursor;      // カーソルタイマー
    int         m_Timer;        // 汎用タイマー
    int         m_State;        // 状態
    BOOL        m_ReqFall;      // 落下要求フラグ
    BOOL        m_ReqVanish;    // 消滅要求フラグ
    BOOL        m_bPutPlayer;   // プレイヤーがそのターンに置いたかどうかフラグ
    
    int         m_nShield;      // 固ぷよカウンタ
}

// 番号を設定する
- (void)setNumber:(int)number;

// 番号を取得する
- (int)getNumber;

// 固ぷよカウンタを設定
- (void)setShield:(int)v;

// 固ぷよカウンタを減らす
- (void)decShield;

// 固ぷよカウンタが有効かどうか
- (BOOL)isShield;

// ドクロブロックにする
- (void)setSkull;

// ドクロブロックかどうか
- (BOOL)isSkull;

// スペシャルブロックの設定をする
- (void)setSpecial:(BOOL)b;

// スペシャルブロックかどうか
- (BOOL)isSpecial;

// チップ座標の取得 (X座標)
- (int)getChipX;

// チップ座標の取得 (Y座標)
- (int)getChipY;

// チップ座標の取得 (インデックス)
- (int)getChipIdx;

// 座標の設定
- (void)setPosFromChip:(int)chipX chipY:(int)chipY;

// 落下要求を送る
- (void)requestFall;

// 落下停止中かどうか
- (BOOL)isFallWait;

// 消去要求を送る
- (void)requestVanish;

// 消滅演出中かどうか
- (BOOL)isVanishing;

// プレイヤー操作可能状態にする
- (void)changeSlide;

// 待機状態にする
- (void)changeStandby;

// 落下待機待ちにする
- (void)changeFallWait;

// 数値のカウントダウンをする
- (void)countDown;

// プレイヤーがそのターンに置いたかどうかフラグを設定
- (void)setPutPlayer:(BOOL)b;

// プレイヤーがそのターンに置いたかどうか
- (BOOL)isPutPlayer;

// ブロックを追加する
+ (Block*)add:(int)number x:(float)x y:(float)y;

// ブロックを追加する (インデックス指定)
+ (Block*)addFromIdx:(int)number idx:(int)idx;

// ブロックを追加する (チップ座標指定)
+ (Block*)addFromChip:(int)number chipX:(int)chipX chipY:(int)chipY;

@end
