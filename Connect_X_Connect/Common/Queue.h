//
//  Queue.h
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/06/09.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

// キューのサイズ
static const int QUEUE_SIZE = 8;

// 無効な要素
static const int QUEUE_INVALID = 0;

/**
 * 簡易的なキューの実装 (固定長)
 */
struct SimpleQueue
{
    int m_Pool[QUEUE_SIZE];
    int m_Ptr;
    
    /**
     * コンストラクタ
     */
    SimpleQueue()
    {
        clear(); 
    }
    
    /**
     * 初期化
     */
    void clear()
    {
        memset(m_Pool, QUEUE_INVALID, sizeof(SimpleQueue));
        m_Ptr = -1;
    }
    
    /**
     * キューに積んだ要素の数
     * @return 要素の数
     */
    int count()
    {
        return m_Ptr + 1;
    }
    
    /**
     * 末尾に要素を追加
     * @param v 追加する要素
     */
    void push(int v)
    {
        if (m_Ptr >= QUEUE_SIZE - 1) {
            
            // サイズオーバー
            assert(0);
            return;
        }
        
        m_Ptr++;
        m_Pool[m_Ptr] = v;
    }
    
    /**
     * 先頭にある要素を取得・削除
     */
    int pop()
    {
        if (m_Ptr < 0) {
            
            // 要素がない
            assert(0);
            return QUEUE_INVALID;
        }
        int ret = m_Pool[0];
        
        // 前詰めする
        for (int i = 0; i < m_Ptr; i++) {
            m_Pool[i] = m_Pool[i + 1];
        }
        m_Pool[m_Ptr] = QUEUE_INVALID;
        m_Ptr--;
        
        return ret;
    }
    
    /**
     * 要素番号を指定して直接取得
     * @param idx 要素番号
     * @return 値
     */
    int getFromIndex(int idx)
    {
        if (idx < 0 || QUEUE_SIZE <= idx) {
            
            NSLog(@"Warning: SimpleQueue::getFromIndex() Invalid Index = %d", idx);
            return QUEUE_INVALID;
        }
        
        return m_Pool[idx];
    }
    
    void dump()
    {
        fprintf(stdout, "[SimpleQueue]\n");
        fprintf(stdout, "  Ptr = %d\n", m_Ptr);
        fprintf(stdout, "  Val = ");
        
        for (int i = 0; i < QUEUE_SIZE; i++) {
            fprintf(stdout, "%d,", m_Pool[i]);
        }
        fprintf(stdout, "\n");
    }
};