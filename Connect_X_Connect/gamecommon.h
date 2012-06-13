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
static const int FIELD_OFS_Y = 24;

// 7x11フィールド
static const int FIELD_BLOCK_COUNT_X = 7;
static const int FIELD_BLOCK_COUNT_Y = 8;
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

// 次に出現するブロックの数
static const int BLOCK_NEXT_COUNT = 3;

// ブロック出現座標
// X座標
static const int BLOCK_APPEAR_X = 3;
// Y座標
static const int BLOCK_APPEAR_Y1 = FIELD_BLOCK_COUNT_Y-1; // １つ目
static const int BLOCK_APPEAR_Y2 = 9;  // ２つ目

// ■ベジェ曲線エフェクト
static const int BEZIEREFFECT_FRAME = 40; // 出現フレーム数
static const int BEZIEREFFECT_FRAME_MAX = 80;

// ■計算式関連
/**
 * スコアを取得する
 * @param nVanish   消去数
 * @param nConnect  最大連結数
 * @param nKind     色数
 * @param nChain    連鎖数
 * @param nCombo    コンボ数
 * @return スコア
 */
int GameCommon_GetScore(int nVanish, int nConnect, int nKind, int nChain, int nCombo);




#endif
