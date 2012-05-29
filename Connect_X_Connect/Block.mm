//
//  Block.mm
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/05/29.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Block.h"
#import "SceneMain.h"

/**
 * 状態
 */
enum eState {
    eState_Standby, // 待機中
    eState_Fall,    // 落下中
    eState_Vanish,  // 消滅中
};

/**
 * ブロックの実装
 */
@implementation Block

@synthesize fontNumber;

/**
 * コンストラクタ
 */
- (id)init {
    self = [super init];
    if (self == nil) {
        return self;
    }
    
    [self load:@"font.png"];
    
    self._r = BLOCK_SiZE / 2;
    
    [self.m_pSprite setVisible:NO];
    
    return self;
}

/**
 * デストラクタ
 */
- (void)dealloc {
    
    self.fontNumber = nil;
    
    [super dealloc];
}

/**
 * フォントの生成
 */
- (void)attachLayer:(CCLayer *)layer {
    
    self.fontNumber = [AsciiFont node];
    [self.fontNumber createFont:layer length:2];
    [self.fontNumber setAlign:eFontAlign_Center];
    [self.fontNumber setScale:3];
}

/**
 * 初期化
 */
- (void)initialize {
    m_State = eState_Standby;
    m_Timer = 0;
    m_nNumber = 1;
}

/**
 * 更新
 */
- (void)update:(ccTime)dt {
    
    // 速度固定
    [self move:1.0 / 60];
    
    [self.fontNumber setPosScreen:self._x y:self._y];
}

/**
 * 矩形描画
 */
- (void)visit {
    [super visit];
    
    glColor4f(1, 1, 1, 1);
    float s = BLOCK_SiZE / 2;
    [self drawRect:self._x cy:self._y w:s h:s rot:0 scale:1];
}

// 番号を設定する
- (void)setNumber:(int)number {
    m_nNumber = number;
    [self.fontNumber setText:[NSString stringWithFormat:@"%d", number]];
}

/**
 * ブロックの追加
 */
+ (Block*)add:(int)number x:(float)x y:(float)y {
    TokenManager* mgr = [SceneMain sharedInstance].mgrBlock;
    Block* b = (Block*)[mgr add];
    if (b) {
        
        [b set2:x y:y rot:0 speed:0 ax:0 ay:0];
        [b setNumber:number];
        
    }
    
    return b;
}

// ブロックを追加する (インデックス指定)
+ (Block*)addFromIdx:(int)number idx:(int)idx {
    
    float x = FIELD_OFS_X + (idx % FIELD_BLOCK_COUNT_X) * BLOCK_SiZE;
    float y = FIELD_OFS_Y + (idx / FIELD_BLOCK_COUNT_X) * BLOCK_SiZE;
    
    return [Block add:number x:x y:y];
}

@end
