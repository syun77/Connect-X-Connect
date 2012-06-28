//
//  LevelUp.h
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/06/20.
//  Copyright 2012年 2dgames.jp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Token.h"

/**
 * レベルアップ演出
 */
@interface LevelUp : Token {
    
    int m_State;
    int m_Timer;
    int m_tPast;
}

// 演出開始
- (void)start;

@end
