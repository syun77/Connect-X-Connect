//
//  AppDelegate.h
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/05/28.
//  Copyright 2dgame.jp 2012年. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdWhirlView.h"

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate, AdWhirlDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
    AdWhirlView         *adWhirlView;
    
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) AdWhirlView *adWhirlView;

// AdWhirlView の表示・非表示を切り替え
+ (void)setVisibleAdWhirlView:(BOOL)b;

@end
