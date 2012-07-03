//
//  Back.mm
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/06/07.
//  Copyright 2012年 2dgames.jp. All rights reserved.
//

#import "Back.h"
#import "SceneMain.h"
#import "SaveData.h"

@implementation Back

enum eState {
    eState_None,
    eState_Dark, // 暗くする
    eState_Light, // 明るくする
};

// 暗くするタイマー
static const int TIMER_DARK = 10;

// 危険タイマー
static const int TIMER_DANGER = 10;

- (CGRect)_getTexRect:(int)n {
    
    int x = (n%3) * 320;
    int y = (n/3) * 480;
    
    return CGRectMake(x, y, 320, 480);
}

/**
 * コンストラクタ
 */
- (id)init {
    
    self = [super init];
    if (self == nil) {
        return self;
    }
    
    [self load:@"bg.png"];
    self._x = System_CenterX();
    self._y = System_CenterY();
    
    // レベルを取得
    int nLevel = SaveData_GetRank();
    
    int nSound = GameCommon_LevelToSound(nLevel);
    CGRect r = [self _getTexRect:nSound];
    [self setTexRect:r];
    
    [self move:0];
    [self create];
    
    m_State     = eState_Light;
    m_Timer     = 0;
    m_tDanger   = 0;
    
    return self;
}

- (void)update:(ccTime)dt {
    
    switch (m_State) {
        case eState_Light:
            m_Timer--;
            if (m_Timer < 1) {
                m_Timer = 0;
                m_State = eState_None;
            }
            break;
            
        case eState_Dark:
            m_Timer++;
            if (m_Timer > TIMER_DARK) {
                m_Timer = TIMER_DARK;
            }
            
        default:
            break;
    }
    
    Player* player = [SceneMain sharedInstance].player;
    if ([player isDanger] && [player isDead] == NO) {
        if (m_tDanger < TIMER_DANGER) {
            m_tDanger++;
        }
    }
    else {
        if (m_tDanger > 0) {
            m_tDanger--;
        }
    }
    
    int r = 0xFF - 0xA0 * m_Timer / TIMER_DARK;
    int g = 0xFF - 0xA0 * m_Timer / TIMER_DARK;
    int b = 0xFF - 0xA0 * m_Timer / TIMER_DARK;
    
    g = g * (1 - 0.5 * m_tDanger / TIMER_DANGER);
    b = b * (1 - 0.5 * m_tDanger / TIMER_DANGER);
    
    [self setColor:ccc3(r, g, b)];
}

// 背景変化
- (void)beginDark {
    m_State = eState_Dark;
}

- (void)beginLight {
    m_State = eState_Light;
}

// 背景画像入れ替え
- (void)change:(int)n {
    
    CGRect r = [self _getTexRect:n];
    [self setTexRect:r];
}

// 背景画像入れ替え（素早く変える）
- (void)changeQuick:(int)n {
    
    CGRect r = [self _getTexRect:n];
    [self setTexRect:r];
}
@end
