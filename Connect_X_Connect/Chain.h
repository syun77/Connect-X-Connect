//
//  Chain.h
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/06/08.
//  Copyright 2012年 2dgames.jp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Token.h"
#import "AsciiFont.h"

@interface Chain : Token {
    
    AsciiFont*  m_pFont;
    int         m_State;
    int         m_Timer;
    int         m_tLine;
}

@property (nonatomic, retain)AsciiFont* m_pFont;


// 出現要求を出す
- (void)requestAppear:(int)nChain;

@end
