//
//  Enemy.mm
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/06/05.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Enemy.h"
#import "SceneMain.h"
#import "Exerinya.h"

static const int ENEMY_POS_X = 320-64;
static const int ENEMY_POS_Y = 480-80;

static const int TIMER_DAMAGE = 30;

/**
 * 敵の実装
 */
@implementation Enemy

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
    
    self._x = ENEMY_POS_X;
    self._y = ENEMY_POS_Y;
    CGRect r = Exerinya_GetRect(eExerinyaRect_Nasu);
    [self setTexRect:r];
    
    m_Hp = HP_MAX;
    
    return self;
}

/**
 * 更新
 */
- (void)update:(ccTime)dt {
    
    [self move:0];
    
    m_tPast++;
    
    float rot = 15 * Math_SinEx(m_tPast/2);
    [self setRotation:rot];
    
    [self setColor:ccc3(0xFF, 0xFF, 0xFF)];
    if (m_tDamage > 0) {
        
        m_tDamage--;
        m_tPast = 0;
        
        if (m_tDamage%8 < 4) {
            
            // ダメージ演出
            [self setColor:ccc3(0xFF, 0, 0)];
        }
    }
}

// -------------------------------------------------
// private
/**
 * HPゲージの取得
 */
- (HpGauge*)_getGauge {
    
    return [SceneMain sharedInstance].hpGaugeEnemy;
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
    [hpGauge setPos:320-32-80 y:480-128];
    [self.m_pSprite setScale:0.5];
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
    
    // ダメージ演出開始
    m_tDamage = TIMER_DAMAGE;
    
    // ダメージ数値表示
    [FontEffect add:eFontEffect_Damage x:self._x y:self._y text:[NSString stringWithFormat:@"%d", v]];
}


@end
