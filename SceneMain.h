//
//  SceneMain.h
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/05/28.
//  Copyright 2012年 2dgame.jp. All rights reserved.
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
#import "BezierEffect.h"
#import "Player.h"
#import "Enemy.h"
#import "FontEffect.h"
#import "Particle.h"
#import "Back.h"

/**
 * ゲームメインのシーン
 */
@interface SceneMain : IScene {
    
    // 入力受け取り
    InterfaceLayer* interfaceLayer;
    
    // 描画オブジェクト
    CCLayer*        baseLayer;
    AsciiFont*      fontGameover;
    AsciiFont*      fontTest;
    AsciiFont*      fontTest2;
    AsciiFont*      fontTest3;
    TokenManager*   mgrBlock;
    TokenManager*   mgrBezierEffect;
    TokenManager*   mgrFontEffect;
    TokenManager*   mgrParticle;
    Cursor*         cursor;
    Grid*           grid;
    HpGauge*        hpGauge;
    HpGauge*        hpGaugeEnemy;
    Player*         player;
    Enemy*          enemy;
    Back*           back;
    
    // レイヤー
    Layer2D*        layer;
    
    // ゲーム状態管理
    MainCtrl*       ctrl;
    
    // 変数
    int             m_State;    // 状態
    int             m_Timer;    // タイマー
}

@property (nonatomic, retain)InterfaceLayer*    interfaceLayer;
@property (nonatomic, retain)CCLayer*           baseLayer;
@property (nonatomic, retain)AsciiFont*         fontGameover;
@property (nonatomic, retain)AsciiFont*         fontTest;
@property (nonatomic, retain)AsciiFont*         fontTest2;
@property (nonatomic, retain)AsciiFont*         fontTest3;
@property (nonatomic, retain)TokenManager*      mgrBlock;
@property (nonatomic, retain)TokenManager*      mgrBezierEffect;
@property (nonatomic, retain)TokenManager*      mgrFontEffect;
@property (nonatomic, retain)TokenManager*      mgrParticle;
@property (nonatomic, retain)Cursor*            cursor;
@property (nonatomic, retain)Grid*              grid;
@property (nonatomic, retain)HpGauge*           hpGauge;
@property (nonatomic, retain)HpGauge*           hpGaugeEnemy;
@property (nonatomic, retain)Player*            player;
@property (nonatomic, retain)Enemy*             enemy;
@property (nonatomic, retain)Back*              back;

@property (nonatomic, retain)Layer2D*   layer;

@property (nonatomic, retain)MainCtrl*  ctrl;

+ (SceneMain*)sharedInstance;
+ (void)releaseInstance;

@end
