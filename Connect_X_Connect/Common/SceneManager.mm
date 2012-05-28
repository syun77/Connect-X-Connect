//
//  SceneManager.mm
//  Test7
//
//  Created by OzekiSyunsuke on 12/04/22.
//  Copyright 2012年 2dgames.jp. All rights reserved.
//

#import <objc/runtime.h>

#import "SceneManager.h"

static NSString* s_CurrentName = nil;

// シーンの切り替え
void SceneManager_Change(NSString* pName) {
    
    BOOL bInit = YES;
    if (s_CurrentName) {
        
        // 生成済みならば開放
        NSString* pClass = s_CurrentName;
        SEL sel = @selector(releaseInstance);
        Method method = class_getClassMethod(NSClassFromString(pClass), sel);
        if (method == nil) {
            NSLog(@"Error: %@ hasn't releaseInstance method.", pClass);
            assert(0);
        }
        IMP imp = method_getImplementation(method);
        imp(pClass, sel);
        
        // 初期化不要
        bInit = NO;
    }
    
    // 次に実行するシーンを生成
    NSString* pClass = pName;
    SEL sel = @selector(sharedInstance);
    Method method = class_getClassMethod(NSClassFromString(pClass), sel);
    if (method == nil) {
        NSLog(@"Error: %@ hasn't sharedInstance method.", pClass);
        assert(0);
    }
    IMP imp = method_getImplementation(method);
    CCScene* now = imp(pClass, sel);
    
    if (bInit) {
        
        [[CCDirector sharedDirector] runWithScene:now];
    }
    else {
        
        [[CCDirector sharedDirector] replaceScene:now];
    }
    s_CurrentName = pName;
}

// 現在のシーンを取得する
CCScene* SceneManager_GetCurrent() {
    return nil;
}

// 現在のシーン名を取得する
NSString* SceneManager_GetCurrentName() {
    return s_CurrentName;
}
