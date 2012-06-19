//
//  BackTitle.h
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/06/19.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Token.h"

/**
 * タイトル画面用背景
 */
@interface BackTitle : Token {
    int     m_tPast;        // 経過時間
    int     m_tCursorL;     // カーソルタイマー (左)
    int     m_tCursorR;     // カーソルタイマー (右)
}

// カーソルを動かす（左）
- (void)moveCursorL;

// カーソルを動かす（右）
- (void)moveCursorR;

@end
