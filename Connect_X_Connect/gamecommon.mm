#import "gamecommon.h"

// スクリーン座標からチップ座標への変換
int GameCommon_ScreenXToChipX(int screenX) {
    int x = screenX - FIELD_OFS_X;
    
    return x / BLOCK_SIZE;
}

int GameCommon_ScreenYToChipY(int screenY) {
    int y = screenY - FIELD_OFS_Y;
    
    return y / BLOCK_SIZE;
}

// チップ座標からスクリーン座標への変換
int GameCommon_ChipXToScreenX(int chipX) {
    int x = chipX * BLOCK_SIZE;
    
    return x + FIELD_OFS_X;
}

int GameCommon_ChipYToScreenY(int chipY) {
    int y = chipY * BLOCK_SIZE;
    
    return y + FIELD_OFS_Y;
}

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
int GameCommon_GetScore(int nVanish, int nConnect, int nKind, int nChain, int nCombo) {
    
    // 消去数 x 10 x (最大連結数 + 色数ボーナス + 連鎖ボーナス + コンボボーナス)
    int ret = 0;
    int a   = nVanish;
    int b   = 10;
    int c   = nConnect;
    int d   = nKind;
    int e   = nChain;
    int f   = nCombo;
    
    // 連結ボーナス
    if (c <= 2) {
        c = 0;
    }
    else {
        c = c - 2;
    }
    
    // 色数ボーナス
    if (d <= 2) {
        d = d - 1;
    }
    else {
        d = (d - 2) * 2;
    }
    
    // 連鎖ボーナス
    if (e <= 1) {
        e = 0;
    }
    else {
        e = (e - 1) * 12;
    }
    
    // コンボボーナス
    if (f <= 1) {
        f = 0;
    }
    else {
        f = (f - 1) * 4;
    }
    
    ret = a * b * (c + d + e + f);
    
    if (ret < 10) {
        ret = 10;
    }
    
//    NSLog(@"\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d", nVanish, nConnect, c, nKind, d, nChain, e, nCombo, f, ret);
    
    return ret;
}

int GameCommon_LevelToSound(int nLevel) {
    
    if (nLevel < 10) {
        return 0;
    }
    else if(nLevel < 30) {
        return 1;
    }
    else {
        int lv = (nLevel - 30)/15%4;
        
        switch (lv) {
            case 0:
                return 5;
                
            case 1:
                return 2;
                
            case 2:
                return 3;
                
            default: // case 3:
                return 4;
        }
    }
}

/**
 * サウンド番号に対応したファイル名を取得する
 * @param サウンド番号
 * @return ファイルパス
 */
NSString* GameCommon_GetSoundFile(int nSound) {
    switch (nSound) {
        case 0: { return @"nu_sunday.mp3"; }
        case 1: { return @"sayonara_satellites.mp3"; }
        case 2: { return @"alyssum.mp3"; }
        case 3: { return @"robiopsys.mp3"; }
        case 4: { return @"babys_breath.mp3"; }
        case 5: { return @"straycat.mp3"; }
            
        default: { return @"alyssum.mp3"; }
    }
}

/**
 * サウンド番号に対応した曲名を取得する
 * @param サウンド番号
 * @return 曲名
 */
NSString* GameCommon_GetSoundName(int nSound) {
    switch (nSound) {
        case 0: { return @"nu sunday"; }
        case 1: { return @"sayonara satellites"; }
        case 2: { return @"alyssum"; }
        case 3: { return @"robiopsys"; }
        case 4: { return @"babys breath"; }
        case 5: { return @"straycat"; }
            
        default: { return @"alyssum"; }
    }
    
}
