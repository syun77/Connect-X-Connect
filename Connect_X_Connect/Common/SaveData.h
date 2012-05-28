//
//  SaveData.h
//  Test7
//
//  Created by OzekiSyunsuke on 12/05/02.
//  Copyright 2012年 2dgames.jp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

/**
 * セーブデータを初期化する
 */
void SaveData_Init();

/**
 * ハイスコアを取得する
 * @return ハイスコア
 */
int SaveData_GetHiScore();

/**
 * ハイスコアを設定する
 * @param score ハイスコア
 */
void SaveData_SetHiScore(int score, BOOL bForce=false);

/**
 * タイトル画面で選択した難易度を取得する
 * @return 難易度
 */
int SaveData_GetRank();

/**
 * タイトル画面→メインゲーム用の難易度設定
 * @param rank 難易度
 */
BOOL SaveData_SetRank(int rank);

/**
 * 到達したことのある最大難易度を取得する
 * @return 最大難易度
 */
int SaveData_GetRankMax();

/**
 * 最大難易度を取得する
 * @param rank 最大難易度
 */
void SaveData_SetRankMax(int rank);


/**
 * BGMが有効となっているかどうか
 * @return BGMが有効ならば「YES」
 */
BOOL SaveData_IsEnableBgm();

/**
 * BGMが有効・無効を設定する
 * @param b 有効フラグ
 */
void SaveData_SetEnableBgm(BOOL b);

/**
 * SEが有効となっているかどうか
 * @return SEが有効ならば「YES」
 */
BOOL SaveData_IsEnableSe();

/**
 * SEが有効・無効を設定する
 * @param b 有効フラグ
 */
void SaveData_SetEnableSe(BOOL b);
