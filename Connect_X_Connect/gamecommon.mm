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
 * @return スコア
 */
int GameCommon_GetScore(int nVanish, int nConnect, int nKind, int nChain) {
    
    // 消去数 x 10 x (最大連結数 + 色数ボーナス + 連鎖ボーナス)
    int ret = 0;
    int a   = nVanish;
    int b   = 10;
    int c   = nConnect;
    int d   = nKind;
    int e   = nChain;
    
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
    
    ret = a * b * (c + d + e);
    
    return ret;
}
