//
//  GameOver.h
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/06/20.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Token.h"

/**
 * ゲームオーバー
 */
@interface GameOver : Token {
    BOOL m_bVisible; // 表示フラグ
}

/**
 * 表示開始
 */
- (void)start;

@end
