//
//  MainCtrl.h
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/05/31.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Layer2D.h"

/**
 * ゲームメインのコントローラー
 */
@interface MainCtrl : CCNode {
    
    Layer2D* layerVanish;   // 消去判定用レイヤー
    
    int m_State;
    int m_Timer;
    
}

@property (nonatomic, retain)Layer2D* layerVanish;

- (void)update:(ccTime)dt;
- (BOOL)isEnd;

@end
