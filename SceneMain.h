//
//  SceneMain.h
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/05/28.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "IScene.h"
#import "AsciiFont.h"

/**
 * ゲームメインのシーン
 */
@interface SceneMain : IScene {
    CCLayer*        baseLayer;
    AsciiFont*      fontTest;
}

@property (nonatomic, retain)CCLayer*   baseLayer;
@property (nonatomic, retain)AsciiFont* fontTest;

+ (SceneMain*)sharedInstance;
+ (void)releaseInstance;

@end
