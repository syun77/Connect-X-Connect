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
#import "AtGauge.h"
#import "BezierEffect.h"
#import "Player.h"
#import "Enemy.h"
#import "FontEffect.h"
#import "Particle.h"
#import "Back.h"
#import "Chain.h"
#import "RedBar.h"
#import "BlockNext.h"
#import "Combo.h"
#import "BlockLevel.h"
#import "LevelUp.h"
#import "GameOver.h"
#import "Caption.h"

/**
 * ゲームメインのシーン
 */
@interface SceneMain : IScene {
    
    // 入力受け取り
    InterfaceLayer* interfaceLayer;
    
    // 描画オブジェクト
    CCLayer*        baseLayer;
    
    AsciiFont*      fontGameover;
    AsciiFont*      fontLevelup;
    AsciiFont*      fontLevel;
    AsciiFont*      fontTurn;
    AsciiFont*      fontScore;
    
    TokenManager*   mgrBlock;
    TokenManager*   mgrBezierEffect;
    TokenManager*   mgrFontEffect;
    TokenManager*   mgrParticle;
    
    Cursor*         cursor;
    Grid*           grid;
//    HpGauge*        hpGauge;
//    HpGauge*        hpGaugeEnemy;
    AtGauge*        atGauge;
    Player*         player;
    Enemy*          enemy;
    Back*           back;
    Chain*          chain;
    Combo*          combo;
    RedBar*         redbar;
    BlockNext*      blockNext1;
    BlockNext*      blockNext2;
    BlockNext*      blockNext3;
    LevelUp*        levelUp;
    GameOver*       gameover;
    Caption*        caption;
    
    // レイヤー
    Layer2D*        layer;
    
    // ゲーム状態管理
    MainCtrl*       ctrl;
    BlockLevel*     blockLevel;
    
    // 変数
    int             m_State;    // 状態
    int             m_Timer;    // タイマー
}

@property (nonatomic, retain)InterfaceLayer*    interfaceLayer;
@property (nonatomic, retain)CCLayer*           baseLayer;
@property (nonatomic, retain)AsciiFont*         fontGameover;
@property (nonatomic, retain)AsciiFont*         fontLevelup;
@property (nonatomic, retain)AsciiFont*         fontLevel;
@property (nonatomic, retain)AsciiFont*         fontTurn;
@property (nonatomic, retain)AsciiFont*         fontScore;

@property (nonatomic, retain)TokenManager*      mgrBlock;
@property (nonatomic, retain)TokenManager*      mgrBezierEffect;
@property (nonatomic, retain)TokenManager*      mgrFontEffect;
@property (nonatomic, retain)TokenManager*      mgrParticle;
@property (nonatomic, retain)Cursor*            cursor;
@property (nonatomic, retain)Grid*              grid;
//@property (nonatomic, retain)HpGauge*           hpGauge;
//@property (nonatomic, retain)HpGauge*           hpGaugeEnemy;
@property (nonatomic, retain)AtGauge*           atGauge;
@property (nonatomic, retain)Player*            player;
@property (nonatomic, retain)Enemy*             enemy;
@property (nonatomic, retain)Back*              back;
@property (nonatomic, retain)Chain*             chain;
@property (nonatomic, retain)Combo*             combo;
@property (nonatomic, retain)RedBar*            redbar;
@property (nonatomic, retain)BlockNext*         blockNext1;
@property (nonatomic, retain)BlockNext*         blockNext2;
@property (nonatomic, retain)BlockNext*         blockNext3;
@property (nonatomic, retain)LevelUp*           levelUp;
@property (nonatomic, retain)GameOver*          gameover;
@property (nonatomic, retain)Caption*           caption;

@property (nonatomic, retain)Layer2D*           layer;

@property (nonatomic, retain)MainCtrl*          ctrl;
@property (nonatomic, retain)BlockLevel*        blockLevel;

+ (SceneMain*)sharedInstance;
+ (void)releaseInstance;

@end
