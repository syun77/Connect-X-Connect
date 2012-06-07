//
//  Enemy.h
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/06/05.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Token.h"

/**
 * 敵クラス
 */
@interface Enemy : Token {
    
    int m_State;    // 状態
    int m_Timer;    // タイマー
    
    int m_tPast;    // 経過時間
    int m_tDamage;  // ダメージタイマー
    
    int m_Hp;       // HP
    int m_HpMax;    // 最大HP
}

// HPを初期化する
- (void)initHp;

// 現在HPの割合を取得する
- (float)getHpRatio;

// HPの増加
- (void)addHp:(int)v;

// ダメージを与える
- (void)damage:(int)v;

// 危険状態かどうか
- (BOOL)isDanger;

// 死亡
- (void)destroy;

// 死亡したかどうか
- (BOOL)isDead;

@end
