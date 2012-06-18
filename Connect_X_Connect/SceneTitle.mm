//
//  SceneTitle.mm
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/06/17.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "SceneTitle.h"
#import "SceneManager.h"

/**
 * 描画プライオリティ
 */
enum ePrio {
    ePrio_Font,
};

// シングルトン
static SceneTitle* scene_ = nil;

/**
 * タイトル画面実装
 */
@implementation SceneTitle

@synthesize interfaceLayer;
@synthesize baseLayer;
@synthesize m_pFont;

// --------------------------------------------------
// public static
/**
 * シングルトンを取得する
 */
+ (SceneTitle*)sharedInstance {
    if (scene_ == nil) {
        scene_ = [SceneTitle node];
    }
    
    return scene_;
}

/**
 * インスタンスを解放する
 */
+ (void)releaseInstance {
    scene_ = nil;
}

// --------------------------------------------------
// public
/**
 * コンストラクタ
 */
- (id)init {
    
    self = [super init];
    if (self == nil) {
        return self;
    }
    
    // 基準レイヤー
    self.baseLayer = [CCLayer node];
    [self addChild:self.baseLayer];
    
    // 入力受け取り
    self.interfaceLayer = [InterfaceLayer node];
    [self.baseLayer addChild:self.interfaceLayer];
    
    // 描画関連
    self.m_pFont = [AsciiFont node];
    [self.m_pFont createFont:self.baseLayer length:24];
    [self.m_pFont setScale:2];
    [self.m_pFont setPos:4 y:36];
    [self.m_pFont setText:[NSString stringWithFormat:@"Connect X Connect"]];
    
    [self scheduleUpdate];
    
    return self;
}

/**
 * デストラクタ
 */
- (void)dealloc {
    
    self.m_pFont = nil;
    self.interfaceLayer = nil;
    self.baseLayer = nil;
    
    [super dealloc];
}

/**
 * 更新
 */
- (void)update:(ccTime)dt {
    
    if ([self.interfaceLayer isTouch]) {
        
        SceneManager_Change(@"SceneMain");
    }
}

@end
