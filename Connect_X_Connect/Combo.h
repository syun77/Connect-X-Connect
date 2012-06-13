//
//  Combo.h
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/06/13.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Token.h"
#import "AsciiFont.h"

/**
 * コンボ表示
 */
@interface Combo : Token {
    
    AsciiFont*  m_pFont;
    AsciiFont*  m_pFont2;
    int         m_nCombo;   // コンボ数
    int         m_Timer;
}

@property (nonatomic, retain)AsciiFont* m_pFont;
@property (nonatomic, retain)AsciiFont* m_pFont2;

// コンボ演出開始
- (void)begin:(int)nCombo;

// コンボ演出終了
- (void)end;

@end
