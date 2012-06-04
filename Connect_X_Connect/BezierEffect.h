//
//  BezierEffect.h
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/06/03.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Token.h"
#import "Vec.h"

/**
 * 種別 (目標)
 */
enum eBezierEffect {
    eBezierEffect_Block,  // ブロック
    eBezierEffect_Enemy,  // 敵
    eBezierEffect_Player, // プレイヤー
};

/**
 * ベジェ曲線によるエフェクト
 */
@interface BezierEffect : Token {
    
    eBezierEffect   m_Type;         // ターゲット種別
    int             m_hTarget;      // ターゲットのハンドル（インデックス）
    Vec2D           m_vList[60];    // ベジェ曲線用のベクトル配列
    int             m_Timer;        // 経過時間
    int             m_Frame;        // 移動フレーム数
    int             m_Val;          // 汎用変数
}

- (void)setParam:(int)handle frame:(int)frame;

// 生存数をカウントする
+ (int)countExist;

// エフェクト追加
+ (BezierEffect*)add:(int)handle x:(float)x y:(float)y frame:(int)frame;
+ (BezierEffect*)addFromChip:(int)handle chipX:(int)chipX chipY:(int)chipY frame:(int)frame;
@end
