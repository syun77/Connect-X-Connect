//
//  FontEffect.h
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/06/05.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Token.h"
#import "AsciiFont.h"

/**
 * フォントエフェクト種別
 */
enum eFontEffect {
    eFontEffect_Damage, // ダメージ演出用エフェクト
};

/**
 * 演出用フォント
 */
@interface FontEffect : Token {
    
    AsciiFont*  m_pFont;
    
    eFontEffect m_Type;
    int         m_Timer;
}

@property (nonatomic, retain)AsciiFont* m_pFont;

// パラメータ設定
- (void)setParam:(eFontEffect)type text:(NSString*)text;

// 追加
+ (FontEffect*)add:(eFontEffect)type x:(float)x y:(float)y text:(NSString*)text;

@end
