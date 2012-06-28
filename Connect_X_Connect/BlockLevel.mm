//
//  BlockLevel.mm
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/06/16.
//  Copyright 2012年 2dgames.jp. All rights reserved.
//

#import "BlockLevel.h"

#import "Math.h"

@implementation BlockLevel

/**
 * コンストラクタ
 */
- (id)init {
    self = [super init];
    if (self == nil) {
        return self;
    }
    
    [self load:@"block.png"];
    [self create];
    
    [self setVisible:NO];
    
    return self;
}

/**
 * 更新
 */
- (void)update:(ccTime)dt {
    
}

/**
 * プリミティブの描画
 */
- (void)visit {
    [super visit];
}

// レベルの設定
- (void)setLevel:(int)nLevel {
    
    m_Array.clear();
    
    int d = nLevel/10;
    if (d > 8) {
        d = d % 9;
        if (d < 2) {
            d = 2;
        }
    }
    
    NSString* str = nil;
    
    switch (d) {
        case 8:  { str = @"3,4,5,6"; break; }
        case 7:  { str = @"5,6,7"; break; }
        case 6:  { str = @"6,7,8"; break; }
        case 5:  { str = @"4,5,6,7"; break; }
        case 4:  { str = @"3,4,5,6"; break; }
        case 3:  { str = @"3,4,5,6"; break; }
        case 2:  { str = @"2,3,4,5,6"; break; }
        case 1:  { str = @"2,3,4,5"; break; }
        default: { str = @"2,3,4"; break; }
    }
    
    NSArray* arr = [str componentsSeparatedByString:@","];
    for (NSString* s in arr) {
        int v = [s intValue];
        
        m_Array.push(v);
    }
}

// ランダムで番号を取得する
- (int)getNumber {
    
    m_Array.shuffle();
    
    return m_Array.get(Math_Rand(m_Array.count()));
}

// ランダムで番号を取得 (１を含める)
- (int)getNumberBottom {
    
    int cnt = Math_Rand(m_Array.count() + 1);
    
    if (cnt == 0) {
        return 1;
    }
    else {
        return [self getNumber];
    }
}
@end
