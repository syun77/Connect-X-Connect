//
//  BlockNext.mm
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/06/10.
//  Copyright 2012年 2dgames.jp. All rights reserved.
//

#import "BlockNext.h"
#import "gamecommon.h"

@implementation BlockNext

/**
 * コンストラクタ
 */
- (id)init {
    
    self = [super init];
    if (self == nil) {
        return self;
    }
    
    [self load:@"block.png"];
    [self create];
    [self setVisible:NO];
    
    return self;
}

/**
 * 更新
 */
- (void)update:(ccTime)dt {
    [self move:0];
}

/**
 * パラメータ設定
 */
- (void)setParam:(int)nOrder nNumber:(int)nNumber {
    
    m_nOrder = nOrder;
    m_nNumber = nNumber;
    
    float px = (nNumber - 1) * BLOCK_SIZE;
    if (nNumber == SPECIAL_INDEX) {
        px = 9 * BLOCK_SIZE;
    }
    float py = 0;
    CGRect r = CGRectMake(px, py, BLOCK_SIZE, BLOCK_SIZE);
    [self setTexRect:r];
    [self setVisible:YES];
    
    float x = 320 / 2;
    float y = 308;
    float scale = 1;
    switch (nOrder) {
        case 0:
            y += 40;
            scale = 0.75;
            break;
            
        case 1:
            scale = 0.5;
            y += 40 + 30;
            break;
            
        case 2:
            scale = 0.4;
            y += 40 + 30 + 20;
            break;
            
        default:
            break;
    }
    
    [self setScale:scale];
    self._x = x;
    self._y = y;
    
}

@end
