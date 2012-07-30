//
//  OptionScene.mm
//  Test7
//
//  Created by OzekiSyunsuke on 12/07/14.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "SceneOption.h"

#import "SceneManager.h"
#import "SaveData.h"
#import "GameCenter.h"

enum ePrio {
    ePrio_Back,
};

static SceneOption* scene_ = nil;

@implementation SceneOption

@synthesize baseLayer;
@synthesize interfaceLayer;
@synthesize back;

@synthesize fontOption;
@synthesize fontBgm;
@synthesize fontSe;
@synthesize fontEasy;
@synthesize fontSubmit;
@synthesize fontSubmit2;
@synthesize fontSubmit3;

@synthesize btnBgm;
@synthesize btnSe;
@synthesize btnEasy;
@synthesize btnSubmit; 
@synthesize btnBack;

/**
 * シングルトンを取得する
 */
+ (SceneOption*)sharedInstance {
    
    if (scene_ == nil) {
        scene_ = [SceneOption node];
    }
    
    return scene_;
}

+ (void)releaseInstance {
    scene_ = nil;
}

- (void)setBtnBgm {
    
    BOOL b = Sound_IsEnableBgm();
    
    [self.btnBgm setText:[NSString stringWithFormat:@"BGM:%s", b ? "o" : "x"]];
}

/**
 * BGM ON/OFF ボタン押したコールバック
 */
- (void)cbBtnBgm {
    
    Sound_PlaySe(@"pi.wav");
    
    if(Sound_IsEnableBgm()) {
        
        Sound_SetEnableBgm(NO);
    }
    else {
        
        Sound_SetEnableBgm(YES);
    }
    
    [self setBtnBgm];
}

- (void)setBtnSe {
    
    BOOL b = Sound_IsEnableSe();
    
    [self.btnSe setText:[NSString stringWithFormat:@"SE:%s", b ? "o" : "x"]];
}

/**
 * SE ON/OFF ボタン押したコールバック
 */
- (void)cbBtnSe {
    
    Sound_PlaySe(@"pi.wav");
    
    if (Sound_IsEnableSe()) {
        
        Sound_SetEnableSe(NO);
    }
    else {
        
        Sound_SetEnableSe(YES);
    }
    
    [self setBtnSe];
}

- (void)setBtnEasy {
    
    BOOL b = SaveData_IsEasy();
    
    [self.btnEasy setText:[NSString stringWithFormat:@"EASY:%s", b ? "o" : "x"]];
}

/**
 * EASYモード ボタン押したコールバック
 */
- (void)cbBtnEasy {
    
    Sound_PlaySe(@"pi.wav");
    
    if (SaveData_IsEasy()) {
        
        SaveData_SetEasy(NO);
    }
    else {
        
        SaveData_SetEasy(YES);
    }
    
    [self setBtnEasy];
}

- (void)setBtnSubmit {
    
    if (SaveData_IsScoreAutoSubmit()) {
        [self.btnSubmit setText:@"AUTO"];
    }
    else {
        [self.btnSubmit setText:@"OFF"];
    }
}

/**
 * スコア自動送信ボタンを押した時のコールバック
 */
- (void)cbBtnSubmit {
    
    Sound_PlaySe(@"pi.wav");
    
    if (SaveData_IsScoreAutoSubmit()) {
        
        SaveData_SetScoreAutoSubmit(NO);
    }
    else {
        
        SaveData_SetScoreAutoSubmit(YES);
    }
    
    [self setBtnSubmit];
}

/**
 * 戻るボタンを押した時のコールバック
 */
