//
//  IScene.mm
//  Test7
//
//  Created by OzekiSyunsuke on 12/04/24.
//  Copyright 2012年 2dgames.jp. All rights reserved.
//

#import "IScene.h"


@implementation IScene

- (BOOL)isPress {
    return m_bPress;
}

// ■コールバック関数定義
- (void)cbTouchStart:(float)x y:(float)y {
    m_bPress = YES;
}
- (void)cbTouchMove:(float)x y:(float)y {
}
- (void)cbTouchEnd:(float)x y:(float)y {
}
- (void)cbTouchCancel:(float)x y:(float)y {
}

@end

