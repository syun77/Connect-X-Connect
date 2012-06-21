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

// ----------------------------------------------------
// private

- (Player*)_getPlayer {
    return [SceneMain sharedInstance].player;
}
- (Enemy*)_getEnemy {
    return [SceneMain sharedInstance].enemy;
}

/**
 * フレーム数を指定
 */
- (void)_setFrame:(int)frame {
    
    m_Timer = 0;
    m_Frame = frame;
    
    if (m_Frame >= BEZIEREFFECT_FRAME_MAX) {
        m_Frame = BEZIEREFFECT_FRAME_MAX;
    }
}

- (void)_doPlayer {
    
    // ダメージ処理
//    Player* player = [self _getPlayer];
//    [player damage:m_Damage];
}
- (void)_doEnemy {
    
    // ダメージ処理
    Enemy* enemy = [self _getEnemy];
    [enemy damageAt:m_Damage];
    
    
}
- (void)_doCountDown {
    
    Block* b = [BlockMgr getFromIndex:m_hTarget];
    if (b) {
        
        [b countDown];
    }
}

- (void)update:(ccTime)dt {
    m_Timer++;
    [self move:0];
    
    if (m_Timer >= m_Frame) {
       
        switch (m_Type) {
            case eBezierEffect_Player:
                [self _doPlayer];
                break;
                
            case eBezierEffect_Enemy:
                [self _doEnemy];
                break;
                
            case eBezierEffect_Block:
                [self _doCountDown];
                break;
                
            default:
                NSLog(@"Error: Not Inplement BezierEffect::update().");
                assert(0);
                break;
        }
        [self vanish];
        
        return;
    }
    
    // TODO:
    Vec2D v = m_vList[m_Timer];
    self._x = v.x;
    self._y = v.y;
    
    [self setScale:self.scale * 0.99];
}

// ----------------------------------------------------
// public
/**
 * カウントダウン用の設定
 * @param handle ブロックのハンドラ
 * @param frame  到達フレーム数
 */
- (void)setParamCountDown:(int)handle frame:(int)frame {
    
    m_Type    = eBezierEffect_Block;
    m_hTarget = handle;
    [self _setFrame:frame];
    
    // ベジェ曲線の作成
    Block* b = [BlockMgr getFromIndex:m_hTarget];
    float x3 = b._x;
    float y3 = b._y;
    float y1 = Math_Randf(480);
    float x2 = Math_Randf(320);
    Vec2d_GetBezierCurve(self._x, self._y, 320, y1, x2, 480, x3, y3, m_vList, frame);
}

/**
 * ダメージ用の設定
 * @param type   種別
 * @param frame  到達フレーム数
 * @param damage ダメージ量
 */
- (void)setParamDamage:(eBezierEffect)type frame:(int)frame damage:(int)damage {
    
    m_Type   = type;
    m_Damage = damage;
    [self _setFrame:frame];
    
    float x3 = 0;
    float y3 = 0;
    if (type == eBezierEffect_Player) {
        
        // プレイヤーに向かって飛んでいく
        Player* player = [self _getPlayer];
        x3 = player._x;
        y3 = player._y;
        [self setColor:ccc3(0xFF, 0, 0)];
    }
    else {
        
        // 的に向かって飛んでいく
        Enemy* enemy = [self _getEnemy];
        x3 = enemy._x;
        y3 = enemy._y;
        [self setColor:ccc3(0xFF, 0xFF, 0xFF)];
    }
    
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

+ (BezierEffect*) add:(float)x y:(float)y {
    
    TokenManager* mgr = [BezierEffect _getTokenManager];
    
    BezierEffect* c = (BezierEffect*)[mgr add];
    if (c) {
        [c set2:x y:y rot:0 speed:0 ax:0 ay:0];
    }
    
    return c;
}

+ (BezierEffect*) addFromChip:(int)chipX chipY:(int)chipY {
    
    float x = GameCommon_ChipXToScreenX(chipX);
    float y = GameCommon_ChipYToScreenY(chipY);
    
    return [BezierEffect add:x y:y];
}

@end
