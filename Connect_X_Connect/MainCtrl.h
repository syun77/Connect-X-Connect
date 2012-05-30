//
//  MainCtrl.h
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/05/31.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

/**
 * ゲームメインのコントローラー
 */
@interface MainCtrl : CCNode {
    
    int m_State;
    int m_Timer;
    
}

- (void)update:(ccTime)dt;
- (BOOL)isEnd;

@end
