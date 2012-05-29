//
//  Block.h
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/05/29.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Token.h"

/**
 * ブロック
 */
@interface Block : Token {
    int m_nNumber;  // 数値
    int m_Timer;    // 汎用タイマー
    int m_State;    // 状態
}

// 番号を設定する
- (void)setNumber:(int)number;

// ブロックを追加する
+ (Block*)add:(int)number x:(float)x y:(float)y;

@end
