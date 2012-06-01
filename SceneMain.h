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
#import "InterfaceLayer.h"
#import "MainCtrl.h"
#import "Cursor.h"
#import "Grid.h"
#import "HpGauge.h"

/**
 * ゲームメインのシーン
 */
@interface SceneMain : IScene {
    
    // 入力受け取り
    InterfaceLayer* interfaceLayer;
    
    // 描画オブジェクト
    CCLayer*        baseLayer;
    AsciiFont*      fontTest;
    AsciiFont*      fontTest2;
    AsciiFont*      fontTest3;
    TokenManager*   mgrBlock;
    Cursor*         cursor;
    Grid*           grid;
    HpGauge*        hpGauge;
    
    // レイヤー
    Layer2D*        layer;
    Layer2D*        layer2;
    
    // ゲーム状態管理
    MainCtrl*       ctrl;
    
    // 変数
    int             m_State;    // 状態
    int             m_Timer;    // タイマー
}

@property (nonatomic, retain)InterfaceLayer*    interfaceLayer;
@property (nonatomic, retain)CCLayer*           baseLayer;
@property (nonatomic, retain)AsciiFont*         fontTest;
@property (nonatomic, retain)AsciiFont*         fontTest2;
@property (nonatomic, retain)AsciiFont*         fontTest3;
@property (nonatomic, retain)TokenManager*      mgrBlock;
@property (nonatomic, retain)Cursor*            cursor;
@property (nonatomic, retain)Grid*              grid;
@property (nonatomic, retain)HpGauge*           hpGauge;

@property (nonatomic, retain)Layer2D*   layer;
@property (nonatomic, retain)Layer2D*   layer2;

@property (nonatomic, retain)MainCtrl*  ctrl;

+ (SceneMain*)sharedInstance;
+ (void)releaseInstance;

@end
