//
//  Back.mm
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/06/07.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Back.h"

@implementation Back

/**
 * コンストラクタ
 */
- (id)init {
    
    self = [super init];
    if (self == nil) {
        return self;
    }
    
    [self load:@"bg001.png"];
    self._x = 160;
    self._y = 240;
    
    [self move:0];
    
    return self;
}

- (void)update:(ccTime)dt {
    
}


@end
