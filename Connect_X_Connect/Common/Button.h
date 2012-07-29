//
//  Button.h
//  Test7
//
//  Created by OzekiSyunsuke on 12/07/12.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Token.h"
#import "InterfaceLayer.h"
#import "AsciiFont.h"

/**
 * ボタンオブジェクト
 */
@interface Button : Token {
    InterfaceLayer* m_pInput;       // 入力管理
    BOOL            m_bSelectedPrev;// １フレーム前に選択状態だったかどうか
    BOOL            m_bSelected;    // 選択状態かどうか
    BOOL            m_bVisibled;    // 表示可能かどうか
    BOOL            m_bEnabled;     // 有効かどうか
    
    AsciiFont*      m_Text;         // フォント
    ccColor4F       m_ColorBack;    // 背景色
    
    id              m_Class;
    SEL             m_cbDecide;     // 選択時に呼び出すコールバック
    
    
}

@property (nonatomic, retain)AsciiFont* m_Text;

/**
 * 初期パラメータを設定する
 */
- (void)initWith:(InterfaceLayer*)pInput text:(NSString*)pText cx:(float)cx cy:(float)cy w:(float)w h:(float)h cls:(id)cls onDecide:(SEL)onDecide;

// 選択しているかどうか
- (BOOL)isSelected;

// テキストの変更
- (void)setText:(NSString*)pText;

// テキストのスケール値を設定
- (void)setTextScale:(float)scale;

// 表示非表示切り替え
- (void)setVisible:(BOOL)b;

// 有効無効切り替え
- (void)setEnable:(BOOL)b;

// 背景色の設定
- (void)setBackColor:(ccColor4F)color;



@end
