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
#import "FontEffect.h"

static const int PLAYER_POS_X = 64;
static const int PLAYER_POS_Y = 480 - 80;
static const int PLAYER_POS_DAMAGE = PLAYER_POS_Y - 16;
static const int TIMER_DAMAGE = 30;

/**
 * プレイヤーの実装
 */
@implementation Player

@synthesize m_pFont;

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
 * フォントを登録
 */
- (void)attachLayer:(CCLayer *)layer {
    
    self.m_pFont = [AsciiFont node];
    [self.m_pFont createFont:layer length:24];
    [self.m_pFont setAlign:eFontAlign_Center];
    [self.m_pFont setPos:9 y:45];
}

/**
 * デストラクタ
 */
- (void)dealloc {
    
    self.m_pFont = nil;
    
    [super dealloc];
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
    
    self._x = PLAYER_POS_X;
    self._y = PLAYER_POS_Y;
    
    if (m_tDamage > 0) {
        
        // ダメージ中
        m_tDamage--;
        CGRect r = Exerinya_GetRect(eExerinyaRect_PlayerDamage);
        [self setTexRect:r];
        
        self._x += (m_tPast%8 < 4 ? -1 : 1) * Math_Randf(m_tDamage * 0.5);
        self._y += -m_tDamage*0.5 + Math_Randf(m_tDamage);
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

/**
 * フォント文字の更新
 */
- (void)_setFont {
//    [self.m_pFont setText:[NSString stringWithFormat:@"%d/%d", m_Hp, m_HpMax]];
    [self.m_pFont setText:[NSString stringWithFormat:@"%d", m_Hp]];
}

// ----------------------------------------------------
// public

- (void)initialize {
    
    m_tDamage = 0;
    [self initHp];
}

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
    [self _setFont];
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
    [self _setFont];
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
    [self _setFont];
    
    // ダメージ演出開始
    m_tDamage = TIMER_DAMAGE;
    
    [FontEffect add:eFontEffect_Damage x:PLAYER_POS_X y:PLAYER_POS_DAMAGE text:[NSString stringWithFormat:@"%d", v]];
    
    // ダメージエフェクト再生
    [Particle addDamage:PLAYER_POS_X y:PLAYER_POS_Y];
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
    
    // 死亡エフェクト生成
    [Particle addDead:PLAYER_POS_X y:PLAYER_POS_Y];
}

@end
