//
//  Token.m
//  Test6
//
//  Created by OzekiSyunsuke on 12/03/21.
//  Copyright 2012年 2dgame.jp. All rights reserved.
//

#import "Token.h"
#import "Math.h"

// 塗りつぶしポリゴンの描画
void ccFillPoly( const CGPoint *poli, NSUInteger numberOfPoints, BOOL closePolygon )
{
	ccVertex2F newPoint[numberOfPoints];

	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states: GL_VERTEX_ARRAY, 
	// Unneeded states: GL_TEXTURE_2D, GL_TEXTURE_COORD_ARRAY, GL_COLOR_ARRAY	
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisableClientState(GL_COLOR_ARRAY);

	
	// iPhone and 32-bit machines
	if( sizeof(CGPoint) == sizeof(ccVertex2F) ) {

		// convert to pixels ?
		if( CC_CONTENT_SCALE_FACTOR() != 1 ) {
			memcpy( newPoint, poli, numberOfPoints * sizeof(ccVertex2F) );
			for( NSUInteger i=0; i<numberOfPoints;i++)
				newPoint[i] = (ccVertex2F) { poli[i].x * CC_CONTENT_SCALE_FACTOR(), poli[i].y * CC_CONTENT_SCALE_FACTOR() };

			glVertexPointer(2, GL_FLOAT, 0, newPoint);

		} else
			glVertexPointer(2, GL_FLOAT, 0, poli);

		
	} else {
		// 64-bit machines (Mac)
		
		for( NSUInteger i=0; i<numberOfPoints;i++)
			newPoint[i] = (ccVertex2F) { poli[i].x, poli[i].y };

		glVertexPointer(2, GL_FLOAT, 0, newPoint );

	}
		
	if( closePolygon )
		glDrawArrays(GL_TRIANGLE_STRIP, 0, (GLsizei) numberOfPoints);
	else
		glDrawArrays(GL_TRIANGLE_STRIP, 0, (GLsizei) numberOfPoints);
	
	// restore default state
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnable(GL_TEXTURE_2D);	
}

/**
 * トークン基底実装
 */
@implementation Token

@synthesize m_pSprite;
@synthesize _x;
@synthesize _y;
@synthesize _vx;
@synthesize _vy;
@synthesize _ax;
@synthesize _ay;
@synthesize _w;
@synthesize _h;
@synthesize _r;

/**
 * 生成
 */
-(id) init {
    self = [super init];
    if (self) {
        return self;
    }
    
    self.m_pSprite = nil;
    
    // TODO:
    self._w = 32;
    self._h = 32;
    self._r = 32;
    
    m_Prio = 0;
    
    [self setHitEnabled:YES];
    
    return self;
}

/**
 * 破棄
 */
-(void) dealloc {
    
    [self vanish];
    
    self.m_pSprite = nil;
    
    [super dealloc];
}

/**
 * レイヤーにアタッチする
 */
- (void)attachLayer:(CCLayer*)layer {
    
    // 特に何もしない（オーバーライド用）
}

/**
 * 初期化
 */
- (void)initialize {
    
    // 変数初期化
    m_isExist = NO;
    
    // 表示する
    [self setVisible:YES];
    
    // 色初期化
    [self setColor:ccWHITE];
    
    // α値初期化
    [self setAlpha:0xFF];
    
    // ブレンドモード初期化
    [self setBlend:eBlend_Normal];
    
    // 当たり判定有効
    [self setHitEnabled:YES];
}

/**
 * 表示開始
 */
- (void)create {
    
    // 存在フラグを立てる
    [self setExist:YES];
    
    // スケジューラーに登録
    [self scheduleUpdate];
    
    // 生成フラグを立てる
    m_isCreate = YES;
    
    // 当たり判定有効
    [self setHitEnabled:YES];
}

/**
 * 座標・移動量の設定
 */
- (void)set:(float)x y:(float)y vx:(float)vx vy:(float)vy ax:(float)ax ay:(float)ay {
    
    self._x  = x;  self._y  = y;
    self._vx = vx; self._vy = vy;
    self._ax = ax; self._ay = ay;
    
    [self move:0];
}

- (void)set2:(float)x y:(float)y rot:(float)rot speed:(float)speed ax:(float)ax ay:(float)ay {
    
    float vx = Math_CosEx(rot) * speed;
    float vy = Math_SinEx(rot) * speed;
    
    [self set:x y:y vx:vx vy:vy ax:ax ay:ay];
}

