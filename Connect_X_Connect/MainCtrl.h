//
//  MainCtrl.h
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/05/31.
//  Copyright 2012年 2dgame.jp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Layer2D.h"

/**
 * ゲームメインのコントローラー
 */
@interface MainCtrl : CCNode {
    
    Layer2D* layerVanish;       // 消去判定用レイヤー
    Layer2D* layerTmp;          // 計算用テンポラリ
    
    int     m_State;            // 状態
    int     m_Timer;            // タイマー
    
    int     m_Hp;               // 残りHP
    
    int     m_TouchState;       // タッチしているかどうか
    float   m_TouchStartY;      // タッチ開始座標 (Y)
    float   m_TouchX;           // タッチ座標 (X)
    float   m_TouchY;           // タッチ座標 (Y)
    int     m_ChipX;            // タッチ座標 (チップ座標X)
    int     m_ChipXPrev;        // タッチ座標 (チップ座標X) １つ前
    
    int     m_BlockHandler1;    // 追加中のブロックのハンドラ
    int     m_BlockHandler2;    // 追加中のブロックのハンドラ２
    
    int     m_NumberPrev;       // 出現したブロックの数値
    
}

@property (nonatomic, retain)Layer2D* layerVanish;
@property (nonatomic, retain)Layer2D* layerTmp;

- (void)update:(ccTime)dt;
- (BOOL)isEnd;
- (int)getHp;
- (float)getHpRatio;

@end
