//
//  OptionScene.h
//  Test7
//
//  Created by OzekiSyunsuke on 12/07/14.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "IScene.h"
#import "InterfaceLayer.h"
#import "AsciiFont.h"
#import "Button.h"
#import "BackOption.h"

static const float BGM_BUTTON_CX = 248;
static const float BGM_BUTTON_CY = 300;
static const float BGM_BUTTON_W  = 40;
static const float BGM_BUTTON_H  = 16;

static const float SE_BUTTON_CX = BGM_BUTTON_CX;
static const float SE_BUTTON_CY = 236;
static const float SE_BUTTON_W = 40;
static const float SE_BUTTON_H = 16;

static const float EASY_BUTTON_CX = BGM_BUTTON_CX;
static const float EASY_BUTTON_CY = 172;
static const float EASY_BUTTON_W  = 48;
static const float EASY_BUTTON_H  = 16;

static const float SUBMIT_BUTTON_CX = BGM_BUTTON_CX;
//static const float SUBMIT_BUTTON_CY = 108;
static const float SUBMIT_BUTTON_CY = 172;
static const float SUBMIT_BUTTON_W  = 48;
static const float SUBMIT_BUTTON_H  = 16;

static const float BACK_BUTTON_CX = 320-56;
static const float BACK_BUTTON_CY = 56;
static const float BACK_BUTTON_W  = 48;
static const float BACK_BUTTON_H  = 16;

static const float OPTION_FONT_CX = 160;
static const float OPTION_FONT_CY = 380;

static const float FONT_DY = 16;

static const float BGM_FONT_X = 16;
static const float BGM_FONT_Y = BGM_BUTTON_CY + FONT_DY;

static const float SE_FONT_X = BGM_FONT_X;
static const float SE_FONT_Y = SE_BUTTON_CY + FONT_DY;

static const float EASY_FONT_X = BGM_FONT_X;
static const float EASY_FONT_Y = EASY_BUTTON_CY + FONT_DY;

static const float SUBMIT_FONT_X = BGM_FONT_X;
static const float SUBMIT_FONT_Y = SUBMIT_BUTTON_CY + FONT_DY;

/**
 * オプション画面
 */
@interface SceneOption: IScene {
    
    CCLayer*        baseLayer;      // 基準レイヤー
    InterfaceLayer* interfaceLayer; // 入力受け取り
    BackOption*     back;           // 背景
    
    AsciiFont*      fontOption;     // フォント（オプション）
    AsciiFont*      fontBgm;        // フォント (BGM)
    AsciiFont*      fontSe;         // フォント（SE)
    AsciiFont*      fontSubmit;     // フォント（SUBMIT）
    
    Button*         btnBgm;         // ボタン（BGM）
    Button*         btnSe;          // ボタン（SE）
    Button*         btnEasy;        // ボタン（EASY）
    Button*         btnSubmit;      // ボタン (SUBMIT)
    Button*         btnSubmit2;     // ボタン (SUBMIT)
    Button*         btnSubmit3;     // ボタン (SUBMIT)
    Button*         btnBack;        // タイトル画面に戻る
    
    BOOL            m_bNextScene;   // 次のシーンに進む
}

@property (nonatomic, retain)CCLayer*           baseLayer;
@property (nonatomic, retain)InterfaceLayer*    interfaceLayer;
@property (nonatomic, retain)BackOption*        back;

@property (nonatomic, retain)AsciiFont*         fontOption;
@property (nonatomic, retain)AsciiFont*         fontBgm;
@property (nonatomic, retain)AsciiFont*         fontSe;
@property (nonatomic, retain)AsciiFont*         fontEasy;
@property (nonatomic, retain)AsciiFont*         fontSubmit;
@property (nonatomic, retain)AsciiFont*         fontSubmit2;
@property (nonatomic, retain)AsciiFont*         fontSubmit3;

@property (nonatomic, retain)Button*            btnBgm;
@property (nonatomic, retain)Button*            btnSe;
@property (nonatomic, retain)Button*            btnEasy;
@property (nonatomic, retain)Button*            btnSubmit;
@property (nonatomic, retain)Button*            btnBack;

+ (SceneOption*)sharedInstance;
+ (void)releaseInstance;

@end
