//
//  Caption.mm
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/06/21.
//  Copyright 2012年 2dgames.jp. All rights reserved.
//

#import "Caption.h"
#import "gamecommon.h"
#import "SaveData.h"

static const int TIMER_APPEAR = 240;

@implementation Caption

@synthesize m_pFont;

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

- (void)attachLayer:(CCLayer *)layer {
    
    self.m_pFont = [AsciiFont node];
    [self.m_pFont createFont:layer length:36];
    [self.m_pFont setVisible:NO];
    [self.m_pFont setPos:1 y:4];
    
    // レベルを取得
    int nLevel = SaveData_GetRank();
    
    int nSound = GameCommon_LevelToSound(nLevel);
    [self start:nSound];
    
}

- (void)dealloc {
    
    self.m_pFont = nil;
    
    [super dealloc];
}

- (void)update:(ccTime)dt {
    
    if (m_Timer > 0) {
        m_Timer--;
        if (m_Timer < 30) {
            int alpha = 0xFF * m_Timer / 30;
            [self.m_pFont setAlpha:alpha];
        }
        
        if (m_Timer < 1) {
            [self.m_pFont setVisible:NO];
        }
    }
    
}

- (void)visit {
    [super visit];
    
    if (m_Timer > 0) {
        System_SetBlend(eBlend_Normal);
//        glColor4f(1, 1, 0, 0.5);
//        float y = 32;
//        CGPoint p1 = CGPointMake(0, y);
//        CGPoint p2 = CGPointMake(320, y);
//        ccDrawLine(p1, p2);
        float a = 0.3;
        if (m_Timer < 30) {
            a = 0.3 * m_Timer / 30;
        }
        glColor4f(0, 0, 0, a);
        [self fillRect:160 cy:36 w:160 h:6 rot:0 scale:1];
    }
}

- (void)start:(int)nSound {
    
    [self.m_pFont setVisible:YES];
    [self.m_pFont setAlpha:0xFF];
    NSString* name = GameCommon_GetSoundName(nSound);
    [self.m_pFont setText:[NSString stringWithFormat:@"%@ - dong", name]];
    m_Timer = TIMER_APPEAR;
}

@end
