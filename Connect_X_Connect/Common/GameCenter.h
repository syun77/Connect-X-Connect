//
//  GameCenter.h
//  Test7
//
//  Created by OzekiSyunsuke on 12/07/08.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * GameCenterオブジェクト生成
 */
void GameCenter_Init();

/**
 * GameCenterオブジェクト破棄
 */
void GameCenter_End();

/**
 * 認証を行う
 */
void GameCenter_Login();

/**
 * 認証が完了しているかどうか
 */
BOOL GameCenter_IsLogin();

/**
 * 認証が完了したかどうか
 */
BOOL GameCenter_IsLoginConnecting();

/**
 * 認証に失敗したかどうか
 */
BOOL GameCenter_IsLoginError();

/**
 * ログイン確認ダイアログの表示
 */
void GameCenter_DispLoginDialog();

/**
 * スコアを送信する
 */
void GameCenter_Report(NSString* pName, int value);

/**
 * スコア送信が完了したかどうか
 */
BOOL GameCenter_IsEndReportConnect();

/**
 * スコア送信に失敗したかどうか
 */
BOOL GameCenter_IsReportError();

/**
 * Leaderboardを表示する
 */
void GameCenter_ShowLeaderboard(NSString* pName);

void GameCenter_GetScore();
