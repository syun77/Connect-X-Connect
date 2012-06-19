//
//  BackTitle.mm
//  Test7
//
//  Created by OzekiSyunsuke on 12/05/11.
//  Copyright 2012年 2dgames.jp. All rights reserved.
//

#import "BackTitle.h"
#import "Exerinya.h"
#import "Math.h"
#import "SceneTitle.h"

static const float POS_RANK_L = 80;
static const float POS_RANK_R = 480-POS_RANK_L;
static const float POS_RANK_Y = 160;

/**
 * タイトル画面用背景
 */
@implementation BackTitle

- (id)init {
    self = [super init];
    if (self == nil) {
        return self;
    }
    
    [self load:@"all.png"];
    
    [self create];
    
    self._x = System_CenterX();
    self._y = System_CenterY();
    [self move:0];
    
    // 背景画像を設定
    [self setTexRect:Exerinya_GetRect(eExerinyaRect_Back)];
    
    // 変数初期化
    m_tPast = 0;
    m_tCursorL = 0;
    m_tCursorR = 0;
    
    return self;
}

/**
 * 更新
 */
- (void)update:(ccTime)dt {
    m_tPast++;
    
    if ([[SceneTitle sharedInstance] isTouchRankSelect]) {
        // タッチセレクト中はタイマーを減衰させる
        m_tCursorL *= 0.8;
        m_tCursorR *= 0.8;
    }
    else {
        if (m_tCursorL != m_tCursorR) {
            m_tCursorL = m_tCursorR;
        }
        
        m_tCursorL++;
        m_tCursorR++;
        
        if (m_tCursorL*4 > 180) {
            m_tCursorL -= 180 / 4;
        }
        if (m_tCursorR*4 > 180) {
            m_tCursorR -= 180 / 4;
        }
    }
    
}

- (void)visit {
    [super visit];
    
    // ■ランク選択カーソルの描画
    glColor4f(0, 0, 0, 0.4);
    if ([[SceneTitle sharedInstance] isTouchRankSelect]) {
        
        // タッチ中
        glColor4f(0, 0, 0.5, 0.4);
    }
    [self fillRectLT:RANK_SELECT_RECT_X y:RANK_SELECT_RECT_Y w:RANK_SELECT_RECT_W h:RANK_SELECT_RECT_H rot:0 scale:1];
    
    System_SetBlend(eBlend_Add);
    glColor4f(1, 0.2, 0.2, 1);
    
    float cursorLX = 16 * Math_SinEx((m_tCursorL * 4)%180);
    float cursorRX = 16 * Math_SinEx((m_tCursorR * 4)%180);
    
    [self fillTriangle:POS_RANK_L - cursorLX cy:POS_RANK_Y radius:16 rot:270 scale:1];
    [self fillTriangle:POS_RANK_R + cursorRX cy:POS_RANK_Y radius:16 rot:90 scale:1];
    
    System_SetBlend(eBlend_Normal);
    
    // ■ゲーム開始ボタンの描画
    glColor4f(0.2, 0.2, 0.2, 0.5);
    [self fillRectLT:START_BUTTON_RECT_X-2 y:START_BUTTON_RECT_Y-2 w:START_BUTTON_RECT_W+4 h:START_BUTTON_RECT_H+4 rot:0 scale:1];
    glColor4f(0.5, 0.5, 0.5, 0.5);
    if ([[SceneTitle sharedInstance] isTouchGameStart]) {
        
        // タッチ中
        glColor4f(0, 0, 0.5, 0.4);
    }
    [self fillRectLT:START_BUTTON_RECT_X y:START_BUTTON_RECT_Y w:START_BUTTON_RECT_W h:START_BUTTON_RECT_H rot:0 scale:1];
    
    // ■BGM ON/OFF
    glColor4f(0.2, 0.2, 0.2, 0.5);
    [self fillRectLT:BGM_BUTTON_RECT_X-2 y:BGM_BUTTON_RECT_Y-2 w:BGM_BUTTON_RECT_W+4 h:BGM_BUTTON_RECT_H+4 rot:0 scale:1];
    glColor4f(0.5, 0.5, 0.5, 0.5);
    if ([[SceneTitle sharedInstance] isTouchBgm]) {
        
        // タッチ中
        glColor4f(0, 0, 0.5, 0.4);
    }
    [self fillRectLT:BGM_BUTTON_RECT_X y:BGM_BUTTON_RECT_Y w:BGM_BUTTON_RECT_W h:BGM_BUTTON_RECT_H rot:0 scale:1];
    
    // ■SE ON/OFF
    glColor4f(0.2, 0.2, 0.2, 0.5);
    [self fillRectLT:SE_BUTTON_RECT_X-2 y:SE_BUTTON_RECT_Y-2 w:SE_BUTTON_RECT_W+4 h:SE_BUTTON_RECT_H+4 rot:0 scale:1];
    glColor4f(0.5, 0.5, 0.5, 0.5);
    if ([[SceneTitle sharedInstance] isTouchSe]) {
        
        // タッチ中
        glColor4f(0, 0, 0.5, 0.4);
    }
    [self fillRectLT:SE_BUTTON_RECT_X y:SE_BUTTON_RECT_Y w:SE_BUTTON_RECT_W h:SE_BUTTON_RECT_H rot:0 scale:1];
}


// カーソルを動かす（左）
- (void)moveCursorL {
    m_tCursorL = 90 / 4;
}

// カーソルを動かす（右）
- (void)moveCursorR {
    m_tCursorR = 90 / 4;
}

@end
