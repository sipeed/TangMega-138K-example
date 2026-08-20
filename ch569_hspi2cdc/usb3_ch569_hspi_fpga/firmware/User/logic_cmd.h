#ifndef __SLOGIC_CMD_H__
#define __SLOGIC_CMD_H__

#ifdef USE_MACRO

#define CMD_SYS(isOSC, isNEG) (0x00|isOSC|(isNEG<<1))
#define CMD_CHSEL(chs) ({unsigned char res = 0x20;      \
                        switch(chs){                    \
                        case 1:     res|=0x00;break;    \
                        case 2:     res|=0x10;break;    \
                        case 4:     res|=0x18;break;    \
                        case 8:     res|=0x1C;break;    \
                        case 16:    res|=0x1E;break;    \
                        default:    break;} res;})
#define CMD_RATE_M(rate)  ({  unsigned char res = 0x40; \
                            switch(rate){ \
                            case 1200:  res|=0x00;  break;      \
                            case 600:   res|=0x01;  break;      \
                            case 400:   res|=0x02;  break;      \
                            case 300:   res|=0x03;  break;      \
                            case 200:   res|=0x04;  break;      \
                            case 150:   res|=0x05;  break;      \
                            case 120:   res|=0x06;  break;      \
                            case 100:   res|=0x07;  break;      \
                            case 50:    res|=0x08;  break;      \
                            case 20:    res|=0x09;  break;      \
                            case 10:    res|=0x0A;  break;      \
                            case 5:     res|=0x0B;  break;      \
                            case 2:     res|=0x0C;  break;      \
                            case 1:     res|=0x0D;  break;      \
                            default:                break;      \
                            } res; })
#define CMD_RATE(rate)  ({  unsigned char res = 0x40; \
                            switch(rate/1000000){ \
                            case 1200:  res|=0x00;  break;      \
                            case 600:   res|=0x01;  break;      \
                            case 400:   res|=0x02;  break;      \
                            case 300:   res|=0x03;  break;      \
                            case 200:   res|=0x04;  break;      \
                            case 150:   res|=0x05;  break;      \
                            case 120:   res|=0x06;  break;      \
                            case 100:   res|=0x07;  break;      \
                            case 50:    res|=0x08;  break;      \
                            case 20:    res|=0x09;  break;      \
                            case 10:    res|=0x0A;  break;      \
                            case 5:     res|=0x0B;  break;      \
                            case 2:     res|=0x0C;  break;      \
                            case 1:     res|=0x0D;  break;      \
                            default:                break;      \
                            } res; })
#define CMD_CNT(cnt)    ({  unsigned char res = 0x60;           \
                            switch(cnt){                        \
                            case 0:         res|=0x00;break;    \
                            case 1000000:   res|=0x01;break;    \
                            case 2000000:   res|=0x02;break;    \
                            case 5000000:   res|=0x03;break;    \
                            case 10000000:  res|=0x04;break;    \
                            case 20000000:  res|=0x05;break;    \
                            case 50000000:  res|=0x06;break;    \
                            case 100000000: res|=0x07;break;    \
                            case 200000000: res|=0x08;break;    \
                            case 500000000: res|=0x09;break;    \
                            case 1000000000:res|=0x0A;break;    \
                            case 2000000000:res|=0x0B;break;    \
                            case 5000000000:res|=0x0C;break;    \
                            case 10000000000:res|=0x0D;break;    \
                            case 4096:      res|=0x1E;break;   \
                            case -1:        res|=0x1F;break;    \
                            default:    break;                  \
                            } res;})
#define CMD_LEVEL(level) (0x80|(level&0x1F))
#define CMD_LEVEL_V(v) ({(unsigned char)(v*10);(v>33)?(0x80|0x0A):(0x80|(unsigned char)(v*32/33))})
#define CMD_TCH(chx) (0xA0|(0x1F&chx))
#define CMD_TMOD(isLow, isHigh, isRisingEdge, isFallingEdge, isDoubleEdge, isNone) \
                (0xC0|(isLow?0x00:0x00)|(isHigh?0x01:0x00)|(isRisingEdge?0x02:0x00)|(isFallingEdge?0x03:0x00)|(isDoubleEdge?0x04:0x00)|(isNone?0x07:0x00))

#else

/**
* @brief CMD_SYS
* @param
* @return
*/
static inline unsigned char CMD_SYS(unsigned char isOSC, unsigned char isNEG)
{
    return 0x00|isOSC|(isNEG<<1);
}

