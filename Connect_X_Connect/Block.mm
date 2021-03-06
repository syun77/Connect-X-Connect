//
//  Block.mm
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/05/29.
//  Copyright 2012年 2dgame.jp. All rights reserved.
//

#import "Block.h"
#import "SceneMain.h"
#import "FieldMgr.h"
#import "BlockMgr.h"

static const int TIMER_VANISH = 30;
static const float SPEED_FALL = 50; // ブロック落下速度
static const float SPEED_FALL_MAX = 1000; // 落下速度の最大値

static const int PRIO_OFS_FONT_FRONT = 1; // 前面に出すとき
static const int PRIO_OFS_FONT_BACK  = -1; // 後方に出すとき

static const int POS_FONT_OFFSET = 2; // フォント描画位置調整

/**
 * 状態
 */
enum eState {
    eState_Slide,       // プレイヤー操作可能状態
    eState_Standby,     // 待機中
    eState_Fall,        // 落下中
    eState_FallWait,    // 落下停止中
    eState_Vanish,      // 消滅中
    eState_End,         // おしまい
};

/**
 * ブロックの実装
 */
@implementation Block

- (CGRect)_getTexRect {
    
    float s = BLOCK_SIZE;
    
    if (m_nShield >= 2) {
        
        float px = 10 * s;
        float py = 0;
        
        return CGRectMake(px, py, s, s);
    }
    
    if (m_nShield == 1) {
        
        float px = (m_nNumber - 1) * s;
        float py = 1 * s;
        
        if (m_bSkull) {
            
            // ドクロ
            px = 11 * s;
        }
        
        return CGRectMake(px, py, s, s);
    }
    
    {
        float px = (m_nNumber - 1) * s;
        float py = 0;
        
        if (m_bSkull) {
            
            // ドクロ
            px = 11 * s;
        }
        else if(m_bSpecial) {
            
            // スペシャルブロック
            px = 9 * s;
        }
        
        return CGRectMake(px, py, s, s);
    }
    
}

/**
 * コンストラクタ
 */
- (id)init {
    
    self = [super init];
    if (self == nil) {
        return self;
    }
    
    [self load:@"block.png"];
    
    self._r = BLOCK_SIZE / 2;
    
    m_tCursor = 0;
    
    return self;
}

/**
 * 初期化
 */
- (void)initialize {
    
    m_State         = eState_Standby;
    m_Timer         = 0;
    m_nNumber       = 1;
    m_nShield       = 0;
    m_bSkull        = NO;
    
    m_ReqFall       = NO;
    m_ReqVanish     = NO;
    m_bPutPlayer    = NO;
    m_bSpecial      = NO;
    [self setVisible:YES];
    [self setColor:ccc3(0xFF, 0xFF, 0xFF)];
}

- (void)vanish {
    [super vanish];
}

// --------------------------------------------------------
// private

- (void)setGlColor {
    
    int a = 0x80;
    
    switch (m_nNumber) {
        case 1:
            glColor4ub(197, 197, 197, a); // 白
            break;
            
        case 2:
            glColor4ub(218, 38, 38, a); // 赤
            break;
            
        case 3:
            glColor4ub(218, 128, 38, a); // オレンジ
            break;
            
        case 4:
            glColor4ub(218, 218, 38, a); // 黄色
            break;
            
        case 5:
            glColor4ub(38, 218, 38, a); // 緑
            break;
            
        case 6:
            glColor4ub(218, 218, 132, a); // 水色
            break;
            
        case 7:
            glColor4ub(80, 80, 226, a); // 青
            break;
            
        case 8:
            glColor4ub(226, 80, 226, a); // 紫
            break;
            
        case 9:
        default:
            glColor4ub(141, 141, 141, a); // 灰色
            break;
    }
}

- (void)setGlColor2 {
    
//    int a = 0x30;
//    switch (m_nNumber) {
//        case 1:
//            glColor4ub(197, 197, 197, a); // 白
//            break;
//            
//        case 2:
//            glColor4ub(165, 31, 31, a); // 赤
//            break;
//            
//        case 3:
//            glColor4ub(165, 98, 31, a); // オレンジ
//            break;
//            
//        case 4:
//            glColor4ub(142, 142, 26, a); // 黄色
//            break;
//            
//        case 5:
//            glColor4ub(26, 142, 26, a); // 緑
//            break;
//            
//        case 6:
//            glColor4ub(26, 142, 142, a); // 水色
//            break;
//            
//        case 7:
//            glColor4ub(31, 31, 165, a); // 青
//            break;
//            
//        case 8:
//            glColor4ub(165, 31, 165, a); // 紫
//            break;
//            
//        case 9:
//        default:
//            glColor4ub(85, 85, 85, a); // 灰色
//            break;
//    }
}

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
    if (self._vy < -SPEED_FALL_MAX) {
        self._vy = -SPEED_FALL_MAX;
    }
}

/**
 * 更新・落下完了
 */
