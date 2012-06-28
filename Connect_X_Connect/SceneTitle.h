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

// ランク選択タッチエリア
static const float RANK_SELECT_RECT_X = 0;
static const float RANK_SELECT_RECT_Y = 240-32;
static const float RANK_SELECT_RECT_W = 320;
static const float RANK_SELECT_RECT_H = 64;

static const float START_BUTTON_RECT_X = 160-96;
static const float START_BUTTON_RECT_Y = 124;
static const float START_BUTTON_RECT_W = 96*2;
static const float START_BUTTON_RECT_H = 48;

static const float BGM_BUTTON_RECT_X = 320-80-8;
static const float BGM_BUTTON_RECT_Y = 48+8;
static const float BGM_BUTTON_RECT_W = 80;
static const float BGM_BUTTON_RECT_H = 32;

static const float SE_BUTTON_RECT_X = 320-80-8;
static const float SE_BUTTON_RECT_Y = 16;
static const float SE_BUTTON_RECT_W = 80;
static const float SE_BUTTON_RECT_H = 32;
/**
 * タイトル画面
 */
@interface SceneTitle : IScene {
    
    // 入力受け取り
    InterfaceLayer* interfaceLayer;
    
    // 描画オブジェクト
    CCLayer*    baseLayer;
    AsciiFont*  m_pFont;
    
    BackTitle*      back;           // 背景
    AsciiFont*      fontHiScore;    // フォント (ハイスコア)
    AsciiFont*      fontRank;       // フォント (ランク)
    AsciiFont*      fontRankMax;    // フォント (最大ランク)
    AsciiFont*      fontCopyRight;  // フォント（コピーライト）
    AsciiFont*      fontStartButton;// フォント（スタートボタン）
    AsciiFont*      fontBgm;        // フォント（BGM）
    AsciiFont*      fontSe;         // フォント（SE）
    
    BOOL            m_bNextScene;   // 次のシーンに進む
    float           m_TouchStartX;  // タッチ開始座標 (X)
    float           m_TouchStartY;  // タッチ開始座標 (Y)
    int             m_RankPrev;     // タッチ前のランク
    BOOL            m_bRankSelect;  // ランク選択タッチ中
    BOOL            m_bGameStart;   // ゲームスタートタッチ中
    BOOL            m_bBgm;         // BGM ON/OFF タッチ中
    BOOL            m_bSe;          // SE ON/OF タッチ中
}

@property (nonatomic, retain)InterfaceLayer*    interfaceLayer;
@property (nonatomic, retain)CCLayer*           baseLayer;
@property (nonatomic, retain)AsciiFont*         m_pFont;

@property (nonatomic, retain)BackTitle*         back;
@property (nonatomic, retain)AsciiFont*         fontHiScore;
@property (nonatomic, retain)AsciiFont*         fontRank;
@property (nonatomic, retain)AsciiFont*         fontRankMax;
@property (nonatomic, retain)AsciiFont*         fontCopyRight;
@property (nonatomic, retain)AsciiFont*         fontStartButton;
@property (nonatomic, retain)AsciiFont*         fontBgm;
@property (nonatomic, retain)AsciiFont*         fontSe;

+ (SceneTitle*)sharedInstance;
+ (void)releaseInstance;

// ランク選択タッチ中
- (BOOL)isTouchRankSelect;

// ゲームスタートタッチ中
- (BOOL)isTouchGameStart;

// BGM ON/OFF タッチ中
- (BOOL)isTouchBgm;

// SE ON/OFF タッチ中
- (BOOL)isTouchSe;
@end
