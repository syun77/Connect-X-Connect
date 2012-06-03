//
//  SceneMain.mm
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/05/28.
//  Copyright 2012年 2dgame.jp. All rights reserved.
//

#import "SceneMain.h"
#import "FieldMgr.h"
#import "BlockMgr.h"

/**
 * 描画プライオリティ
 */
enum ePrio {
    ePrio_Back,     // 背景
    ePrio_Grid,     // グリッド線
    ePrio_Block,    // ブロック
    ePrio_Number,   // ブロックの数字
    ePrio_Cursor,   // カーソル
    ePrio_HpGauge,  // HPゲージ
};

enum eState {
    eState_Init,
    eState_Main,
    eState_End,
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
@synthesize cursor;
@synthesize grid;
@synthesize hpGauge;
@synthesize layer;
@synthesize ctrl;


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
    [self.mgrBlock create:self.baseLayer size:FIELD_BLOCK_COUNT_X*(FIELD_BLOCK_COUNT_Y+2) className:@"Block"];
    [self.mgrBlock setPrio:ePrio_Block];
    
    self.cursor = [Cursor node];
    [self.baseLayer addChild:self.cursor z:ePrio_Cursor];
    [self.cursor setDraw:NO chipX:3];
    
    self.grid = [Grid node];
    [self.baseLayer addChild:self.grid z:ePrio_Grid];
    
    self.hpGauge = [HpGauge node];
    [self.baseLayer addChild:self.hpGauge z:ePrio_HpGauge];
    
    // レイヤー
    [[self.layer = [Layer2D alloc] init] autorelease];
    [self.layer create:FIELD_BLOCK_COUNT_X h:FIELD_BLOCK_COUNT_Y];
    
    // ゲーム制御
    self.ctrl = [MainCtrl node];
    [self.interfaceLayer addCB:self.ctrl];
    
    // 変数初期化
    m_State = eState_Init;
    m_Timer = 0;
    
    
    // ■更新開始
    [self scheduleUpdate];
    
    return self;
}

/**
 * デストラクタ
 */
- (void)dealloc {
    
    // コールバックから削除
    [self.interfaceLayer delCB];
    
    // ゲーム制御
    self.ctrl = nil;
    
    self.hpGauge = nil;
    
    self.grid = nil;
    self.cursor = nil;
    
    // レイヤー
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
    
    switch (m_State) {
        case eState_Init:
            m_State = eState_Main;
            break;
            
        case eState_Main:
            
            [self.ctrl update:dt];
            if ([self.ctrl isEnd]) {
                m_State = eState_End;
            }
            
        case eState_End:
            break;
            
        default:
            break;
    }
    
    //[self.fontTest setText:[NSString stringWithFormat:@"%d", s_cnt]];
    //[self.fontTest2 setText:[NSString stringWithFormat:@"%06d", s_cnt]];
    //[self.fontTest3 setText:[NSString stringWithFormat:@"%09d", s_cnt]];
    
}

@end
