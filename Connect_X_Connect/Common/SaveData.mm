//
//  SaveData.mm
//  Test7
//
//  Created by OzekiSyunsuke on 12/05/02.
//  Copyright 2012年 2dgames.jp. All rights reserved.
//

#import "SaveData.h"

/**
 * NSUserDefaultsを取得する
 */
static NSUserDefaults* _Get()
{
    return [NSUserDefaults standardUserDefaults];
}

/**
 * セーブデータを初期化する
 */
void SaveData_Init() {
    NSUserDefaults* defaults = _Get();
    
    if ([defaults boolForKey:@"INIT"]) {
        
        // 初期化済みなので何もしない
        return;
    }
    
    [defaults setBool:YES forKey:@"INIT"];
    [defaults setInteger:0 forKey:@"HI_SCORE"];
    [defaults setInteger:1 forKey:@"RANK"];
    [defaults setInteger:1 forKey:@"RANK_MAX"];
    [defaults setBool:YES forKey:@"BGM"];
    [defaults setBool:YES forKey:@"SE"];
    
    [defaults setBool:NO forKey:@"SCORE_ATTACK"];
    [defaults setInteger:0 forKey:@"HI_SCORE2"];
    [defaults setInteger:RANK_DEFAULT forKey:@"RANK_MAX2"];
    [defaults setBool:YES forKey:@"SCORE_AUTO_SUBMIT"];
    
    // 保存
    [defaults synchronize];
}

/**
 * ハイスコアを取得する
 * @return ハイスコア
 */
int SaveData_GetHiScore() {
    NSUserDefaults* defaults = _Get();
    
    return [defaults integerForKey:@"HI_SCORE"];
    
}

/**
 * ハイスコアを設定する
 * @param score ハイスコア
 * @param bForce 強制的に更新する
 */
void SaveData_SetHiScore(int score, BOOL bForce) {
    int hiScore = SaveData_GetHiScore();
    
    if (bForce == NO) {
        if (score <= hiScore) {
            // 更新不要
            return;
        }
    }
    
    NSUserDefaults* defaults = _Get();
    [defaults setInteger:score forKey:@"HI_SCORE"];
    
    // 保存
    [defaults synchronize];
}

/**
 * タイトル画面で選択した難易度を取得する
 * @return 難易度
 */
int SaveData_GetRank() {
    
    NSUserDefaults* defaults = _Get();
    
    return [defaults integerForKey:@"RANK"];
}

/**
 * ランクを保存する
 * @param rank 難易度
 * @return 成功したら「YES」
 */
BOOL SaveData_SaveRank(int rank) {
    
    int max = SaveData_GetRankMax();
    
    if (rank > max) {
        rank = max;
    }
    
    NSUserDefaults* defaults = _Get();
    [defaults setInteger:rank forKey:@"RANK"];
    
    // 保存
    [defaults synchronize];
    
    // 更新できた
    return YES;
}

/**
 * タイトル画面→メインゲーム用の難易度設定
 * @param rank 難易度
 */
BOOL SaveData_SetRank(int rank) {
    
    // 元の数値
    int src = rank;
    
    // 10の倍数 +1 になるようにする
    rank = (int)(rank / 10) * 10;
    if (rank < 1) {
        rank = 1;
    }
    else {
        if (src%10 != 0) {
            
            rank += 1;
        }
    }
    
    // 最大ランクの端数切捨てで丸める
    int max = (int)(SaveData_GetRankMax() / 10) * 10 - 9;
    if (SaveData_GetRankMax()%10 != 0) {
        max += 10;
    }
    
    if (rank > max) {
        
        rank = max;
    }
    if (rank < 1) {
        rank = 1;
    }
    
    if (rank == SaveData_GetRank()) {
        
        // 更新できなかった
        return NO;
    }
    
    NSUserDefaults* defaults = _Get();
    [defaults setInteger:rank forKey:@"RANK"];
    
    // 保存
    [defaults synchronize];
    
    // 更新できた
    return YES;
}

/**
 * 到達したことのある最大難易度を取得する
 * @return 最大難易度
 */
int SaveData_GetRankMax() {
    
    NSUserDefaults* defaults = _Get();
    
    
    return [defaults integerForKey:@"RANK_MAX"];
}

/**
 * 最大難易度を設定する
 * @param rank 最大難易度
 */
