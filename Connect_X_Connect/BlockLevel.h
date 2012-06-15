//
//  BlockLevel.h
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/06/16.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Token.h"
#import "FixedArray.h"

// 出現するブロックの最大値
static const int BLOCK_KIND_MAX = 10;

/**
 * ブロックのレベル管理
 */
@interface BlockLevel : Token {
    
    int     m_nLevel;   // ブロック修験レベル
    FixedArray  m_Array;
}

// レベルの設定
- (void)setLevel:(int)nLevel;

// ランダムで番号を取得する
- (int)getNumber;

// ランダムで番号を取得 (１を含める)
- (int)getNumberBottom;

@end