/**
* @brief CMD_CHSEL
* @param chs  number of channels
* @return cmd for chsel
*/
static inline unsigned char CMD_CHSEL(const unsigned char chs)
{
    unsigned char reg_chsel = 0x20;
    switch(chs) {
        case 1: reg_chsel|=0x00; break;
        case 2: reg_chsel|=0x10; break;
        case 4: reg_chsel|=0x18; break;
        case 8: reg_chsel|=0x1C; break;
        case 16:reg_chsel|=0x1E; break;
        default: break;
    }
    return reg_chsel;
}
/**
* @brief CMD_RATE_M
* @param rate  (Sampling rate/1000000)
* @return cmd for sampling rate
*/
static inline unsigned char CMD_RATE_M(const unsigned int rate)
{
    unsigned char reg_rate = 0x40;
    switch(rate) {
        case 1200:  reg_rate|=0x00; break;
        case 600:   reg_rate|=0x01; break;
        case 400:   reg_rate|=0x02; break;
        case 300:   reg_rate|=0x03; break;
        case 150:   reg_rate|=0x04; break;
        case 200:   reg_rate|=0x05; break;
        case 120:   reg_rate|=0x06; break;
        case 100:   reg_rate|=0x07; break;
        case 50:    reg_rate|=0x08; break;
        case 20:    reg_rate|=0x09; break;
        case 10:    reg_rate|=0x0A; break;
        case 5:     reg_rate|=0x0B; break;
        case 2:     reg_rate|=0x0C; break;
        case 1:     reg_rate|=0x0D; break;
        default: break;
    }
}
/**
* @brief CMD_RATE
* @param rate Sampling rate
* @return cmd for sampling rate
*/
static inline unsigned char CMD_RATE(const unsigned int rate)
{
    return CMD_RATE_M((unsigned char)(rate/1000000));
}
/**
* @brief CMD_CNT
* @param cnt Sampling cnt
* @return cmd for sampling cnt
*/
static inline unsigned char CMD_CNT(const long long cnt)
{
    unsigned char reg_cnt = 0x60;
    switch(cnt) {
        case 0:             reg_cnt|=0x00;  break;
        case 1000000:       reg_cnt|=0x01;  break;
        case 2000000:       reg_cnt|=0x02;  break;
        case 5000000:       reg_cnt|=0x03;  break;
        case 10000000:      reg_cnt|=0x04;  break;
        case 20000000:      reg_cnt|=0x05;  break;
        case 50000000:      reg_cnt|=0x06;  break;
        case 100000000:     reg_cnt|=0x07;  break;
        case 200000000:     reg_cnt|=0x08;  break;
        case 500000000:     reg_cnt|=0x09;  break;
        case 1000000000:    reg_cnt|=0x0A;  break;
        case 2000000000:    reg_cnt|=0x0B;  break;
        case 5000000000:    reg_cnt|=0x0C;  break;
        case 10000000000:   reg_cnt|=0x0D;  break;
        case 4096:          reg_cnt|=0x1E;  break;
        case -1:            reg_cnt|=0x1F;  break;
        default:    break;
    }
}
/**
* @brief CMD_LEVEL
* @param level Sampling level
* @return cmd for sampling level
*/
static inline unsigned char CMD_LEVEL(const unsigned char level)
{
    return 0x80|(level&0x1F);
}
/**
* @brief CMD_LEVEL_V
* @param v  voltage eg. 2.3 means 2.3V
* @return cmd for sampling level
*/
static inline unsigned char CMD_LEVEL_V(const float v)
{
    unsigned char v_tmp = (unsigned char)(v*10);
    return (v>33)?(0x80|0x0A):(0x80|(unsigned char)(v*32/33));
}
/**
* @brief CMD_TCH
* @param chx number of channel
* @return
*/
static inline unsigned char CMD_TCH(const unsigned char chx)
{
    return (0xA0|(0x1F&chx));
}

enum TMOD{
    Low = 0x00,
    High,
    RisingEdge,
    FallingEdge,
    DoubleEdge,
    None = 0x07
};
/**
* @brief CMD_TMOD
* @param tmod trigger mode
* @return
*/
static inline unsigned char CMD_TMOD(enum TMOD tmod)
{
    return (0xC0&tmod);
}
#endif



#endif