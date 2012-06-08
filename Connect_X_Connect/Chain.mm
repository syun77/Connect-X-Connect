//
//  Chain.mm
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/06/08.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Chain.h"


static const int PRIO_OFS_CHAINFONT = 20;
static const int TIMER_MAIN = 60;
static const int TIMER_VANISH = 30;
static const float POS_APPEAR_X = 320;
static const float POS_APPEAR_Y = 360;
static const float SPEED_X = -2400;

/**
 * 状態
 */
enum eState {
    eState_Hide,    // 隠れている
    eState_Main,    // 出現中
    eState_Vanish,  // 消滅
};

@implementation Chain

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
    [self setVisible:NO];
    
    return self;
}

/**
 * レイヤーにアタッチする
 */
- (void)attachLayer:(CCLayer *)layer {
    
    int prio = [self getPrio];
    
    self.m_pFont = [AsciiFont node];
    [self.m_pFont setPrio:prio + PRIO_OFS_CHAINFONT];
    [self.m_pFont createFont:layer length:12];
    [self.m_pFont setAlign:eFontAlign_Center];
    [self.m_pFont setScale:2];
    [self.m_pFont setColor:ccc3(0xFF, 0xFF, 0xFF)];
    
    [self.m_pFont setVisible:NO];
    
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
    
    [self move:1/60.0];
    [self.m_pFont setPosScreen:self._x y:self._y];
    
    switch (m_State) {
        case eState_Main:
            m_Timer--;
            self._vx *= 0.75f;
            if (m_Timer < 1) {
                m_State = eState_Vanish;
                m_Timer = TIMER_VANISH;
            }
            
            break;
            
        case eState_Vanish:
            m_Timer--;
            [self.m_pFont setAlpha:0xFF * m_Timer / TIMER_VANISH];
            
            if (m_Timer < 1) {
                m_State = eState_Hide;
                [self.m_pFont setVisible:NO];
            }
            break;
            
        case eState_Hide:
        default:
            break;
    }
}

/**
 * 出現要求を出す
 */
- (void)requestAppear:(int)nChain {
    
    if (nChain <= 1) {
//        return;
    }
    
    m_State = eState_Main;
    m_Timer = TIMER_MAIN;
    
    [self.m_pFont setVisible:YES];
    [self.m_pFont setText:[NSString stringWithFormat:@"%d CHAIN", nChain]];
    
    self._x = POS_APPEAR_X;
    self._y = POS_APPEAR_Y;
    self._vx = SPEED_X;
    [self.m_pFont setPosScreen:self._x y:self._y];
    [self.m_pFont setAlpha:0xFF];
}

@end
