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
#import "Queue.h"
#import "ReqBlock.h"

/**
 * ゲームメインのコントローラー
 */
@interface MainCtrl : CCNode {
    
    Layer2D* layerVanish;       // 消去判定用レイヤー
    Layer2D* layerTmp;          // 計算用テンポラリ
    
    int     m_StatePrev;        // 状態 (１つ前)
    int     m_State;            // 状態
    int     m_Timer;            // タイマー
    
    int     m_TouchState;       // タッチしているかどうか
    float   m_TouchStartY;      // タッチ開始座標 (Y)
    float   m_TouchX;           // タッチ座標 (X)
    float   m_TouchY;           // タッチ座標 (Y)
    int     m_ChipX;            // タッチ座標 (チップ座標X)
    int     m_ChipXPrev;        // タッチ座標 (チップ座標X) １つ前
    
    int     m_BlockHandler1;    // 追加中のブロックのハンドラ
    
    int     m_NumberPrev;       // 出現したブロックの数値
    
    BOOL        m_ReqAppearUpper;   // 上から出現要求
    BOOL        m_ReqAppearBottom;  // 下から出現要求
    int         m_nBlockLevel;      // 出現ブロックレベル
    ReqBlock    m_ReqParamUpper;    // 上から出現要求のパラメータ
    ReqBlock    m_ReqParamBottom;   // 下から出現要求のパラメータ
    
    int     m_nLevel;           // 現在のレベル
    
    int     m_nChain;           // 連鎖回数
    int     m_nConnect;         // 最大連結数 (数字)
    int     m_nVanish;          // 消去数
    int     m_nKind;            // 消去グループ数
    
    SimpleQueue m_Queue;        // 次に出現するブロックの管理キュー
    
    int     m_nTurn;            // 経過ターン数
    
}

@property (nonatomic, retain)Layer2D* layerVanish;
@property (nonatomic, retain)Layer2D* layerTmp;

- (void)update:(ccTime)dt;
- (BOOL)isEnd;

@end
