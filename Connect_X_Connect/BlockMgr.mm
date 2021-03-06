//
//  BlockMgr.mm
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/05/30.
//  Copyright 2012年 2dgame.jp. All rights reserved.
//

#import "BlockMgr.h"

#import "SceneMain.h"


/**
 * ブロック管理クラス実装
 */
@implementation BlockMgr

+ (TokenManager*)_getTokenManager {
    
    return [SceneMain sharedInstance].mgrBlock;
}

// 落下要求を送る
+ (void)requestFall {
    
    TokenManager* mgr = [BlockMgr _getTokenManager];
    
    for (Block* b in mgr.m_Pool) {
        
        if ([b isExist] == NO) {
            continue;
        }
        
        // 落下要求を送る
        [b requestFall];
    }
}

// 落下が全て完了したかどうか
+ (BOOL)isFallWaitAll {
    
    TokenManager* mgr = [BlockMgr _getTokenManager];
    
    for (Block* b in mgr.m_Pool) {
        
        if ([b isExist] == NO) {
            
            // 存在しないのでチェック不要
            continue;
        }
        
        if ([b isFallWait]) {
            
            // 落下待ちになっている
            continue;
        }
        
        // 落下待ちになっていない
        return NO;
    }
    
    // 全て落下待ちになった
    return YES; 
}

// ブロックの当たり判定をチェックする
+ (BOOL)checkHitBlock:(Block*)block {
    
    TokenManager* mgr = [BlockMgr _getTokenManager];
    
    for (Block* b in mgr.m_Pool) {
        
        if ([b isExist] == NO) {
            continue;
        }
        
        if ([b getIndex] == [block getIndex]) {
            
            // 同じブロック
            continue;
        }
        
        if (block._y < b._y) {
            
            // 下にいたら判定不要
            continue;
        }
        
        int x1 = b._x;
        int x2 = block._x;
        int y1 = block._y - block._r;   // 下を見る
        int y2 = b._y + b._r;           // 上を見る
        int y3 = block._y + block._r;   // 上を見る
        int y4 = b._y - b._r;           // 下を見る

        if (x1 == x2 && y1 <= y2 && y3 >= y4) {
            
            // 当たった
            block._vy = 0;
            block._y = y2 + block._r;
            
            if ([b isFallWait]) {
                
                // 停止する
                return YES;
            }
            
            // 止まるだけ
            break;;
        }
    }
    
    // 当たっていない
    return NO;
}

// 指定の座標にあるブロックに消去要求を送る
+ (void)requestVanish:(int)x y:(int)y {
    
    TokenManager* mgr = [BlockMgr _getTokenManager];
    
    for (Block* b in mgr.m_Pool) {
        
        if ([b isExist] == NO) {
            
            // 存在しないのでチェックしない
            continue;
        }
        
        int px = [b getChipX];
        int py = [b getChipY];
        
        if (px == x && py == y) {
            
            // 消去要求を送る
            [b requestVanish];
            
            break;
        }
    }
}

// 消滅処理が全て完了したかどうか
+ (BOOL)isEndVanishingAll {
    
    TokenManager* mgr = [BlockMgr _getTokenManager];
    
    for (Block* b in mgr.m_Pool) {
        
        if ([b isExist] == NO) {
            
            // 存在しないのでチェック不要
            continue;
        }
        
        if ([b isVanishing]) {
            
            // 消滅演出中のものがある
            return NO;
        }
        
    }
    
    // 消滅演出完了
    return YES; 
 
}

// 待機状態にする
+ (void)changeStandbyAll {
    
    TokenManager* mgr = [BlockMgr _getTokenManager];
    
    for (Block* b in mgr.m_Pool) {
        
        if ([b isExist] == NO) {
            
            continue;
        }
        
        // 待機状態にする
        [b changeStandby];
    }
}

// 全て落下後の待機状態にする
+ (void)changeFallWaitAll {
    
    TokenManager* mgr = [BlockMgr _getTokenManager];
    
    for (Block* b in mgr.m_Pool) {
        
        if ([b isExist] == NO) {
            
            continue;
        }
        
        // 落下待機状態にする
        [b changeFallWait];
    }
}

/**
 * カウントダウン要求を送る
 */
