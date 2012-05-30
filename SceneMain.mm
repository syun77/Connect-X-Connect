//
//  SceneMain.mm
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/05/28.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "SceneMain.h"
#import "FieldMgr.h"

/**
 * 描画プライオリティ
 */
enum ePrio {
    ePrio_Block, // ブロック
};

// シングルトン
static SceneMain* scene_ = nil;

@implementation SceneMain

@synthesize interfaceLayer;
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
    
    // 基準レイヤー
    self.baseLayer = [CCLayer node];
    [self addChild:self.baseLayer];
    
    // 入力受け取り
    self.interfaceLayer = [InterfaceLayer node];
    [self.baseLayer addChild:self.interfaceLayer];
    
    // 描画関連
    
    self.fontTest = [AsciiFont node];
    [self.fontTest createFont:self.baseLayer length:24];
    [self.fontTest setScale:3];
    [self.fontTest setPos:5 y:16];
    [self.fontTest setVisible:NO];
    
    self.fontTest2 = [AsciiFont node];
    [self.fontTest2 createFont:self.baseLayer length:24];
    [self.fontTest2 setScale:3];
    [self.fontTest2 setPos:5 y:13];
    [self.fontTest2 setVisible:NO];
    
    self.fontTest3 = [AsciiFont node];
    [self.fontTest3 createFont:self.baseLayer length:24];
    [self.fontTest3 setScale:3];
    [self.fontTest3 setPos:5 y:10];
    [self.fontTest3 setVisible:NO];
    
    self.mgrBlock = [TokenManager node];
    [self.mgrBlock create:self.baseLayer size:64 className:@"Block"];
    [self.mgrBlock setPrio:ePrio_Block];
    
    // レイヤー
    [[self.layer = [Layer2D alloc] init] autorelease];
    [self.layer create:FIELD_BLOCK_COUNT_X h:FIELD_BLOCK_COUNT_Y];
    
    
    [[self.layer2 = [Layer2D alloc] init] autorelease];
    [self.layer create:FIELD_BLOCK_COUNT_X h:FIELD_BLOCK_COUNT_Y];
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
    
    self.interfaceLayer = nil;
    
    self.baseLayer = nil;
    
    [super dealloc];
}

- (void)update:(ccTime)dt {
    
    static int s_cnt = 0;
    s_cnt++;
    
    if ([self.interfaceLayer isTouch]) {
        s_cnt = 0;
        
        // すべて消す
        [self.mgrBlock vanishAll];
    }
    
    if (s_cnt == 1) {
        
        // ブロック生成テスト
        [self.layer random:5];
        [self.layer dump];
        
        for (int i = 0; i < FIELD_BLOCK_COUNT_MAX; i++) {
            int v = [self.layer getFromIdx:i];
            if (v > 0) {
                [Block addFromIdx:v idx:i];
            }
        }
        
        // 落下要求を送る
        [FieldMgr requestFallBlock];
    }
    
    
    //[self.fontTest setText:[NSString stringWithFormat:@"%d", s_cnt]];
    //[self.fontTest2 setText:[NSString stringWithFormat:@"%06d", s_cnt]];
    //[self.fontTest3 setText:[NSString stringWithFormat:@"%09d", s_cnt]];
    
    //[self.layer copyWithLayer2D:self.layer2];
    
    
}

@end
