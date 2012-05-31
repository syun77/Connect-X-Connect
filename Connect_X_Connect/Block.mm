//
//  Block.mm
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/05/29.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Block.h"
#import "SceneMain.h"
#import "FieldMgr.h"
#import "BlockMgr.h"

static const int TIMER_VANISH = 30;
static const float SPEED_FALL = 50; // ブロック落下速度

/**
 * 状態
 */
enum eState {
    eState_Standby,     // 待機中
    eState_Fall,        // 落下中
    eState_FallWait,    // 落下停止中
    eState_Vanish,      // 消滅中
};

/**
 * ブロックの実装
 */
@implementation Block

@synthesize fontNumber;

/**
 * コンストラクタ
 */
- (id)init {
    self = [super init];
    if (self == nil) {
        return self;
    }
    
    [self load:@"font.png"];
    
    self._r = BLOCK_SIZE / 2 - 2;
    
    [self.m_pSprite setVisible:NO];
    
    return self;
}

/**
 * デストラクタ
 */
- (void)dealloc {
    
    self.fontNumber = nil;
    
    [super dealloc];
}

/**
 * フォントの生成
 */
- (void)attachLayer:(CCLayer *)layer {
    
    self.fontNumber = [AsciiFont node];
    [self.fontNumber setPrio:1];
    [self.fontNumber createFont:layer length:2];
    [self.fontNumber setAlign:eFontAlign_Center];
    [self.fontNumber setScale:3];
    
}

/**
 * 初期化
 */
- (void)initialize {
    
    m_State         = eState_Standby;
    m_Timer         = 0;
    m_nNumber       = 1;
    m_ReqFall       = NO;
    m_ReqVanish     = NO;
    [self.fontNumber setVisible:YES];
    [self setVisible:YES];
}

- (void)vanish {
    [self.fontNumber setVisible:NO];
    
    [super vanish];
}

// --------------------------------------------------------
// private

/**
 * グリッド内に収まるようにする
 */
- (void)fitGrid {
    int y = (int)self._y;
    y -= FIELD_OFS_Y;
    int n = y/BLOCK_SIZE;
    if (y - (n * BLOCK_SIZE) > BLOCK_SIZE/2) {
        n += 1;
    }

    self._y = FIELD_OFS_Y + n * BLOCK_SIZE;
}

/**
 * 更新・待機中
 */
- (void)_updateStandby {
    
    if (m_ReqFall) {
        
        // 落下要求を処理
        m_State = eState_Fall;
        
        m_ReqFall = NO;
    }
}

/**
 * 更新・落下中
 */
- (void)_updateFall {
    
    // 下にブロックがあるかどうかチェック
    if ([FieldMgr isBottomOut:self] == YES) {
        
        // 落下待機状態へ
        m_State = eState_FallWait;
        [self fitGrid];
        self._vy = 0;
        self._y = FIELD_OFS_Y;
        
        return;
    }
    
    if ([BlockMgr checkHitBlock:self]) {
        
        // 落下待機状態へ
        m_State = eState_FallWait;
        [self fitGrid];
        self._vy = 0;
        
        return;
    }
    
    // 落下処理
    self._vy -= SPEED_FALL;
}

/**
 * 更新・落下完了
 */
- (void)_updateFallWait {
    
    if (m_ReqVanish) {
        
        // 消滅要求を処理
        m_State = eState_Vanish;
        m_Timer = TIMER_VANISH;
        
        m_ReqVanish = NO;
    }
}

/**
 * 更新・消滅中
 */
- (void)_updateVanish {
    m_Timer--;
    if (m_Timer%4 < 2) {
        
        [self setVisible:NO];
        [self.fontNumber setVisible:NO];
    }
    else {
        
        [self setVisible:YES];
        [self.fontNumber setVisible:YES];
    }
    
    if (m_Timer < 1) {
        [self vanish];
    }
}




// --------------------------------------------------------
// public

/**
 * 更新
 */
- (void)update:(ccTime)dt {
    
    // 速度固定
    [self move:1.0 / 60];
    
    [self.fontNumber setPosScreen:self._x y:self._y];
    
    switch (m_State) {
        case eState_Standby:
            [self _updateStandby];
            break;
            
        case eState_Fall:
            [self _updateFall];
            break;
            
        case eState_FallWait:
            [self _updateFallWait];
            break;
            
        case eState_Vanish:
            [self _updateVanish];
            break;
            
        default:
            break;
    }
}

/**
 * 矩形描画
 */
- (void)visit {
    [super visit];
    
    glColor4f(1, 1, 1, 1);
    float s = BLOCK_SIZE / 2;
    [self drawRect:self._x cy:self._y w:s h:s rot:0 scale:1];
}

// 番号を設定する
- (void)setNumber:(int)number {
    m_nNumber = number;
    [self.fontNumber setText:[NSString stringWithFormat:@"%d", number]];
}

// 番号を取得する
- (int)getNumber {
    return m_nNumber;
}

/**
 * チップ座標の取得 (X座標)
 */
- (int)getChipX {
    
    int x = (int)self._x - FIELD_OFS_X;
    int ret = (int)(x / BLOCK_SIZE);
    
    if (x%BLOCK_SIZE > 0) {
        ret++;
    }
    return ret;
}

/**
 * チップ座標の取得 (Y座標)
 */
- (int)getChipY {
    
    int y = (int)self._y - FIELD_OFS_Y;
    
    int ret = (int)(y / BLOCK_SIZE);
    
    if (y%BLOCK_SIZE > 0) {
        ret++;
    }
    return ret;
}

/**
 * チップ座標の取得 (インデックス)
 */
- (int)getChipIdx {
    
    int x = [self getChipX];
    int y = [self getChipY];
    
    return x + y * BLOCK_SIZE;
}

// 落下要求を送る
- (void)requestFall {
    
    m_ReqFall = YES;
}

// 落下停止中かどうか
- (BOOL)isFallWait {
    
    return m_State == eState_FallWait;
}

// 消去要求を送る
- (void)requestVanish {
    
    m_ReqVanish = YES;
}

// 消滅演出中かどうか
- (BOOL)isVanishing {
    
    return m_State == eState_Vanish;
}

// 待機状態にする
- (void)changeStandby {
    
    m_State = eState_Standby;
}

/**
 * ブロックの追加
 */
+ (Block*)add:(int)number x:(float)x y:(float)y {
    TokenManager* mgr = [SceneMain sharedInstance].mgrBlock;
    Block* b = (Block*)[mgr add];
    if (b) {
        
        [b set2:x y:y rot:0 speed:0 ax:0 ay:0];
        [b setNumber:number];
        
    }
    
    return b;
}

// ブロックを追加する (インデックス指定)
+ (Block*)addFromIdx:(int)number idx:(int)idx {
    
    float x = FIELD_OFS_X + (idx % FIELD_BLOCK_COUNT_X) * BLOCK_SIZE;
    float y = FIELD_OFS_Y + (idx / FIELD_BLOCK_COUNT_X) * BLOCK_SIZE;
    
    return [Block add:number x:x y:y];
}

@end
