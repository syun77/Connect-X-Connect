//
//  LogoTitle.mm
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/07/06.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "LogoTitle.h"

// 初回起動
static BOOL s_bInit = YES;

static const int TIMER_FADE = 60;

/**
 * タイトルロゴ実装
 */
@implementation LogoTitle

- (id)init {
    self = [super init];
    if (self == nil) {
        return self;
    }
    
    [self load:@"all.png"];
    [self create];
    int w = 292;
    CGRect r = CGRectMake(1024-w, 560, w, 120);
    [self setTexRect:r];
    
    self._x = System_CenterX();
    self._y = 480 + 120;
    self._ay = -10;
    [self move:0];
    
    m_tFade = TIMER_FADE;
    
    return self;
}

- (void)update:(ccTime)dt {
    [self move:dt];
    
    if (self._y < 480-104) {
        self._y = 480-104;
        self._vy = -self._vy * 0.5;
    }
}

- (void)visit {
    
    if (s_bInit) {
        m_tFade--;
        float c = 1.0 * m_tFade / TIMER_FADE;
        //glColor4f(0.7, 0.7, 0.7, c);
        glColor4f(c, c, c, c);
        [self fillRectLT:0 y:0 w:System_Width() h:System_Height() rot:0 scale:1];
        if (m_tFade == 0) {
            s_bInit = NO;
        }
    }
    [super visit];
    
}

@end
