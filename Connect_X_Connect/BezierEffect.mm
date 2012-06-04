//
//  BezierEffect.mm
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/06/03.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BezierEffect.h"
#import "SceneMain.h"
#import "BlockMgr.h"
#import "Exerinya.h"

/**
 * ベジェ曲線によるエフェクトの実装
 */
@implementation BezierEffect

+ (TokenManager*)_getTokenManager {
    
    return [SceneMain sharedInstance].mgrBezierEffect;
}

/**
 * コンストラクタ
 */
- (id)init {
    self = [super init];
    if (self == nil) {
        return self;
    }
    
    [self load:@"all.png"];
    CGRect r = Exerinya_GetRect(eExerinyaRect_EftBall);
    [self setTexRect:r];
    
    return self;
}

- (void)initialize {
    [self setScale:0.5];
    [self setBlend:eBlend_Add];
    
}

- (void)update:(ccTime)dt {
    m_Timer++;
    [self move:0];
    
    if (m_Timer >= m_Frame) {
        
        Block* b = [BlockMgr getFromIndex:m_hTarget];
        if (b) {
            
            [b countDown];
        }
        [self vanish];
        
        return;
    }
    
    // TODO:
    Vec2D v = m_vList[m_Timer];
    self._x = v.x;
    self._y = v.y;
    
    [self setScale:self.scale * 0.98];
}

// ----------------------------------------------------
// public
- (void)setParam:(int)handle frame:(int)frame {
    m_hTarget = handle;
    m_Timer = 0;
    m_Frame = frame;
    
    // ベジェ曲線の作成
    Block* b = [BlockMgr getFromIndex:m_hTarget];
    float x3 = b._x;
    float y3 = b._y;
    float y1 = Math_Randf(480);
    float x2 = Math_Randf(320);
    Vec2d_GetBezierCurve(self._x, self._y, 320, y1, x2, 480, x3, y3, m_vList, frame);
}

// ----------------------------------------------------
// static public
/**
 * 生存数をカウントする
 */
+ (int)countExist {
    
    TokenManager* mgr = [BezierEffect _getTokenManager];
    
    return [mgr count];
}

+ (BezierEffect*) add:(int)handle x:(float)x y:(float)y frame:(int)frame {
    
    TokenManager* mgr = [BezierEffect _getTokenManager];
    
    BezierEffect* c = (BezierEffect*)[mgr add];
    if (c) {
        [c set2:x y:y rot:0 speed:0 ax:0 ay:0];
        [c setParam:handle frame:frame];
    }
    
    return c;
}

+ (BezierEffect*) addFromChip:(int)handle chipX:(int)chipX chipY:(int)chipY frame:(int)frame {
    
    float x = GameCommon_ChipXToScreenX(chipX);
    float y = GameCommon_ChipYToScreenY(chipY);
    
    return [BezierEffect add:handle x:x y:y frame:frame];
}

@end
