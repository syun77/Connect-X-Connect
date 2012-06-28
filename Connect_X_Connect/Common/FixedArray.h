//
//  FixedArray.h
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/06/12.
//  Copyright 2012年 2dgames.jp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "Math.h"

static const int FIXED_ARRAY_SIZE = 16;

/**
 * ソート比較関数
 */
inline int cmp_int_sort(const void* a, const void* b) {
    if (*(int*)a < *(int*)b) {
        return -1;
    }
    else if(*(int*)a == *(int*)b) {
        return 0;
    }
    return 1;
}

/**
 * 固定長の配列
 */
struct FixedArray {
    
    int m_Pool[FIXED_ARRAY_SIZE];
    int m_Ptr;
    
    /**
     * コンストラクタ
     */
    FixedArray()
    {
        clear();
    }
    
    /**
     * 値をクリア
     */
    void clear()
    {
        
        memset(m_Pool, 0, sizeof(m_Pool));
        m_Ptr = -1;
    }
    
    /**
     * 有効な要素数を取得
     */
    int count()
    {
        return m_Ptr + 1;
    }
    
    /**
     * 末尾に要素を追加する
     */
    void push(int v)
    {
        if (m_Ptr >= FIXED_ARRAY_SIZE - 1) {
            
            // 要素数オーバー
            assert(0);
            return;
        }
        
        m_Ptr++;
        
        m_Pool[m_Ptr] = v;
    }
    
    /**
     * 値の取得
     */
    int get(int i)
    {
        if (i < 0 || i > m_Ptr) {
            
            // 未設定・領域外アクセス
            assert(0);
            return 0;
        }
        
        return m_Pool[i];
    }
    
    /**
     * 値をシャッフルする
     */
    void shuffle()
    {
        for (int i = 0; i < count(); i++) {
            int tmp = get(i);
            int idx = Math_Rand(count());
            m_Pool[i] = m_Pool[idx];
            m_Pool[idx] = tmp;
        }
    }
    
    /**
     * ソートする
     */
    void sort()
    {
        qsort(m_Pool, m_Ptr, sizeof(int), cmp_int_sort);
    }
    
    void dump()
    {
        fprintf(stdout, "[FixedArray]\n");
        fprintf(stdout, "  Ptr=%d\n  [", m_Ptr);
        for (int i = 0; i < count(); i++) {
            
            int v = get(i);
            fprintf(stdout, "%d,", v);
        }
        fprintf(stdout, "]\n");
    }
    
    
};