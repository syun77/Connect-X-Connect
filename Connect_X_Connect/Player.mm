//
//  Player.mm
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/06/04.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Player.h"
#import "SceneMain.h"
#import "Exerinya.h"

static const int PLAYER_POS_X = 64;
static const int PLAYER_POS_Y = 480 - 80;

/**
 * プレイヤーの実装
 */
@implementation Player

/**
 * コンストラクタ
 */
- (id)init {
    self = [super init];
    if (self == nil) {
        return self;
    }
    
    [self load:@"all.png"];
    [self create];
    self._x = PLAYER_POS_X;
    self._y = PLAYER_POS_Y;
    CGRect r = Exerinya_GetRect(eExerinyaRect_Player1);
    [self setTexRect:r];
    [self setScale:0.5f];
    
    m_Hp = HP_MAX;
    
    return self;
}

/**
 * 更新
 */
- (void)update:(ccTime)dt {
    
    [self move:0];
    
    m_tPast++;
    if (m_tPast%64 < 32) {
        CGRect r = Exerinya_GetRect(eExerinyaRect_Player1);
        [self setTexRect:r];
    }
    else {
        CGRect r = Exerinya_GetRect(eExerinyaRect_Player2);
        [self setTexRect:r];
    }
}

// ----------------------------------------------------
// private
/**
 * HPゲージの取得
 */
- (HpGauge*)_getGauge {
    
    return [SceneMain sharedInstance].hpGauge;
}

// ----------------------------------------------------
// public

/**
 * HPを初期化する
 */
- (void)initHp {
    
    m_Hp = HP_MAX;
    m_HpMax = HP_MAX;
    HpGauge* hpGauge = [self _getGauge];
    [hpGauge initHp:[self getHpRatio]];
    
    // 描画座標を設定
    [hpGauge setPos:32 y:480-128];
}

/**
 * 現在HPの割合を取得する
 */
- (float)getHpRatio {
    return 1.0 * m_Hp / m_HpMax;
}

/**
 * HPの増加
 */
- (void)addHp:(int)v {
    
    // HPを増やす
    m_Hp += v;
    if (m_Hp > m_HpMax) {
        m_Hp = m_HpMax;
    }
    HpGauge* hpGauge = [self _getGauge];
    [hpGauge initHp:[self getHpRatio]];
}

/**
 * ダメージを与える
 */
- (void)damage:(int)v {
    
    m_Hp -= v;
    if (m_Hp < 0) {
        m_Hp = 0;
    }
    
    HpGauge* hpGauge = [self _getGauge];
    [hpGauge setHp:[self getHpRatio]];
}
@end
