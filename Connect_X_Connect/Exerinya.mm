//
//  Exerinya.mm
//  Test7
//
//  Created by OzekiSyunsuke on 12/04/03.
//  Copyright 2012年 2dgame.jp. All rights reserved.
//

#import "Exerinya.h"


// 指定のタイプに対応する矩形を取得する
CGRect Exerinya_GetRect(eExerinyaRect rect) {
    static const CGRect tbl[] = {
        {0,   0,   128, 128}, // eExerinyaRect_Player1,      // プレイヤー１
        {128, 0,   128, 128}, // eExerinyaRect_Player2,      // プレイヤー２
        {256, 0,   128, 128}, // eExerinyaRect_PlayerDamage, // プレイヤーダメージ
        {0,   128, 128, 128}, // eExerinyaRect_Nasu,         // ナス
        {128, 128, 128, 128}, // eExerinyaRect_5Box,         // 5箱
        {128, 396, 128, 128}, // eExerinyaRect_Tako,         // たこ焼き
//        {768, 256, 256, 256}, // eExerinyaRect_Pudding,      // プリン
        {769, 257, 254, 254}, // eExerinyaRect_Pudding,      // プリン
        {256, 128, 256, 256}, // eExerinyaRect_Milk,         // 牛乳
        {512, 128, 256, 256}, // eExerinyaRect_XBox,         // XBox
        {0,   256,  64,  64}, // eExerinyaRect_Bullet,       // 弾
        {0,   396, 128, 128}, // eExerinyaRect_Radish,       // 大根
        {128, 256, 128, 128}, // eExerinyaRect_Carrot,       // 人参
        {256, 396, 128, 128}, // eExerinyaRect_Pokey,        // ポッキー
        {768, 0,   128, 128}, // eExerinyaRect_EftBall,      // エフェクト・球体
        {896, 0,   128, 128}, // eExerinyaRect_EftRing,      // エフェクト・輪っか
        {768, 128, 256, 128}, // eExerinyaRect_EftBlade,     // エフェクト・刃
        {0,   544, 640, 480}, // eExerinyaRect_Back,         // 背景
        {0,   320,  64,  64}, // eExerinyaRect_Banana,       // バナナ
        {64,  320,  64,  64}, // eExerinyaRect_Banana_p1,    // バナナ＋１
        {768, 0,     1,   1},
    };
    
    return tbl[rect];
}
