//
//  IScene.h
//  Test7
//
//  Created by OzekiSyunsuke on 12/04/24.
//  Copyright 2012年 2dgames.jp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface IScene : CCScene {
    bool m_bPress;  // そのフレーム内でタッチしたかどうかを判定するフラグ
}

- (BOOL)isPress;

// ■コールバック関数
- (void)cbTouchStart:(float)x y:(float)y;
- (void)cbTouchMove:(float)x y:(float)y;
- (void)cbTouchEnd:(float)x y:(float)y;
- (void)cbTouchCancel:(float)x y:(float)y;

@end
