//
//  gamecommon.h
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/05/29.
//  Copyright (c) 2012年 2dgame.jp. All rights reserved.
//

#ifndef Connect_X_Connect_gamecommon_h
#define Connect_X_Connect_gamecommon_h

// ★ゲーム共通定数ヘッダ
// ■フィールド関連
static const int FIELD_OFS_X = 20 + 20;
static const int FIELD_OFS_Y = 64;

// 7x11フィールド
static const int FIELD_BLOCK_COUNT_X = 7;
static const int FIELD_BLOCK_COUNT_Y = 11;
static const int FIELD_BLOCK_COUNT_MAX = (FIELD_BLOCK_COUNT_X * FIELD_BLOCK_COUNT_Y);

static const int FIELD_OUT = -1; // 領域外

// ■ステータス
static const int HP_MAX = 100;

// スクリーン座標からチップ座標への変換
int GameCommon_ScreenXToChipX(int screenX);
int GameCommon_ScreenYToChipY(int screenY);

// チップ座標からスクリーン座標への変換
int GameCommon_ChipXToScreenX(int chipX);
int GameCommon_ChipYToScreenY(int chipY);


// ■ブロック関連
static const int BLOCK_SIZE = 40;
static const int BLOCK_INVALID = 0; // 無効なブロック

// ブロック出現座標
// X座標
static const int BLOCK_APPEAR_X = 3;
// Y座標
static const int BLOCK_APPEAR_Y1 = 10; // １つ目
static const int BLOCK_APPEAR_Y2 = 9;  // ２つ目


#endif
