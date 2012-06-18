//
//  EnemyTbl.h
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/06/19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef Connect_X_Connect_EnemyTbl_h
#define Connect_X_Connect_EnemyTbl_h

// 敵出現テーブル
struct EnemyParam {
    eEnemy m_Id;    // 敵の種類

};

static EnemyParam s_tbl[] = {
    {eEnemy_Nasu},
    {eEnemy_Tako},
    {eEnemy_Nasu},
    {eEnemy_Tako},
    {eEnemy_5Box},
    {eEnemy_Nasu},
    {eEnemy_Tako},
    {eEnemy_Nasu},
    {eEnemy_Tako},
    {eEnemy_Milk},
    {eEnemy_Nasu},
    {eEnemy_Tako},
    {eEnemy_Nasu},
    {eEnemy_Tako},
    {eEnemy_Pudding},
    {eEnemy_Nasu},
    {eEnemy_Tako},
    {eEnemy_Milk},
    {eEnemy_Nasu},
    {eEnemy_XBox},
};

#endif
