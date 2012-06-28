//
//  RedBar.mm
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/06/09.
//  Copyright 2012年 2dgames.jp. All rights reserved.
//

#import "RedBar.h"
#import "Math.h"
#import "gamecommon.h"
#import "SceneMain.h"


@implementation RedBar

/**
 * コンストラクタ
 */
- (id)init {
    
    self = [super init];
    if (self == nil) {
        return self;
    }
    
    [self load:@"font.png"];
    [self.m_pSprite setVisible:NO];
    [self create];
    
    m_tPast = 0;
    
    return self;
}

/**
 * 更新
 */
- (void)update:(ccTime)dt {
    
    m_tPast++;
}

/**
 * グリッド描画
 */
- (void)visit {
    
    [super visit];
    
    // 危険バー
    const int WIDTH = 320 - 8;
    
    System_SetBlend(eBlend_Normal);
    float x = 8;
    float y = FIELD_OFS_Y + BLOCK_SIZE * (FIELD_BLOCK_COUNT_Y-1) - BLOCK_SIZE / 2;
    
    float c = 0.3 * Math_SinEx((m_tPast*3)%180);
    
    glLineWidth(8);
    {
        glColor4f(1-c, 0, 0, 0.5);
        CGPoint origin = CGPointMake(x, y);
        CGPoint destination = CGPointMake(WIDTH, y);
        ccDrawLine(origin, destination);
    }
    glLineWidth(1);
    
    System_SetBlend(eBlend_Normal);
    
}

@end
