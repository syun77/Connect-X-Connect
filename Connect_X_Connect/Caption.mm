//
//  Caption.mm
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/06/21.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Caption.h"

static const int TIMER_APPEAR = 120;

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
    [self.m_pFont createFont:layer length:24];
    [self.m_pFont setVisible:NO];
    [self.m_pFont setPos:2 y:3];
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

- (void)start:(int)nSound {
    
    [self.m_pFont setVisible:YES];
    [self.m_pFont setText:[NSString stringWithFormat:@"BGM"]];
    m_Timer = TIMER_APPEAR;
}

@end
