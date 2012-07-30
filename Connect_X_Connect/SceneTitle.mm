//
//  SceneTitle.mm
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/06/17.
//  Copyright 2012年 2dgames.jp. All rights reserved.
//

#import "SceneTitle.h"
#import "SceneManager.h"
#import "SaveData.h"
#import "Math.h"
#import "GameCenter.h"

/**
 * 描画プライオリティ
 */
enum ePrio {
    ePrio_Back,
    ePrio_Logo,
    ePrio_Font,
};

enum eScene {
    eScene_Main,    // メインゲーム
    eScene_Option,  // オプション画面
};

// シングルトン
static SceneTitle* scene_ = nil;

/**
 * タイトル画面実装
 */
@implementation SceneTitle

@synthesize interfaceLayer;
@synthesize baseLayer;

@synthesize back;
@synthesize logo;
@synthesize fontHiScore;
@synthesize fontRank;
@synthesize fontRankMax;

@synthesize btnStart;
@synthesize btnGamemode;
@synthesize btnScore;
@synthesize btnOption;
@synthesize btnCopyright;

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

/**
 * ランク選択の表示を切り替える
 */
- (void)setRankSelect:(BOOL)b {
    
    BackTitle* backTitle = [SceneTitle sharedInstance].back;
    
    
    [backTitle setRankSelect:b];
}

/**
 * スタートボタン押したコールバック
 */
- (void)cbBtnStart {
    
    Sound_PlaySe(@"push.wav");
    
    // メインゲーム開始
    m_bNextScene = YES;
    m_NextSceneId = eScene_Main;
}


/**
 * ゲームモードの表示を切り替える
 */
- (void)setBtnGamemode {
    
    int hiScore = 0;
    int rank    = 0;
    int hiRank  = 0;
    if (SaveData_IsScoreAttack()) {
        
        // スコアアタックモード
        [self.btnGamemode setText:@"SCORE ATTACK"];
        hiScore = SaveData2_GetHiScore();
        rank    = SaveData2_GetRank();
        hiRank  = SaveData2_GetRankMax();
        [self setRankSelect:NO];
    }
    else {
        
        [self.btnGamemode setText:@"FREE PLAY"];
        hiScore = SaveData_GetHiScore();
        rank    = SaveData_GetRank();
        hiRank  = SaveData_GetRankMax();
        [self setRankSelect:YES];
    }
    
    [self.fontHiScore setText:[NSString stringWithFormat:@"HI-SCORE %d", hiScore]];
    
    [self.fontRank setText:[NSString stringWithFormat:@"RANK     %d", rank]];
    [self.fontRankMax setText:[NSString stringWithFormat:@"HI-RANK  %d", hiRank]];
}

/**
 * ゲームモードの切り替え
 */
- (void)cbBtnGamemove {
    Sound_PlaySe(@"pi.wav");
    
    if (SaveData_IsScoreAttack()) {
        
        SaveData_SetScoreAttack(NO);
    }
    else {
        
        SaveData_SetScoreAttack(YES);
    }
    
    [self setBtnGamemode];
}

/**
 * リーダーボード表示
 */
- (void)cbBtnScore {
    Sound_PlaySe(@"pi.wav");
    
    if (SaveData_IsScoreAttack()) {
        
        GameCenter_ShowLeaderboard(@"02_scoreattack_score");
    }
    else {
        
        GameCenter_ShowLeaderboard(@"freeplay_score");
    }
}

/**
 * Optionボタン押したコールバック
 */
- (void)cbBtnOption {
    Sound_PlaySe(@"push.wav");
    
    m_NextSceneId = eScene_Option;
    m_bNextScene = YES;
}

/**
 * Copyright押した時のコールバック
 */
