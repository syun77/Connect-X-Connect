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
 * 簡易的なキューの実装
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
        memset(m_Pool, 0, sizeof(SimpleQueue));
        m_Ptr = -1;
    }
    
    void push(int v)
    {
        if (m_Ptr >= QUEUE_SIZE) {
            assert(0);
        }
        
        m_Ptr++;
        m_Pool[m_Ptr] = v;
    }
    int pop()
    {
        if (m_Ptr < 0) {
            assert(0);
        }
        int ret = m_Pool[0];
    }
};