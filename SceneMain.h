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
#import "Layer2D.h"
#import "gamecommon.h"
#import "Block.h"
#import "TokenManager.h"

/**
 * ゲームメインのシーン
 */
@interface SceneMain : IScene {
    
    // 描画オブジェクト
    CCLayer*        baseLayer;
    AsciiFont*      fontTest;
    AsciiFont*      fontTest2;
    AsciiFont*      fontTest3;
    TokenManager*   mgrBlock;
    
    // レイヤー
    Layer2D*        layer;
    Layer2D*        layer2;
}

@property (nonatomic, retain)CCLayer*       baseLayer;
@property (nonatomic, retain)AsciiFont*     fontTest;
@property (nonatomic, retain)AsciiFont*     fontTest2;
@property (nonatomic, retain)AsciiFont*     fontTest3;
@property (nonatomic, retain)TokenManager*  mgrBlock;

@property (nonatomic, retain)Layer2D*   layer;
@property (nonatomic, retain)Layer2D*   layer2;

+ (SceneMain*)sharedInstance;
+ (void)releaseInstance;

@end