void SaveData_SetRankMax(int rank) {
    
    NSUserDefaults* defaults = _Get();
    
    int max = SaveData_GetRankMax();
    if (rank < max) {
        
        // 更新不要
        return;
    }
    
    [defaults setInteger:rank forKey:@"RANK_MAX"];
    
    // 保存
    [defaults synchronize];
}

/**
 * BGMが有効となっているかどうか
 * @return BGMが有効ならば「YES」
 */
BOOL SaveData_IsEnableBgm() {
    NSUserDefaults* ix = _Get();
    
    return [ix boolForKey:@"BGM"];
}

/**
 * BGMが有効・無効を設定する
 * @param b 有効フラグ
 */
void SaveData_SetEnableBgm(BOOL b) {
    NSUserDefaults* ix = _Get();
    
    [ix setBool:b forKey:@"BGM"];
    
    // 保存
    [ix synchronize];
}

/**
 * SEが有効となっているかどうか
 * @return SEが有効ならば「YES」
 */
BOOL SaveData_IsEnableSe() {
    NSUserDefaults* ix = _Get();
    
    return [ix boolForKey:@"SE"];
}

/**
 * SEが有効・無効を設定する
 * @param b 有効フラグ
 */
void SaveData_SetEnableSe(BOOL b) {
    NSUserDefaults* ix = _Get();
    
    [ix setBool:b forKey:@"SE"];
    
    // 保存
    [ix synchronize];
}

/**
 * EASYモードの設定
 */
void SaveData_SetEasy(BOOL b) {
    
    NSUserDefaults* ix = _Get();
    
    [ix setBool:b forKey:@"EASY"];
    
    // 保存
    [ix synchronize];
}

/**
 * EASYモードの取得
 */
BOOL SaveData_IsEasy() {
    
    NSUserDefaults* ix = _Get();
    
    if (SaveData_IsScoreAttack()) {
        
        // スコアアタックモードの時は無効
        return NO;
    }
    
    return [ix boolForKey:@"EASY"];
}

/**
 * スコアアタックモードが有効かどうか
 */
BOOL SaveData_IsScoreAttack() {
    
    NSUserDefaults* ix = _Get();
    
    return [ix boolForKey:@"SCORE_ATTACK"];
}

/**
 * スコアアタックモードの設定
 */
void SaveData_SetScoreAttack(BOOL b) {
    
    NSUserDefaults* ix = _Get();
    
    [ix setBool:b forKey:@"SCORE_ATTACK"];
    
    // 保存
    [ix synchronize];
}

/**
 * ハイスコアを取得する
 * @return ハイスコア
 */
int SaveData2_GetHiScore() {
    
    NSUserDefaults* ix = _Get();
    
    return [ix integerForKey:@"HI_SCORE2"];
}

/**
 * ハイスコアを設定する
 * @param score ハイスコア
 */
void SaveData2_SetHiScore(int score, BOOL bForce) {
    
    NSUserDefaults* ix = _Get();
    
    if (bForce == NO) {
        
        int max = SaveData2_GetHiScore();
        if (score < max) {
            
            // 更新不要
            return;
        }
    }
    
    [ix setInteger:score forKey:@"HI_SCORE2"];
    
    // 保存
    [ix synchronize];
}

/**
 * 到達したことのある最大難易度を取得する
 * @return 最大難易度
 */
int SaveData2_GetRankMax() {
    
    NSUserDefaults* ix = _Get();
    
    return [ix integerForKey:@"RANK_MAX2"];
}

/**
 * 最大難易度を取得する
 * @param rank 最大難易度
 */
void SaveData2_SetRankMax(int rank) {
    
    NSUserDefaults* ix = _Get();
    
    int max = SaveData2_GetRankMax();
    if (rank < max) {
        
        // 更新不要
        return;
    }
    
    [ix setInteger:rank forKey:@"RANK_MAX2"];
    
    // 保存
    [ix synchronize];
    
}

int SaveData2_GetRank()
{
    return RANK_DEFAULT;
}

/**
 * スコア自動送信設定
 */
void SaveData_SetScoreAutoSubmit(BOOL b) {
    
    NSUserDefaults* ix = _Get();
    
    [ix setBool:b forKey:@"SCORE_AUTO_SUBMIT"];
    
    // 保存
    [ix synchronize];
    
}

BOOL SaveData_IsScoreAutoSubmit() {
    
    NSUserDefaults* ix = _Get();
    
    return [ix integerForKey:@"SCORE_AUTO_SUBMIT"];
}
