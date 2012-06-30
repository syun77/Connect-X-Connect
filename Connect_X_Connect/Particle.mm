//
//  Particle.m
//  Test7
//
//  Created by OzekiSyunsuke on 12/03/31.
//  Copyright 2012年 2dgame.jp. All rights reserved.
//

#import "Particle.h"
#import "Exerinya.h"
#import "SceneMain.h"

// 消滅用のタイマー
static const int TIMER_VANISH = 48;

@implementation Particle

/**
 * コンストラクタ
 */
- (id)init {
    self = [super init];
    
    if (self == nil) {
        return self;
    }
    
    [self load:@"all.png"];
    [self setScale:0.5];
    
    CGRect r = Exerinya_GetRect(eExerinyaRect_EftBall);
    [self.m_pSprite setTextureRect:r];
    
    [self setBlend:eBlend_Add];
    
    return self;
}

/**
 * 初期化
 */
- (void)initialize {
    m_Timer = 0;    
    m_bBlink = NO;
    [self setVisible:YES];
    [self setAlpha:255];
    [self setColor:ccc3(0xFF, 0xFF, 0xFF)];
}

/**
 * 更新
 */
- (void)update:(ccTime)dt {
    [self move:dt];
    
    self._vx *= 0.95f;
    self._vy *= 0.95f;
    
    switch (m_Type) {
        case eParticle_Ball:
            // 縮小する
            m_Timer++;
            
            self.scale = self.scale * 0.9f;
            
            // じわじわ半透明にして消す
            [self setAlpha:[self getAlpha] * 0.97f];
            
            break;
        case eParticle_Ring:
            // 拡大する
            m_Timer++;
            
            m_Val *= 0.97f;
            self.scale = self.scale + m_Val;
            
            // じわじわ半透明にして消す
            [self setAlpha:[self getAlpha] * 0.95f];
            
        case eParticle_Blade:
            // 縮小する
            m_Timer++;
            
            self.scale = self.scale * 0.9f;
            
            // じわじわ半透明にして消す
            [self setAlpha:[self getAlpha] * 0.97f];
            break;
            
        case eParticle_Rect:
            m_Timer++;
            if (m_Timer > TIMER_VANISH/2) {
                m_bBlink = YES;
            }
            break;
            
        case eParticle_Circle:
            break;
            
        default:
            break;
    }
    
    if (m_Timer > TIMER_VANISH) {
        // 普通に消す
        [self vanish];
    }
    
    if (m_bBlink) {
        // 点滅して消す
        if (m_Timer > 32) {
            if (m_Timer % 4 < 2) {
                [self setVisible:YES];
            } else {
                [self setVisible:NO];
            }
        }
        
        if (m_Timer > 64) {
            
            // 消滅
            NSLog(@"vanish[%d]", [self getIndex]);
            
            [self vanish];
        }
    }
}

/**
 * プリミティブ描画
 */
- (void)visit {
    [super visit];
    
    if (self.visible == NO) {
        return;
    }
    
    switch (m_Type) {
        case eParticle_Rect:
            System_SetBlend(eBlend_Normal);
            glColor4f(0.5, 0.5, 0.5, 0.8);
            [self fillRect:self._x cy:self._y w:4 h:4 rot:0 scale:1];
            
            break;
            
        case eParticle_Circle:
        {
            float ratio = (float)(TIMER_VANISH - m_Timer) / TIMER_VANISH;
            float val = ratio * TIMER_VANISH * 0.1f;
            if (val < 1) {
                val = 1;
            }
            m_Timer += val;
            System_SetBlend(eBlend_Add);
            float a = ratio;
            float w = 1 + 7 * ratio;
            
            switch (m_Color) {
                case eColor_Red:
                    glColor4f(1, 0, 0, a);
                    break;
                    
                case eColor_Green:
                    glColor4f(0, 1, 0, a);
                    break;
                    
                default:
                    break;
            }
            glLineWidth(w);
            [self drawCircle:self._x cy:self._y radius:m_Timer];
            glLineWidth(1);
        }
            break;
            
        default:
            break;
    }
    
    System_SetBlend(eBlend_Normal);
    
}

/**
 * 種別の設定
 */
