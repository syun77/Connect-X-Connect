//
//  Player.mm
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/06/04.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Player.h"
#import "SceneMain.h"

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
    [self setVisible:NO];
    
    m_Hp = HP_MAX;
    
    return self;
}

/**
 * 更新
 */
- (void)update:(ccTime)dt {
    
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