- (void)cbBtnBack {
    
    Sound_PlaySe(@"push.wav");
    
    m_bNextScene = YES;
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
    
    self.interfaceLayer = [InterfaceLayer node];
    [self.baseLayer addChild:self.interfaceLayer];
    
    self.back = [BackOption node];
    [self.baseLayer addChild:self.back z:ePrio_Back];
    
    self.fontOption = [AsciiFont node];
    [self.fontOption createFont:self.baseLayer length:24];
    [self.fontOption setPosScreen:OPTION_FONT_CX y:OPTION_FONT_CY];
    [self.fontOption setAlign:eFontAlign_Center];
    [self.fontOption setScale:4];
    [self.fontOption setText:@"OPTION"];
    
    self.fontBgm = [AsciiFont node];
    [self.fontBgm createFont:self.baseLayer length:16];
    [self.fontBgm setPosScreen:BGM_FONT_X y:BGM_FONT_Y];
    [self.fontBgm setScale:2];
    [self.fontBgm setText:@"PLAY BGM"];
    
    self.fontSe = [AsciiFont node];
    [self.fontSe createFont:self.baseLayer length:16];
    [self.fontSe setPosScreen:SE_FONT_X y:SE_FONT_Y];
    [self.fontSe setScale:2];
    [self.fontSe setText:@"PLAY SE"];
    
    self.fontEasy = [AsciiFont node];
    [self.fontEasy createFont:self.baseLayer length:16];
    [self.fontEasy setPosScreen:EASY_FONT_X y:EASY_FONT_Y];
    [self.fontEasy setScale:2];
    [self.fontEasy setText:@"EASY MODE"];
    [self.fontEasy setVisible:NO];
    
    self.fontSubmit = [AsciiFont node];
    [self.fontSubmit createFont:self.baseLayer length:16];
    [self.fontSubmit setPosScreen:SUBMIT_FONT_X y:SUBMIT_FONT_Y];
    [self.fontSubmit setScale:2];
    [self.fontSubmit setText:@"LEADERBOARD"];
    self.fontSubmit2 = [AsciiFont node];
    [self.fontSubmit2 createFont:self.baseLayer length:16];
    [self.fontSubmit2 setPosScreen:SUBMIT_FONT_X y:SUBMIT_FONT_Y-16];
    [self.fontSubmit2 setScale:2];
    [self.fontSubmit2 setText:@"SCORE"];
    self.fontSubmit3 = [AsciiFont node];
    [self.fontSubmit3 createFont:self.baseLayer length:16];
    [self.fontSubmit3 setPosScreen:SUBMIT_FONT_X y:SUBMIT_FONT_Y-32];
    [self.fontSubmit3 setScale:2];
    [self.fontSubmit3 setText:@"SUBMISSION"];
    
    self.btnBgm = [Button node];
    [self.btnBgm initWith:self.interfaceLayer text:@"BGM" cx:BGM_BUTTON_CX cy:BGM_BUTTON_CY w:BGM_BUTTON_W h:BGM_BUTTON_H cls:self onDecide:@selector(cbBtnBgm)];
    [self setBtnBgm];
    
    self.btnSe = [Button node];
    [self.btnSe initWith:self.interfaceLayer text:@"SE" cx:SE_BUTTON_CX cy:SE_BUTTON_CY w:SE_BUTTON_W h:SE_BUTTON_H cls:self onDecide:@selector(cbBtnSe)];
    [self setBtnSe];
    
    self.btnEasy = [Button node];
    [self.btnEasy initWith:self.interfaceLayer text:@"EASY" cx:EASY_BUTTON_CX cy:EASY_BUTTON_CY w:EASY_BUTTON_W h:EASY_BUTTON_H cls:self onDecide:@selector(cbBtnEasy)];
    [self setBtnEasy];
    [self.btnEasy setVisible:NO];
    
    self.btnSubmit = [Button node];
    [self.btnSubmit initWith:self.interfaceLayer text:@"" cx:SUBMIT_BUTTON_CX cy:SUBMIT_BUTTON_CY-8 w:SUBMIT_BUTTON_W h:SUBMIT_BUTTON_H cls:self onDecide:@selector(cbBtnSubmit)];
    [self setBtnSubmit];
    
    self.btnBack = [Button node];
    [self.btnBack initWith:self.interfaceLayer text:@"BACK" cx:BACK_BUTTON_CX cy:BACK_BUTTON_CY w:BACK_BUTTON_W h:BACK_BUTTON_H cls:self onDecide:@selector(cbBtnBack)];
    
    m_bNextScene = NO;
    
    // 更新スケジューラ登録
    [self scheduleUpdate];
    
    return self;
}

/**
 * デストラクタ
 */
- (void)dealloc {
    
    self.btnBack = nil;
    self.btnSubmit = nil;
    self.btnSe = nil;
    self.btnEasy = nil;
    self.btnBgm = nil;
    
    self.fontSubmit3 = nil;
    self.fontSubmit2 = nil;
    self.fontSubmit = nil;
    self.fontEasy = nil;
    self.fontSe = nil;
    self.fontBgm = nil;
    
    self.back = nil;
    self.interfaceLayer = nil;
    self.baseLayer = nil;
    
    [super dealloc];
}

/**
 * 更新
 */
- (void)update:(ccTime)dt {
    
    if (m_bNextScene) {
        
        // タイトル画面に戻る
        SceneManager_Change(@"SceneTitle");
    }
}

@end
