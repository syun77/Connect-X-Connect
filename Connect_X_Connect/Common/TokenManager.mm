//
//  TokenManager.m
//  Test6
//
//  Created by OzekiSyunsuke on 12/03/21.
//  Copyright 2012年 2dgame.jp. All rights reserved.
//

#import "TokenManager.h"

@implementation TokenManager

@synthesize m_Pool;

/**
 * 生成
 * @param layer     親レイヤー
 * @param size      トークンの数
 * @param className クラス名
 */
- (void)create:(CCLayer *)layer size:(NSInteger)size className:(NSString *)className {
    
    if (self.m_Pool) {
        
        // 生成済み
        assert(0);
    }
    
    // 配列を確保
    self.m_Pool = [NSMutableArray arrayWithCapacity:size];
    
    // トークンのインスタンスを生成
    for (int i = 0; i < size; i++) {
        
        Token* token = [NSClassFromString(className) node];
        if (token == nil) {
            
            // クラス名が違うとか未実装とかでエラー
            NSLog(@"Error: %@ is nil.", className);
            assert(0);
        }
        
        // レイヤーの登録
        [token attachLayer:layer];
        
        // 要素番号の設定
        [token setIndex:i];
        
        // 配列に追加
        [self.m_Pool addObject:token];
    }
    
    // 初期化・設定
    m_Name  = className;
    m_Idx   = 0;
    m_Size  = size;
    m_Layer = layer;
    m_Prio  = 0;
    
//    NSLog(@"TokenManager::Create '%@'", m_Name);
}

/**
 * トークンの最大数を取得する
 * @return 最大数
 */
- (NSInteger)max {
    return m_Size;
}

/**
 * トークンの生存数を取得する
 * @return 生存数
 */
- (NSInteger)count {
    NSInteger ret = 0;
    
    for (Token* t in self.m_Pool) {
        if ([t isExist]) {
            ret++;
        }
    }
    
    return ret;
}

/**
 * リーク数を取得する
 * @return リーク数
 */
- (NSInteger)leak {
    NSInteger ret = 0;
    
    for (Token* t in self.m_Pool) {
        if ([t isExist] == NO && t.parent != nil) {
            ret++;
        }
    }
             
    return ret;
}

/**
 * デストラクタ
 */
- (void)dealloc {
    self.m_Pool = nil;
    
    [super dealloc];
    
//    NSLog(@"TokenManager::Dealloc '%@'", m_Name);
}

/**
 * トークンの追加
 * @return トークン（追加出来なかったときは nil)
 */
- (Token*)add {
    
    for (int i = 0; i < m_Size; i++) {
        
        Token* ret = [self.m_Pool objectAtIndex:m_Idx];
        m_Idx = (m_Idx + 1) % m_Size;
        if ([ret isExist] == NO && [ret parent] == nil) {
            
            // 空きが見つかったので生成
            [m_Layer addChild:ret z:m_Prio];
            
            // 初期化
            [ret initialize];
            
            // 表示開始
            [ret create];
            
            return ret;
        }
        
    }
    
    return nil;
}

/**
 * トークンの追加・取得 (Idx指定)
 * @param idx 配列のインデックス
 */
- (Token*)getFromIdx:(NSInteger)idx {
    
    if (idx < 0 || m_Size <= idx) {
        return nil;
    }
    
    return [self.m_Pool objectAtIndex:idx];
}

/**
 * トークンを全て登録する
 */
- (void)addAll {
    
    for (int i = 0; i < m_Size; i++) {
        Token* t = [self.m_Pool objectAtIndex:i];
        
        // レイヤーに登録
        [m_Layer addChild:t z:m_Prio];
        
        // 初期化
        [t initialize];
        
        // 表示
        [t create];
    }
}

/**
 * トークンを全て削除する
 */
- (void)vanishAll {
    
    for (Token* t in self.m_Pool) {
        
        if ([t isExist] == NO) {
            
            // 消滅済み
            continue;
        }
        
        // 消滅
        [t vanish];
    }
}

/**
 * 描画プライオリティの設定
 */
- (void)setPrio:(NSInteger)Prio {
    
    m_Prio = Prio;
    
    for (Token* t in self.m_Pool) {
        
        [t setPrio:Prio];
    }
}

/**
 * スケジューラの更新を止める
 */
- (void)pauseAll {
    for (Token* t in self.m_Pool) {
        [t pauseSchedulerAndActions];
    } 
}

/**
 * スケジューラの更新を再開する
 */
- (void)resumeAll {
    for (Token* t in self.m_Pool) {
        [t resumeSchedulerAndActions];
    }
}

/**
 * デバッグ表示
 */
- (void)echo {
    NSLog(@"Hello.");
}

@end