- (void)_updateFallWait {
    
    if (m_ReqVanish) {
        
        // 消滅要求を処理
        m_State = eState_Vanish;
        m_Timer = TIMER_VANISH;
        
        if (m_bSpecial) {
            
            // スペシャルブロックはSEを変える
            Sound_PlaySe(@"ax.wav");
        }
        
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
    }
    else {
        
        [self setVisible:YES];
    }
    
    if (m_Timer < 1) {
        [self vanish];
        m_State = eState_End;
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
    
    m_tPast++;
    
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
    
    if (m_bSpecial) {
        
        // スペシャルブロックは光る
        int fix = 0x80;
        int var = 0x7F;
        int r = fix + Math_Rand(var);
        int g = fix + Math_Rand(var);
        int b = fix + Math_Rand(var);
        
        [self setColor:ccc3(r, g, b)];
    }
}

/**
 * 矩形描画
 */
- (void)visit {
    [super visit];
    
    if (self.visible == NO) {
        return;
    }
    
    System_SetBlend(eBlend_Normal);
    float s = BLOCK_SIZE / 2;
    
    glLineWidth(2);
    glColor4f(1, 1, 1, 1);
    [self drawRect:self._x cy:self._y w:s h:s rot:0 scale:1];
    
    if (m_State == eState_Slide) {
        
        // スライド操作中
        System_SetBlend(eBlend_Add);
        
        float cx = self._x;
        float cy = self._y;
        for (int i = 0; i < 3; i++) {
            int t  = (m_tPast+i*10)%30;
            int t2 = 30 - t;            
            
            glColor4f(1, 0, 0, t2/30.0);
            float size = (BLOCK_SIZE/2)+t/2;
            
            [self drawRect:cx cy:cy w:size h:size rot:0 scale:1];
            
        }
        
        System_SetBlend(eBlend_Normal);
    }
}

// 番号を設定する
- (void)setNumber:(int)number {
    m_nNumber = number;
    [self setTexRect:[self _getTexRect]];
    
}

// 番号を取得する
- (int)getNumber {
    
    if (m_bSpecial) {
        return SPECIAL_INDEX;
    }
    if (m_bSkull) {
        return SKULL_INDEX;
    }
    
    return m_nNumber;
}

// 固ぷよカウンタを設定
- (void)setShield:(int)v {
    
    m_nShield = v;
    
    [self setTexRect:[self _getTexRect]];
}

// 固ぷよカウンタを減らす
- (void)decShield {
    if (m_nShield > 0) {
        m_nShield--;
        
        // エフェクト生成
        [Particle addShieldBreak:self._x y:self._y];
    }
    
    [self setTexRect:[self _getTexRect]];
}

// 固ぷよカウンタが有効かどうか
- (BOOL)isShield {
    
    return m_nShield > 0;
}

// ドクロブロックにする
- (void)setSkull {
    
    m_bSkull = YES;
    [self setTexRect:[self _getTexRect]];
    
    // ドクロはダメージがでかい
    m_nNumber = 10;
}

// ドクロブロックかどうか
- (BOOL)isSkull {
    
    return m_bSkull;
}

/**
 * スペシャルブロックの設定をする
 */
- (void)setSpecial:(BOOL)b {
    m_bSpecial = b;
    
    if (b) {
        [self setTexRect:[self _getTexRect]];
    }
    
}

/**
 * スペシャルブロックかどうか
 */
- (BOOL)isSpecial {
    return m_bSpecial;
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

// 座標の設定
- (void)setPosFromChip:(int)chipX chipY:(int)chipY {
    
    self._x = GameCommon_ChipXToScreenX(chipX);
    self._y = GameCommon_ChipYToScreenY(chipY);
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

// プレイヤー操作可能状態にする
- (void)changeSlide {
    
    m_State = eState_Slide;
}

// 待機状態にする
- (void)changeStandby {
    
    m_State = eState_Standby;
}

// 落下待機待ちにする
- (void)changeFallWait {
    
    m_State = eState_FallWait;
}

// 数値のカウントダウンをする
- (void)countDown {
    
    if ([self isShield]) {
        
        // シールドがあればシールド破壊
        [self decShield];
        return;
    }
    
    if (m_nNumber > 1) {
        
        // 数値を減らす
        m_nNumber--;
        [self setNumber:m_nNumber];
    }
}

/**
 * プレイヤーがそのターンに置いたかどうかフラグを設定
 */
- (void)setPutPlayer:(BOOL)b {
    
    m_bPutPlayer = b;
}

/**
 * プレイヤーがそのターンに置いたかどうか
 */
- (BOOL)isPutPlayer {
    
    return m_bPutPlayer;
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

// ブロックを追加する (チップ座標指定)
+ (Block*)addFromChip:(int)number chipX:(int)chipX chipY:(int)chipY {
    
    float x = GameCommon_ChipXToScreenX(chipX);
    float y = GameCommon_ChipYToScreenY(chipY);
    
    return [Block add:number x:x y:y];
}
@end
