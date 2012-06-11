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
    
    int m_Id;       // 敵のID
    int m_State;    // 状態
    int m_Timer;    // タイマー
    
    int m_tPast;    // 経過時間
    int m_tDamage;  // ダメージタイマー
    
    int m_Hp;       // HP
    int m_HpMax;    // 最大HP
    
    int m_nLevel;   // 現在のレベル
    
    int m_nAT;      // アクティブタイムゲージ (現在値)
    int m_dAT;      // アクティブタイムゲージ (上昇率)
}

// レベルを設定する
- (void)setLevel:(int)lv;

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

// ターン経過
- (void)doTurn;

// ターン終了
- (void)endTurn;

// 攻撃可能かどうか
- (BOOL)isAttack;

// 攻撃を実行する
- (void)doAttack;

// ATゲージの割合を取得する
- (float)getAtRatio;


@end
