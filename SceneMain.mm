//
//  SceneMain.mm
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/05/28.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "SceneMain.h"

/**
 * 描画プライオリティ
 */
enum ePrio {
    ePrio_Block, // ブロック
};

// シングルトン
static SceneMain* scene_ = nil;

@implementation SceneMain

@synthesize baseLayer;
@synthesize fontTest;
@synthesize fontTest2;
@synthesize fontTest3;
@synthesize mgrBlock;
@synthesize layer;
@synthesize layer2;

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
    
    // 描画関連
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
    
    self.mgrBlock = [TokenManager node];
    [self.mgrBlock create:self.baseLayer size:64 className:@"Block"];
    [self.mgrBlock setPrio:ePrio_Block];
    
    // レイヤー
    [[self.layer = [Layer2D alloc] init] autorelease];
    [self.layer test];
    [self.layer dump];
    
    
    [[self.layer2 = [Layer2D alloc] init] autorelease];
    [self.layer2 test];
    [self.layer2 set:6 y:6 val:9];
    
    [self scheduleUpdate];
    
    
    
    
    return self;
}

/**
 * デストラクタ
 */
- (void)dealloc {
    
    // レイヤー
    self.layer2 = nil;
    self.layer = nil;
    
    // ■描画オブジェクト
    // トークン
    self.mgrBlock = nil;
    
    // フォント
    self.fontTest = nil;
    self.baseLayer = nil;
    
    [super dealloc];
}

- (void)update:(ccTime)dt {
    
    static int s_cnt = 0;
    s_cnt++;
    
    if (s_cnt == 1) {
        
        // ブロック生成テスト
        [Block add:5 x:80 y:100];
    }
    
    [self.fontTest setText:[NSString stringWithFormat:@"%d", s_cnt]];
    [self.fontTest2 setText:[NSString stringWithFormat:@"%06d", s_cnt]];
    [self.fontTest3 setText:[NSString stringWithFormat:@"%09d", s_cnt]];
    
    [self.layer copyWithLayer2D:self.layer2];
    
    
}

@end
