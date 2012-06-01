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
    Layer2D* layerTmp;      // 計算用テンポラリ
    
    int     m_State;        // 状態
    int     m_Timer;        // タイマー
    
    int     m_TouchState;   // タッチしているかどうか
    float   m_TouchX;       // タッチ座標 (X)
    float   m_TouchY;       // タッチ座標 (Y)
    int     m_ChipX;        // タッチ座標 (チップ座標X)
    
    int     m_BlockHandler; // 追加中のブロックのハンドラ
    
}

@property (nonatomic, retain)Layer2D* layerVanish;
@property (nonatomic, retain)Layer2D* layerTmp;

- (void)update:(ccTime)dt;
- (BOOL)isEnd;

@end