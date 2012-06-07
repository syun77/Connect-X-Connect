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
#import "Particle.h"

// 座標関連
static const int ENEMY_POS_X = 320-64;
static const int ENEMY_POS_Y = 480-80;
static const int ENEMY_POS_LV_Y = ENEMY_POS_Y-64;

// タイマー関連
static const int TIMER_DAMAGE = 30;
static const int TIMER_APPEAR = 30;

/**
 * 状態
 */
enum eState {
    eState_Appear,  // 出現状態
    eState_Standby, // 待機中
    eState_Vanish,  // 消滅演出
};

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
    [self setVisible:NO];
    
    m_Hp = HP_MAX;
    
    return self;
}

- (void)_updateAppear {
    
    [self setVisible:YES];
    
    float x = ENEMY_POS_X;
    float y = ENEMY_POS_Y;
    x += m_Timer * 2;
    self._x = x;
    self._y = y;
    
    m_Timer = m_Timer * 0.9;
    if (m_Timer < 1) {
        
        m_Timer = 0;
        m_State = eState_Standby;
    }
    
}
- (void)_updateStandby {
    
    float rot = 15 * Math_SinEx(m_tPast/2);
    [self setRotation:rot];
    
    [self setColor:ccc3(0xFF, 0xFF, 0xFF)];
    
    self._x = ENEMY_POS_X;
    self._y = ENEMY_POS_Y;
    if (m_tDamage > 0) {
        
        m_tDamage--;
        m_tPast = 0;
        
        if (m_tDamage%8 < 4) {
            
            // ダメージ演出
            [self setColor:ccc3(0xFF, 0, 0)];
        }
        
        self._x += (m_tPast%8 < 4 ? -1 : 1) * Math_Randf(m_tDamage);
        self._y += (-m_tDamage*0.5 + Math_Randf(m_tDamage));
    }
}
- (void)_updateVanish {
    
}

/**
 * 更新
 */
- (void)update:(ccTime)dt {
    
    [self move:0];
    
    m_tPast++;
    
    switch (m_State) {
        case eState_Appear:
            [self _updateAppear];
            break;
            
        case eState_Standby:
            [self _updateStandby];
            break;
            
        case eState_Vanish:
            [self _updateVanish];
            break;
            
        default:
            break;
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

- (AsciiFont*)_getFontLevel {
    return [SceneMain sharedInstance].fontLevel;
}

// ----------------------------------------------------
// public

/**
 * レベルを設定する
 */
- (void)setLevel:(int)lv {
    m_nLevel = lv;
}

/**
 * 初期化
 */
- (void)initialize {
    
    [self setVisible:YES];
    
    m_State = eState_Appear;
    m_Timer = TIMER_APPEAR;
    m_tDamage = 0;
    
    // レベル表示
    AsciiFont* fontLevel = [self _getFontLevel];
    [fontLevel setPosScreen:ENEMY_POS_X y:ENEMY_POS_LV_Y];
    [fontLevel setText:[NSString stringWithFormat:@"Lv %d", m_nLevel]];
    [fontLevel setVisible:YES];
    
    // HPを初期化する
    [self initHp];
    
}

/**
 * HPを初期化する
 */
- (void)initHp {
    
    m_Hp = HP_MAX;
    m_HpMax = HP_MAX;
    
    // TODO:
    m_Hp *= 0.1;
    
    HpGauge* hpGauge = [self _getGauge];
    [hpGauge initHp:[self getHpRatio]];
    
    // 描画座標を設定
    [hpGauge setPos:320-32-80 y:480-128];
    [self.m_pSprite setScale:0.5];
    
    // 出現演出開始
    m_State = eState_Appear;
    m_Timer = TIMER_APPEAR;
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
    [FontEffect add:eFontEffect_Damage x:ENEMY_POS_X y:ENEMY_POS_Y text:[NSString stringWithFormat:@"%d", v]];
    
    // ダメージエフェクト再生
    [Particle addDamage:ENEMY_POS_X y:ENEMY_POS_Y];
    
}

/**
 * 危険状態かどうか
 */
- (BOOL)isDanger {
    
    return [self getHpRatio] < 0.3f;
}

/**
 * 死亡したかどうか
 */
- (BOOL)isDead {
    return m_Hp <= 0;
}

// 死亡
- (void)destroy {
    
    [self setVisible:NO];
    
    // レベル表示を消す
    AsciiFont* fontLevel = [self _getFontLevel];
    [fontLevel setVisible:NO];
    
    // 死亡エフェクト生成
    [Particle addDead:ENEMY_POS_X y:ENEMY_POS_Y];
}

@end
