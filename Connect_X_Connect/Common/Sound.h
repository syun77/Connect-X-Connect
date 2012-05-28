//
//  Sound.h
//  Test7
//
//  Created by OzekiSyunsuke on 12/05/07.
//  Copyright 2012年 2dgames.jp. All rights reserved.
//

/**
 * サウンド初期化
 */
void Sound_Init();

/**
 * BGMを再生する
 */
void Sound_PlayBgm(NSString* pPath);

/**
 * BGMを停止する
 */
void Sound_StopBgm();

/**
 * BGMの音量を設定する
 */
void Sound_SetBgmVolume(float vol);

/**
 * SEを再生する
 */
void Sound_PlaySe(NSString* pPath);

/**
 * SEをロードする
 */
void Sound_LoadSe(NSString* pPath);

/**
 * BGMのON/OFF設定
 */
void Sound_SetEnableBgm(BOOL b);

/**
 * SEのON/OFF設定
 */
void Sound_SetEnableSe(BOOL b);

/**
 * BGMが有効かどうか
 */
BOOL Sound_IsEnableBgm();

/**
 * SEが有効かどうか
 */
BOOL Sound_IsEnableSe();