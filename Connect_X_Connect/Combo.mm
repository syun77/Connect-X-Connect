//
//  Combo.mm
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/06/13.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Combo.h"

static const int TIMER_BEGIN = 60;

@implementation Combo

@synthesize m_pFont;
@synthesize m_pFont2;

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
 * レイヤーにアタッチ
 */
- (void)attachLayer:(CCLayer *)layer {
    
    // フォントをアタッチ
    self.m_pFont = [AsciiFont node];
    [self.m_pFont createFont:layer length:8];
    [self.m_pFont setPos:28 y:50];
    [self.m_pFont setAlign:eFontAlign_Center];
    
    [self.m_pFont setVisible:NO];
    
    // フォントをアタッチ
    self.m_pFont2 = [AsciiFont node];
    [self.m_pFont2 createFont:layer length:8];
    [self.m_pFont2 setPos:28 y:48];
    [self.m_pFont2 setAlign:eFontAlign_Center];
    [self.m_pFont2 setText:@"combo"];
    
    [self.m_pFont2 setVisible:NO];
    
}

/**
 * デストラクタ
 */
- (void)dealloc {
    
    self.m_pFont2 = nil;
    self.m_pFont = nil;
    
    [super dealloc];
}

/**
 * 更新
 */
- (void)update:(ccTime)dt {
    
    if (m_Timer > 0) {
        
        m_Timer = m_Timer * 0.8;
    }
    
    float scale = 2.0 + 6.0 * m_Timer / TIMER_BEGIN;
    [self.m_pFont setScale:scale];
}

// コンボ演出開始
- (void)begin:(int)nCombo {
    
    m_nCombo = nCombo;
    m_Timer = TIMER_BEGIN;
    
    [self.m_pFont setText:[NSString stringWithFormat:@"%d", m_nCombo]];
    [self.m_pFont2 setVisible:YES];
}

// コンボ演出終了
- (void)end {
    
    m_nCombo = 0;
    [self.m_pFont setVisible:NO];
    [self.m_pFont2 setVisible:NO];
}

@end
