//
//  Grid.mm
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/06/01.
//  Copyright 2012年 2dgame.jp. All rights reserved.
//

#import "Grid.h"
#import "gamecommon.h"
#import "Math.h"
#import "SceneMain.h"


@implementation Grid

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
    
    System_SetBlend(eBlend_Normal);
    float c = 0.3 * Math_SinEx(m_tPast%180) + 0.3;
    glColor4f(c, c, c, 0.5);
    
    int x = FIELD_OFS_X - BLOCK_SIZE / 2;
    int y = FIELD_OFS_Y - BLOCK_SIZE / 2;
    for (int i = 0; i < FIELD_BLOCK_COUNT_X+1; i++) {
        
        CGPoint origin = CGPointMake(x, y);
        CGPoint destination = CGPointMake(x, 444);
        
        ccDrawLine(origin, destination);
        
        x += BLOCK_SIZE;
    }
        
    x = FIELD_OFS_X - BLOCK_SIZE / 2;
    y = FIELD_OFS_Y - BLOCK_SIZE / 2;
    for (int j = 0; j < FIELD_BLOCK_COUNT_Y+1; j++) {
        
        CGPoint origin = CGPointMake(x, y);
        CGPoint destination = CGPointMake(300, y);
        
        ccDrawLine(origin, destination);
        
        y += BLOCK_SIZE;
    }
    
    // 危険バー
    const int WIDTH = 320 - 16;
    
    System_SetBlend(eBlend_Add);
    x = 8;
    y = FIELD_OFS_Y + BLOCK_SIZE * (FIELD_BLOCK_COUNT_Y-1) - BLOCK_SIZE / 2;
    
    c = 0.3 * Math_SinEx((m_tPast*3)%180);
    
    glLineWidth(8);
    {
        glColor4f(1-c, 0, 0, 1);
        CGPoint origin = CGPointMake(x, y);
        CGPoint destination = CGPointMake(WIDTH, y);
        ccDrawLine(origin, destination);
    }
    glLineWidth(1);
    
}

@end
