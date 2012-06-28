//
//  Caption.h
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/06/21.
//  Copyright 2012年 2dgames.jp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Token.h"
#import "AsciiFont.h"

/**
 * 再生BGM名表示
 */
@interface Caption : Token {
    
    AsciiFont* m_pFont;
    int m_Timer;
}

@property (nonatomic, retain)AsciiFont* m_pFont;

- (void)start:(int)nSound;

@end
