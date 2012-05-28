//
//  TokenManager.h
//  Test6
//
//  Created by OzekiSyunsuke on 12/03/21.
//  Copyright 2012年 2dgame.jp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "Token.h"

/**
 * トークン管理クラス
 */
@interface TokenManager : CCNode {
    NSString*       m_Name;     // 管理トークン名
    CCLayer*        m_Layer;    // トークン描画用レイヤー
    NSMutableArray* m_Pool;     // 管理オブジェクト配列
    NSInteger       m_Idx;      // 検索インデックス
    NSInteger       m_Size;     // 配列のサイズ
    NSInteger       m_Prio;     // 描画プライオリティ
}

@property (nonatomic,retain)NSMutableArray* m_Pool;

/**
 * 生成
 * @param layer     親レイヤー
 * @param size      トークンの数
 * @param className クラス名
 */
- (void)create:(CCLayer*)layer size:(NSInteger)size className:(NSString*)className;

/**
 * トークンの最大数を取得する
 * @return 最大数
 */
- (NSInteger)max;

/**
 * トークンの生存数を取得する
 * @return 生存数
 */
- (NSInteger)count;

/**
 * リーク数を取得する
 * @return リーク数
 */
- (NSInteger)leak;

/**
 * トークンの追加・取得
 * @return トークン
 */
- (Token*)add;

/**
 * トークンの取得 (Idx指定)
 * @param idx 配列のインデックス
 */
- (Token*)getFromIdx:(NSInteger)idx;

/**
 * トークンを全て登録する
 */
- (void)addAll;

/**
 * 描画プライオリティの設定
 */
- (void)setPrio:(NSInteger)Prio;

/**
 * スケジューラの更新を止める
 */
- (void)pauseAll;

/**
 * スケジューラの更新を再開する
 */
- (void)resumeAll;

/**
 * デバッグ表示
 */
- (void)echo;

@end
