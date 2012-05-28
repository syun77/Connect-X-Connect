//
//  Layer2D.mm
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/05/28.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Layer2D.h"

@implementation Layer2D

@synthesize width = m_Width;
@synthesize height = m_Height;

/**
 * コンストラクタ
 */
- (id)init {
    self = [super init];
    if (self == nil) {
        return self;
    }
    
    m_Out   = -1; // 領域外
    m_Default = 0; // 初期値
    m_Width = 0;
    m_Height = 0;
    m_Data = nil;
    
    return self;
}

/**
 * デストラクタ
 */
- (void)dealloc {
    m_Data = nil;
    
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
        [m_Data removeAllObjects];
        return;
    }
    
    m_Width = w;
    m_Height = h;
    
    m_Data = [NSMutableDictionary dictionaryWithCapacity:m_Width * m_Height];
}

/**
 * コピー
 * @param layer コピーレイヤー
 */
- (void)copyWithLayer2D:(Layer2D*)layer {
    
    // 作り直し
    [self create:layer.width h:layer.height];
    
    // パラメータ受け渡し
    m_Default = [layer getDefault];
    m_Out     = [layer getOut];
    
    NSDictionary* dictionary = [layer getData];
    [m_Data addEntriesFromDictionary:dictionary];
    
}

/**
 * 値が設定されているかどうか
 * @param x X座標
 * @param y Y座標
 * @return 設定されていれば「YES」
 */
- (BOOL)has:(int)x y:(int)y {
    if (m_Data) {
        int key = [self getIdx:x y:y];
        return [m_Data objectForKey:[NSNumber numberWithInt:key]] != nil;
    }
    
    return NO;
}

// インデックスに変換する
- (int)getIdx:(int)x y:(int)y {
    
    return x + y * m_Width;
}

// 領域内かどうか
- (BOOL)isRange:(int)x y:(int)y {
    
    int idx = [self getIdx:x y:y];
    
    return [self isRangeFromIdx:idx];
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
        NSLog(@"Warning: Layer2D::se() Out of range. x=%d y=%d val=%d", x, y, val);
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
    
    NSNumber* key    = [NSNumber numberWithInt:idx];
    NSNumber* number = [NSNumber numberWithInt:val];
    
    [m_Data setObject:number forKey:key];
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
    
    if ([self has:x y:y] == NO) {
        
        // 未設定
        return m_Default;
    }
    
    int idx = [self getIdx:x y:y];
    NSNumber* number = [m_Data objectForKey:[NSNumber numberWithInt:idx]];
    
    return [number intValue];
}


// 初期値を取得する
- (int)getDefault {
    return m_Default;
}

// 領域外の値を取得する
- (int)getOut {
    return m_Out;
    
}

// ディクショナリを取得する (コピー用)
- (NSDictionary*)getData {
    return m_Data;
}

// デバッグ出力
- (void)dump {
    NSLog(@"[Layer2D]");
    NSLog(@"  (w,h)=(%d,%d) Default=%d Out=%d", m_Width, m_Height, m_Default, m_Out);
    
    for (int j = 0; j < m_Height; j++) {
        
        for (int i = 0; i < m_Width; i++) {
            
            fprintf(stdout, "%d", [self get:i y:j]);
        }
        fprintf(stdout, "\n");
    }
}


@end