- (void)cbBtnCopyright {
    
    // 他のアプリ一覧を開く
    System_OpenBrowserOtherApp();
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
    self.back = [BackTitle node];
    [self.baseLayer addChild:self.back z:ePrio_Back];
    
    self.logo = [LogoTitle node];
    [self.baseLayer addChild:self.logo z:ePrio_Logo];
    
    self.fontHiScore = [AsciiFont node];
    [self.fontHiScore createFont:self.baseLayer length:24];
    [self.fontHiScore setPos:7 y:25];
    [self.fontHiScore setScale:2];
    [self.fontHiScore setText:[NSString stringWithFormat:@"HI-SCORE %d", SaveData_GetHiScore()]];
    
    self.fontRank = [AsciiFont node];
    [self.fontRank createFont:self.baseLayer length:24];
    [self.fontRank setPos:7 y:23];
    [self.fontRank setScale:2];
    [self.fontRank setText:[NSString stringWithFormat:@"LEVEL    %d", SaveData_GetRank()]];
    
    self.fontRankMax = [AsciiFont node];
    [self.fontRankMax createFont:self.baseLayer length:24];
    [self.fontRankMax setPos:7 y:21];
    [self.fontRankMax setScale:2];
    [self.fontRankMax setText:[NSString stringWithFormat:@"HI-LEVEL %d", SaveData_GetRankMax()]];
    
    self.btnStart = [Button node];
    [self.btnStart initWith:self.interfaceLayer text:@"START" cx:START_BUTTON_CX cy:START_BUTTON_CY w:START_BUTTON_W h:START_BUTTON_H cls:self onDecide:@selector(cbBtnStart)];
    
    self.btnGamemode = [Button node];
    [self.btnGamemode initWith:self.interfaceLayer text:@"" cx:GAMEMODE_BUTTON_CX cy:GAMEMODE_BUTTON_CY w:GAMEMODE_BUTTON_W h:GAMEMODE_BUTTON_H cls:self onDecide:@selector(cbBtnGamemove)];
    
    self.btnScore = [Button node];
    [self.btnScore initWith:self.interfaceLayer text:@"SCORE" cx:SCORE_BUTTON_CX cy:SCORE_BUTTON_CY w:SCORE_BUTTON_W h:SCORE_BUTTON_H cls:self onDecide:@selector(cbBtnScore)];
    
    self.btnOption = [Button node];
    [self.btnOption initWith:self.interfaceLayer text:@"OPTION" cx:OPTION_BUTTON_CX cy:OPTION_BUTTON_CY w:OPTION_BUTTON_W h:OPTION_BUTTON_H cls:self onDecide:@selector(cbBtnOption)];
    
    self.btnCopyright = [Button node];
    [self.btnCopyright initWith:self.interfaceLayer text:@"(c) 2012 2dgames.jp" cx:COPY_BUTTON_CX cy:COPY_BUTTON_CY w:COPY_BUTTON_W h:COPY_BUTTON_H cls:self onDecide:@selector(cbBtnCopyright)];
    [self.btnCopyright setTextScale:1];
    [self.btnCopyright setBackColor:ccc4f(0.1, 0.1, 0.1, 0.5)];
    
    // 変数初期化
    m_bNextScene = NO;
    m_TouchStartX = 0;
    m_TouchStartY = 0;
    m_bRankSelect = NO;
    m_NextSceneId = eScene_Main;
    
    // 入力コールバック登録
    [self.interfaceLayer addCB:self];
    
    [self scheduleUpdate];
    
    return self;
}

/**
 * デストラクタ
 */
- (void)dealloc {
    
    self.btnCopyright = nil;
    self.btnOption = nil;
    self.btnScore = nil;
    self.btnGamemode = nil;
    self.btnStart = nil;
    
    self.fontRankMax = nil;
    self.fontRank = nil;
    self.fontHiScore = nil;
    self.logo = nil;
    self.back = nil;
    
    self.interfaceLayer = nil;
    self.baseLayer = nil;
    
    [super dealloc];
}

/**
 * 更新
 */
