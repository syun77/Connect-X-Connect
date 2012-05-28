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
    [self.fontTest setText:@"0123456789"];
    [self.fontTest setScale:3];
    [self.fontTest setPos:5 y:10];
    
    [self scheduleUpdate];
    
    
    return self;
}

/**
 * デストラクタ
 */
- (void)dealloc {
    
    self.fontTest = nil;
    self.baseLayer = nil;
    
    [super dealloc];
}

- (void)update:(ccTime)dt {
    
    static int s_cnt = 0;
    s_cnt++;
    [self.fontTest setText:[NSString stringWithFormat:@"%d", s_cnt]];
    
}

@end
