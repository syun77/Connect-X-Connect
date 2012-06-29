//
//  HpGauge.mm
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/06/02.
//  Copyright 2012年 2dgame.jp. All rights reserved.
//

#import "HpGauge.h"
#import "SceneMain.h"
#import "Math.h"

// HPの減少アニメ時間
static const int TIMER_DECREASE = 60;

@implementation HpGauge

/**
 * コンストラクタ
 */
- (id)init {
    self = [super init];
    if (self == nil) {
        return self;
    }
    
    m_Timer = 0;
    m_Now   = 0;
    m_Prev  = 0;
    
    [self load:@"font.png"];
    [self.m_pSprite setVisible:NO];
    [self create];
    
    return self;
}

// 更新
- (void)update:(ccTime)dt {
    
    m_tPast++;
    
    if(m_Timer > 0) {
        m_Timer--;
    }
}

/**
 * 減少ゲージの割合を取得する
 */
- (float)getDecrease {
    
    float d = m_Prev - m_Now;
    
    return m_Now + d * m_Timer / TIMER_DECREASE;
}

- (void)visit {
    [super visit];
    
    const int WIDTH = 80;
    const int HEIGHT = 4;
    
    
    int x = m_BaseX;
    int y = m_BaseY;
    
    System_SetBlend(eBlend_Normal);
    glLineWidth(1);
    {
        glColor4f(1, 1, 1, 1);
        [self drawRectLT:x-1 y:y-3 w:WIDTH+2 h:HEIGHT+2 rot:0 scale:1];
        glColor4f(0, 0, 0, 0.5);
        [self fillRectLT:x y:y-2 w:WIDTH h:HEIGHT rot:0 scale:1];
    }
    
    System_SetBlend(eBlend_Add);
    float c = 0.3 * Math_SinEx(m_tPast%180);
    
    glLineWidth(HEIGHT);
    {
        glColor4f(1, 1, 0, 1);
        float px1 = x + WIDTH * m_Now;
        float px2 = px1 + WIDTH * (m_Prev - m_Now) * m_Timer / TIMER_DECREASE;
        CGPoint origin = CGPointMake(px1, y);
        CGPoint destination = CGPointMake(px2, y);
        ccDrawLine(origin, destination);
    }
    {
        glColor4f(0, 1-c, 0, 1);
        CGPoint origin = CGPointMake(x, y);
        CGPoint destination = CGPointMake(x + WIDTH*m_Now, y);
        ccDrawLine(origin, destination);
    }
    
    System_SetBlend(eBlend_Normal);
    
}

// ----------------------------------------------------
// public

/**
 * 描画座標を設定
 */
- (void)setPos:(int)x y:(int)y {
    
    m_BaseX = x;
    m_BaseY = y;
}

// HP初期値の設定
- (void)initHp:(float)v {
    
    m_Now = v;
    m_Prev = v;
}

// HPを設定 (ダメージ用)
- (void)setHp:(float)v {
    
    m_Prev = m_Now;
    m_Now = v;
    m_Timer = TIMER_DECREASE;
}

// HPを設定 (回復用)
- (void)setHpRecover:(float)v {
    
}

@end
