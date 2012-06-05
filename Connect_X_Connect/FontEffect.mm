//
//  FontEffect.mm
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/06/05.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "FontEffect.h"
#import "SceneMain.h"

@implementation FontEffect

@synthesize m_pFont;

+ (TokenManager*)_getTokenManager {
    
    return [SceneMain sharedInstance].mgrFontEffect;
}

/**
 * コンストラクタ
 */
- (id)init {
    self = [super init];
    if (self == nil) {
        return self;
    }
    
    [self load:@"font.png"];
    [self setVisible:NO];
    
    self.m_pFont = [AsciiFont node];
    
    return self;
}

/**
 * デストラクタ
 */
- (void)dealloc {
    
    self.m_pFont = nil;
    
    [super dealloc];
}

/**
 * 描画レイヤーにAttachする
 */
- (void)attachLayer:(CCLayer *)layer {
    
    [self.m_pFont createFont2:layer length:8 prio:10];
    [self.m_pFont setVisible:NO];
}

/**
 * 初期化
 */
- (void)initialize {
    [self.m_pFont setVisible:YES];
    m_Timer = 60;
    [self.m_pFont setScale:2];
}

/**
 * 更新
 */
- (void)update:(ccTime)dt {
    
    m_Timer--;
    if (m_Timer < 1) {
        
        [self.m_pFont setVisible:NO];
        [self vanish];
    }
}

// -------------------------------------------------------
// public

/**
 * パラメータ設定
 */
- (void)setParam:(eFontEffect)type text:(NSString*)text {
    
    m_Type = type;
    [self.m_pFont setText:text];
    [self.m_pFont setPosScreen:self._x y:self._y];
}

// -------------------------------------------------------
// static public
/**
 * 生成
 */
+ (FontEffect*)add:(eFontEffect)type x:(float)x y:(float)y text:(NSString *)text {
    
    TokenManager* mgr = [FontEffect _getTokenManager];
    FontEffect* f = (FontEffect*)[mgr add];
    if (f) {
        
        [f set2:x y:y rot:0 speed:0 ax:0 ay:0];
        [f setParam:type text:text];
    }
    
    return f;
}

@end
