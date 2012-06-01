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
