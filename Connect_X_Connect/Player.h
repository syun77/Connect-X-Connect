//
//  Player.h
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/06/04.
//  Copyright 2012年 2dgames.jp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Token.h"
#import "AsciiFont.h"

/**
 * プレイヤー
 */
@interface Player : Token {
    
    AsciiFont*  m_pFont;
    
    int m_tPast;    // 経過時間
    int m_tDamage;  // ダメージタイマー
    int m_tAttack;  // 攻撃タイマー
    
    int m_Hp;       // HP
    int m_HpMax;    // 最大HP
    
    int m_Mp;       // MP
    int m_MpMax;    // 最大MP
    
}

@property (nonatomic, retain)AsciiFont* m_pFont;

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

// 死亡したかどうか
- (BOOL)isDead;

// 死亡
- (void)destroy;

// MPの割合を取得する
- (float)getMpRatio;

// MPが最大値かどうか
- (BOOL)isMpMax;

// MPをクリアする
- (void)clearMp;

// MPを増やす
- (void)addMp:(int)v;

// 攻撃開始
- (void)doAttack;

@end
