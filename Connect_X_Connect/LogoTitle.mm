//
//  LogoTitle.mm
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/07/06.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "LogoTitle.h"

/**
 * タイトルロゴ実装
 */
@implementation LogoTitle

- (id)init {
    self = [super init];
    if (self == nil) {
        return self;
    }
    
    [self load:@"all.png"];
    [self create];
    int w = 292;
    CGRect r = CGRectMake(1024-w, 560, w, 120);
    [self setTexRect:r];
    
    self._x = System_CenterX();
    self._y = 480 - 120;
    [self move:0];
    
    return self;
}

- (void)update:(ccTime)dt {
    [self move:0];
}

@end