/**
 * サイズを設定する
 */
- (void)setSize:(float)w h:(float)h {
    self._w = w;
    self._h = h;
}
- (void)setSize2:(float)r {
    self._r = r;
}

// 描画プライオリティの設定
- (void)setPrio:(int)prio {
    m_Prio = prio;
}

// 描画プライオリティの取得
- (int)getPrio {
    return m_Prio;
}

/**
 * 画面外に出たかどうか
 */
- (BOOL)isOut {
    CGSize win = [CCDirector sharedDirector].winSize;
    
    if (self._x < 0) { return YES; }
    if (self._x > win.width) { return YES; }
    if (self._y < 0) { return YES; }
    if (self._y > win.height) { return YES; }
    
    return NO;
}

// 画面外に出たかどうか (X方向)
- (BOOL)isOutRectX:(float)w {
    CGSize win = [CCDirector sharedDirector].winSize;
    
    if (self._x < -w) {
        return YES;
    }
    if (self._x > win.width+w) {
        return YES;
    }
    
    return NO;
}

// 画面外に出たかどうか (Y方向)
- (BOOL)isOutRectY:(float)h {
    CGSize win = [CCDirector sharedDirector].winSize;
    
    if (self._y < -h) {
        return YES;
    }
    if (self._y > win.height+h) {
        return YES;
    }
    
    return NO;
}

/**
 * 画面外に出たかどうか（矩形）
 */
- (BOOL)isOutRect:(float)w h:(float)h {
    CGSize win = [CCDirector sharedDirector].winSize;
    
    if (self._x < -w) { return YES; }
    if (self._x > win.width+w) { return YES; }
    if (self._y < -h) { return YES; }
    if (self._y > win.height+h) { return YES; }
    
    return NO;
    
}

/**
 * 画面外に出たかどうか（円）
 */
- (BOOL)isOutCircle:(float)r {
    CGSize win = [CCDirector sharedDirector].winSize;
    
    if (self._x < -r) { return YES; }
    if (self._x > win.width+r) { return YES; }
    if (self._y < -r) { return YES; }
    if (self._y > win.height+r) { return YES; }
    
    return NO;
    
}

/**
 * 画面外の跳ね返りチェック（矩形）
 */
- (BOOL)isBoundRect:(float)w h:(float)h {
    CGSize win = [CCDirector sharedDirector].winSize;
    
    BOOL ret = NO;
    if (self._x < w)
    {
        self._x = w;
        ret = YES;
    }
    if (self._x > win.width - w)
    {
        self._x = win.width - w;
        ret = YES;
    }
    if (self._y < h)
    {
        self._y = h;
        ret = YES;
    }
    if (self._y > win.height - h)
    {
        self._y = win.height - h;
        ret = YES;
    }
    
    return ret;
}

/**
 * 画面外の跳ね返りチェック（矩形）
 */
- (BOOL)isBoundRectX:(float)w {
    CGSize win = [CCDirector sharedDirector].winSize;
    
    if (self._x < w)
    {
        // 押し出し処理を入れる
        self._x = w;
        return YES;
    }
    
    if (self._x > win.width - w)
    {
        // 押し出し処理を入れる
        self._x = win.width - w;
        return YES;
    }
    
    return NO;
    
}

/**
 * 画面外の跳ね返りチェック（矩形）
 */
- (BOOL)isBoundRectY:(float)h {
    CGSize win = [CCDirector sharedDirector].winSize;
    
    if (self._y < h)
    {
        // 押し出し処理を入れる
        self._y = h;
        return YES;
    }
    
    if (self._y > win.height - h)
    {
        // 押し出し処理を入れる
        self._y = win.height - h;
        return YES;
    }
    
    return NO;
    
}


/**
 * 画面外の跳ね返りチェック（円）
 */
- (BOOL)isBoundCircle:(float)r {
    CGSize win = [CCDirector sharedDirector].winSize;
    
    if (self._x < r) { return YES; }
    if (self._x > win.width-r) { return YES; }
    if (self._y < r) { return YES; }
    if (self._y > win.height-r) { return YES; }
    
    return NO;
    
}

/**
 * 当たり判定チェック
 */
