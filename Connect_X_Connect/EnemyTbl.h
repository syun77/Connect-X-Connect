//
//  EnemyTbl.h
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/06/19.
//  Copyright (c) 2012年 2dgames.jp. All rights reserved.
//

#ifndef Connect_X_Connect_EnemyTbl_h
#define Connect_X_Connect_EnemyTbl_h

/**
 * 敵の種類
 */
enum eEnemy {
    eEnemy_Nasu,
    eEnemy_Tako,
    eEnemy_5Box,
    eEnemy_Pudding,
    eEnemy_Milk,
    eEnemy_XBox,
};

static CGRect _getEnemyTexRect(eEnemy type)
{
    float px = 120 * type;
    float py = 0;
    
    return CGRectMake(px, py, 120, 120);
}

/**
 * 攻撃種別
 */
enum eAttack {
    eAttack_Upper,      // 上から降らす
    eAttack_UpperS1,    // 上から降らす (シールド+1)
    eAttack_UpperS2,    // 上から降らす (シールド+2)
    eAttack_UpperD,     // 上から降らす (ドクロ)
    eAttack_UpperDS1,   // 上から降らす (ドクロ+1)
    eAttack_Bottom,     // 下からせり上げる
    eAttack_BottomS1,   // 下からせり上げる (シールド+1)
    eAttack_BottomS2,   // 下からせり上げる (シールド+2)
};

// 敵出現テーブル
struct EnemyParam {
    eEnemy m_Id;        // 敵の種類
    eAttack m_Attack;   // 攻撃パターン

};

static EnemyParam s_appear[] = {
    {eEnemy_Nasu,       eAttack_Upper},
    {eEnemy_Tako,       eAttack_UpperD},
    {eEnemy_Nasu,       eAttack_Upper},
    {eEnemy_Tako,       eAttack_UpperD},
    {eEnemy_5Box,       eAttack_UpperS1},
    {eEnemy_Nasu,       eAttack_Upper},
    {eEnemy_Tako,       eAttack_UpperD},
    {eEnemy_Pudding,    eAttack_UpperS2},
    {eEnemy_Nasu,       eAttack_Upper},
    {eEnemy_5Box,       eAttack_UpperS1},
    {eEnemy_Nasu,       eAttack_Upper},
    {eEnemy_Tako,       eAttack_UpperD},
    {eEnemy_Milk,       eAttack_UpperS1},
    {eEnemy_Nasu,       eAttack_Upper},
    {eEnemy_5Box,       eAttack_UpperS1},
    {eEnemy_Nasu,       eAttack_Upper},
    {eEnemy_Tako,       eAttack_UpperD},
    {eEnemy_Pudding,    eAttack_UpperS2},
    {eEnemy_Nasu,       eAttack_Upper},
    {eEnemy_XBox,       eAttack_Bottom},
};

struct EnemyTbl {
    eExerinyaRect   m_Id;       // 敵ID
    int             m_HpFix;    // HP固定値
    int             m_HpVal;    // HP変動値
    int             m_dAt;      // AT増分
    int             m_CntFix;   // ブロック降らす・固定値
    int             m_CntVal;   // ブロック降らす・変動値
    int             m_DivLevel; // レベル間隔
    
};

static EnemyTbl s_tbl[] = {
    {eExerinyaRect_Nasu,    50,     400,   20, 5,  11,  8},
    {eExerinyaRect_Tako,    25,     250,    40, 2,  5,  8},
    {eExerinyaRect_5Box,    100,    500,   10, 2,  12,  5},
    {eExerinyaRect_Pudding, 1000,   4900,   15, 3,  3,  4},
    {eExerinyaRect_Milk,    1500,   4500,   15, 4,  7,  8},
    {eExerinyaRect_XBox,    2000,   3000,  15, 1,  4,  8},
};

#endif
