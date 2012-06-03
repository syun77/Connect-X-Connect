//
//  Grid.h
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/06/01.
//  Copyright 2012年 2dgame.jp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Token.h"

/**
 * グリッド描画
 */
@interface Grid : Token {
    int m_tPast;    // 経過タイマー
}

@end
