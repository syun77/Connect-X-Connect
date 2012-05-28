//
//  SceneMain.mm
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/05/28.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "SceneMain.h"

// シングルトン
static SceneMain* scene_ = nil;

@implementation SceneMain

@synthesize baseLayer;
@synthesize fontTest;
@synthesize fontTest2;
@synthesize fontTest3;
@synthesize layer;

/**
 * シングルトンを取得する
 */
+ (SceneMain*)sharedInstance {
    if (scene_ == nil) {
        scene_ = [SceneMain node];
    }
    
    return scene_;
}

/**
 * インスタンスを解放する
 */
+ (void)releaseInstance {
    scene_ = nil;
}

/**
 * コンストラクタ
 */
- (id)init {
    
    self = [super init];
    if (self == nil) {
        return self;
    }
    
    self.baseLayer = [CCLayer node];
    [self addChild:self.baseLayer];
    
    self.fontTest = [AsciiFont node];
    [self.fontTest createFont:self.baseLayer length:24];
    [self.fontTest setScale:3];
    [self.fontTest setPos:5 y:16];
    
    self.fontTest2 = [AsciiFont node];
    [self.fontTest2 createFont:self.baseLayer length:24];
    [self.fontTest2 setScale:3];
    [self.fontTest2 setPos:5 y:13];
    
    self.fontTest3 = [AsciiFont node];
    [self.fontTest3 createFont:self.baseLayer length:24];
    [self.fontTest3 setScale:3];
    [self.fontTest3 setPos:5 y:10];
    
    [[self.layer = [Layer2D alloc] init] autorelease];
    [self.layer create:7 h:7];
    
    [self.layer dump];
    
    [self scheduleUpdate];
    
    
    return self;
}

/**
 * デストラクタ
 */
- (void)dealloc {
    
    self.layer = nil;
    
    self.fontTest = nil;
    self.baseLayer = nil;
    
    [super dealloc];
}

- (void)update:(ccTime)dt {
    
    static int s_cnt = 0;
    s_cnt++;
    [self.fontTest setText:[NSString stringWithFormat:@"%d", s_cnt]];
    [self.fontTest2 setText:[NSString stringWithFormat:@"%06d", s_cnt]];
    [self.fontTest3 setText:[NSString stringWithFormat:@"%09d", s_cnt]];
    
}

@end
