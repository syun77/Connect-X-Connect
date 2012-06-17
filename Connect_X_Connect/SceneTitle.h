//
//  SceneTitle.h
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/06/17.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "IScene.h"
#import "AsciiFont.h"
#import "InterfaceLayer.h"

/**
 * タイトル画面
 */
@interface SceneTitle : IScene {
    
    // 入力受け取り
    InterfaceLayer* interfaceLayer;
    
    // 描画オブジェクト
    CCLayer*    baseLayer;
    AsciiFont*  m_pFont;
}

@property (nonatomic, retain)InterfaceLayer*    interfaceLayer;
@property (nonatomic, retain)CCLayer*           baseLayer;
@property (nonatomic, retain)AsciiFont*         m_pFont;

+ (SceneTitle*)sharedInstance;
+ (void)releaseInstance;

@end
