//
//  SceneMain.mm
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/05/28.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "SceneMain.h"

// シングルトン
static SceneMain* scene_ = nil;

@implementation SceneMain

/**
 * シングルトンを取得する
 */
+ (SceneMain*)sharedInstance
{
    if (scene_ == nil) {
        scene_ = [SceneMain node];
    }
    
    return scene_;
}

/**
 * インスタンスを解放する
 */
+ (void)releaseInstance
{
    scene_ = nil;
}
@end
