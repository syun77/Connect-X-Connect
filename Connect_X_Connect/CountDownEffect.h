//
//  CountDownEffect.h
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/06/03.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Token.h"
#import "Vec.h"

@interface CountDownEffect : Token {
    int     m_hTarget;
    Vec2D   m_vList[60];
    int     m_Timer;
    int     m_Frame;
}

- (void)setParam:(int)handle frame:(int)frame;

// 生存数をカウントする
+ (int)countExist;

// エフェクト追加
+ (CountDownEffect*)add:(int)handle x:(float)x y:(float)y frame:(int)frame;
+ (CountDownEffect*)addFromChip:(int)handle chipX:(int)chipX chipY:(int)chipY frame:(int)frame;
@end
