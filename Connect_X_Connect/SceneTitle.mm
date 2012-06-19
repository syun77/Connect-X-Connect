//
//  SceneTitle.mm
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/06/17.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "SceneTitle.h"
#import "SceneManager.h"
#import "SaveData.h"
#import "Math.h"

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

@synthesize back;
@synthesize fontHiScore;
@synthesize fontRank;
@synthesize fontRankMax;
@synthesize fontCopyRight;
@synthesize fontStartButton;
@synthesize fontBgm;
@synthesize fontSe;


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
    self.back = [BackTitle node];
    [self.baseLayer addChild:self.back];
    
    self.m_pFont = [AsciiFont node];
    [self.m_pFont createFont:self.baseLayer length:24];
    [self.m_pFont setScale:2];
    [self.m_pFont setPos:3 y:40];
    [self.m_pFont setText:[NSString stringWithFormat:@"Connect X Connect"]];
    
    self.fontHiScore = [AsciiFont node];
    [self.fontHiScore createFont:self.baseLayer length:24];
    [self.fontHiScore setPos:7 y:31];
    [self.fontHiScore setScale:2];
    [self.fontHiScore setText:[NSString stringWithFormat:@"HI-SCORE %d", SaveData_GetHiScore()]];
    
    self.fontRank = [AsciiFont node];
    [self.fontRank createFont:self.baseLayer length:24];
    [self.fontRank setPos:7 y:29];
    [self.fontRank setScale:2];
    [self.fontRank setText:[NSString stringWithFormat:@"LEVEL    %d", SaveData_GetRank()]];
    
    self.fontRankMax = [AsciiFont node];
    [self.fontRankMax createFont:self.baseLayer length:24];
    [self.fontRankMax setPos:7 y:27];
    [self.fontRankMax setScale:2];
    [self.fontRankMax setText:[NSString stringWithFormat:@"HI-LEVEL %d", SaveData_GetRankMax()]];
    
    self.fontCopyRight = [AsciiFont node];
    [self.fontCopyRight createFont:self.baseLayer length:24];
    [self.fontCopyRight setPos:17 y:1];
    [self.fontCopyRight setScale:1];
    [self.fontCopyRight setAlign:eFontAlign_Center];
    [self.fontCopyRight setText:@"(c) 2012 2dgames.jp"];
    
    self.fontStartButton = [AsciiFont node];
    [self.fontStartButton createFont:self.baseLayer length:12];
    [self.fontStartButton setPos:20 y:18];
    [self.fontStartButton setAlign:eFontAlign_Center];
    [self.fontStartButton setScale:2];
    [self.fontStartButton setText:@"START"];
    
    self.fontBgm = [AsciiFont node];
    [self.fontBgm createFont:self.baseLayer length:12];
    [self.fontBgm setPos:34 y:9];
    [self.fontBgm setAlign:eFontAlign_Center];
    [self.fontBgm setScale:2];
    
    self.fontSe = [AsciiFont node];
    [self.fontSe createFont:self.baseLayer length:12];
    [self.fontSe setPos:34 y:4];
    [self.fontSe setAlign:eFontAlign_Center];
    [self.fontSe setScale:2];
    
    // 変数初期化
    m_bNextScene = NO;
    m_TouchStartX = 0;
    m_TouchStartY = 0;
    m_bRankSelect = NO;
    m_bGameStart = NO;
    
    // 入力コールバック登録
    [self.interfaceLayer addCB:self];
    
    [self scheduleUpdate];
    
    return self;
}

/**
 * デストラクタ
 */
- (void)dealloc {
    
    
    self.fontSe = nil;
    self.fontBgm = nil;
    self.fontCopyRight = nil;
    self.fontRankMax = nil;
    self.fontRank = nil;
    self.fontHiScore = nil;
    self.back = nil;
    
    self.m_pFont = nil;
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
    
    [self.fontBgm setText:[NSString stringWithFormat:@"BGM:%@", Sound_IsEnableBgm() ? @"o" : @"x"]];
    [self.fontSe setText:[NSString stringWithFormat:@"SE:%@", Sound_IsEnableSe() ? @"o" : @"x"]];
    
    if (m_bNextScene) {
        
        // 登録したコールバックから除去
        [self.interfaceLayer delCB];
        
        SceneManager_Change(@"SceneMain");
        
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
    
    // ■ゲームスタートタッチ判定
    {
        
        if ([self isHitGameStart:x y:y]) {
            
            // タッチした
            Sound_PlaySe(@"pi.wav");
            
            m_bGameStart = YES;
        }
    }
    
    // ■BGMタッチ判定
    {
        
        if ([self isHitBgm :x y:y]) {
            
            // タッチした
            Sound_PlaySe(@"pi.wav");
            
            m_bBgm = YES;
        }
    }
    
    // ■SEタッチ判定
    {
        
        if ([self isHitSe:x y:y]) {
            
            // タッチした
            Sound_PlaySe(@"pi.wav");
            
            m_bSe = YES;
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
    
    // ゲームスタートタッチ判定
    {
        
        if ([self isHitGameStart:x y:y] == NO) {
            
            // フォーカスが外れた
            m_bGameStart = NO;
        }
        if (m_bGameStart == NO) {
            if ([self isHitGameStart:x y:y]) {
                
                // フォーカスに入った
                Sound_PlaySe(@"pi.wav");
                m_bGameStart = YES;
            }
        }
    }
    // BGMタッチ判定
    {
        
        if ([self isHitBgm:x y:y] == NO) {
            
            // フォーカスが外れた
            m_bBgm = NO;
        }
        if (m_bBgm == NO) {
            if ([self isHitBgm:x y:y]) {
                
                // フォーカスに入った
                Sound_PlaySe(@"pi.wav");
                m_bBgm = YES;
            }
        }
    }
    // SEタッチ判定
    {
        
        if ([self isHitSe:x y:y] == NO) {
            
            // フォーカスが外れた
            m_bSe = NO;
        }
        
        if (m_bSe == NO) {
            if ([self isHitSe:x y:y]) {
                
                // フォーカスに入った
                Sound_PlaySe(@"pi.wav");
                m_bSe = YES;
            }
        }
    }
}

/**
 * タッチ終了
 */
- (void)cbTouchEnd:(float)x y:(float)y {
    
    if (m_bGameStart) {
        
        // ゲーム開始
        Sound_PlaySe(@"push.wav");
        m_bNextScene = YES;
    }
    
    if (m_bBgm) {
        Sound_SetEnableBgm(Sound_IsEnableBgm() ? NO : YES);
    }
    if (m_bSe) {
        Sound_SetEnableSe(Sound_IsEnableSe() ? NO : YES);
    }
    
    // タッチ終了
    m_bRankSelect = NO;
    m_bGameStart = NO;
    m_bBgm = NO;
    m_bSe = NO;
}

// ランク選択タッチ中
- (BOOL)isTouchRankSelect {
    return m_bRankSelect;
}

// ゲームスタートタッチ中
- (BOOL)isTouchGameStart {
    return m_bGameStart;
}

// BGM ON/OFF タッチ中
- (BOOL)isTouchBgm {
    return m_bBgm;
}

// SE ON/OFF タッチ中
- (BOOL)isTouchSe {
    return m_bSe;
}

@end
