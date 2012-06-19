//
//  AtGauge.mm
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/06/12.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "AtGauge.h"
#import "Math.h"

// ATゲージの上昇アニメ
static const int TIMER_INCREASE = 60;
static const int TIMER_DECREASE = 60;

/**
 * ATゲージの実装
 */
@implementation AtGauge

enum eState {
    eState_Standby,     // 変化なし
    eState_Increase,    // 上昇
    eState_Decrease,    // 減少
};

/**
 * コンストラクタ
 */
- (id)init {
    self = [super init];
    if (self == nil) {
        return self;
    }
    
    m_State = eState_Standby;
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
    
    switch (m_State) {
        case eState_Standby:
            break;
            
        case eState_Increase:
            m_Timer = m_Timer * 0.9;
            
            if (m_Timer < 1) {
                m_State = eState_Standby;
            }
            break;
            
        case eState_Decrease:
            m_Timer = m_Timer * 0.9;
            
            if (m_Timer < 1) {
                m_State = eState_Standby;
            }
            
            break;
            
        default:
            break;
    }
}

/**
 * 上昇ゲージの割合を取得する
 */
- (float)getIncrease {
    
    float d = m_Prev - m_Now;
    
    return m_Now + d * m_Timer / TIMER_INCREASE;
}

- (void)visit {
    [super visit];
    
    const int WIDTH = 80;
    const int HEIGHT = 8;
    
    System_SetBlend(eBlend_Normal);
    
    int x = m_BaseX;
    int y = m_BaseY;
    
    glLineWidth(1);
    {
        glColor4f(1, 1, 1, 0.5);
        [self drawRectLT:x-1 y:y-5 w:WIDTH+2 h:HEIGHT+2 rot:0 scale:1];
        glColor4f(0, 0, 0, 0.5);
        [self fillRectLT:x y:y-4 w:WIDTH h:HEIGHT rot:0 scale:1];
    }
    
    
    float c = 0;
    if (m_Now == m_Max) {
        
        c = 0.5 * Math_SinEx((m_tPast*3)%180);
    }
    
    glLineWidth(HEIGHT);
    switch (m_State) {
        case eState_Standby:
        {
            glColor4f(1, c, c, 1);
            CGPoint origin = CGPointMake(x, y);
            CGPoint destination = CGPointMake(x + WIDTH*m_Now, y);
            ccDrawLine(origin, destination);
            
        }
            break;
        
        case eState_Increase:
        {
            float px1 = x + WIDTH * m_Now;
            float px2 = px1 + WIDTH * (m_Prev - m_Now) * m_Timer / TIMER_INCREASE;
            glColor4f(1, 0, 0, 1);
            CGPoint origin = CGPointMake(x, y);
            CGPoint destination = CGPointMake(px2, y);
            ccDrawLine(origin, destination);
        }
            break;
            
        case eState_Decrease:
            glLineWidth(HEIGHT);
            {
                glColor4f(1, 1, 0, 1);
                float px1 = x + WIDTH * m_Now;
                float px2 = px1 + WIDTH * (m_Prev - m_Now) * m_Timer / TIMER_INCREASE;
                CGPoint origin = CGPointMake(px1, y);
                CGPoint destination = CGPointMake(px2, y);
                ccDrawLine(origin, destination);
            }
            {
                glColor4f(1, 0, 0, 1);
                CGPoint origin = CGPointMake(x, y);
                CGPoint destination = CGPointMake(x + WIDTH*m_Now, y);
                ccDrawLine(origin, destination);
            }
            break;
        default:
            break;
    }
    
    /*
    glLineWidth(HEIGHT);
    {
        glColor4f(1, 1, 0, 1);
        float px1 = x + WIDTH * m_Now;
        float px2 = px1 + WIDTH * (m_Prev - m_Now) * m_Timer / TIMER_INCREASE;
        CGPoint origin = CGPointMake(px1, y);
        CGPoint destination = CGPointMake(px2, y);
        ccDrawLine(origin, destination);
    }
    {
        glColor4f(1-c, 0, 0, 1);
        CGPoint origin = CGPointMake(x, y);
        CGPoint destination = CGPointMake(x + WIDTH*m_Now, y);
        ccDrawLine(origin, destination);
    }
     */
    
    glLineWidth(1);
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

// AT初期値の設定
- (void)initAt:(float)v {
    
    m_Now  = v;
    m_Max  = 1;
    m_Prev = v;
}

// ATを設定 (上昇用)
- (void)setAt:(float)v {
    
    m_Prev = m_Now;
    m_Now = v;
    m_Timer = TIMER_INCREASE;
    m_State = eState_Increase;
}

// ATを設定 (ダメージ用)
- (void)damageAt:(float)v {
    
    m_Prev = m_Now;
    m_Now = v;
    m_State = eState_Decrease;
    m_Timer = TIMER_DECREASE;
}

@end
