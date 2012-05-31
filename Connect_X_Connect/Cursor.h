//
//  Cursor.h
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/06/01.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Token.h"

/**
 * タッチカーソル
 */
@interface Cursor : Token {
    
}

// 描画設定
- (void)setDraw:(BOOL)b chipX:(int)chipX;

@end