- (BOOL)isHit2:(Token*)t {
    
    if (m_isHit == NO) {
        
        // 当たり判定無効
        return NO;
    }
    
    if ([t isHitEnabled] == NO) {
        
        // 当たり判定無効
        return NO;
    }
    
    // 円の当たり判定を行う
    float dx = t._x - self._x;
    float dy = t._y - self._y;
    
    float len = (dx * dx) + (dy * dy);
    float len2 = (t._r + self._r) * (t._r + self._r);
    
    if (len < len2) {
        return YES;
    }
    return NO;
}

/**
 * 移動する
 */
- (void)move:(float)dt {
    self._vx += self._ax;
    self._vy += self._ay;
    self._x  += self._vx * dt;
    self._y  += self._vy * dt;
    
    self.position = ccp(self._x, self._y);
}

/**
 * 要素番号の設定
 */
- (void)setIndex:(NSInteger)index {
    
    m_Index = index;
}

/**
 * 要素番号の取得
 */
- (NSInteger)getIndex {
    
    return m_Index;
}

/**
 * テクスチャをロードしてスプライトを生成
 */
- (void)load:(NSString *)filename {
    
    CCTexture2D* pTex = [[CCTextureCache sharedTextureCache] addImage:filename];
    self.m_pSprite = [CCSprite spriteWithTexture:pTex];
//    self.m_pSprite = [CCSprite spriteWithFile:filename];
    [self addChild:self.m_pSprite];
}
- (void)load2:(NSString*)filename bLinear:(BOOL)bLinear {
    CCTexture2D* pTex = [[CCTextureCache sharedTextureCache] addImage:filename];
    if (bLinear == NO) {
        ccTexParams params = {
            GL_NEAREST,
            GL_NEAREST,
            GL_CLAMP_TO_EDGE,
            GL_CLAMP_TO_EDGE,
        };
        [pTex setTexParameters:&params];
    }
    self.m_pSprite = [CCSprite spriteWithTexture:pTex];
    [self addChild:self.m_pSprite];
    
}

/**
 * 存在するかどうか
 */
- (BOOL)isExist {
    return m_isExist;
}

/**
 * 存在フラグを設定
 */
- (void)setExist:(BOOL)b {
    m_isExist = b;
}

/**
 * 消滅処理 
 */
- (void)vanish {
    
    if (m_isCreate) {
        
        // スケジューラから破棄
        [self removeFromParentAndCleanup:YES];
        
        // 存在フラグを下げる
        [self setExist:NO];
        
        m_isCreate = NO;
    }    
}

/**
 * 色を設定する
 */
- (void)setColor:(ccColor3B) color {
    
    self.m_pSprite.color = color;
}

/**
 * α値を設定する (0〜255)
 */
- (void)setAlpha:(int) alpha {
    
    self.m_pSprite.opacity = alpha;    
}

/**
 * α値を設定する (0〜255)
 */
- (int)getAlpha {
    return self.m_pSprite.opacity;
}

/**
 * ブレンドモードを設定する
 */
- (void)setBlend:(eBlend) mode {
    
    switch (mode) {
        case eBlend_Normal:
            // 通常合成 (透過・α付き)
        {
            self.m_pSprite.blendFunc = (ccBlendFunc) {CC_BLEND_SRC, CC_BLEND_DST};
        }
            break;
                        
        case eBlend_Add:
            // 加算合成
        {
            self.m_pSprite.blendFunc = (ccBlendFunc){GL_SRC_ALPHA, GL_ONE};
        }
            break;
            
        case eBlend_Sub:
            // 減算合成
            NSLog(@"Warning: 'eBlend_Sub' Not implement.");
            break;
            
        case eBlend_Mul:     // 乗算合成
        {
            self.m_pSprite.blendFunc = (ccBlendFunc){GL_ZERO, GL_SRC_COLOR};
        }
            break;
            
        case eBlend_Reverse: // 反転合成
        {
            self.m_pSprite.blendFunc = (ccBlendFunc){GL_ONE_MINUS_DST_COLOR, GL_ZERO};
        }
            break;
            
        case eBlend_Screen:  // スクリーン合成
        {
            self.m_pSprite.blendFunc = (ccBlendFunc){GL_ONE_MINUS_DST_COLOR, GL_ONE};
        }
            break;
            
        case eBlend_XOR:     // 排他的論理和
        {
            self.m_pSprite.blendFunc = (ccBlendFunc){GL_ONE_MINUS_DST_COLOR, GL_ONE_MINUS_SRC_COLOR};
        }
            break;
            
        default:
            break;
    }
}

