//
//  SceneManager.h
//  Test7
//
//  Created by OzekiSyunsuke on 12/04/22.
//  Copyright 2012年 2dgames.jp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

// シーンの切り替え
void SceneManager_Change(NSString* pName);

// 現在のシーンを取得する
CCScene* SceneManager_GetCurrent();

// 現在のシーン名を取得する
NSString* SceneManager_GetCurrentName();
