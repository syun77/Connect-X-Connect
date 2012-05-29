//
//  Layer2D.mm
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/05/28.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Layer2D.h"
#import "Math.h"

@implementation Layer2D

/**
 * コンストラクタ
 */
- (id)init {
    self = [super init];
    if (self == nil) {
        return self;
    }
    
    m_Out   = -1; // 領域外
    m_Width = 0;
    m_Height = 0;
    m_pData = NULL;
    
    return self;
}

/**
 * デストラクタ
 */
- (void)dealloc {
    
    if (m_pData) {
        free(m_pData);
        m_pData = NULL;
    }
    
    [super dealloc];
    
}

/**
 * 生成
 * @param w 幅
 * @param h 高さ
 */
- (void)create:(int)w h:(int)h {
    
    if (m_Width == w && m_Height == h) {
        
        // 同じサイズであれば作りなおさない
        // 要素は削除しておく
        memset(m_pData, 0, sizeof(int) * m_Width * m_Height);
        return;
    }
    
    m_Width = w;
    m_Height = h;

    m_pData = (int*)malloc(sizeof(int) * m_Width * m_Height);
    memset(m_pData, 0, sizeof(int) * m_Width * m_Height);
}

/**
 * コピー
 * @param layer コピーレイヤー
 */
- (void)copyWithLayer2D:(Layer2D*)layer {
    
    // 作り直し
    [self create:[layer getWidth] h:[layer getHeight]];
    
    // パラメータ受け渡し
    m_Out = [layer getOut];
    
    for (int j = 0; j < m_Height; j++) {
        
        for (int i = 0; i < m_Width; i++) {
            
            int val = [layer get:i y:j];
            
            // 設定
            [self set:i y:j val:val];
        }
    }
}

// 幅を取得
- (int)getWidth {
    
    return m_Width;
}

// 高さを取得
- (int)getHeight {
    
    return m_Height;
}

// インデックスの最大値を取得
- (int)getIdxMax {
    
    return m_Width * m_Height;;
}

// インデックスに変換する
- (int)getIdx:(int)x y:(int)y {
    
    return x + y * m_Width;
}

// 領域内かどうか
- (BOOL)isRange:(int)x y:(int)y {
    
    if (x < 0 || x >= m_Width || y < 0 || y >= m_Height) {
        
        // 領域外
        return NO;
    }
    
    // 領域内
    return YES;
}

// 領域内かどうか (インデックス指定)
- (BOOL)isRangeFromIdx:(int)idx {
    
    if (idx < 0) {
        
        // 領域外
        return NO;
    }
    
    if (idx > m_Width * m_Height) {
        
        // 領域外
        return NO;
    }
    
    // 領域内
    return YES;
}



/**
 * 値の設定
 * @param x X座標
 * @param y Y座標
 * @param val 値
 */
- (void)set:(int)x y:(int)y val:(int)val {
    
    if ([self isRange:x y:y] == NO) {
        
        // 領域外
        NSLog(@"Warning: Layer2D::set() Out of range. (x,y)=(%d,%d) val=%d", x, y, val);
        return;
    }
    
    [self setFromIdx:[self getIdx:x y:y] val:val];
}

/**
 * 値の設定 (インデックス指定)
 */
- (void)setFromIdx:(int)idx val:(int)val {
    
    if ([self isRangeFromIdx:idx] == NO) {
        
        // 領域外
        NSLog(@"Warning: Layer2D::setFromIdx() Out of range. idx=%d val=%d", idx, val);
        return;
    }
    
    m_pData[idx] = val;
}

/**
 * 値の取得
 * @param x X座標
 * @param y Y座標
 * @return 値
 */
- (int)get:(int)x y:(int)y {
    
    if ([self isRange:x y:y] == NO) {
        
        // 領域外
        return m_Out;
    }
    
    int idx = [self getIdx:x y:y];
    return m_pData[idx];
}

// 値の取得 (インデックス指定)
- (int)getFromIdx:(int)idx {
    if ([self isRangeFromIdx:idx] == NO) {
        
        // 領域外
        return m_Out;
    }
    
    return m_pData[idx];
}

// 領域外の値を取得する
- (int)getOut {
    return m_Out;
    
}

// ランダムで値を埋める
- (void)random:(int)range {
    
    for (int i = 0; i < [self getIdxMax]; i++) {
        
        // ランダムで値を設定
        int v = Math_Rand(range);
        [self setFromIdx:i val:v];
    }
}

// デバッグ出力
- (void)dump {
    NSLog(@"[Layer2D]");
    NSLog(@"  (w,h)=(%d,%d) Out=%d", m_Width, m_Height, m_Out);
    
    for (int j = 0; j < m_Height; j++) {
        
        for (int i = 0; i < m_Width; i++) {
            
            fprintf(stdout, "%d", [self get:i y:j]);
        }
        fprintf(stdout, "\n");
    }
}

// テストデータ作成
- (void)test {
    [self create:7 h:7];
    [self set:4 y:4 val:3];
    [self set:0 y:0 val:1];
    [self set:8 y:10 val:5]; // 領域外テスト
    [self set:-1 y:5 val:3]; // 領域外テスト
}


@end

