//
//  System.mm
//  Test7
//
//  Created by OzekiSyunsuke on 12/04/08.
//  Copyright 2012年 2dgames.jp. All rights reserved.
//

#import "System.h"

#include <sys/sysctl.h>
#import <mach/mach.h>
#import <mach/mach_host.h>
#import "Math.h"

/**
 * システムの初期化を行う
 */
void System_Init()
{
    
    // 数学関連の初期化
    Math_Init();
}

/**
 * Retinaディスプレイかどうか
 */
BOOL System_IsRetina()
{
    return NO;
}

/**
 * ウィンドウサイズを取得する
 */
CGSize System_Size()
{
    return  [CCDirector sharedDirector].winSize;
}

/**
 * ウィンドウの幅を取得する
 */
float System_Width()
{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    return winSize.width;
}

/**
 * ウィンドウの高さを取得する
 */
float System_Height()
{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    return winSize.height;
}

/**
 * 中心座標(X)を取得する
 */
float System_CenterX()
{
    return System_Width() * 0.5f;
}

/**
 * 中心座標(Y)を取得する
 */
float System_CenterY()
{
    return System_Height() * 0.5f;
}

/**
 * 当たり判定を描画するかどうか
 */
bool System_IsDispCollision()
{
//    return YES;
    return NO;
}

// ブレンドモードの設定
void System_SetBlend(eBlend mode) {
    
    // 減算合成したらこれで初期化が必要
    glBlendEquationOES(GL_FUNC_ADD_OES);
    
    switch (mode) {
        case eBlend_Normal:
            glBlendFunc(CC_BLEND_SRC, CC_BLEND_DST);
            break;
            
        case eBlend_Add:
            glBlendFunc(GL_SRC_ALPHA, GL_ONE);
            break;
            
        case eBlend_Sub:
            glBlendEquationOES(GL_FUNC_REVERSE_SUBTRACT_OES);
            glBlendFunc(GL_SRC_ALPHA, GL_ONE);
            break;
            
        case eBlend_Mul:
            glBlendFunc(GL_ZERO, GL_SRC_COLOR);
            break;
            
        case eBlend_XOR:
            glBlendFunc(GL_ONE_MINUS_DST_COLOR, GL_ZERO);
            break;
            
        case eBlend_Screen:
            glBlendFunc(GL_ONE_MINUS_DST_COLOR, GL_ONE);
            break;
            
        case eBlend_Reverse:
            glBlendFunc(GL_ONE_MINUS_DST_COLOR, GL_ONE_MINUS_SRC_COLOR);
            break;
            
        default:
            break;
    }
}

/**
 * メモリ残量を取得する
 * @return メモリ残量 (Byte単位)
 */
float System_GetAvailableBytes()
{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount=HOST_VM_INFO_COUNT;
    kern_return_t kernReturn=host_statistics(mach_host_self(),HOST_VM_INFO,(host_info_t)&vmStats,&infoCount);

    if(kernReturn!=KERN_SUCCESS)
    {
        return NSNotFound;
    }

    return(vm_page_size *vmStats.free_count);
}


