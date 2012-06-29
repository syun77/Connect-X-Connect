//
//  MyCocos2DClass.mm
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/05/30.
//  Copyright 2012年 2dgame.jp. All rights reserved.
//

#import "FieldMgr.h"

#import "SceneMain.h"

@implementation FieldMgr

/**
 * フィールドレイヤーを取得する
 * @return レイヤー
 */
+ (Layer2D*)getLayer {
    SceneMain* scene = [SceneMain sharedInstance];
    return scene.layer;
}

/**
 * ブロック管理オブジェクトを取得
 * @return ブロック管理オブジェクト
 */
+ (TokenManager*)getManager {
    SceneMain* scene = [SceneMain sharedInstance];
    return scene.mgrBlock;
}

/**
 * 他のブロックに当たっているかどうか調べる
 */
+ (BOOL)isHitBlock:(Block*)block {
    
    TokenManager* mgr = [FieldMgr getManager];
    
    for (Block* b in mgr.m_Pool) {
        
        if ([b isExist] == NO) {
            
            // 存在しない
            continue;
        }
        
        if ([b getIndex] == [block getIndex]) {
            
            // インデックスが一致している
            continue;
        }
        
        if ([b isHit2:block]) {
            
            // 当たっている
            return YES;
        }
    }
    
    // 当たっていない
    return NO;
}

/**
 * 下が領域外かどうか
 */
+ (BOOL)isBottomOut:(Block*)block {
    int x = [block getChipX];
    int y = [block getChipY];
    
    // 一つ下
    y -= 1;
    
    Layer2D* layer = [FieldMgr getLayer];
    int idx = [layer getIdx:x y:y];
    
    int val = [layer getFromIdx:idx];
    
    if (val <= FIELD_OUT) {
        
        // 領域外
        return YES;
    }
    
    // 領域内
    return NO;
    
}

/**
 * １つ下にブロックがあるかどうか調べる
 */
+ (BOOL)isBlockBottom:(Block*)block {
    int x = [block getChipX];
    int y = [block getChipY];
    
    // 一つ下
    y -= 1;
    
    Layer2D* layer = [FieldMgr getLayer];
    int idx = [layer getIdx:x y:y];
    
    if ([FieldMgr isBlock:idx] == YES) {
        
        // ブロックがある
        return YES;
    }
    
    // ブロックがない
    return NO;
}

/**
 * 指定の座標にブロックがあるかどうか 
 * @param idx インデックス
 * @return ブロックがあれば「YES」
 */
+ (BOOL)isBlock:(int)idx {
    Layer2D* layer = [FieldMgr getLayer];
    
    int v = [layer getFromIdx:idx];
    
    if (v <= BLOCK_INVALID) {
        
        // ブロックでない or フィールド外
        return NO;
    }
    
    return YES;
}

/**
 * ブロックの情報をレイヤーにコピーする
 * @param nSpecial スペシャルブロックの数
 */
+ (void)copyBlockToLayer:(int)nSpecial {
    
    Layer2D* layer = [FieldMgr getLayer];
    [layer clear];
    
    TokenManager* mgr = [FieldMgr getManager];
    for (Block* b in mgr.m_Pool) {
        if ([b isExist] == NO) {
            
            // 存在しない
            continue;
        }
        
        int x = [b getChipX];
        int y = [b getChipY];
        int num = [b getNumber];
        
        if ([b isShield]) {
            
            if (nSpecial == num) {
                
                // スペシャル時は消せる (1扱い)
                [layer set:x y:y val:1];
            }
            else {
                
                // シールド有効時は消せない
                [layer set:x y:y val:100];
            }
            continue;
        }
        
        if ([b isSkull]) {
            
            if (nSpecial == SKULL_INDEX) {
                
                // スペシャル時は消せる (1扱い)
                [layer set:x y:y val:1];
            }
            else {
                
                // ドクロはそのままでは消せない
                [layer set:x y:y val:SKULL_INDEX];
            }
            continue;
        }
        
        if ([b isSpecial]) {
            
            // スペシャルブロックは１扱い
            [layer set:x y:y val:1];
            continue;
        }
        
        if (nSpecial == num) {
            
            // スペシャル時は消せる (1扱い)
            [layer set:x y:y val:1];
        }
        else {
            
            [layer set:x y:y val:[b getNumber]];
        }
    }
    
}


@end