//
//  GameCenter.mm
//  Test7
//
//  Created by OzekiSyunsuke on 12/07/08.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "GameCenter.h"
#import <GameKit/GameKit.h>
#import "AppDelegate.h"
#import "cocos2d.h"

// 縦持ちかどうか
//#define LEADER_BOARD_PORTRAIT

/**
 * ログイン状態
 */
enum eLogin {
    eLogin_None,
    eLogin_Connecting,
    eLogin_Success,
    eLogin_Error,
};

/**
 * スコア送信状態
 */
enum eReport {
    eReport_None,
    eReport_Connecting,
    eReport_Success,
    eReport_Error,
};


/**
 * GameCenter制御
 */
@interface GCController : UIViewController<GKLeaderboardViewControllerDelegate, GKAchievementViewControllerDelegate> {
    
    eLogin  m_Login;    // ログイン状態
    eReport m_Report;   // スコア送信状態
}

- (eLogin)getLogin;
- (void)setLogin:(eLogin)s;
- (eReport)getReport;
- (void)setReport:(eReport)s;

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController;
- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController;

@end

@implementation GCController

/**
 * コンストラクタ
 */
- (id)init {
    self = [super init];
    if (self == nil) {
        return self;
    }
    
    m_Login = eLogin_None;
    m_Report = eReport_None;
    
    return self;
}

- (eLogin)getLogin {
    return m_Login;
}
- (void)setLogin:(eLogin)s {
    m_Login = s;
}
- (eReport)getReport {
    return m_Report;
}
- (void)setReport:(eReport)s {
    m_Report = s;
}

/**
 * リーダーボードを閉じた
 */
- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController {
    
    [self dismissModalViewControllerAnimated:YES];
}

/**
 * アチーブメントを閉じた
 */
- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController {
    
    [self dismissModalViewControllerAnimated:YES];
}

@end // @implementation GCController



static GCController* s_pController = nil;

/**
 * インスタンスを取得
 */
static GCController* _Get()
{
    return s_pController;
}

/**
 * GameCenterオブジェクト生成
 */
void GameCenter_Init()
{
    GCController* ix = _Get();
    if (s_pController == nil) {
        AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        s_pController = [[[GCController alloc] init] autorelease];
        
        // Viewを登録
        [delegate.window addSubview:ix.view];
        [[CCDirector sharedDirector].openGLView addSubview:s_pController.view];
    }
}

/**
 * GameCenterオブジェクト破棄
 */
void GameCenter_End()
{
    if (s_pController) {
        s_pController = nil;
    }
}

/**
 * 認証を行う
 */
void GameCenter_Login()
{
    GCController* ix = _Get();
    if (ix == nil) {
        NSLog(@"Error: GameCenter Login failed.");
        return;
    }
    
//    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    // GameCenterにログインする
    [ix setLogin:eLogin_Connecting];
    [[GKLocalPlayer localPlayer] authenticateWithCompletionHandler:^(NSError* error) {
        
//        UIAlertView* alert = nil;
        
        if (error == nil) {
            // 認証に成功
            [ix setLogin:eLogin_Success];
            NSLog(@"GameCenter auth success.");
            
        }
        else {
            // 認証に失敗
            [ix setLogin:eLogin_Error];
            NSLog(@"%@", error);
//            alert = [[UIAlertView alloc] initWithTitle:@"Auth GameCenter  failed"
//                                               message:@"Server connection problem. Please try to 'LOGIN' from OPTION."
//                                              delegate:delegate
//                                     cancelButtonTitle:@"ok"
//                                     otherButtonTitles:nil];
//            [alert show];
//            [alert release];
            
        }
    }];
    
}

/**
 * 認証が完了しているかどうか
 */
BOOL GameCenter_IsLogin() {
    
    GCController* ix = _Get();
    if (ix == nil) {
        
        NSLog(@"Error: GameCenter IsLogin failed.");
        
        return NO;
    }
    
    switch ([ix getLogin]) {
        case eLogin_Success:
            return YES;
            
        default:
            return NO;
    }
}

/**
 * ログイン確認ダイアログの表示
 */
void GameCenter_DispLoginDialog()
{
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                 
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"GameCenter auth fali." message:@"Can you retry to auth GameCenter?" delegate:delegate cancelButtonTitle:@"retry" otherButtonTitles:@"cancel", nil];
    [alert show];
    
    [alert release];
    
                                           
}

/**
 * 認証が完了したかどうか
 */
