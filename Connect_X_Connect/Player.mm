//
//  Player.mm
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/06/04.
//  Copyright 2012年 2dgames.jp. All rights reserved.
//

#import "Player.h"
#import "SceneMain.h"
#import "Exerinya.h"
#import "FontEffect.h"

static const int PLAYER_POS_X = 64;
static const int PLAYER_POS_Y = 480 - 108;
static const int PLAYER_POS_DAMAGE = PLAYER_POS_Y - 16;
static const int TIMER_DAMAGE = 30;
static const int TIMER_ATTACK = 30;
static const int MP_MAX = 40;
static const int MP_MAX_INC = 40;

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
    [self setVisible:NO];
    
    m_Hp = HP_MAX;
    m_MpMax = MP_MAX;
    
    // TODO:
    m_Mp = MP_MAX;
    m_Mp = 0;
    
    return self;
}

/**
 * フォントを登録
 */
- (void)attachLayer:(CCLayer *)layer {
    
    self.m_pFont = [AsciiFont node];
    [self.m_pFont createFont:layer length:24];
    [self.m_pFont setAlign:eFontAlign_Center];
    [self.m_pFont setPos:8 y:42];
    [self.m_pFont setScale:2];
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
    CGRect r = Exerinya_GetRect(eExerinyaRect_Player2);
    [self setTexRect:r];
    [self setColor:ccc3(0xFF, 0xFF, 0xFF)];
    
    self._x = PLAYER_POS_X;
    self._y = PLAYER_POS_Y;
    
    if (m_tDamage > 0) {
        
        // ダメージ中
        m_tDamage--;
        CGRect r = Exerinya_GetRect(eExerinyaRect_PlayerDamage);
        [self setTexRect:r];
        if (m_tDamage%8 < 4) {
            
            // ダメージ演出
            [self setColor:ccc3(0xFF, 0, 0)];
        }
        
        self._x += (m_tPast%8 < 4 ? -1 : 1) * Math_Randf(m_tDamage * 0.5);
        self._y += -m_tDamage*0.5 + Math_Randf(m_tDamage);
    }
    else {
        
        if ([self isDanger] && m_tPast%48 < 24) {
            
            // HP危険
            CGRect r = Exerinya_GetRect(eExerinyaRect_PlayerDamage);
            [self setTexRect:r];
        }
        
    }
    
    // 攻撃演出
    if (m_tAttack > 0) {
        m_tAttack--;
        CGRect r = Exerinya_GetRect(eExerinyaRect_Player1);
        [self setTexRect:r];
        
        m_tPast = 0;
        
        self._x += 16;
    }
    
    
    self._y += 2 * Math_SinEx(m_tPast*2);
    
    // HPフォントの色設定
    if ([self getHpRatio] < 0.3) {
        
        [self.m_pFont setColor:ccc3(0xFF, 0x80, 0x80)];
    }
    else if([self getHpRatio] < 0.5) {
        
        [self.m_pFont setColor:ccc3(0xFF, 0xFF, 0x80)];
    }
    else {
        
        [self.m_pFont setColor:ccc3(0xFF, 0xFF, 0xFF)];
    }
    
    if ([self isDead] == NO && [self isMpMax]) {
        if (m_tPast%32 == 16) {
            
            Particle* p = [Particle addBlockAppear:self._x y:self._y];
            if (p) {
                
                // 緑色にする
                [p setColorType:eColor_Green];
            }
        }
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
    [self setVisible:YES];
}

/**
 * HPを初期化する
 */
- (void)initHp {
    
    // 表示する
    [self setVisible:YES];
    
    m_Hp = HP_MAX;
    m_HpMax = HP_MAX;
    
    HpGauge* hpGauge = [self _getGauge];
    [hpGauge initHp:[self getMpRatio]];
    
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
//    HpGauge* hpGauge = [self _getGauge];
//    [hpGauge initHp:[self getHpRatio]];
    [self _setFont];
}

/**
 * ダメージを与える
 */
- (void)damage:(int)v {
    
    // 計算前の値を保持しておく
    int prev = m_Hp;
    
    m_Hp -= v;
    if (m_Hp < 0) {
        
        if (prev >= 2) {
            
            // 30以上の場合、一撃では死なないようにしておく
            m_Hp = 1;
        }
        else {
            m_Hp = 0;
        }
        
    }
    
//    HpGauge* hpGauge = [self _getGauge];
//    [hpGauge setHp:[self getHpRatio]];
    [self _setFont];
    
    // ダメージ演出開始
    m_tDamage = TIMER_DAMAGE;
    
    [FontEffect add:eFontEffect_Damage x:PLAYER_POS_X y:PLAYER_POS_DAMAGE text:[NSString stringWithFormat:@"%d", v]];
    
    // ダメージエフェクト再生
    [Particle addDamage:PLAYER_POS_X y:PLAYER_POS_Y];
    
    Sound_PlaySe(@"hit03.wav");
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
    
    Sound_PlaySe(@"damage3.wav");
    
    // 非表示にする
    [self setVisible:NO];
}

/**
 * MPの割合を取得する
 */
- (float)getMpRatio {
    
    return 1.0 * m_Mp / m_MpMax;
}

/**
 * MPが最大値かどうか
 */
- (BOOL)isMpMax {
    
    return m_Mp == m_MpMax;
}

/**
 * MPをクリアする
 */
- (void)clearMp {
    
    m_Mp = 0;
    
    // 最大MPを増やす
    m_MpMax += MP_MAX_INC;
    
    HpGauge* hpGauge = [self _getGauge];
    [hpGauge setHpRecover:[self getMpRatio]];
    
    Particle* p = [Particle addBlockAppear:self._x y:self._y];
    if (p) {
        
        // 緑色にする
        [p setColorType:eColor_Green];
    }
}

/**
 * MPを増やす
 */
- (void)addMp:(int)v {
    
    BOOL bPrev = [self isMpMax];
    
    m_Mp += v;
    if (m_Mp > m_MpMax) {
        
        m_Mp = m_MpMax;
    }
    
    if (bPrev == NO) {
        if ([self isMpMax]) {
            
            // MPが最大値に達した
            Sound_PlaySe(@"key.wav");
            
            Particle* p = [Particle addBlockAppear:self._x y:self._y];
            if (p) {
                
                // 緑色にする
                [p setColorType:eColor_Green];
            }
        }
    }
    
    HpGauge* hpGauge = [self _getGauge];
    [hpGauge setHpRecover:[self getMpRatio]];
}

// 攻撃開始
- (void)doAttack {
    m_tAttack = TIMER_ATTACK;
}
@end