- (void)setType:(eParticle)type {
    
    [self.m_pSprite setVisible:YES];
    
    m_Type = type;
    CGRect r = Exerinya_GetRect(eExerinyaRect_EftBall); 
    switch (m_Type) {
        case eParticle_Ball:
            r = Exerinya_GetRect(eExerinyaRect_EftBall);
            break;
            
        case eParticle_Ring:
            r = Exerinya_GetRect(eExerinyaRect_EftRing);
            m_Val = 0.1;
            break;
            
        case eParticle_Blade:
            r = Exerinya_GetRect(eExerinyaRect_EftBlade);
            break;
            
        default:
            [self.m_pSprite setVisible:NO];
            break;
    }
    
    [self setTexRect:r];
    
}

// タイマーの設定
- (void)setTimer:(int)timer {
    m_Timer = timer;
}

// 色の設定
- (void)setColorType:(eColor)c {
    m_Color = c;
}

/**
 * 要素の追加
 */
+ (Particle*)add:(eParticle)type x:(float)x y:(float)y rot:(float)rot speed:(float)speed {
    
    SceneMain* scene = [SceneMain sharedInstance];
    Particle* p = (Particle*)[scene.mgrParticle add];
    if (p) {
        [p set2:x y:y rot:rot speed:speed ax:0 ay:0];
        [p setType:type];
    }
    
    return p;
}

/**
 * ダメージエフェクト再生
 */
+ (void)addDamage:(float)x y:(float)y {
    
    Particle* p = [Particle add:eParticle_Ring x:x y:y rot:0 speed:0];
    if (p) {
        [p setScale:0.25];
        [p setAlpha:255];
    }
    
    float rot = 0;
    for (int i = 0; i < 6; i++) {
        rot += Math_RandFloat(30, 60);
        float scale = Math_RandFloat(.35, .75);
        float speed = Math_RandFloat(120, 640);
        Particle* p2 = [Particle add:eParticle_Ball x:x y:y rot:rot speed:speed];
        if (p2) {
            [p2 setScale:scale];
        }
    }
}

/**
 * 死亡エフェクト再生
 */
+ (void)addDead:(float)x y:(float)y {
    
    Particle* p = [Particle add:eParticle_Ring x:x y:y rot:0 speed:0];
    if (p) {
        [p setScale:1.5];
        [p setAlpha:0xff];
    }
    
    float rot = 0;
    for (int i = 0; i < 6; i++) {
        rot += Math_RandFloat(30, 60);
        float scale = Math_RandFloat(.75, 1.5);
        float speed = Math_RandFloat(120, 640);
        Particle* p2 = [Particle add:eParticle_Ball x:x y:y rot:rot speed:speed];
        if (p2) {
            [p2 setScale:scale];
        }
    }
    rot = 0;
    for (int i = 0; i < 3; i++) {
        rot += Math_RandFloat(60, 120);
        float scale = Math_RandFloat(1, 2);
        float speed = Math_RandFloat(30, 120);
        float px = x + speed * Math_CosEx(rot);
        float py = y + speed * -Math_SinEx(rot);
        Particle* p2 = [Particle add:eParticle_Blade x:px y:py rot:rot speed:speed];
        if (p2) {
            [p2 setScale:scale];
            [p2 setRotation:rot];
        }
    }
}

// シールド破壊エフェクトを生成
+ (void)addShieldBreak:(float)x y:(float)y {
    
    float dRot = 360 / 8.0;
    float rot = Math_Randf(dRot);
    for (int i = 0; i < 8; i++) {
        
        float speed = 150 + Math_Randf(75);
        rot += dRot + Math_Randf(15);
        
        Particle* p = [Particle add:eParticle_Rect x:x y:y rot:rot speed:speed];
        if (p) {
            [p setScale:1.5];
            [p setAlpha:0xFF];
            p._ay = -5;
        }
    }
    
}

// ブロック出現エフェクトを生成
+ (Particle*)addBlockAppear:(float)x y:(float)y {
    
    Particle* p = [Particle add:eParticle_Circle x:x y:y rot:0 speed:1];
    
    if (p) {
        [p setAlpha:0xFF];
        [p setColorType:eColor_Red];
    }
    
    return p;
}

@end

