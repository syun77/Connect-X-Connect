//
//  BlockNext.h
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/06/10.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Token.h"
#import "AsciiFont.h"

/**
 * 次に出現するブロックの表示
 */
@interface BlockNext : Token {
    
    int         m_nOrder;   // 順番
    int         m_nNumber;  // 数字
}

/**
 * パラメータ設定
 */
- (void)setParam:(int)nOrder nNumber:(int)nNumber;


@end