BOOL GameCenter_IsLoginConnecting()
{
    GCController* ix = _Get();
    if (ix == nil) {
        
        NSLog(@"Error: GameCenter Login failed.");
        
        // 完了したことにする
        return YES;
    }
    
    switch ([ix getLogin]) {
        case eLogin_Error:
        case eLogin_Success:
            return YES;
            
        default:
            return NO;
    }
}

/**
 * 認証に失敗したかどうか
 */
BOOL GameCenter_IsLoginError()
{
    GCController* ix = _Get();
    if (ix == nil) {
        
        // 失敗
        return YES;
    }
    
    switch ([ix getLogin]) {
        case eLogin_Success:
            return NO;
            
        default:
            return YES;
    }
}

/**
 * スコアを送信する
 * @param pName リーダーボードID
 * @param value 設定するスコア
 */
void GameCenter_Report(NSString* pName, int value)
{
    GCController* ix = _Get();
    if (ix == nil) {
        
        NSLog(@"Error: GameCenter Report failed.");
        
        // 送信失敗
        return;
    }
    
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [ix setReport:eReport_Connecting];
    
    GKScore* report = [[[GKScore alloc] initWithCategory:pName] autorelease];
    report.value = value;
    [report reportScoreWithCompletionHandler:^(NSError* error) {
        
        UIAlertView* alert = nil;
        GCController* ix = _Get();
        
        if (error) {
            // エラー処理
            if ([ix getReport] != eReport_Error) {
                NSLog(@"%@", error);
                alert = [[UIAlertView alloc] initWithTitle:@"Submit score failed"
                                                   message:@"Server connection problem. Please try to press 'SUBMIT SCORE' button."
                                                  delegate:delegate
                                         cancelButtonTitle:@"ok"
                                         otherButtonTitles:nil];
                [alert show];
                [alert release];
                
            }
            
            [ix setReport:eReport_Error];
        }
        else {
            // 送信成功
            [ix setReport:eReport_Success];
        }
    }];
    
    report = nil;
    
}

/**
 * スコア送信が完了したかどうか
 */
BOOL GameCenter_IsEndReportConnect() {
    
    GCController* ix = _Get();
    if (ix == nil) {
        
        NSLog(@"Error: GameCenter Report failed.");
        
        // 完了したことにする
        return YES;
    }
    
    switch ([ix getReport]) {
        case eReport_None:
        case eReport_Error:
        case eReport_Success:
            return YES;
            
        default:
            return NO;
    }
}

/**
 * スコア送信に失敗したかどうか
 */
BOOL GameCenter_IsReportError() {
    
    GCController* ix = _Get();
    if (ix == nil) {
        
        // 失敗
        return YES;
    }
    
    switch ([ix getReport]) {
        case eReport_None:
        case eReport_Success:
            return NO;
            
        default:
            return YES;
    }
}

/**
 * Leaderboardを表示する
 */
void GameCenter_ShowLeaderboard(NSString* pName)
{
    GCController* ix = _Get();
    if (ix == nil) {
        
        NSLog(@"Error: GameCenter ShowLeaderboard failed.");
        
        // 送信失敗
        return;
    }
    
    GKLeaderboardViewController* leader = [[[GKLeaderboardViewController alloc] init] autorelease];
    if (leader == nil) {
        return;
    }
    
    leader.leaderboardDelegate = ix;
    leader.category = pName;
    [s_pController presentModalViewController:leader animated:NO];
    
#ifdef LEADER_BOARD_PORTRAIT
    
    // 横持ち対応
    leader.view.transform = CGAffineTransformMakeRotation(CC_DEGREES_TO_RADIANS(0.0f));
    leader.view.bounds = CGRectMake(0, 0, 480, 320);
    leader.view.center = CGPointMake(240, 160);
#endif // #ifdef LEADER_BOARD_PORTRAIT
}


void GameCenter_GetScore()
{
    GKLeaderboard* leader = [[[GKLeaderboard alloc] init] autorelease];
    if (leader) {
        leader.playerScope = GKLeaderboardPlayerScopeGlobal;
        leader.timeScope = GKLeaderboardTimeScopeAllTime;
        leader.category = @"SCORE01";
        leader.range = NSMakeRange(1, 10);
        [leader loadScoresWithCompletionHandler: ^(NSArray* scores, NSError* error) {
            
            if (error) {
                // エラー処理
            }
            if (scores) {
                for (id score in scores) {
                    NSLog(@"%@", score);
                }
            }
        }];
    }
}
