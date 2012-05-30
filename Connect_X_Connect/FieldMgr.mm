//
//  MyCocos2DClass.mm
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/05/30.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "FieldMgr.h"

#import "SceneMain.h"

@implementation FieldMgr

/**
 * フィールドレイヤーを取得する
 * @return レイヤー
 */
+ (Layer2D*)getFieldLayer {
    SceneMain* scene = [SceneMain sharedInstance];
    return scene.layer;
}

/**
 * 指定の座標にブロックがあるかどうか 
 * @param idx インデックス
 * @return ブロックがあれば「YES」
 */
+ (BOOL)isBlock:(int)idx {
    Layer2D* layer = [FieldMgr getFieldLayer];
    
    int v = [layer getFromIdx:idx];
    
    if (v <= BLOCK_INVALID) {
        
        // ブロックでない or フィールド外
        return NO;
    }
    
    return YES;
}

@end