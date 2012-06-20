//
//  Sound.mm
//  Test7
//
//  Created by OzekiSyunsuke on 12/05/07.
//  Copyright 2012年 2dgames.jp. All rights reserved.
//

#import "Sound.h"
#import "SimpleAudioEngine.h"
#import "SaveData.h"

struct Sound {
    float VolumeBgm;
    float VolumeSe;
};

static Sound s_This;

static Sound* _Get()
{
    return &s_This;
}

/**
 * サウンド初期化
 */
void Sound_Init() {
    Sound* ix = _Get();
    
    ix->VolumeBgm = 1;
    ix->VolumeSe = 1;
    
    // 使用するサウンドをロード
    Sound_LoadSe(@"push.wav");
}

/**
 * BGMを再生する
 */
void Sound_PlayBgm(NSString* pPath) {
    
    if (Sound_IsEnableBgm() == NO) {
        
        // BGM再生無効
        return;
    }
    
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:pPath];
}

/**
 * BGMを停止する
 */
void Sound_StopBgm() {
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}

/**
 * BGMの音量を設定する
 */
void Sound_SetBgmVolume(float vol) {
    
    Sound* ix = _Get();
    ix->VolumeBgm = vol;
    
    [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:vol];
}

/**
 * SEを再生する
 */
void Sound_PlaySe(NSString* pPath)
{
    if (Sound_IsEnableSe() == NO) {
        
        // SE再生無効
        return;
    }

    [[SimpleAudioEngine sharedEngine] playEffect:pPath];
}

/**
 * SEをロードする
 */
void Sound_LoadSe(NSString* pPath) {
    
    [[SimpleAudioEngine sharedEngine] preloadEffect:pPath];
}


/**
 * BGMのON/OFF設定
 */
void Sound_SetEnableBgm(BOOL b) {
    
    SaveData_SetEnableBgm(b);
}

/**
 * SEのON/OFF設定
 */
void Sound_SetEnableSe(BOOL b) {
    
    SaveData_SetEnableSe(b);
}


/**
 * BGMが有効かどうか
 */
BOOL Sound_IsEnableBgm() {
    
    return SaveData_IsEnableBgm();
}

/**
 * SEが有効かどうか
 */
BOOL Sound_IsEnableSe() {
    
    return SaveData_IsEnableSe();
}