// テクスチャ描画範囲を指定する
- (void)setTexRect:(CGRect) rect {
    
    [self.m_pSprite setTextureRect:rect];
}

// 当たり判定を有効にするかどうか
- (void)setHitEnabled:(BOOL)b {
    
    m_isHit = b;
}

// 当たり判定が有効かどうか
- (BOOL)isHitEnabled {
    
    return m_isHit;
}

// 矩形の描画
- (void)drawRect:(float)cx cy:(float)cy w:(float)w h:(float)h rot:(float) rot scale:(float)scale {
    
    // TODO: 回転は未実装
    float width  = w * scale;
    float height = h * scale;
    float x1 = cx - width;
    float y1 = cy - height;
    float x2 = cx + width;
    float y2 = cy + height;
    CGPoint vertices[] = {
        {x1, y1 },
        {x2, y1 },
        {x2, y2 },
        {x1, y2 },
    };
    
    ccDrawPoly(vertices, 4, YES);
    
}

- (void)fillRect:(float)cx cy:(float)cy w:(float)w h:(float)h rot:(float)rot scale:(float)scale {
    
    // TODO: 回転は未実装
    float width  = w * scale;
    float height = h * scale;
    float x1 = cx - width;
    float y1 = cy - height;
    float x2 = cx + width;
    float y2 = cy + height;
    CGPoint vertices[] = {
        {x1, y1 },
        {x2, y1 },
        {x1, y2 },
        {x2, y2 },
    };
    
    ccFillPoly(vertices, 4, YES);
}

- (void)drawRectLT:(float)x y:(float)y w:(float)w h:(float)h rot:(float)rot scale:(float)scale {
    
    float width = w / 2;
    float height = h / 2;
    float cx = x + width;
    float cy = y + height;
    
    [self drawRect:cx cy:cy w:width h:height rot:rot scale:scale];
}

- (void)fillRectLT:(float)x y:(float)y w:(float)w h:(float)h rot:(float)rot scale:(float)scale {
    
    float width = w / 2;
    float height = h / 2;
    float cx = x + width;
    float cy = y + height;
    
    [self fillRect:cx cy:cy w:width h:height rot:rot scale:scale];
}

// 円の描画
- (void)drawCircle:(float)cx cy:(float)cy radius:(float)radius {
    ccDrawCircle(CGPointMake(cx, cy), radius, 0, 20, NO);
}

// 三角形の描画
- (void)fillTriangle:(float)cx cy:(float)cy radius:(float)radius rot:(float)rot scale:(float)scale {
    
    // iPhoneの座標系はYが逆
    rot += 180;
    
    float r = radius * scale;
    
    float x1 = cx + Math_CosEx(rot + 90) * r;
    float y1 = cy - Math_SinEx(rot + 90) * r;
    float x2 = cx + Math_CosEx(rot + 210) * r;
    float y2 = cy - Math_SinEx(rot + 210) * r;
    float x3 = cx + Math_CosEx(rot + 330) * r;
    float y3 = cy - Math_SinEx(rot + 330) * r;
    
    CGPoint vertices[] = {
        {x1, y1 },
        {x2, y2 },
        {x3, y3 },
    };
    
    ccFillPoly(vertices, 3, YES);
}

- (void)fillTriangleEx:(float)x1 y1:(float)y1 x2:(float)x2 y2:(float)y2 x3:(float)x3 y3:(float)y3 {
    
    CGPoint vertices[] = {
        {x1, y1},
        {x2, y2},
        {x3, y3},
    };
    
    ccFillPoly(vertices, 3, YES);
}

- (void)visit {
    [super visit];
    
    if (System_IsDispCollision()) {
        
        glLineWidth(1);
        CGPoint center = CGPointMake(self._x, self._y);
        glColor4f(1, 0, 0, 1);
        ccDrawCircle(center, self._r, 0, 20, NO);
    }
    
}

// ■コールバック関数定義
- (void)cbTouchStart:(float)x y:(float)y {
}
- (void)cbTouchMove:(float)x y:(float)y {
}
- (void)cbTouchEnd:(float)x y:(float)y {
}
- (void)cbTouchCancel:(float)x y:(float)y {
}

@end
