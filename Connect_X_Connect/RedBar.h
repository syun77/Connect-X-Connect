//
//  RedBar.h
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/06/09.
//  Copyright 2012年 2dgames.jp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Token.h"

/**
 * 危険バーの表示
 */
@interface RedBar : Token {
    
    int m_tPast;    // 経過タイマー
}

@end
