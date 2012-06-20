//
//  LevelUp.mm
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/06/20.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "LevelUp.h"
#import "SceneMain.h"

// タイマー
static const int TIMER_APPEAR = 10; // 出現までの時間
static const int TIMER_MAIN = 40;   // カットイン時間
static const int TIMER_HIDE = 10;   // 退出時間

/**
 * 状態
 */
enum eState {
    eState_Standby,
    eState_Appear,
    eState_Main,
    eState_Hide,
};

@implementation LevelUp

- (AsciiFont*)_getLevelUpFont {
    return [SceneMain sharedInstance].fontLevelup;
}

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
    
    [self load:@"font.png"];
    [self.m_pSprite setVisible:NO];
    [self create];
    
    return self;
}

/**
 * 更新
 */
- (void)update:(ccTime)dt {
    
    m_tPast++;
    
    AsciiFont* font = [self _getLevelUpFont];
    [font setPosScreen:self._x y:self._y];
    
    switch (m_State) {
        case eState_Appear:
            
            self._x -= 32;
            
//            m_Timer--;
//            if (m_Timer < 1) {
            if (self._x < 240 - 16) {
                m_State = eState_Main;
                m_Timer = TIMER_MAIN;
            }
            break;
            
        case eState_Main:
            
            self._x -= 1;
            m_Timer--;
            if (m_Timer < 1) {
                m_State = eState_Hide;
                m_Timer = TIMER_HIDE;
            }
            break;
            
        case eState_Hide:
            
            self._x -= 32;
            
            m_Timer--;
            if (m_Timer < 1) {
                m_State = eState_Standby;
                m_Timer = 0;
            }
            break;
            
        default:
            break;
    }
}

/**
 * プリミティブ描画
 */
- (void)visit {
    
    if (m_State != eState_Standby) {
        System_SetBlend(eBlend_Add);
        glLineWidth(2);
        float a = 0.2;
        if (m_State == eState_Hide) {
            a = 0.2 * m_Timer / TIMER_HIDE;
        }
        
        int t = m_tPast * 4;
        if (t > 90) {
//            t = 90;
        }
        float y1 = 248 + 32 * Math_SinEx(t);
        float y2 = 248 + 32 * Math_SinEx(t + 180);
        
        float r = Math_Randf(1);
        float g = Math_Randf(1);
        float b = Math_Randf(1);
        
        glColor4f(r, g, b, a);
        [self drawRectLT:0 y:y1 w:480 h:1 rot:0 scale:1];
        [self drawRectLT:0 y:y2 w:480 h:1 rot:0 scale:1];
        
        System_SetBlend(eBlend_Normal);
    }
}

/**
 * 演出開始
 */
- (void)start {
    
    m_State = eState_Appear;
    m_Timer = TIMER_APPEAR;
    
    AsciiFont* font = [self _getLevelUpFont];
    [font setVisible:YES];
    
    m_tPast = 0;
    self._x = 424;
    self._y = 240+8;
}

@end
