//
//  Back.h
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/06/07.
//  Copyright 2012年 2dgames.jp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Token.h"

/**
 * 背景
 */
@interface Back : Token {
    
    int     m_State;    // 状態
    int     m_Timer;    // コンボ用タイマー
    int     m_tDanger;  // 危険タイマー
}

// 背景変化
- (void)beginDark;
- (void)beginLight;

// 背景画像入れ替え
- (void)change:(int)n;

// 背景画像入れ替え（素早く変える）
- (void)changeQuick:(int)n;

@end