- (void)update:(ccTime)dt {
    
    if (m_bRankSelect) {
        
        [self.fontRank setColor:ccc3(0xFF, 0x80, 0x80)];
        [self.fontRank setText:[NSString stringWithFormat:@"LEVEL    %d", SaveData_GetRank()]];
    }
    else {
        [self.fontRank setColor:ccc3(0xFF, 0xFF, 0xFF)];
        
    }
    
    if (m_bNextScene) {
        
        // 登録したコールバックから除去
        [self.interfaceLayer delCB];
        
        switch (m_NextSceneId) {
            case eScene_Main:
                
                // 次のシーンに進む
                SceneManager_Change(@"SceneMain");
        
                break;
                
            case eScene_Option:
                
                // オプション画面に遷移する
                SceneManager_Change(@"SceneOption");
                break;
                
            default:
                break;
        }
    }
}
/**
 * ランク選択の矩形にヒットしているかどうか
 */
- (BOOL)isHitRankSelect:(float)x y:(float)y {
    
    CGRect rect = CGRectMake(RANK_SELECT_RECT_X, RANK_SELECT_RECT_Y, RANK_SELECT_RECT_W, RANK_SELECT_RECT_H);
    CGPoint p = CGPointMake(x, y);
    
    if (Math_IsHitRect(rect, p)) {
        return YES;
    }
    
    return NO;
}

/**
 * ゲーム開始の矩形にヒットしているかどうか
 */
- (BOOL)isHitGameStart:(float)x y:(float)y {
    
    CGRect rect = CGRectMake(START_BUTTON_RECT_X, START_BUTTON_RECT_Y, START_BUTTON_RECT_W, START_BUTTON_RECT_H);
    CGPoint p = CGPointMake(x, y);
    
    if (Math_IsHitRect(rect, p)) {
        return YES;
    }
    
    return NO;
}

/**
 * ゲーム開始の矩形にヒットしているかどうか
 */
- (BOOL)isHitBgm:(float)x y:(float)y {
    
    CGRect rect = CGRectMake(BGM_BUTTON_RECT_X, BGM_BUTTON_RECT_Y, BGM_BUTTON_RECT_W, BGM_BUTTON_RECT_H);
    CGPoint p = CGPointMake(x, y);
    
    if (Math_IsHitRect(rect, p)) {
        return YES;
    }
    
    return NO;
}

/**
 * ゲーム開始の矩形にヒットしているかどうか
 */
- (BOOL)isHitSe:(float)x y:(float)y {
    
    CGRect rect = CGRectMake(SE_BUTTON_RECT_X, SE_BUTTON_RECT_Y, SE_BUTTON_RECT_W, SE_BUTTON_RECT_H);
    CGPoint p = CGPointMake(x, y);
    
    if (Math_IsHitRect(rect, p)) {
        return YES;
    }
    
    return NO;
}

/**
 * タッチ開始
 */
- (void)cbTouchStart:(float)x y:(float)y {
    m_RankPrev = SaveData_GetRank();
    
    // ■ランク選択タッチ判定
    m_bRankSelect = NO;
    {
        
        if ([self isHitRankSelect:x y:y]) {
            
            // タッチした
            Sound_PlaySe(@"pi.wav");
            
            m_bRankSelect = YES;
        }
    }
    
    // タッチ開始座標を保持
    m_TouchStartX = x;
    m_TouchStartY = y;
    
}

/**
 * タッチ移動中
 */
- (void)cbTouchMove:(float)x y:(float)y {
    
    if ([self isTouchRankSelect]) {
        
        // ランク選択有効
        int rank = m_RankPrev;
        
        float vx = x - m_TouchStartX;
        rank += 10 * (int)(vx / 10);
        
        if (rank < 1) {
            rank = 1;
            m_TouchStartX = x;
        }
        
        if (rank != m_RankPrev) {
            m_RankPrev = rank;
            m_TouchStartX = x;
        }
        
        if (SaveData_SetRank(rank)) {
            // 設定できた
            if (vx < 0) {
                
                // 左
                [self.back moveCursorL];
            }
            else {
                
                // 右
                [self.back moveCursorR];
            }
            
            Sound_PlaySe(@"pi.wav");
        }
    }
    
}

/**
 * タッチ終了
 */
- (void)cbTouchEnd:(float)x y:(float)y {
    
    // タッチ終了
    m_bRankSelect = NO;
}

// ランク選択タッチ中
- (BOOL)isTouchRankSelect {
    return m_bRankSelect;
}

@end
