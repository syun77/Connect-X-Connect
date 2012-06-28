//
//  ReqBlock.h
//  Connect_X_Connect
//
//  Created by OzekiSyunsuke on 12/06/10.
//  Copyright (c) 2012年 2dgames.jp. All rights reserved.
//

#ifndef Connect_X_Connect_ReqBlock_h
#define Connect_X_Connect_ReqBlock_h


enum eReqBlock {
    eReqBlock_None,     // 要求無し
    eReqBlock_Upper,    // 上から出現
    eReqBlock_Bottom,   // 下から出現
};

/**
 * 出現要求のパラメータ
 */
struct ReqBlock {
    
    eReqBlock   type;       // 種別
    int         count;      // 出現数
    int         nShield;    // シールドの数
    float       rSkull;     // ドクロの出現率 (0〜1.0)
    int         nLine;      // 上昇するライン数 (下からの時のみ有効)
    
    /**
     * コンストラクタ
     */
    ReqBlock()
    {
        clear();
    }
    
    /**
     * 初期化
     */
    void clear()
    {
        type    = eReqBlock_None;
        count   = 0;
        nShield = 0;
        rSkull  = 0.0;
        nLine   = 0;
    }
    
    /**
     * 要求があるかどうか
     */
    BOOL isRequest()
    {
        return type != eReqBlock_None;
    }
    
    /**
     * 上から出現
     */
    void setUpper(int count)
    {
        this->type = eReqBlock_Upper;
        this->count = count;
        this->nShield = 0;
    }
    
    /**
     * 上から出現 (固ぷよ)
     */
    void setUpperShield(int count)
    {
        this->type = eReqBlock_Upper;
        this->count = count;
        this->nShield = 1;
    }
    
    /**
     * 上から出現 (固ぷよ)
     */
    void setUpperShield2(int count)
    {
        this->type = eReqBlock_Upper;
        this->count = count;
        this->nShield = 2;
    }
    
    /**
     * 上から出現 (ドクロ)
     */
    void setUpperSkull(int count)
    {
        this->type = eReqBlock_Upper;
        this->count = count;
        this->rSkull = 1.0f;
    }
    
    /**
     * 下から出現
     * @param nLine 出現ライン数
     */
    void setBottom(int nLine)
    {
        this->type = eReqBlock_Bottom;
        this->nLine = nLine;
        this->nShield = 0;
    }
    
    /**
     * 下から出現 (固ぷよ)
     */
    void setBottomShield(int nLine)
    {
        this->type = eReqBlock_Bottom;
        this->nLine = nLine;
        this->nShield = 1;
    }
};

#endif
