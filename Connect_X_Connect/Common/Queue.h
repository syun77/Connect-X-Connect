//
//  Queue.h
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/06/09.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

static const int QUEUE_SIZE = 8;

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
        memset(m_Pool, 0, sizeof(SimpleQueue));
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
            assert(0);
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
            assert(0);
        }
        int ret = m_Pool[0];
        
        for (int i = 0; i < m_Ptr; i++) {
            m_Pool[i] = m_Pool[i + 1];
        }
        m_Pool[m_Ptr] = 0;
        m_Ptr--;
        
        return ret;
    }
    
    void dump()
    {
        fprintf(stdout, "[SimpleQueue]¥n");
        fprintf(stdout, "  Ptr = %d¥n", m_Ptr);
        fprintf(stdout, "  Val = ");
        
        for (int i = 0; i < QUEUE_SIZE; i++) {
            fprintf(stdout, "%d,", m_Pool[i]);
        }
        fprintf(stdout, "¥n");
    }
};