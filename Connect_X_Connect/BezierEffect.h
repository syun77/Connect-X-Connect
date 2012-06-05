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

static const int BEZIEREFFECT_FRAME_MAX = 80;

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
    int             m_Timer;        // 経過時間
    int             m_Frame;        // 移動フレーム数
    int             m_Damage;       // ダメージ量
    
    Vec2D m_vList[BEZIEREFFECT_FRAME_MAX];    // ベジェ曲線用のベクトル配列
}

/**
 * カウントダウン用の設定
 * @param handle ブロックのハンドラ
 * @param frame  到達フレーム数
 */
- (void)setParamCountDown:(int)handle frame:(int)frame;

/**
 * ダメージ用の設定
 * @param type   種別
 * @param frame  到達フレーム数
 * @param damage ダメージ量
 */
- (void)setParamDamage:(eBezierEffect)type frame:(int)frame damage:(int)damage;

// 生存数をカウントする
+ (int)countExist;

// エフェクト追加
+ (BezierEffect*)add:(float)x y:(float)y;
+ (BezierEffect*)addFromChip:(int)chipX chipY:(int)chipY;
@end
