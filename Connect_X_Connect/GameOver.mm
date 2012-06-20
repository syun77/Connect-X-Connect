//
//  GameOver.mm
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/06/20.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "GameOver.h"


@implementation GameOver

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
    
    m_bVisible = NO;
    
    return self;
}

/**
 * 更新
 */
- (void)update:(ccTime)dt {
    
}

/**
 * プリミティブ描画
 */
- (void)visit {
    
    [super visit];
    
    if (m_bVisible) {
        glColor4f(0, 0, 0, 0.8);
        
        [self fillRect:160 cy:240 w:160 h:32 rot:0 scale:1];
    }
    
}

/**
 * 表示開始
 */
- (void)start {
    m_bVisible = YES;
}

@end
