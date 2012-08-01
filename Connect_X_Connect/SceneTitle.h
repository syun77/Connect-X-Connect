//
//  SceneTitle.h
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/06/17.
//  Copyright 2012年 2dgames.jp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "IScene.h"
#import "AsciiFont.h"
#import "InterfaceLayer.h"
#import "BackTitle.h"
#import "LogoTitle.h"
#import "Button.h"

// ランク選択タッチエリア
static const float RANK_SELECT_RECT_X = 0;
static const float RANK_SELECT_RECT_Y = 240-48;
static const float RANK_SELECT_RECT_W = 320;
static const float RANK_SELECT_RECT_H = 64;

static const float GAMEMODE_BUTTON_CX = 160;
static const float GAMEMODE_BUTTON_CY = 168;
static const float GAMEMODE_BUTTON_W  = 96;
static const float GAMEMODE_BUTTON_H  = 16;

static const float START_BUTTON_CX = 160;
static const float START_BUTTON_CY = 112;
static const float START_BUTTON_W  = 96;
static const float START_BUTTON_H  = 24;

static const float SCORE_BUTTON_CX = 56;
static const float SCORE_BUTTON_CY = 56;
static const float SCORE_BUTTON_W  = 48;
static const float SCORE_BUTTON_H  = 16;

static const float OPTION_BUTTON_CX = 320-56;
static const float OPTION_BUTTON_CY = 56;
static const float OPTION_BUTTON_W  = 48;
static const float OPTION_BUTTON_H  = 16;

static const float COPY_BUTTON_CX = 160;
static const float COPY_BUTTON_CY = 16;
static const float COPY_BUTTON_W = 156;
static const float COPY_BUTTON_H = 12;

/**
 * タイトル画面
 */
@interface SceneTitle : IScene {
    
    // 入力受け取り
    InterfaceLayer* interfaceLayer;
    
    // 描画オブジェクト
    CCLayer*    baseLayer;
    
    BackTitle*      back;           // 背景
    LogoTitle*      logo;           // タイトルロゴ
    AsciiFont*      fontHiScore;    // フォント (ハイスコア)
    AsciiFont*      fontRank;       // フォント (ランク)
    AsciiFont*      fontRankMax;    // フォント (最大ランク)
    
    Button*         btnStart;       // ボタン（スタート）
    Button*         btnGamemode;    // ボタン（ゲームモード）
    Button*         btnScore;       // ボタン（スコア）
    Button*         btnOption;      // ボタン（オプション）
    Button*         btnCopyright;   // ボタン（コピーライト）
    
    BOOL            m_bNextScene;   // 次のシーンに進む
    int             m_NextSceneId;  // 次のシーンの番号
    float           m_TouchStartX;  // タッチ開始座標 (X)
    float           m_TouchStartY;  // タッチ開始座標 (Y)
    int             m_RankPrev;     // タッチ前のランク
    BOOL            m_bRankSelect;  // ランク選択タッチ中
    
    BOOL            m_bInit;        // 初期化フラグ
}

@property (nonatomic, retain)InterfaceLayer*    interfaceLayer;
@property (nonatomic, retain)CCLayer*           baseLayer;

@property (nonatomic, retain)BackTitle*         back;
@property (nonatomic, retain)LogoTitle*         logo;
@property (nonatomic, retain)AsciiFont*         fontHiScore;
@property (nonatomic, retain)AsciiFont*         fontRank;
@property (nonatomic, retain)AsciiFont*         fontRankMax;

@property (nonatomic, retain)Button*            btnStart;
@property (nonatomic, retain)Button*            btnGamemode;
@property (nonatomic, retain)Button*            btnScore;
@property (nonatomic, retain)Button*            btnOption;
@property (nonatomic, retain)Button*            btnCopyright;


+ (SceneTitle*)sharedInstance;
+ (void)releaseInstance;

// ランク選択タッチ中
- (BOOL)isTouchRankSelect;

@end
