//
//  Back.h
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/06/07.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
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

@end
