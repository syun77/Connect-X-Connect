//
//  AsciiFont.mm
//  FontTest
//
//  Created by OzekiSyunsuke on 12/04/01.
//  Copyright 2012年 2dgame.jp. All rights reserved.
//

#import "AsciiFont.h"


/**
 * フォントオブジェクト実装
 */
@implementation AsciiObj

/**
 * コンストラクタ
 */
- (id)init {
    
    self = [super init];
    if (self == nil) {
        return self;
    }
    
    // フォント読み込み
    [self load2:@"font.png" bLinear:NO];
//    [self load:@"font.png"];
    
    [self setChar:' '];
    [self setVisible:NO];
    
    return self;
}

/**
 * 文字に対応する矩形を取得する
 */
- (CGRect)getRectWithChar:(char)c {
//    CGRect ret = CGRectMake(0, 0, ASCII_SIZE, ASCII_SIZE);
    CGRect ret = CGRectMake(256, 256, ASCII_SIZE, ASCII_SIZE);
    
    // ASCII文字の並び
    const char* decode = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.()[]#$%&'\"!?^+-*/=;:_<>";
    
    // 文字の場所を見つける
    int idx = -1;
    for (int i = 0; i < strlen(decode); i++) {
        if (c == decode[i]) {
            
            // 見つかった
            idx = i;
            break;
        }
    }
    
    if (idx == -1) {
        return ret;
    }
    
    // 描画矩形を作成
    int px = idx % ASCII_X_COUNT;
    int py = idx / ASCII_X_COUNT;
    
    ret = CGRectMake(px * (ASCII_SIZE), py * (ASCII_SIZE), ASCII_SIZE, ASCII_SIZE);
    
    return ret;
    
}

/**
 * 文字を設定する
 */
- (void)setChar:(char)c {
    
    CGRect rect = [self getRectWithChar:c];
    
    [self.m_pSprite setTextureRect:rect];
}

- (void)update:(ccTime)dt {
}

@end

// -----------------------------------------------------------------------------
/**
 * ASCIIフォント管理・実装
 */
@implementation AsciiFont

/**
 * コンストラクタ
 */
- (id)init {
    
    self = [super init];
    
    if (self == nil) {
        return self;
    }
    
    // 描画プライオリティを大きめにする
    [super setPrio:PRIO_ASCIIFONT];
    
    return self;
}

/**
 * フォントの生成
 * @param layer 描画レイヤー
 * @param length 最大文字列長
 */
- (void)createFont:(CCLayer *)layer length:(NSInteger)length {
    
    // 管理トークンの生成
    [super create:layer size:length className:@"AsciiObj"];
    
    
    // 表示を有効にする
    [super addAll];
    
    // 変数初期化
    m_Length    = 0;
    m_Scale     = 1.0f;
    m_Align     = eFontAlign_Left;
    m_X         = 0;
    m_Y         = 0;
}

- (void)createFont2:(CCLayer *)layer length:(NSInteger)length prio:(NSInteger)prio {
    
    [self setPrio:prio];
    
    [self createFont:layer length:length];
}

/**
 * フォントの１文字あたりのサイズを取得する
 */
- (float)getLetterSize {
    return ASCII_SIZE * m_Scale;
}

/**
 * 描画種別
 */
- (void)setAlign:(eFontAlign)align {
    m_Align = align;
    
    // 描画座標更新
    [self setPosScreen:m_X y:m_Y];
}

/**
 * 色を設定する
 */
- (void)setColor:(ccColor3B) color {
    
    for (AsciiObj* t in self.m_Pool) {
        
        // 色の設定
        [t setColor:color];
    }
}

// α値を設定する (0〜255)
- (void)setAlpha:(int) alpha {
    
    for (AsciiObj* t in self.m_Pool) {
        // α値の設定
        [t setAlpha:alpha];
    }
    
}

// 拡縮する
- (void)setScale:(float)scale {
    
    for (AsciiObj* t in self.m_Pool) {
        
        [t setScale:scale];
    }
    
    m_Scale = scale;
}

/**
 * 文字列の設定
 * @param text 文字列
 */
- (void)setText:(NSString *)pText {
    
    m_Length = [pText lengthOfBytesUsingEncoding:NSASCIIStringEncoding];
    if (m_Length > [self max]) {
        
        // 文字列長が足りない
        NSLog(@"Warning: FontAscii::setText over length = %d", m_Length);
        //return;
    }
    
    for (int i = 0; i < [self max]; i++) {
        
        // 文字オブジェクト取得
        AsciiObj* t = (AsciiObj*)[self getFromIdx:i];
        
        if (i < m_Length) {
            
            // 描画する
            [t setVisible:YES];
            [t setChar:[pText characterAtIndex:i]];
        }
        else {
            
            // 描画不要なものは消しておく
            [t setVisible:NO];
        }
    }
    
    // 描画座標更新
    [self setPosScreen:m_X y:m_Y];
}

// 文字列長を取得する
- (int)getLength {
    return m_Length;
}

// 描画座標を設定する (フォント座標)
- (void)setPos:(float)x y:(float)y {
    [self setPosScreen:x * ASCII_SIZE y:y * ASCII_SIZE];
}

// 描画座標を設定する (スクリーン座標)
- (void)setPosScreen:(float)x y:(float)y {
    
    m_X = x;
    m_Y = y;
    float size = [self getLetterSize];
    
    for (int i = 0; i < [self max]; i++) {
        
        // 文字オブジェクト取得
        AsciiObj* p = (AsciiObj*)[self getFromIdx:i];
        
        // 描画基準座標を設定
        float ofsX = 0;
        switch (m_Align) {
            case eFontAlign_Left:
                p.m_pSprite.anchorPoint = ccp(0, 0);
                break;
                
            case eFontAlign_Center:
                p.m_pSprite.anchorPoint = ccp(0.5, 0.5);
                ofsX = -(m_Length - 1) * size / 2.0f;
                break;
                
            default:
                break;
        }
        
        float px = x + i * size + ofsX;
        float py = y;
        [p setPosition:ccp(px, py)];
    }
}

// 表示・非表示を設定する
- (void)setVisible:(BOOL)b {
    for (int i = 0; i < [self max]; i++) {
        
        // 文字オブジェクト取得
        AsciiObj* t = (AsciiObj*)[self getFromIdx:i];
        
        if (i < m_Length) {
            [t setVisible:b];
        }
    }
}

@end
