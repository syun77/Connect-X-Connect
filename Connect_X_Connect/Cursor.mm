//
//  Cursor.mm
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/06/01.
//  Copyright 2012年 2dgame.jp. All rights reserved.
//

#import "Cursor.h"
#import "gamecommon.h"

/**
 * タッチカーソル
 */
@implementation Cursor

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
    
    return self;
}

/**
 * 更新
 */
- (void)update:(ccTime)dt {
    
    // 特に何もしない
}

/**
 * 矩形描画
 */
- (void)visit {
    
    [super visit];
    
    if (self.visible == NO) {
        
        // 非表示
        return;
    }
    
    System_SetBlend(eBlend_Normal);
    glColor4f(0.3, 0.3, 0.3, 0.2);
    [self fillRectLT:self._x y:self._y w:BLOCK_SIZE h:320 rot:0 scale:1];
    System_SetBlend(eBlend_Normal);
}

// 描画設定
- (void)setDraw:(BOOL)b chipX:(int)chipX {
    
    [self setVisible:b];
    
    self._x = FIELD_OFS_X + chipX * BLOCK_SIZE - BLOCK_SIZE / 2;
    self._y = FIELD_OFS_Y - BLOCK_SIZE / 2;
}

@end