+ (void)countDonwBlock:(Block*)block {
    
    TokenManager* mgr = [BlockMgr _getTokenManager];
    
    for (Block* b in mgr.m_Pool) {
        
        if ([b isExist] == NO) {
            
            continue;
        }
        
        if ([b getNumber] != [block getNumber]) {
            
            // 番号が違う
            continue;
        }
        
        if ([b getIndex] == [block getIndex]) {
            
            // 自分自身
            continue;
        }
        
        if ([b getChipY] < FIELD_BLOCK_COUNT_Y-1) {
            
            // 領域内
            // カウントダウンさせる
//            [b countDown];
            BezierEffect* eft = [BezierEffect add:block._x y:block._y];
            if (eft) {
                [eft setParamCountDown:[b getIndex] frame:BEZIEREFFECT_FRAME];
            }
        }
    }
}

/**
 * フィールド外にあるブロックを削除する
 * @return 削除した数
 */
+ (int)vanishOutOfField {
    
    int ret = 0;
    TokenManager* mgr = [BlockMgr _getTokenManager];
    
    for (Block* b in mgr.m_Pool) {
        
        if ([b isExist] == NO) {
            
            continue;
        }
        
        if ([b getChipY] >= FIELD_BLOCK_COUNT_Y-1) {
            
            // 領域外
            if (NO) {
                
                // 他のブロックをカウントダウンさせる
                [BlockMgr countDonwBlock:b];
            }
            
            if ([b isPutPlayer]) {
                
                // プレイヤーがそのターンに置いたブロックは除外
                // 下にあるブロックを消す
                int px = [b getChipX];
                int py = [b getChipY] - 1;
                
                [BlockMgr requestVanish:px y:py];
                
                Sound_PlaySe(@"vanish03.wav");
                
                // スペシャル要求を発行
                MainCtrl* ctrl = [SceneMain sharedInstance].ctrl;
                [ctrl requestSpecial];
            }
            else {
        
                // ダメージ処理を行う
                int chipX = [b getChipX];
                int chipY = [b getChipY];
                int frame  = BEZIEREFFECT_FRAME + Math_RandInt(-10, 10);
    //            int damage = [b getNumber] * 3;
                int damage = 30;
                BezierEffect* eft = [BezierEffect addFromChip:chipX chipY:chipY];
                if (eft) {
                    
                    // エフェクト生成
                    [eft setParamDamage:eBezierEffect_Player frame:frame damage:damage];
                }
                
                // ダメージブロック数をカウントアップ
                ret++;
            }
            
            [b requestVanish];
        }
        else {
            
            // プレイヤーが置いたフラグを下げておく
            [b setPutPlayer:NO];
        }
    }
    
    return ret;
}

// チップ座標を指定してブロックを取得する
+ (Block*)getFromChip:(int)chipX chipY:(int)chipY {
    
    TokenManager* mgr = [BlockMgr _getTokenManager];
    
    for (Block* b in mgr.m_Pool) {
        
        if ([b isExist] == NO) {
            
            continue;
        }
        
        if ([b getChipX] == chipX && [b getChipY] == chipY) {
            
            // 見つかった
            return b;
        }
    }
    
    // 該当のブロックはなし
    return nil;
}

// インデックス指定でブロック取得
+ (Block*)getFromIndex:(int)index {
    
    TokenManager* mgr = [BlockMgr _getTokenManager];
    
    for (Block* b in mgr.m_Pool) {
        
        if ([b isExist] == NO) {
            
            continue;
        }
        
        if ([b getIndex] == index) {
            
            // 見つかった
            return b;
        }
    }
    
    // 該当のブロックなし
    return nil;
}

// 全てのブロックを上に移動する
+ (void)shiftUpAll:(int)dy {
    
    TokenManager* mgr = [BlockMgr _getTokenManager];
    
    for (Block* b in mgr.m_Pool) {
        
        if ([b isExist] == NO) {
            
            continue;
        }
        
        // 座標を移動させる
        b._y += dy;
    }
}

// 存在するブロックの数を取得する
+ (int)count {
    
    TokenManager* mgr = [BlockMgr _getTokenManager];
    
    return [mgr count];
}

@end
