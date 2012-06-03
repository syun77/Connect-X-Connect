//
//  Exerinya.h
//  Test7
//
//  Created by OzekiSyunsuke on 12/04/03.
//  Copyright 2012年 2dgame.jp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

enum eExerinyaRect
{
    eExerinyaRect_Player1,      // プレイヤー１
    eExerinyaRect_Player2,      // プレイヤー２
    eExerinyaRect_PlayerDamage, // プレイヤーダメージ
    eExerinyaRect_Nasu,         // ナス
    eExerinyaRect_5Box,         // 5箱
    eExerinyaRect_Tako,         // たこ焼き
    eExerinyaRect_Pudding,      // プリン
    eExerinyaRect_Milk,         // 牛乳
    eExerinyaRect_XBox,         // XBox
    eExerinyaRect_Bullet,       // 弾
    eExerinyaRect_Radish,       // 大根
    eExerinyaRect_Carrot,       // 人参
    eExerinyaRect_Pokey,        // ポッキー
    eExerinyaRect_EftBall,      // エフェクト・球体
    eExerinyaRect_EftRing,      // エフェクト・輪っか
    eExerinyaRect_EftBlade,     // エフェクト・刃
    eExerinyaRect_Back,         // 背景
    eExerinyaRect_Banana,       // バナナ (黄色)
    eExerinyaRect_Banana_p1,    // バナナ (黄色＋１)
    eExerinyaRect_Black,        // 暗い部分だけ取る
    eExerinyaRect_Max,
};

// 指定のタイプに対応する矩形を取得する
CGRect Exerinya_GetRect(eExerinyaRect rect);

