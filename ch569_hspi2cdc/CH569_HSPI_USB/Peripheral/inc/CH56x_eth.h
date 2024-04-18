/********************************** (C) COPYRIGHT  *******************************
* File Name          : ch56x_eth.h
* Author             : WCH
* Version            : V1.0.0
* Date               : 2023/03/03
* Description        : This file contains all the functions prototypes for the
*                      ETH firmware library.
*********************************************************************************
* Copyright (c) 2021 Nanjing Qinheng Microelectronics Co., Ltd.
* Attention: This software (modified or not) and binary are used for 
* microcontroller manufactured by Nanjing Qinheng Microelectronics.
*******************************************************************************/


#ifndef __CH56x_ETH_H
#define __CH56x_ETH_H

#ifdef __cplusplus
 extern "C" {
#endif


#include "CH56xSFR.h"
#include "core_riscv.h"
#include "CH56x_common.h"

#ifndef uint16_t
typedef  unsigned short  uint16_t;
#endif

#ifndef uint8_t
typedef unsigned char uint8_t ;
#endif

#ifdef __cplusplus
extern "C" {
#endif


#ifndef __IO
#define __IO volatile
#endif


/*-------------------------------CH565/569 register table----------------------------------*/
typedef struct
{
    __IO unsigned int MACCR;
    __IO unsigned int MACFFR;
    __IO unsigned int MACHTHR;
    __IO unsigned int MACHTLR;
    __IO unsigned int MACMIIAR;
    __IO unsigned int MACMIIDR;
    __IO unsigned int MACFCR;
    __IO unsigned int MACVLANTR;
    unsigned int      RESERVED0[2];
    __IO unsigned int MACRWUFFR;
    __IO unsigned int MACPMTCSR;
    unsigned int      RESERVED1[2];
    __IO unsigned int MACSR;
    __IO unsigned int MACIMR;
    __IO unsigned int MACA0HR;
    __IO unsigned int MACA0LR;
    __IO unsigned int MACA1HR;
    __IO unsigned int MACA1LR;
    __IO unsigned int MACA2HR;
    __IO unsigned int MACA2LR;
    __IO unsigned int MACA3HR;
    __IO unsigned int MACA3LR;
    unsigned int      RESERVED2[40];
    __IO unsigned int MMCCR;
    __IO unsigned int MMCRIR;
    __IO unsigned int MMCTIR;
    __IO unsigned int MMCRIMR;
    __IO unsigned int MMCTIMR;
    unsigned int      RESERVED3[14];
    __IO unsigned int MMCTGFSCCR;
    __IO unsigned int MMCTGFMSCCR;
    unsigned int      RESERVED4[5];
    __IO unsigned int MMCTGFCR;
    unsigned int      RESERVED5[10];
    __IO unsigned int MMCRFCECR;
    __IO unsigned int MMCRFAECR;
    unsigned int      RESERVED6[10];
    __IO unsigned int MMCRGUFCR;
    unsigned int      RESERVED7[334];
    /* PTP is not supported yet */
    __IO unsigned int PTPTSCR;
    __IO unsigned int PTPSSIR;
    __IO unsigned int PTPTSHR;
    __IO unsigned int PTPTSLR;
    __IO unsigned int PTPTSHUR;
    __IO unsigned int PTPTSLUR;
    __IO unsigned int PTPTSAR;
    __IO unsigned int PTPTTHR;
    __IO unsigned int PTPTTLR;
    __IO unsigned int RESERVED8;
    __IO unsigned int PTPTSSR;

    unsigned int      RESERVED9[565];
    __IO unsigned int DMABMR;
    __IO unsigned int DMATPDR;
    __IO unsigned int DMARPDR;
    __IO unsigned int DMARDLAR;
    __IO unsigned int DMATDLAR;
    __IO unsigned int DMASR;
    __IO unsigned int DMAOMR;
    __IO unsigned int DMAIER;
    __IO unsigned int DMAMFBOCR;
    __IO unsigned int DMARSWTR;
    unsigned int      RESERVED10[8];
    __IO unsigned int DMACHTDR;
    __IO unsigned int DMACHRDR;
    __IO unsigned int DMACHTBAR;
    __IO unsigned int DMACHRBAR;
} ETH_TypeDef;

#define ETH    ((ETH_TypeDef*)ETH_BASE)

/******************************************************************************/
/*                                                                            */
/*                Ethernet MAC Registers bits definitions                     */
/*                                                                            */
/******************************************************************************/
/* Bit definition for Ethernet MAC Control Register register */
#define ETH_MACCR_WD            ((unsigned int)0x00800000)  /* Watchdog disable */
#define ETH_MACCR_JD            ((unsigned int)0x00400000)  /* Jabber disable */
#define ETH_MACCR_IFG           ((unsigned int)0x000E0000)  /* Inter-frame gap */
#define ETH_MACCR_IFG_96Bit     ((unsigned int)0x00000000)  /* Minimum IFG between frames during transmission is 96Bit */
#define ETH_MACCR_IFG_88Bit     ((unsigned int)0x00020000)  /* Minimum IFG between frames during transmission is 88Bit */
#define ETH_MACCR_IFG_80Bit     ((unsigned int)0x00040000)  /* Minimum IFG between frames during transmission is 80Bit */
#define ETH_MACCR_IFG_72Bit     ((unsigned int)0x00060000)  /* Minimum IFG between frames during transmission is 72Bit */
#define ETH_MACCR_IFG_64Bit     ((unsigned int)0x00080000)  /* Minimum IFG between frames during transmission is 64Bit */
#define ETH_MACCR_IFG_56Bit     ((unsigned int)0x000A0000)  /* Minimum IFG between frames during transmission is 56Bit */
#define ETH_MACCR_IFG_48Bit     ((unsigned int)0x000C0000)  /* Minimum IFG between frames during transmission is 48Bit */
#define ETH_MACCR_IFG_40Bit     ((unsigned int)0x000E0000)  /* Minimum IFG between frames during transmission is 40Bit */
#define ETH_MACCR_CSD           ((unsigned int)0x00010000)  /* Carrier sense disable (during transmission) */
#define ETH_MACCR_FES           ((unsigned int)0x00004000)  /* Fast ethernet speed */
#define ETH_MACCR_ROD           ((unsigned int)0x00002000)  /* Receive own disable */
#define ETH_MACCR_LM            ((unsigned int)0x00001000)  /* loopback mode */
#define ETH_MACCR_DM            ((unsigned int)0x00000800)  /* Duplex mode */
#define ETH_MACCR_IPCO          ((unsigned int)0x00000400)  /* IP Checksum offload */
#define ETH_MACCR_RD            ((unsigned int)0x00000200)  /* Retry disable */
#define ETH_MACCR_APCS          ((unsigned int)0x00000080)  /* Automatic Pad/CRC stripping */
#define ETH_MACCR_BL            ((unsigned int)0x00000060)  /* Back-off limit: random integer number (r) of slot time delays before reschedulinga transmission attempt during retries after a collision: 0 =< r <2^k */
#define ETH_MACCR_BL_10         ((unsigned int)0x00000000)  /* k = min (n, 10) */
#define ETH_MACCR_BL_8          ((unsigned int)0x00000020)  /* k = min (n, 8) */
#define ETH_MACCR_BL_4          ((unsigned int)0x00000040)  /* k = min (n, 4) */
#define ETH_MACCR_BL_1          ((unsigned int)0x00000060)  /* k = min (n, 1) */
#define ETH_MACCR_DC            ((unsigned int)0x00000010)  /* Defferal check */
#define ETH_MACCR_TE            ((unsigned int)0x00000008)  /* Transmitter enable */
#define ETH_MACCR_RE            ((unsigned int)0x00000004)  /* Receiver enable */

/* Bit definition for Ethernet MAC Frame Filter Register */
#define ETH_MACFFR_RA           ((unsigned int)0x80000000)  /* Receive all */
#define ETH_MACFFR_HPF          ((unsigned int)0x00000400)  /* Hash or perfect filter */
#define ETH_MACFFR_SAF          ((unsigned int)0x00000200)  /* Source address filter enable */
#define ETH_MACFFR_SAIF         ((unsigned int)0x00000100)  /* SA inverse filtering */
#define ETH_MACFFR_PCF          ((unsigned int)0x000000C0)  /* Pass control frames: 3 cases */
#define ETH_MACFFR_PCF_BlockAll                ((unsigned int)0x00000040)  /* MAC filters all control frames from reaching the application */
#define ETH_MACFFR_PCF_ForwardAll              ((unsigned int)0x00000080)  /* MAC forwards all control frames to application even if they fail the Address Filter */
#define ETH_MACFFR_PCF_ForwardPassedAddrFilter ((unsigned int)0x000000C0)  /* MAC forwards control frames that pass the Address Filter. */
#define ETH_MACFFR_BFD          ((unsigned int)0x00000020)  /* Broadcast frame disable */
#define ETH_MACFFR_PAM          ((unsigned int)0x00000010)  /* Pass all mutlicast */
#define ETH_MACFFR_DAIF         ((unsigned int)0x00000008)  /* DA Inverse filtering */
#define ETH_MACFFR_HM           ((unsigned int)0x00000004)  /* Hash multicast */
#define ETH_MACFFR_HU           ((unsigned int)0x00000002)  /* Hash unicast */
#define ETH_MACFFR_PM           ((unsigned int)0x00000001)  /* Promiscuous mode */

/* Bit definition for Ethernet MAC Hash Table High Register */
#define ETH_MACHTHR_HTH         ((unsigned int)0xFFFFFFFF)  /* Hash table high */

/* Bit definition for Ethernet MAC Hash Table Low Register */
#define ETH_MACHTLR_HTL         ((unsigned int)0xFFFFFFFF)  /* Hash table low */

/* Bit definition for Ethernet MAC MII Address Register */
#define ETH_MACMIIAR_PA         ((unsigned int)0x0000F800)  /* Physical layer address */
#define ETH_MACMIIAR_MR         ((unsigned int)0x000007C0)  /* MII register in the selected PHY */
#define ETH_MACMIIAR_CR         ((unsigned int)0x0000001C)  /* CR clock range: 6 cases */
#define ETH_MACMIIAR_CR_Div42   ((unsigned int)0x00000000)  /* HCLK:60-100 MHz; MDC clock= HCLK/42 */
#define ETH_MACMIIAR_CR_Div62   ((unsigned int)0x00000004)  /* HCLK:100-150 MHz; MDC clock= HCLK/62 */
#define ETH_MACMIIAR_CR_Div16   ((unsigned int)0x00000008)  /* HCLK:20-35 MHz; MDC clock= HCLK/16 */
#define ETH_MACMIIAR_CR_Div26   ((unsigned int)0x0000000C)  /* HCLK:35-60 MHz; MDC clock= HCLK/26 */
#define ETH_MACMIIAR_CR_Div102  ((unsigned int)0x00000010)  /* HCLK:150-168 MHz; MDC clock= HCLK/102 */
#define ETH_MACMIIAR_MW         ((unsigned int)0x00000002)  /* MII write */
#define ETH_MACMIIAR_MB         ((unsigned int)0x00000001)  /* MII busy */

/* Bit definition for Ethernet MAC MII Data Register */
#define ETH_MACMIIDR_MD         ((unsigned int)0x0000FFFF)  /* MII data: read/write data from/to PHY */

/* Bit definition for Ethernet MAC Flow Control Register */
#define ETH_MACFCR_PT           ((unsigned int)0xFFFF0000)  /* Pause time */
#define ETH_MACFCR_ZQPD         ((unsigned int)0x00000080)  /* Zero-quanta pause disable */
#define ETH_MACFCR_PLT          ((unsigned int)0x00000030)  /* Pause low threshold: 4 cases */
#define ETH_MACFCR_PLT_Minus4   ((unsigned int)0x00000000)  /* Pause time minus 4 slot times */
#define ETH_MACFCR_PLT_Minus28  ((unsigned int)0x00000010)  /* Pause time minus 28 slot times */
#define ETH_MACFCR_PLT_Minus144 ((unsigned int)0x00000020)  /* Pause time minus 144 slot times */
#define ETH_MACFCR_PLT_Minus256 ((unsigned int)0x00000030)  /* Pause time minus 256 slot times */
#define ETH_MACFCR_UPFD         ((unsigned int)0x00000008)  /* Unicast pause frame detect */
#define ETH_MACFCR_RFCE         ((unsigned int)0x00000004)  /* Receive flow control enable */
#define ETH_MACFCR_TFCE         ((unsigned int)0x00000002)  /* Transmit flow control enable */
#define ETH_MACFCR_FCBBPA       ((unsigned int)0x00000001)  /* Flow control busy/backpressure activate */

/* Bit definition for Ethernet MAC VLAN Tag Register */
#define ETH_MACVLANTR_VLANTC    ((unsigned int)0x00010000)  /* 12-bit VLAN tag comparison */
#define ETH_MACVLANTR_VLANTI    ((unsigned int)0x0000FFFF)  /* VLAN tag identifier (for receive frames) */

/* Bit definition for Ethernet MAC Remote Wake-UpFrame Filter Register */
#define ETH_MACRWUFFR_D         ((unsigned int)0xFFFFFFFF)  /* Wake-up frame filter register data */
/* Eight sequential Writes to this address (offset 0x28) will write all Wake-UpFrame Filter Registers.
Eight sequential Reads from this address (offset 0x28) will read all Wake-UpFrame Filter Registers. */
/* Wake-UpFrame Filter Reg0 : Filter 0 Byte Mask
Wake-UpFrame Filter Reg1 : Filter 1 Byte Mask
Wake-UpFrame Filter Reg2 : Filter 2 Byte Mask
Wake-UpFrame Filter Reg3 : Filter 3 Byte Mask
Wake-UpFrame Filter Reg4 : RSVD - Filter3 Command - RSVD - Filter2 Command -
                           RSVD - Filter1 Command - RSVD - Filter0 Command
Wake-UpFrame Filter Re5 : Filter3 Offset - Filter2 Offset - Filter1 Offset - Filter0 Offset
Wake-UpFrame Filter Re6 : Filter1 CRC16 - Filter0 CRC16
Wake-UpFrame Filter Re7 : Filter3 CRC16 - Filter2 CRC16 */

/* Bit definition for Ethernet MAC PMT Control and Status Register */
#define ETH_MACPMTCSR_WFFRPR    ((unsigned int)0x80000000)  /* Wake-Up Frame Filter Register Pointer Reset */
#define ETH_MACPMTCSR_GU        ((unsigned int)0x00000200)  /* Global Unicast */
#define ETH_MACPMTCSR_WFR       ((unsigned int)0x00000040)  /* Wake-Up Frame Received */
#define ETH_MACPMTCSR_MPR       ((unsigned int)0x00000020)  /* Magic Packet Received */
#define ETH_MACPMTCSR_WFE       ((unsigned int)0x00000004)  /* Wake-Up Frame Enable */
#define ETH_MACPMTCSR_MPE       ((unsigned int)0x00000002)  /* Magic Packet Enable */
#define ETH_MACPMTCSR_PD        ((unsigned int)0x00000001)  /* Power Down */

/* Bit definition for Ethernet MAC Status Register */
#define ETH_MACSR_TSTS          ((unsigned int)0x00000200)  /* Time stamp trigger status */
#define ETH_MACSR_MMCTS         ((unsigned int)0x00000040)  /* MMC transmit status */
#define ETH_MACSR_MMMCRS        ((unsigned int)0x00000020)  /* MMC receive status */
#define ETH_MACSR_MMCS          ((unsigned int)0x00000010)  /* MMC status */
#define ETH_MACSR_PMTS          ((unsigned int)0x00000008)  /* PMT status */

/* Bit definition for Ethernet MAC Interrupt Mask Register */
#define ETH_MACIMR_TSTIM        ((unsigned int)0x00000200)  /* Time stamp trigger interrupt mask */
#define ETH_MACIMR_PMTIM        ((unsigned int)0x00000008)  /* PMT interrupt mask */

/* Bit definition for Ethernet MAC Address0 High Register */
#define ETH_MACA0HR_MACA0H      ((unsigned int)0x0000FFFF)  /* MAC address0 high */

/* Bit definition for Ethernet MAC Address0 Low Register */
#define ETH_MACA0LR_MACA0L      ((unsigned int)0xFFFFFFFF)  /* MAC address0 low */

/* Bit definition for Ethernet MAC Address1 High Register */
#define ETH_MACA1HR_AE                  ((unsigned int)0x80000000)  /* Address enable */
#define ETH_MACA1HR_SA                  ((unsigned int)0x40000000)  /* Source address */
#define ETH_MACA1HR_MBC                 ((unsigned int)0x3F000000)  /* Mask byte control: bits to mask for comparison of the MAC Address bytes */
#define ETH_MACA1HR_MBC_HBits15_8       ((unsigned int)0x20000000)  /* Mask MAC Address high reg bits [15:8] */
#define ETH_MACA1HR_MBC_HBits7_0        ((unsigned int)0x10000000)  /* Mask MAC Address high reg bits [7:0] */
#define ETH_MACA1HR_MBC_LBits31_24      ((unsigned int)0x08000000)  /* Mask MAC Address low reg bits [31:24] */
#define ETH_MACA1HR_MBC_LBits23_16      ((unsigned int)0x04000000)  /* Mask MAC Address low reg bits [23:16] */
#define ETH_MACA1HR_MBC_LBits15_8       ((unsigned int)0x02000000)  /* Mask MAC Address low reg bits [15:8] */
#define ETH_MACA1HR_MBC_LBits7_0        ((unsigned int)0x01000000)  /* Mask MAC Address low reg bits [7:0] */
#define ETH_MACA1HR_MACA1H              ((unsigned int)0x0000FFFF)  /* MAC address1 high */

/* Bit definition for Ethernet MAC Address1 Low Register */
#define ETH_MACA1LR_MACA1L              ((unsigned int)0xFFFFFFFF)  /* MAC address1 low */

/* Bit definition for Ethernet MAC Address2 High Register */
#define ETH_MACA2HR_AE                  ((unsigned int)0x80000000)  /* Address enable */
#define ETH_MACA2HR_SA                  ((unsigned int)0x40000000)  /* Source address */
#define ETH_MACA2HR_MBC                 ((unsigned int)0x3F000000)  /* Mask byte control */
#define ETH_MACA2HR_MBC_HBits15_8       ((unsigned int)0x20000000)  /* Mask MAC Address high reg bits [15:8] */
#define ETH_MACA2HR_MBC_HBits7_0        ((unsigned int)0x10000000)  /* Mask MAC Address high reg bits [7:0] */
#define ETH_MACA2HR_MBC_LBits31_24      ((unsigned int)0x08000000)  /* Mask MAC Address low reg bits [31:24] */
#define ETH_MACA2HR_MBC_LBits23_16      ((unsigned int)0x04000000)  /* Mask MAC Address low reg bits [23:16] */
#define ETH_MACA2HR_MBC_LBits15_8       ((unsigned int)0x02000000)  /* Mask MAC Address low reg bits [15:8] */
#define ETH_MACA2HR_MBC_LBits7_0        ((unsigned int)0x01000000)  /* Mask MAC Address low reg bits [70] */
#define ETH_MACA2HR_MACA2H              ((unsigned int)0x0000FFFF)  /* MAC address1 high */

/* Bit definition for Ethernet MAC Address2 Low Register */
#define ETH_MACA2LR_MACA2L              ((unsigned int)0xFFFFFFFF)  /* MAC address2 low */

/* Bit definition for Ethernet MAC Address3 High Register */
#define ETH_MACA3HR_AE                  ((unsigned int)0x80000000)  /* Address enable */
#define ETH_MACA3HR_SA                  ((unsigned int)0x40000000)  /* Source address */
#define ETH_MACA3HR_MBC                 ((unsigned int)0x3F000000)  /* Mask byte control */
#define ETH_MACA3HR_MBC_HBits15_8       ((unsigned int)0x20000000)  /* Mask MAC Address high reg bits [15:8] */
#define ETH_MACA3HR_MBC_HBits7_0        ((unsigned int)0x10000000)  /* Mask MAC Address high reg bits [7:0] */
#define ETH_MACA3HR_MBC_LBits31_24      ((unsigned int)0x08000000)  /* Mask MAC Address low reg bits [31:24] */
#define ETH_MACA3HR_MBC_LBits23_16      ((unsigned int)0x04000000)  /* Mask MAC Address low reg bits [23:16] */
#define ETH_MACA3HR_MBC_LBits15_8       ((unsigned int)0x02000000)  /* Mask MAC Address low reg bits [15:8] */
#define ETH_MACA3HR_MBC_LBits7_0        ((unsigned int)0x01000000)  /* Mask MAC Address low reg bits [70] */
#define ETH_MACA3HR_MACA3H              ((unsigned int)0x0000FFFF)  /* MAC address3 high */

/* Bit definition for Ethernet MAC Address3 Low Register */
#define ETH_MACA3LR_MACA3L              ((unsigned int)0xFFFFFFFF)  /* MAC address3 low */

/******************************************************************************/
/*                Ethernet MMC Registers bits definition                      */
/******************************************************************************/

/* Bit definition for Ethernet MMC Contol Register */
#define ETH_MMCCR_MCFHP         ((unsigned int)0x00000020)  /* MMC counter Full-Half preset */
#define ETH_MMCCR_MCP           ((unsigned int)0x00000010)  /* MMC counter preset */
#define ETH_MMCCR_MCF           ((unsigned int)0x00000008)  /* MMC Counter Freeze */
#define ETH_MMCCR_ROR           ((unsigned int)0x00000004)  /* Reset on Read */
#define ETH_MMCCR_CSR           ((unsigned int)0x00000002)  /* Counter Stop Rollover */
#define ETH_MMCCR_CR            ((unsigned int)0x00000001)  /* Counters Reset */

/* Bit definition for Ethernet MMC Receive Interrupt Register */
#define ETH_MMCRIR_RGUFS        ((unsigned int)0x00020000)  /* Set when Rx good unicast frames counter reaches half the maximum value */
#define ETH_MMCRIR_RFAES        ((unsigned int)0x00000040)  /* Set when Rx alignment error counter reaches half the maximum value */
#define ETH_MMCRIR_RFCES        ((unsigned int)0x00000020)  /* Set when Rx crc error counter reaches half the maximum value */

/* Bit definition for Ethernet MMC Transmit Interrupt Register */
#define ETH_MMCTIR_TGFS         ((unsigned int)0x00200000)  /* Set when Tx good frame count counter reaches half the maximum value */
#define ETH_MMCTIR_TGFMSCS      ((unsigned int)0x00008000)  /* Set when Tx good multi col counter reaches half the maximum value */
#define ETH_MMCTIR_TGFSCS       ((unsigned int)0x00004000)  /* Set when Tx good single col counter reaches half the maximum value */

/* Bit definition for Ethernet MMC Receive Interrupt Mask Register */
#define ETH_MMCRIMR_RGUFM       ((unsigned int)0x00020000)  /* Mask the interrupt when Rx good unicast frames counter reaches half the maximum value */
#define ETH_MMCRIMR_RFAEM       ((unsigned int)0x00000040)  /* Mask the interrupt when when Rx alignment error counter reaches half the maximum value */
#define ETH_MMCRIMR_RFCEM       ((unsigned int)0x00000020)  /* Mask the interrupt when Rx crc error counter reaches half the maximum value */

/* Bit definition for Ethernet MMC Transmit Interrupt Mask Register */
#define ETH_MMCTIMR_TGFM        ((unsigned int)0x00200000)  /* Mask the interrupt when Tx good frame count counter reaches half the maximum value */
#define ETH_MMCTIMR_TGFMSCM     ((unsigned int)0x00008000)  /* Mask the interrupt when Tx good multi col counter reaches half the maximum value */
#define ETH_MMCTIMR_TGFSCM      ((unsigned int)0x00004000)  /* Mask the interrupt when Tx good single col counter reaches half the maximum value */

/* Bit definition for Ethernet MMC Transmitted Good Frames after Single Collision Counter Register */
#define ETH_MMCTGFSCCR_TGFSCC       ((unsigned int)0xFFFFFFFF)  /* Number of successfully transmitted frames after a single collision in Half-duplex mode. */

/* Bit definition for Ethernet MMC Transmitted Good Frames after More than a Single Collision Counter Register */
#define ETH_MMCTGFMSCCR_TGFMSCC     ((unsigned int)0xFFFFFFFF)  /* Number of successfully transmitted frames after more than a single collision in Half-duplex mode. */

/* Bit definition for Ethernet MMC Transmitted Good Frames Counter Register */
#define ETH_MMCTGFCR_TGFC           ((unsigned int)0xFFFFFFFF)  /* Number of good frames transmitted. */

/* Bit definition for Ethernet MMC Received Frames with CRC Error Counter Register */
#define ETH_MMCRFCECR_RFCEC         ((unsigned int)0xFFFFFFFF)  /* Number of frames received with CRC error. */

/* Bit definition for Ethernet MMC Received Frames with Alignement Error Counter Register */
#define ETH_MMCRFAECR_RFAEC         ((unsigned int)0xFFFFFFFF)  /* Number of frames received with alignment (dribble) error */

/* Bit definition for Ethernet MMC Received Good Unicast Frames Counter Register */
#define ETH_MMCRGUFCR_RGUFC         ((unsigned int)0xFFFFFFFF)  /* Number of good unicast frames received. */

/******************************************************************************/
/*               Ethernet PTP Registers bits definition                       */
/******************************************************************************/
/* PTP is not supported yet */
/* Bit definition for Ethernet PTP Time Stamp Contol Register */
#define ETH_PTPTSCR_TSCNT       ((unsigned int)0x00030000)  /* Time stamp clock node type */
#define ETH_PTPTSSR_TSSMRME     ((unsigned int)0x00008000)  /* Time stamp snapshot for message relevant to master enable */
#define ETH_PTPTSSR_TSSEME      ((unsigned int)0x00004000)  /* Time stamp snapshot for event message enable */
#define ETH_PTPTSSR_TSSIPV4FE   ((unsigned int)0x00002000)  /* Time stamp snapshot for IPv4 frames enable */
#define ETH_PTPTSSR_TSSIPV6FE   ((unsigned int)0x00001000)  /* Time stamp snapshot for IPv6 frames enable */
#define ETH_PTPTSSR_TSSPTPOEFE  ((unsigned int)0x00000800)  /* Time stamp snapshot for PTP over ethernet frames enable */
#define ETH_PTPTSSR_TSPTPPSV2E  ((unsigned int)0x00000400)  /* Time stamp PTP packet snooping for version2 format enable */
#define ETH_PTPTSSR_TSSSR       ((unsigned int)0x00000200)  /* Time stamp Sub-seconds rollover */
#define ETH_PTPTSSR_TSSARFE     ((unsigned int)0x00000100)  /* Time stamp snapshot for all received frames enable */

#define ETH_PTPTSCR_TSARU       ((unsigned int)0x00000020)  /* Addend register update */
#define ETH_PTPTSCR_TSITE       ((unsigned int)0x00000010)  /* Time stamp interrupt trigger enable */
#define ETH_PTPTSCR_TSSTU       ((unsigned int)0x00000008)  /* Time stamp update */
#define ETH_PTPTSCR_TSSTI       ((unsigned int)0x00000004)  /* Time stamp initialize */
#define ETH_PTPTSCR_TSFCU       ((unsigned int)0x00000002)  /* Time stamp fine or coarse update */
#define ETH_PTPTSCR_TSE         ((unsigned int)0x00000001)  /* Time stamp enable */

/* Bit definition for Ethernet PTP Sub-Second Increment Register */
#define ETH_PTPSSIR_STSSI       ((unsigned int)0x000000FF)  /* System time Sub-second increment value */

/* Bit definition for Ethernet PTP Time Stamp High Register */
#define ETH_PTPTSHR_STS         ((unsigned int)0xFFFFFFFF)  /* System Time second */

/* Bit definition for Ethernet PTP Time Stamp Low Register */
#define ETH_PTPTSLR_STPNS       ((unsigned int)0x80000000)  /* System Time Positive or negative time */
#define ETH_PTPTSLR_STSS        ((unsigned int)0x7FFFFFFF)  /* System Time sub-seconds */

/* Bit definition for Ethernet PTP Time Stamp High Update Register */
#define ETH_PTPTSHUR_TSUS       ((unsigned int)0xFFFFFFFF)  /* Time stamp update seconds */

/* Bit definition for Ethernet PTP Time Stamp Low Update Register */
#define ETH_PTPTSLUR_TSUPNS     ((unsigned int)0x80000000)  /* Time stamp update Positive or negative time */
#define ETH_PTPTSLUR_TSUSS      ((unsigned int)0x7FFFFFFF)  /* Time stamp update sub-seconds */

/* Bit definition for Ethernet PTP Time Stamp Addend Register */
#define ETH_PTPTSAR_TSA         ((unsigned int)0xFFFFFFFF)  /* Time stamp addend */

/* Bit definition for Ethernet PTP Target Time High Register */
#define ETH_PTPTTHR_TTSH        ((unsigned int)0xFFFFFFFF)  /* Target time stamp high */

/* Bit definition for Ethernet PTP Target Time Low Register */
#define ETH_PTPTTLR_TTSL        ((unsigned int)0xFFFFFFFF)  /* Target time stamp low */

/* Bit definition for Ethernet PTP Time Stamp Status Register */
#define ETH_PTPTSSR_TSTTR       ((unsigned int)0x00000020)  /* Time stamp target time reached */
#define ETH_PTPTSSR_TSSO        ((unsigned int)0x00000010)  /* Time stamp seconds overflow */

/******************************************************************************/
/*                 Ethernet DMA Registers bits definition                     */
/******************************************************************************/

/* Bit definition for Ethernet DMA Bus Mode Register */
#define ETH_DMABMR_AAB                  ((unsigned int)0x02000000)  /* Address-Aligned beats */
#define ETH_DMABMR_FPM                  ((unsigned int)0x01000000)  /* 4xPBL mode */
#define ETH_DMABMR_USP                  ((unsigned int)0x00800000)  /* Use separate PBL */
#define ETH_DMABMR_RDP                  ((unsigned int)0x007E0000)  /* RxDMA PBL */
#define ETH_DMABMR_RDP_1Beat            ((unsigned int)0x00020000)  /* maximum number of beats to be transferred in one RxDMA transaction is 1 */
#define ETH_DMABMR_RDP_2Beat            ((unsigned int)0x00040000)  /* maximum number of beats to be transferred in one RxDMA transaction is 2 */
#define ETH_DMABMR_RDP_4Beat            ((unsigned int)0x00080000)  /* maximum number of beats to be transferred in one RxDMA transaction is 4 */
#define ETH_DMABMR_RDP_8Beat            ((unsigned int)0x00100000)  /* maximum number of beats to be transferred in one RxDMA transaction is 8 */
#define ETH_DMABMR_RDP_16Beat           ((unsigned int)0x00200000)  /* maximum number of beats to be transferred in one RxDMA transaction is 16 */
#define ETH_DMABMR_RDP_32Beat           ((unsigned int)0x00400000)  /* maximum number of beats to be transferred in one RxDMA transaction is 32 */
#define ETH_DMABMR_RDP_4xPBL_4Beat      ((unsigned int)0x01020000)  /* maximum number of beats to be transferred in one RxDMA transaction is 4 */
#define ETH_DMABMR_RDP_4xPBL_8Beat      ((unsigned int)0x01040000)  /* maximum number of beats to be transferred in one RxDMA transaction is 8 */
#define ETH_DMABMR_RDP_4xPBL_16Beat     ((unsigned int)0x01080000)  /* maximum number of beats to be transferred in one RxDMA transaction is 16 */
#define ETH_DMABMR_RDP_4xPBL_32Beat     ((unsigned int)0x01100000)  /* maximum number of beats to be transferred in one RxDMA transaction is 32 */
#define ETH_DMABMR_RDP_4xPBL_64Beat     ((unsigned int)0x01200000)  /* maximum number of beats to be transferred in one RxDMA transaction is 64 */
#define ETH_DMABMR_RDP_4xPBL_128Beat    ((unsigned int)0x01400000)  /* maximum number of beats to be transferred in one RxDMA transaction is 128 */
#define ETH_DMABMR_FB                   ((unsigned int)0x00010000)  /* Fixed Burst */
#define ETH_DMABMR_RTPR                 ((unsigned int)0x0000C000)  /* Rx Tx priority ratio */
#define ETH_DMABMR_RTPR_1_1             ((unsigned int)0x00000000)  /* Rx Tx priority ratio */
#define ETH_DMABMR_RTPR_2_1             ((unsigned int)0x00004000)  /* Rx Tx priority ratio */
#define ETH_DMABMR_RTPR_3_1             ((unsigned int)0x00008000)  /* Rx Tx priority ratio */
#define ETH_DMABMR_RTPR_4_1             ((unsigned int)0x0000C000)  /* Rx Tx priority ratio */
#define ETH_DMABMR_PBL                  ((unsigned int)0x00003F00)  /* Programmable burst length */
#define ETH_DMABMR_PBL_1Beat            ((unsigned int)0x00000100)  /* maximum number of beats to be transferred in one TxDMA (or both) transaction is 1 */
#define ETH_DMABMR_PBL_2Beat            ((unsigned int)0x00000200)  /* maximum number of beats to be transferred in one TxDMA (or both) transaction is 2 */
#define ETH_DMABMR_PBL_4Beat            ((unsigned int)0x00000400)  /* maximum number of beats to be transferred in one TxDMA (or both) transaction is 4 */
#define ETH_DMABMR_PBL_8Beat            ((unsigned int)0x00000800)  /* maximum number of beats to be transferred in one TxDMA (or both) transaction is 8 */
#define ETH_DMABMR_PBL_16Beat           ((unsigned int)0x00001000)  /* maximum number of beats to be transferred in one TxDMA (or both) transaction is 16 */
#define ETH_DMABMR_PBL_32Beat           ((unsigned int)0x00002000)  /* maximum number of beats to be transferred in one TxDMA (or both) transaction is 32 */
#define ETH_DMABMR_PBL_4xPBL_4Beat      ((unsigned int)0x01000100)  /* maximum number of beats to be transferred in one TxDMA (or both) transaction is 4 */
#define ETH_DMABMR_PBL_4xPBL_8Beat      ((unsigned int)0x01000200)  /* maximum number of beats to be transferred in one TxDMA (or both) transaction is 8 */
#define ETH_DMABMR_PBL_4xPBL_16Beat     ((unsigned int)0x01000400)  /* maximum number of beats to be transferred in one TxDMA (or both) transaction is 16 */
#define ETH_DMABMR_PBL_4xPBL_32Beat     ((unsigned int)0x01000800)  /* maximum number of beats to be transferred in one TxDMA (or both) transaction is 32 */
#define ETH_DMABMR_PBL_4xPBL_64Beat     ((unsigned int)0x01001000)  /* maximum number of beats to be transferred in one TxDMA (or both) transaction is 64 */
#define ETH_DMABMR_PBL_4xPBL_128Beat    ((unsigned int)0x01002000)  /* maximum number of beats to be transferred in one TxDMA (or both) transaction is 128 */
#define ETH_DMABMR_EDE                  ((unsigned int)0x00000080)  /* Enhanced Descriptor Enable */
#define ETH_DMABMR_DSL                  ((unsigned int)0x0000007C)  /* Descriptor Skip Length */
#define ETH_DMABMR_DA                   ((unsigned int)0x00000002)  /* DMA arbitration scheme */
#define ETH_DMABMR_SR                   ((unsigned int)0x00000001)  /* Software reset */

/* Bit definition for Ethernet DMA Transmit Poll Demand Register */
#define ETH_DMATPDR_TPD                 ((unsigned int)0xFFFFFFFF)  /* Transmit poll demand */

/* Bit definition for Ethernet DMA Receive Poll Demand Register */
#define ETH_DMARPDR_RPD                 ((unsigned int)0xFFFFFFFF)  /* Receive poll demand  */

/* Bit definition for Ethernet DMA Receive Descriptor List Address Register */
#define ETH_DMARDLAR_SRL                ((unsigned int)0xFFFFFFFF)  /* Start of receive list */

/* Bit definition for Ethernet DMA Transmit Descriptor List Address Register */
#define ETH_DMATDLAR_STL                ((unsigned int)0xFFFFFFFF)  /* Start of transmit list */

/* Bit definition for Ethernet DMA Status Register */
#define ETH_DMASR_TSTS                  ((unsigned int)0x20000000)  /* Time-stamp trigger status */
#define ETH_DMASR_PMTS                  ((unsigned int)0x10000000)  /* PMT status */
#define ETH_DMASR_MMCS                  ((unsigned int)0x08000000)  /* MMC status */
#define ETH_DMASR_EBS                   ((unsigned int)0x03800000)  /* Error bits status */
/* combination with EBS[2:0] for GetFlagStatus function */
#define ETH_DMASR_EBS_DescAccess        ((unsigned int)0x02000000)  /* Error bits 0-data buffer, 1-desc. access */
#define ETH_DMASR_EBS_ReadTransf        ((unsigned int)0x01000000)  /* Error bits 0-write trnsf, 1-read transfr */
#define ETH_DMASR_EBS_DataTransfTx      ((unsigned int)0x00800000)  /* Error bits 0-Rx DMA, 1-Tx DMA */
#define ETH_DMASR_TPS                   ((unsigned int)0x00700000)  /* Transmit process state */
#define ETH_DMASR_TPS_Stopped           ((unsigned int)0x00000000)  /* Stopped - Reset or Stop Tx Command issued  */
#define ETH_DMASR_TPS_Fetching          ((unsigned int)0x00100000)  /* Running - fetching the Tx descriptor */
#define ETH_DMASR_TPS_Waiting           ((unsigned int)0x00200000)  /* Running - waiting for status */
#define ETH_DMASR_TPS_Reading           ((unsigned int)0x00300000)  /* Running - reading the data from host memory */
#define ETH_DMASR_TPS_Suspended         ((unsigned int)0x00600000)  /* Suspended - Tx Descriptor unavailabe */
#define ETH_DMASR_TPS_Closing           ((unsigned int)0x00700000)  /* Running - closing Rx descriptor */
#define ETH_DMASR_RPS                   ((unsigned int)0x000E0000)  /* Receive process state */
#define ETH_DMASR_RPS_Stopped           ((unsigned int)0x00000000)  /* Stopped - Reset or Stop Rx Command issued */
#define ETH_DMASR_RPS_Fetching          ((unsigned int)0x00020000)  /* Running - fetching the Rx descriptor */
#define ETH_DMASR_RPS_Waiting           ((unsigned int)0x00060000)  /* Running - waiting for packet */
#define ETH_DMASR_RPS_Suspended         ((unsigned int)0x00080000)  /* Suspended - Rx Descriptor unavailable */
#define ETH_DMASR_RPS_Closing           ((unsigned int)0x000A0000)  /* Running - closing descriptor */
#define ETH_DMASR_RPS_Queuing           ((unsigned int)0x000E0000)  /* Running - queuing the recieve frame into host memory */
#define ETH_DMASR_NIS                   ((unsigned int)0x00010000)  /* Normal interrupt summary */
#define ETH_DMASR_AIS                   ((unsigned int)0x00008000)  /* Abnormal interrupt summary */
#define ETH_DMASR_ERS                   ((unsigned int)0x00004000)  /* Early receive status */
#define ETH_DMASR_FBES                  ((unsigned int)0x00002000)  /* Fatal bus error status */
#define ETH_DMASR_ETS                   ((unsigned int)0x00000400)  /* Early transmit status */
#define ETH_DMASR_RWTS                  ((unsigned int)0x00000200)  /* Receive watchdog timeout status */
#define ETH_DMASR_RPSS                  ((unsigned int)0x00000100)  /* Receive process stopped status */
#define ETH_DMASR_RBUS                  ((unsigned int)0x00000080)  /* Receive buffer unavailable status */
#define ETH_DMASR_RS                    ((unsigned int)0x00000040)  /* Receive status */
#define ETH_DMASR_TUS                   ((unsigned int)0x00000020)  /* Transmit underflow status */
#define ETH_DMASR_ROS                   ((unsigned int)0x00000010)  /* Receive overflow status */
#define ETH_DMASR_TJTS                  ((unsigned int)0x00000008)  /* Transmit jabber timeout status */
#define ETH_DMASR_TBUS                  ((unsigned int)0x00000004)  /* Transmit buffer unavailable status */
#define ETH_DMASR_TPSS                  ((unsigned int)0x00000002)  /* Transmit process stopped status */
#define ETH_DMASR_TS                    ((unsigned int)0x00000001)  /* Transmit status */

/* Bit definition for Ethernet DMA Operation Mode Register */
#define ETH_DMAOMR_DTCEFD               ((unsigned int)0x04000000)  /* Disable Dropping of TCP/IP checksum error frames */
#define ETH_DMAOMR_RSF                  ((unsigned int)0x02000000)  /* Receive store and forward */
#define ETH_DMAOMR_DFRF                 ((unsigned int)0x01000000)  /* Disable flushing of received frames */
#define ETH_DMAOMR_TSF                  ((unsigned int)0x00200000)  /* Transmit store and forward */
#define ETH_DMAOMR_FTF                  ((unsigned int)0x00100000)  /* Flush transmit FIFO */
#define ETH_DMAOMR_TTC                  ((unsigned int)0x0001C000)  /* Transmit threshold control */
#define ETH_DMAOMR_TTC_64Bytes          ((unsigned int)0x00000000)  /* threshold level of the MTL Transmit FIFO is 64 Bytes */
#define ETH_DMAOMR_TTC_128Bytes         ((unsigned int)0x00004000)  /* threshold level of the MTL Transmit FIFO is 128 Bytes */
#define ETH_DMAOMR_TTC_192Bytes         ((unsigned int)0x00008000)  /* threshold level of the MTL Transmit FIFO is 192 Bytes */
#define ETH_DMAOMR_TTC_256Bytes         ((unsigned int)0x0000C000)  /* threshold level of the MTL Transmit FIFO is 256 Bytes */
#define ETH_DMAOMR_TTC_40Bytes          ((unsigned int)0x00010000)  /* threshold level of the MTL Transmit FIFO is 40 Bytes */
#define ETH_DMAOMR_TTC_32Bytes          ((unsigned int)0x00014000)  /* threshold level of the MTL Transmit FIFO is 32 Bytes */
#define ETH_DMAOMR_TTC_24Bytes          ((unsigned int)0x00018000)  /* threshold level of the MTL Transmit FIFO is 24 Bytes */
#define ETH_DMAOMR_TTC_16Bytes          ((unsigned int)0x0001C000)  /* threshold level of the MTL Transmit FIFO is 16 Bytes */
#define ETH_DMAOMR_ST                   ((unsigned int)0x00002000)  /* Start/stop transmission command */
#define ETH_DMAOMR_FEF                  ((unsigned int)0x00000080)  /* Forward error frames */
#define ETH_DMAOMR_FUGF                 ((unsigned int)0x00000040)  /* Forward undersized good frames */
#define ETH_DMAOMR_RTC                  ((unsigned int)0x00000018)  /* receive threshold control */
#define ETH_DMAOMR_RTC_64Bytes          ((unsigned int)0x00000000)  /* threshold level of the MTL Receive FIFO is 64 Bytes */
#define ETH_DMAOMR_RTC_32Bytes          ((unsigned int)0x00000008)  /* threshold level of the MTL Receive FIFO is 32 Bytes */
#define ETH_DMAOMR_RTC_96Bytes          ((unsigned int)0x00000010)  /* threshold level of the MTL Receive FIFO is 96 Bytes */
#define ETH_DMAOMR_RTC_128Bytes         ((unsigned int)0x00000018)  /* threshold level of the MTL Receive FIFO is 128 Bytes */
#define ETH_DMAOMR_OSF                  ((unsigned int)0x00000004)  /* operate on second frame */
#define ETH_DMAOMR_SR                   ((unsigned int)0x00000002)  /* Start/stop receive */

/* Bit definition for Ethernet DMA Interrupt Enable Register */
#define ETH_DMAIER_NISE                 ((unsigned int)0x00010000)  /* Normal interrupt summary enable */
#define ETH_DMAIER_AISE                 ((unsigned int)0x00008000)  /* Abnormal interrupt summary enable */
#define ETH_DMAIER_ERIE                 ((unsigned int)0x00004000)  /* Early receive interrupt enable */
#define ETH_DMAIER_FBEIE                ((unsigned int)0x00002000)  /* Fatal bus error interrupt enable */
#define ETH_DMAIER_ETIE                 ((unsigned int)0x00000400)  /* Early transmit interrupt enable */
#define ETH_DMAIER_RWTIE                ((unsigned int)0x00000200)  /* Receive watchdog timeout interrupt enable */
#define ETH_DMAIER_RPSIE                ((unsigned int)0x00000100)  /* Receive process stopped interrupt enable */
#define ETH_DMAIER_RBUIE                ((unsigned int)0x00000080)  /* Receive buffer unavailable interrupt enable */
#define ETH_DMAIER_RIE                  ((unsigned int)0x00000040)  /* Receive interrupt enable */
#define ETH_DMAIER_TUIE                 ((unsigned int)0x00000020)  /* Transmit Underflow interrupt enable */
#define ETH_DMAIER_ROIE                 ((unsigned int)0x00000010)  /* Receive Overflow interrupt enable */
#define ETH_DMAIER_TJTIE                ((unsigned int)0x00000008)  /* Transmit jabber timeout interrupt enable */
#define ETH_DMAIER_TBUIE                ((unsigned int)0x00000004)  /* Transmit buffer unavailable interrupt enable */
#define ETH_DMAIER_TPSIE                ((unsigned int)0x00000002)  /* Transmit process stopped interrupt enable */
#define ETH_DMAIER_TIE                  ((unsigned int)0x00000001)  /* Transmit interrupt enable */

/* Bit definition for Ethernet DMA Missed Frame and Buffer Overflow Counter Register */
#define ETH_DMAMFBOCR_OFOC              ((unsigned int)0x10000000)  /* Overflow bit for FIFO overflow counter */
#define ETH_DMAMFBOCR_MFA               ((unsigned int)0x0FFE0000)  /* Number of frames missed by the application */
#define ETH_DMAMFBOCR_OMFC              ((unsigned int)0x00010000)  /* Overflow bit for missed frame counter */
#define ETH_DMAMFBOCR_MFC               ((unsigned int)0x0000FFFF)  /* Number of frames missed by the controller */

/* Bit definition for Ethernet DMA Current Host Transmit Descriptor Register */
#define ETH_DMACHTDR_HTDAP              ((unsigned int)0xFFFFFFFF)  /* Host transmit descriptor address pointer */

/* Bit definition for Ethernet DMA Current Host Receive Descriptor Register */
#define ETH_DMACHRDR_HRDAP              ((unsigned int)0xFFFFFFFF)  /* Host receive descriptor address pointer */

/* Bit definition for Ethernet DMA Current Host Transmit Buffer Address Register */
#define ETH_DMACHTBAR_HTBAP             ((unsigned int)0xFFFFFFFF)  /* Host transmit buffer address pointer */

/* Bit definition for Ethernet DMA Current Host Receive Buffer Address Register */
#define ETH_DMACHRBAR_HRBAP             ((unsigned int)0xFFFFFFFF)  /* Host receive buffer address pointer */

#define PHY_RESET_DELAY                 ((uint32_t)0x000FFFFF)
#define PHY_CONFIG_DELAY                ((uint32_t)0x00FFFFFF)
#define PHY_BMCR                        0x00
#define PHY_BMSR                        0x01
#define PHY_SR		                    0X11
#define PHY_DUPLEX_STATUS               (1<<13)
#define PHY_SPEED_STATUS                (0XC000)

/**--------------------------------------------------------------------------**/
/**
* @brief                 Ethernet DMA descriptors registers bits definition
*/
/**--------------------------------------------------------------------------**/

/**
@code
DMA Tx Desciptor
-----------------------------------------------------------------------------------------------
TDES0 | OWN(31) | CTRL[30:26] | Reserved[25:24] | CTRL[23:20] | Reserved[19:17] | Status[16:0] |
-----------------------------------------------------------------------------------------------
TDES1 |                          Reserved[31:13]                     | Buffer1 ByteCount[12:0] |
-----------------------------------------------------------------------------------------------
TDES2 |                         Buffer1 Address [31:0]                                         |
-----------------------------------------------------------------------------------------------
TDES3 |                   Buffer2 Address [31:0] / Next Descriptor Address [31:0]              |
-----------------------------------------------------------------------------------------------
@endcode
*/

/**
* @brief  Bit definition of TDES0 register: DMA Tx descriptor status register
*/
#ifndef ETH_DMATxDesc_OWN
#define ETH_DMATxDesc_OWN                       ((unsigned int)0x80000000)  /*!< OWN bit: descriptor is owned by DMA engine */
#define ETH_DMATxDesc_IC                        ((unsigned int)0x40000000)  /*!< Interrupt on Completion */
#define ETH_DMATxDesc_LS                        ((unsigned int)0x20000000)  /*!< Last Segment */
#define ETH_DMATxDesc_FS                        ((unsigned int)0x10000000)  /*!< First Segment */
#define ETH_DMATxDesc_DC                        ((unsigned int)0x08000000)  /*!< Disable CRC */
#define ETH_DMATxDesc_DP                        ((unsigned int)0x04000000)  /*!< Disable Padding */
#define ETH_DMATxDesc_TTSE                      ((unsigned int)0x02000000)  /*!< Transmit Time Stamp Enable */
#define ETH_DMATxDesc_CIC                       ((unsigned int)0x00C00000)  /*!< Checksum Insertion Control: 4 cases */
#define ETH_DMATxDesc_CIC_ByPass                ((unsigned int)0x00000000)  /*!< Do Nothing: Checksum Engine is bypassed */
#define ETH_DMATxDesc_CIC_IPV4Header            ((unsigned int)0x00400000)  /*!< IPV4 header Checksum Insertion */
#define ETH_DMATxDesc_CIC_TCPUDPICMP_Segment    ((unsigned int)0x00800000)  /*!< TCP/UDP/ICMP Checksum Insertion calculated over segment only */
#define ETH_DMATxDesc_CIC_TCPUDPICMP_Full       ((unsigned int)0x00C00000)  /*!< TCP/UDP/ICMP Checksum Insertion fully calculated */
#define ETH_DMATxDesc_TER                       ((unsigned int)0x00200000)  /*!< Transmit End of Ring */
#define ETH_DMATxDesc_TCH                       ((unsigned int)0x00100000)  /*!< Second Address Chained */
#define ETH_DMATxDesc_TTSS                      ((unsigned int)0x00020000)  /*!< Tx Time Stamp Status */
#define ETH_DMATxDesc_IHE                       ((unsigned int)0x00010000)  /*!< IP Header Error */
#define ETH_DMATxDesc_ES                        ((unsigned int)0x00008000)  /*!< Error summary: OR of the following bits: UE || ED || EC || LCO || NC || LCA || FF || JT */
#define ETH_DMATxDesc_JT                        ((unsigned int)0x00004000)  /*!< Jabber Timeout */
#define ETH_DMATxDesc_FF                        ((unsigned int)0x00002000)  /*!< Frame Flushed: DMA/MTL flushed the frame due to SW flush */
#endif
#define ETH_DMATxDesc_PCE                       ((unsigned int)0x00001000)  /*!< Payload Checksum Error */
#define ETH_DMATxDesc_LCA                       ((unsigned int)0x00000800)  /*!< Loss of Carrier: carrier lost during transmission */
#define ETH_DMATxDesc_NC                        ((unsigned int)0x00000400)  /*!< No Carrier: no carrier signal from the transceiver */
#define ETH_DMATxDesc_LCO                       ((unsigned int)0x00000200)  /*!< Late Collision: transmission aborted due to collision */
#define ETH_DMATxDesc_EC                        ((unsigned int)0x00000100)  /*!< Excessive Collision: transmission aborted after 16 collisions */
#define ETH_DMATxDesc_VF                        ((unsigned int)0x00000080)  /*!< VLAN Frame */
#define ETH_DMATxDesc_CC                        ((unsigned int)0x00000078)  /*!< Collision Count */
#define ETH_DMATxDesc_ED                        ((unsigned int)0x00000004)  /*!< Excessive Deferral */
#define ETH_DMATxDesc_UF                        ((unsigned int)0x00000002)  /*!< Underflow Error: late data arrival from the memory */
#define ETH_DMATxDesc_DB                        ((unsigned int)0x00000001)  /*!< Deferred Bit */

/**
* @brief  Bit definition of TDES1 register
*/
#define ETH_DMATxDesc_TBS2                      ((unsigned int)0x1FFF0000)  /*!< Transmit Buffer2 Size */
#define ETH_DMATxDesc_TBS1                      ((unsigned int)0x00001FFF)  /*!< Transmit Buffer1 Size */

/**
* @brief  Bit definition of TDES2 register
*/
#define ETH_DMATxDesc_B1AP                      ((unsigned int)0xFFFFFFFF)  /*!< Buffer1 Address Pointer */

/**
* @brief  Bit definition of TDES3 register
*/
#define ETH_DMATxDesc_B2AP                      ((unsigned int)0xFFFFFFFF)  /*!< Buffer2 Address Pointer */

/**
* @}
*/


/** @defgroup DMA_Rx_descriptor 
* @{
*/

/**
@code 
DMA Rx Descriptor
--------------------------------------------------------------------------------------------------------------------
RDES0 | OWN(31) |                                             Status [30:0]                                          |
---------------------------------------------------------------------------------------------------------------------
RDES1 | DIC(31) | Reserved(31:16)|   RER(15)|         Reserved(14:13)                      | Buffer1 ByteCount[12:0] |
---------------------------------------------------------------------------------------------------------------------
RDES2 |                                       Buffer1 Address [31:0]                                                 |
---------------------------------------------------------------------------------------------------------------------
RDES3 |                          Buffer2 Address [31:0] / Next Descriptor Address [31:0]                             |
---------------------------------------------------------------------------------------------------------------------
@endcode
*/

/** 
* @brief  Bit definition of RDES0 register: DMA Rx descriptor status register
*/
#define ETH_DMARxDesc_OWN           ((unsigned int)0x80000000)  /*!< OWN bit: descriptor is owned by DMA engine  */
#define ETH_DMARxDesc_AFM           ((unsigned int)0x40000000)  /*!< DA Filter Fail for the rx frame  */
#define ETH_DMARxDesc_FL            ((unsigned int)0x3FFF0000)  /*!< Receive descriptor frame length  */
#define ETH_DMARxDesc_ES            ((unsigned int)0x00008000)  /*!< Error summary: OR of the following bits: DE || OE || IPC || LC || RWT || RE || CE */
#define ETH_DMARxDesc_DE            ((unsigned int)0x00004000)  /*!< Descriptor error: no more descriptors for receive frame  */
#define ETH_DMARxDesc_SAF           ((unsigned int)0x00002000)  /*!< SA Filter Fail for the received frame */
#define ETH_DMARxDesc_LE            ((unsigned int)0x00001000)  /*!< Frame size not matching with length field */
#define ETH_DMARxDesc_OE            ((unsigned int)0x00000800)  /*!< Overflow Error: Frame was damaged due to buffer overflow */
#define ETH_DMARxDesc_VLAN          ((unsigned int)0x00000400)  /*!< VLAN Tag: received frame is a VLAN frame */
#define ETH_DMARxDesc_FS            ((unsigned int)0x00000200)  /*!< First descriptor of the frame  */
#define ETH_DMARxDesc_LS            ((unsigned int)0x00000100)  /*!< Last descriptor of the frame  */
#define ETH_DMARxDesc_IPV4HCE       ((unsigned int)0x00000080)  /*!< IPC Checksum Error: Rx Ipv4 header checksum error   */
#define ETH_DMARxDesc_LC            ((unsigned int)0x00000040)  /*!< Late collision occurred during reception   */
#define ETH_DMARxDesc_FT            ((unsigned int)0x00000020)  /*!< Frame type - Ethernet, otherwise 802.3    */
#define ETH_DMARxDesc_RWT           ((unsigned int)0x00000010)  /*!< Receive Watchdog Timeout: watchdog timer expired during reception    */
#define ETH_DMARxDesc_RE            ((unsigned int)0x00000008)  /*!< Receive error: error reported by MII interface  */
#define ETH_DMARxDesc_DBE           ((unsigned int)0x00000004)  /*!< Dribble bit error: frame contains non int multiple of 8 bits  */
#define ETH_DMARxDesc_CE            ((unsigned int)0x00000002)  /*!< CRC error */
#define ETH_DMARxDesc_MAMPCE        ((unsigned int)0x00000001)  /*!< Rx MAC Address/Payload Checksum Error: Rx MAC address matched/ Rx Payload Checksum Error */

/** 
* @brief  Bit definition of RDES1 register /* DMA不会使用下述的位
*/
#define ETH_DMARxDesc_DIC           ((unsigned int)0x80000000)  /*!< Disable Interrupt on Completion */
//#define ETH_DMARxDesc_RBS2        ((unsigned int)0x1FFF0000)  /*!< Receive Buffer2 Size */
#define ETH_DMARxDesc_RER           ((unsigned int)0x00008000)  /*!< Receive End of Ring */
//#define ETH_DMARxDesc_RCH         ((unsigned int)0x00004000)  /*!< Second Address Chained */
//#define ETH_DMARxDesc_RBS1        ((unsigned int)0x00001FFF)  /*!< Receive Buffer1 Size */

/** 
* @brief  Bit definition of RDES2 register
*/
#define ETH_DMARxDesc_B1AP          ((unsigned int)0xFFFFFFFF)  /*!< Buffer1 Address Pointer */

/** 
* @brief  Bit definition of RDES3 register
*/
#define ETH_DMARxDesc_B2AP          ((unsigned int)0xFFFFFFFF)  /*!< Buffer2 Address Pointer */

/**--------------------------------------------------------------------------**/
/** 
* @brief                     Description of common PHY registers
*/
/**--------------------------------------------------------------------------**/

/**
* @}
*/

/** @defgroup PHY_Read_write_Timeouts 
* @{
*/
#define PHY_READ_TO                 ((unsigned int)0x0004FFFF)
#define PHY_WRITE_TO                ((unsigned int)0x0004FFFF)

/**
* @}
*/

/** @defgroup PHY_Register_address 
* @{
*/
#define PHY_BCR                     0          /*!< Transceiver Basic Control Register */
#define PHY_BSR                     1          /*!< Transceiver Basic Status Register */

#define IS_ETH_PHY_ADDRESS(ADDRESS) ((ADDRESS) <= 0x20)
#define IS_ETH_PHY_REG(REG) (((REG) == PHY_BCR) || \
                         ((REG) == PHY_BSR) || \
                         ((REG) == PHY_SR))
/**
* @}
*/

/** @defgroup PHY_basic_Control_register 
* @{
*/
#define PHY_Reset                       ((uint16_t)0x8000)      /*!< PHY Reset */
#define PHY_Loopback                    ((uint16_t)0x4000)      /*!< Select loop-back mode */
#define PHY_FULLDUPLEX_100M             ((uint16_t)0x2100)      /*!< Set the full-duplex mode at 100 Mb/s */
#define PHY_HALFDUPLEX_100M             ((uint16_t)0x2000)      /*!< Set the half-duplex mode at 100 Mb/s */
#define PHY_FULLDUPLEX_10M              ((uint16_t)0x0100)      /*!< Set the full-duplex mode at 10 Mb/s */
#define PHY_HALFDUPLEX_10M              ((uint16_t)0x0000)      /*!< Set the half-duplex mode at 10 Mb/s */
#define PHY_AutoNegotiation             ((uint16_t)0x1000)      /*!< Enable auto-negotiation function */
#define PHY_Restart_AutoNegotiation     ((uint16_t)0x0200)      /*!< Restart auto-negotiation function */
#define PHY_Powerdown                   ((uint16_t)0x0800)      /*!< Select the power down mode */
#define PHY_Isolate                     ((uint16_t)0x0400)      /*!< Isolate PHY from MII */

/**
* @}
*/

/** @defgroup PHY_basic_status_register 
* @{
*/
#define PHY_AutoNego_Complete           ((uint16_t)0x0020)      /*!< Auto-Negotiation process completed */
#define PHY_Linked_Status               ((uint16_t)0x0004)      /*!< Valid link established */
#define PHY_Jabber_detection            ((uint16_t)0x0002)      /*!< Jabber condition detected */

/**
* @}
*/

/**--------------------------------------------------------------------------**/
/** 
* @brief                                  MAC defines
*/
/**--------------------------------------------------------------------------**/

/** @defgroup ETH_AutoNegotiation 
* @{
*/
#define ETH_AutoNegotiation_Enable     ((unsigned int)0x00000001)
#define ETH_AutoNegotiation_Disable    ((unsigned int)0x00000000)
#define IS_ETH_AUTONEGOTIATION(CMD) (((CMD) == ETH_AutoNegotiation_Enable) || \
                                 ((CMD) == ETH_AutoNegotiation_Disable))

/**
* @}
*/

/** @defgroup ETH_watchdog 
* @{
*/
#define ETH_Watchdog_Enable       ((unsigned int)0x00000000)
#define ETH_Watchdog_Disable      ((unsigned int)0x00800000)
#define IS_ETH_WATCHDOG(CMD) (((CMD) == ETH_Watchdog_Enable) || \
                          ((CMD) == ETH_Watchdog_Disable))

/**
* @}
*/

/** @defgroup ETH_Jabber 
* @{
*/
#define ETH_Jabber_Enable    ((unsigned int)0x00000000)
#define ETH_Jabber_Disable   ((unsigned int)0x00400000)
#define IS_ETH_JABBER(CMD) (((CMD) == ETH_Jabber_Enable) || \
                        ((CMD) == ETH_Jabber_Disable))

/**
* @}
*/

/** @defgroup ETH_Inter_Frame_Gap 
* @{
*/
#define ETH_InterFrameGap_96Bit   ((unsigned int)0x00000000)  /*!< minimum IFG between frames during transmission is 96Bit */
#define ETH_InterFrameGap_88Bit   ((unsigned int)0x00020000)  /*!< minimum IFG between frames during transmission is 88Bit */
#define ETH_InterFrameGap_80Bit   ((unsigned int)0x00040000)  /*!< minimum IFG between frames during transmission is 80Bit */
#define ETH_InterFrameGap_72Bit   ((unsigned int)0x00060000)  /*!< minimum IFG between frames during transmission is 72Bit */
#define ETH_InterFrameGap_64Bit   ((unsigned int)0x00080000)  /*!< minimum IFG between frames during transmission is 64Bit */
#define ETH_InterFrameGap_56Bit   ((unsigned int)0x000A0000)  /*!< minimum IFG between frames during transmission is 56Bit */
#define ETH_InterFrameGap_48Bit   ((unsigned int)0x000C0000)  /*!< minimum IFG between frames during transmission is 48Bit */
#define ETH_InterFrameGap_40Bit   ((unsigned int)0x000E0000)  /*!< minimum IFG between frames during transmission is 40Bit */
#define IS_ETH_INTER_FRAME_GAP(GAP) (((GAP) == ETH_InterFrameGap_96Bit) || \
                                 ((GAP) == ETH_InterFrameGap_88Bit) || \
                                 ((GAP) == ETH_InterFrameGap_80Bit) || \
                                 ((GAP) == ETH_InterFrameGap_72Bit) || \
                                 ((GAP) == ETH_InterFrameGap_64Bit) || \
                                 ((GAP) == ETH_InterFrameGap_56Bit) || \
                                 ((GAP) == ETH_InterFrameGap_48Bit) || \
                                 ((GAP) == ETH_InterFrameGap_40Bit))

/**
* @}
*/

/** @defgroup ETH_Carrier_Sense 
* @{
*/
#define ETH_CarrierSense_Enable   ((unsigned int)0x00000000)
#define ETH_CarrierSense_Disable  ((unsigned int)0x00010000)
#define IS_ETH_CARRIER_SENSE(CMD) (((CMD) == ETH_CarrierSense_Enable) || \
                               ((CMD) == ETH_CarrierSense_Disable))

/**
* @}
*/

/** @defgroup ETH_Speed 
* @{
*/
#define ETH_Speed_10M        ((unsigned int)0x00000000)
#define ETH_Speed_100M       ((unsigned int)0x00004000)
#define ETH_Speed_1000M     ((unsigned int)0x00008000)
#define IS_ETH_SPEED(SPEED) (((SPEED) == ETH_Speed_10M) || \
                         ((SPEED) == ETH_Speed_100M))|| \
                         ((SPEED) == ETH_Speed_1000M))

/**
* @}
*/

/** @defgroup ETH_Receive_Own 
* @{
*/
#define ETH_ReceiveOwn_Enable     ((unsigned int)0x00000000)
#define ETH_ReceiveOwn_Disable    ((unsigned int)0x00002000)
#define IS_ETH_RECEIVE_OWN(CMD) (((CMD) == ETH_ReceiveOwn_Enable) || \
                             ((CMD) == ETH_ReceiveOwn_Disable))

/**
* @}
*/

/** @defgroup ETH_Loop_Back_Mode 
* @{
*/
#define ETH_LoopbackMode_Enable        ((unsigned int)0x00001000)
#define ETH_LoopbackMode_Disable       ((unsigned int)0x00000000)
#define IS_ETH_LOOPBACK_MODE(CMD) (((CMD) == ETH_LoopbackMode_Enable) || \
                               ((CMD) == ETH_LoopbackMode_Disable))

/**
* @}
*/

/** @defgroup ETH_Duplex_Mode 
* @{
*/
#define ETH_Mode_FullDuplex       ((unsigned int)0x00000800)
#define ETH_Mode_HalfDuplex       ((unsigned int)0x00000000)
#define IS_ETH_DUPLEX_MODE(MODE) (((MODE) == ETH_Mode_FullDuplex) || \
                              ((MODE) == ETH_Mode_HalfDuplex))

/**
* @}
*/

/** @defgroup ETH_Checksum_Offload 
* @{
*/
#define ETH_ChecksumOffload_Enable     ((unsigned int)0x00000400)
#define ETH_ChecksumOffload_Disable    ((unsigned int)0x00000000)
#define IS_ETH_CHECKSUM_OFFLOAD(CMD) (((CMD) == ETH_ChecksumOffload_Enable) || \
                                  ((CMD) == ETH_ChecksumOffload_Disable))

/**
* @}
*/

/** @defgroup ETH_Retry_Transmission 
* @{
*/
#define ETH_RetryTransmission_Enable   ((unsigned int)0x00000000)
#define ETH_RetryTransmission_Disable  ((unsigned int)0x00000200)
#define IS_ETH_RETRY_TRANSMISSION(CMD) (((CMD) == ETH_RetryTransmission_Enable) || \
                                    ((CMD) == ETH_RetryTransmission_Disable))

/**
* @}
*/

/** @defgroup ETH_Automatic_Pad_CRC_Strip 
* @{
*/
#define ETH_AutomaticPadCRCStrip_Enable     ((unsigned int)0x00000080)
#define ETH_AutomaticPadCRCStrip_Disable    ((unsigned int)0x00000000)
#define IS_ETH_AUTOMATIC_PADCRC_STRIP(CMD) (((CMD) == ETH_AutomaticPadCRCStrip_Enable) || \
                                        ((CMD) == ETH_AutomaticPadCRCStrip_Disable))

/**
* @}
*/

/** @defgroup ETH_Back_Off_Limit 
* @{
*/
#define ETH_BackOffLimit_10  ((unsigned int)0x00000000)
#define ETH_BackOffLimit_8   ((unsigned int)0x00000020)
#define ETH_BackOffLimit_4   ((unsigned int)0x00000040)
#define ETH_BackOffLimit_1   ((unsigned int)0x00000060)
#define IS_ETH_BACKOFF_LIMIT(LIMIT) (((LIMIT) == ETH_BackOffLimit_10) || \
                                 ((LIMIT) == ETH_BackOffLimit_8) || \
                                 ((LIMIT) == ETH_BackOffLimit_4) || \
                                 ((LIMIT) == ETH_BackOffLimit_1))

/**
* @}
*/

/** @defgroup ETH_Deferral_Check 
* @{
*/
#define ETH_DeferralCheck_Enable       ((unsigned int)0x00000010)
#define ETH_DeferralCheck_Disable      ((unsigned int)0x00000000)
#define IS_ETH_DEFERRAL_CHECK(CMD) (((CMD) == ETH_DeferralCheck_Enable) || \
                                ((CMD) == ETH_DeferralCheck_Disable))

/**
* @}
*/

/** @defgroup ETH_Receive_All 
* @{
*/
#define ETH_ReceiveAll_Enable     ((unsigned int)0x80000000)
#define ETH_ReceiveAll_Disable    ((unsigned int)0x00000000)
#define IS_ETH_RECEIVE_ALL(CMD) (((CMD) == ETH_ReceiveAll_Enable) || \
                             ((CMD) == ETH_ReceiveAll_Disable))

/**
* @}
*/

/** @defgroup ETH_Source_Addr_Filter 
* @{
*/
#define ETH_SourceAddrFilter_Normal_Enable       ((unsigned int)0x00000200)
#define ETH_SourceAddrFilter_Inverse_Enable      ((unsigned int)0x00000300)
#define ETH_SourceAddrFilter_Disable             ((unsigned int)0x00000000)
#define IS_ETH_SOURCE_ADDR_FILTER(CMD) (((CMD) == ETH_SourceAddrFilter_Normal_Enable) || \
                                    ((CMD) == ETH_SourceAddrFilter_Inverse_Enable) || \
                                    ((CMD) == ETH_SourceAddrFilter_Disable))

/**
* @}
*/

/** @defgroup ETH_Pass_Control_Frames 
* @{
*/
#define ETH_PassControlFrames_BlockAll                ((unsigned int)0x00000040)  /*!< MAC filters all control frames from reaching the application */
#define ETH_PassControlFrames_ForwardAll              ((unsigned int)0x00000080)  /*!< MAC forwards all control frames to application even if they fail the Address Filter */
#define ETH_PassControlFrames_ForwardPassedAddrFilter ((unsigned int)0x000000C0)  /*!< MAC forwards control frames that pass the Address Filter. */
#define IS_ETH_CONTROL_FRAMES(PASS) (((PASS) == ETH_PassControlFrames_BlockAll) || \
                                 ((PASS) == ETH_PassControlFrames_ForwardAll) || \
                                 ((PASS) == ETH_PassControlFrames_ForwardPassedAddrFilter))

/**
* @}
*/

/** @defgroup ETH_Broadcast_Frames_Reception 
* @{
*/
#define ETH_BroadcastFramesReception_Enable      ((unsigned int)0x00000000)
#define ETH_BroadcastFramesReception_Disable     ((unsigned int)0x00000020)
#define IS_ETH_BROADCAST_FRAMES_RECEPTION(CMD) (((CMD) == ETH_BroadcastFramesReception_Enable) || \
                                            ((CMD) == ETH_BroadcastFramesReception_Disable))

/**
* @}
*/

/** @defgroup ETH_Destination_Addr_Filter 
* @{
*/
#define ETH_DestinationAddrFilter_Normal    ((unsigned int)0x00000000)
#define ETH_DestinationAddrFilter_Inverse   ((unsigned int)0x00000008)
#define IS_ETH_DESTINATION_ADDR_FILTER(FILTER) (((FILTER) == ETH_DestinationAddrFilter_Normal) || \
                                            ((FILTER) == ETH_DestinationAddrFilter_Inverse))

/**
* @}
*/

/** @defgroup ETH_Promiscuous_Mode 
* @{
*/
#define ETH_PromiscuousMode_Enable     ((unsigned int)0x00000001)
#define ETH_PromiscuousMode_Disable    ((unsigned int)0x00000000)
#define IS_ETH_PROMISCUOUS_MODE(CMD) (((CMD) == ETH_PromiscuousMode_Enable) || \
                                  ((CMD) == ETH_PromiscuousMode_Disable))

/**
* @}
*/

/** @defgroup ETH_Multicast_Frames_Filter 
* @{
*/
#define ETH_MulticastFramesFilter_PerfectHashTable    ((unsigned int)0x00000404)
#define ETH_MulticastFramesFilter_HashTable           ((unsigned int)0x00000004)
#define ETH_MulticastFramesFilter_Perfect             ((unsigned int)0x00000000)
#define ETH_MulticastFramesFilter_None                ((unsigned int)0x00000010)
#define IS_ETH_MULTICAST_FRAMES_FILTER(FILTER) (((FILTER) == ETH_MulticastFramesFilter_PerfectHashTable) || \
                                            ((FILTER) == ETH_MulticastFramesFilter_HashTable) || \
                                            ((FILTER) == ETH_MulticastFramesFilter_Perfect) || \
                                            ((FILTER) == ETH_MulticastFramesFilter_None))


/**
* @}
*/

/** @defgroup ETH_Unicast_Frames_Filter 
* @{
*/
#define ETH_UnicastFramesFilter_PerfectHashTable ((unsigned int)0x00000402)
#define ETH_UnicastFramesFilter_HashTable        ((unsigned int)0x00000002)
#define ETH_UnicastFramesFilter_Perfect          ((unsigned int)0x00000000)
#define IS_ETH_UNICAST_FRAMES_FILTER(FILTER) (((FILTER) == ETH_UnicastFramesFilter_PerfectHashTable) || \
                                          ((FILTER) == ETH_UnicastFramesFilter_HashTable) || \
                                          ((FILTER) == ETH_UnicastFramesFilter_Perfect))

/**
* @}
*/

/** @defgroup ETH_Pause_Time 
* @{
*/
#define IS_ETH_PAUSE_TIME(TIME) ((TIME) <= 0xFFFF)

/**
* @}
*/

/** @defgroup ETH_Zero_Quanta_Pause 
* @{
*/
#define ETH_ZeroQuantaPause_Enable     ((unsigned int)0x00000000)
#define ETH_ZeroQuantaPause_Disable    ((unsigned int)0x00000080)
#define IS_ETH_ZEROQUANTA_PAUSE(CMD)   (((CMD) == ETH_ZeroQuantaPause_Enable) || \
                                    ((CMD) == ETH_ZeroQuantaPause_Disable))
/**
* @}
*/

/** @defgroup ETH_Pause_Low_Threshold 
* @{
*/
#define ETH_PauseLowThreshold_Minus4        ((unsigned int)0x00000000)  /*!< Pause time minus 4 slot times */
#define ETH_PauseLowThreshold_Minus28       ((unsigned int)0x00000010)  /*!< Pause time minus 28 slot times */
#define ETH_PauseLowThreshold_Minus144      ((unsigned int)0x00000020)  /*!< Pause time minus 144 slot times */
#define ETH_PauseLowThreshold_Minus256      ((unsigned int)0x00000030)  /*!< Pause time minus 256 slot times */
#define IS_ETH_PAUSE_LOW_THRESHOLD(THRESHOLD) (((THRESHOLD) == ETH_PauseLowThreshold_Minus4) || \
                                           ((THRESHOLD) == ETH_PauseLowThreshold_Minus28) || \
                                           ((THRESHOLD) == ETH_PauseLowThreshold_Minus144) || \
                                           ((THRESHOLD) == ETH_PauseLowThreshold_Minus256))

/**
* @}
*/

/** @defgroup ETH_Unicast_Pause_Frame_Detect 
* @{
*/
#define ETH_UnicastPauseFrameDetect_Enable  ((unsigned int)0x00000008)
#define ETH_UnicastPauseFrameDetect_Disable ((unsigned int)0x00000000)
#define IS_ETH_UNICAST_PAUSE_FRAME_DETECT(CMD) (((CMD) == ETH_UnicastPauseFrameDetect_Enable) || \
                                            ((CMD) == ETH_UnicastPauseFrameDetect_Disable))

/**
* @}
*/

/** @defgroup ETH_Receive_Flow_Control 
* @{
*/
#define ETH_ReceiveFlowControl_Enable       ((unsigned int)0x00000004)
#define ETH_ReceiveFlowControl_Disable      ((unsigned int)0x00000000)
#define IS_ETH_RECEIVE_FLOWCONTROL(CMD) (((CMD) == ETH_ReceiveFlowControl_Enable) || \
                                     ((CMD) == ETH_ReceiveFlowControl_Disable))

/**
* @}
*/

/** @defgroup ETH_Transmit_Flow_Control 
* @{
*/
#define ETH_TransmitFlowControl_Enable      ((unsigned int)0x00000002)
#define ETH_TransmitFlowControl_Disable     ((unsigned int)0x00000000)
#define IS_ETH_TRANSMIT_FLOWCONTROL(CMD) (((CMD) == ETH_TransmitFlowControl_Enable) || \
                                      ((CMD) == ETH_TransmitFlowControl_Disable))

/**
* @}
*/

/** @defgroup ETH_VLAN_Tag_Comparison 
* @{
*/
#define ETH_VLANTagComparison_12Bit    ((unsigned int)0x00010000)
#define ETH_VLANTagComparison_16Bit    ((unsigned int)0x00000000)
#define IS_ETH_VLAN_TAG_COMPARISON(COMPARISON) (((COMPARISON) == ETH_VLANTagComparison_12Bit) || \
                                            ((COMPARISON) == ETH_VLANTagComparison_16Bit))
#define IS_ETH_VLAN_TAG_IDENTIFIER(IDENTIFIER) ((IDENTIFIER) <= 0xFFFF)

/**
* @}
*/

/** @defgroup ETH_MAC_Flags 
* @{
*/
#define ETH_MAC_FLAG_TST     ((unsigned int)0x00000200)  /*!< Time stamp trigger flag (on MAC) */
#define ETH_MAC_FLAG_MMCT    ((unsigned int)0x00000040)  /*!< MMC transmit flag  */
#define ETH_MAC_FLAG_MMCR    ((unsigned int)0x00000020)  /*!< MMC receive flag */
#define ETH_MAC_FLAG_MMC     ((unsigned int)0x00000010)  /*!< MMC flag (on MAC) */
#define ETH_MAC_FLAG_PMT     ((unsigned int)0x00000008)  /*!< PMT flag (on MAC) */
#define IS_ETH_MAC_GET_FLAG(FLAG) (((FLAG) == ETH_MAC_FLAG_TST) || ((FLAG) == ETH_MAC_FLAG_MMCT) || \
                               ((FLAG) == ETH_MAC_FLAG_MMCR) || ((FLAG) == ETH_MAC_FLAG_MMC) || \
                               ((FLAG) == ETH_MAC_FLAG_PMT))
/**
* @}
*/

/** @defgroup ETH_MAC_Interrupts 
* @{
*/
#define ETH_MAC_IT_TST       ((unsigned int)0x00000200)  /*!< Time stamp trigger interrupt (on MAC) */
#define ETH_MAC_IT_MMCT      ((unsigned int)0x00000040)  /*!< MMC transmit interrupt */
#define ETH_MAC_IT_MMCR      ((unsigned int)0x00000020)  /*!< MMC receive interrupt */
#define ETH_MAC_IT_MMC       ((unsigned int)0x00000010)  /*!< MMC interrupt (on MAC) */
#define ETH_MAC_IT_PMT       ((unsigned int)0x00000008)  /*!< PMT interrupt (on MAC) */
#define IS_ETH_MAC_IT(IT) ((((IT) & (unsigned int)0xFFFFFDF7) == 0x00) && ((IT) != 0x00))
#define IS_ETH_MAC_GET_IT(IT) (((IT) == ETH_MAC_IT_TST) || ((IT) == ETH_MAC_IT_MMCT) || \
                           ((IT) == ETH_MAC_IT_MMCR) || ((IT) == ETH_MAC_IT_MMC) || \
                           ((IT) == ETH_MAC_IT_PMT))
/**
* @}
*/

/** @defgroup ETH_MAC_addresses 
* @{
*/
#define ETH_MAC_Address0     ((unsigned int)0x00000000)
#define ETH_MAC_Address1     ((unsigned int)0x00000008)
#define ETH_MAC_Address2     ((unsigned int)0x00000010)
#define ETH_MAC_Address3     ((unsigned int)0x00000018)
#define IS_ETH_MAC_ADDRESS0123(ADDRESS) (((ADDRESS) == ETH_MAC_Address0) || \
                                     ((ADDRESS) == ETH_MAC_Address1) || \
                                     ((ADDRESS) == ETH_MAC_Address2) || \
                                     ((ADDRESS) == ETH_MAC_Address3))
#define IS_ETH_MAC_ADDRESS123(ADDRESS) (((ADDRESS) == ETH_MAC_Address1) || \
                                    ((ADDRESS) == ETH_MAC_Address2) || \
                                    ((ADDRESS) == ETH_MAC_Address3))
/**
* @}
*/

/** @defgroup ETH_MAC_addresses_filter_SA_DA_filed_of_received_frames 
* @{
*/
#define ETH_MAC_AddressFilter_SA       ((unsigned int)0x00000000)
#define ETH_MAC_AddressFilter_DA       ((unsigned int)0x00000008)
#define IS_ETH_MAC_ADDRESS_FILTER(FILTER) (((FILTER) == ETH_MAC_AddressFilter_SA) || \
                                       ((FILTER) == ETH_MAC_AddressFilter_DA))
/**
* @}
*/

/** @defgroup ETH_MAC_addresses_filter_Mask_bytes 
* @{
*/
#define ETH_MAC_AddressMask_Byte6      ((unsigned int)0x20000000)  /*!< Mask MAC Address high reg bits [15:8] */
#define ETH_MAC_AddressMask_Byte5      ((unsigned int)0x10000000)  /*!< Mask MAC Address high reg bits [7:0] */
#define ETH_MAC_AddressMask_Byte4      ((unsigned int)0x08000000)  /*!< Mask MAC Address low reg bits [31:24] */
#define ETH_MAC_AddressMask_Byte3      ((unsigned int)0x04000000)  /*!< Mask MAC Address low reg bits [23:16] */
#define ETH_MAC_AddressMask_Byte2      ((unsigned int)0x02000000)  /*!< Mask MAC Address low reg bits [15:8] */
#define ETH_MAC_AddressMask_Byte1      ((unsigned int)0x01000000)  /*!< Mask MAC Address low reg bits [70] */
#define IS_ETH_MAC_ADDRESS_MASK(MASK) (((MASK) == ETH_MAC_AddressMask_Byte6) || \
                                   ((MASK) == ETH_MAC_AddressMask_Byte5) || \
                                   ((MASK) == ETH_MAC_AddressMask_Byte4) || \
                                   ((MASK) == ETH_MAC_AddressMask_Byte3) || \
                                   ((MASK) == ETH_MAC_AddressMask_Byte2) || \
                                   ((MASK) == ETH_MAC_AddressMask_Byte1))

/**--------------------------------------------------------------------------**/
/** 
* @brief                      Ethernet DMA Descriptors defines
*/
/**--------------------------------------------------------------------------**/
/**
* @}
*/

/** @defgroup ETH_DMA_Tx_descriptor_flags
* @{
*/
#define IS_ETH_DMATxDESC_GET_FLAG(FLAG) (((FLAG) == ETH_DMATxDesc_OWN) || \
                                     ((FLAG) == ETH_DMATxDesc_IC) || \
                                     ((FLAG) == ETH_DMATxDesc_LS) || \
                                     ((FLAG) == ETH_DMATxDesc_FS) || \
                                     ((FLAG) == ETH_DMATxDesc_DC) || \
                                     ((FLAG) == ETH_DMATxDesc_DP) || \
                                     ((FLAG) == ETH_DMATxDesc_TTSE) || \
                                     ((FLAG) == ETH_DMATxDesc_TER) || \
                                     ((FLAG) == ETH_DMATxDesc_TCH) || \
                                     ((FLAG) == ETH_DMATxDesc_TTSS) || \
                                     ((FLAG) == ETH_DMATxDesc_IHE) || \
                                     ((FLAG) == ETH_DMATxDesc_ES) || \
                                     ((FLAG) == ETH_DMATxDesc_JT) || \
                                     ((FLAG) == ETH_DMATxDesc_FF) || \
                                     ((FLAG) == ETH_DMATxDesc_PCE) || \
                                     ((FLAG) == ETH_DMATxDesc_LCA) || \
                                     ((FLAG) == ETH_DMATxDesc_NC) || \
                                     ((FLAG) == ETH_DMATxDesc_LCO) || \
                                     ((FLAG) == ETH_DMATxDesc_EC) || \
                                     ((FLAG) == ETH_DMATxDesc_VF) || \
                                     ((FLAG) == ETH_DMATxDesc_CC) || \
                                     ((FLAG) == ETH_DMATxDesc_ED) || \
                                     ((FLAG) == ETH_DMATxDesc_UF) || \
                                     ((FLAG) == ETH_DMATxDesc_DB))

/**
* @}
*/

/** @defgroup ETH_DMA_Tx_descriptor_segment 
* @{
*/
#define ETH_DMATxDesc_LastSegment      ((unsigned int)0x40000000)  /*!< Last Segment */
#define ETH_DMATxDesc_FirstSegment     ((unsigned int)0x20000000)  /*!< First Segment */
#define IS_ETH_DMA_TXDESC_SEGMENT(SEGMENT) (((SEGMENT) == ETH_DMATxDesc_LastSegment) || \
                                        ((SEGMENT) == ETH_DMATxDesc_FirstSegment))

/**
* @}
*/

/** @defgroup ETH_DMA_Tx_descriptor_Checksum_Insertion_Control
* @{
*/
#define ETH_DMATxDesc_ChecksumByPass             ((unsigned int)0x00000000)   /*!< Checksum engine bypass */
#define ETH_DMATxDesc_ChecksumIPV4Header         ((unsigned int)0x00400000)   /*!< IPv4 header checksum insertion  */
#define ETH_DMATxDesc_ChecksumTCPUDPICMPSegment  ((unsigned int)0x00800000)   /*!< TCP/UDP/ICMP checksum insertion. Pseudo header checksum is assumed to be present */
#define ETH_DMATxDesc_ChecksumTCPUDPICMPFull     ((unsigned int)0x00C00000)   /*!< TCP/UDP/ICMP checksum fully in hardware including pseudo header */
#define IS_ETH_DMA_TXDESC_CHECKSUM(CHECKSUM) (((CHECKSUM) == ETH_DMATxDesc_ChecksumByPass) || \
                                          ((CHECKSUM) == ETH_DMATxDesc_ChecksumIPV4Header) || \
                                          ((CHECKSUM) == ETH_DMATxDesc_ChecksumTCPUDPICMPSegment) || \
                                          ((CHECKSUM) == ETH_DMATxDesc_ChecksumTCPUDPICMPFull))
/** 
* @brief  ETH DMA Tx Desciptor buffer size
*/
#define IS_ETH_DMATxDESC_BUFFER_SIZE(SIZE) ((SIZE) <= 0x1FFF)

/**
* @}
*/

/** @defgroup ETH_DMA_Rx_descriptor_flags
* @{
*/
#define IS_ETH_DMARxDESC_GET_FLAG(FLAG) (((FLAG) == ETH_DMARxDesc_OWN) || \
                                     ((FLAG) == ETH_DMARxDesc_AFM) || \
                                     ((FLAG) == ETH_DMARxDesc_ES) || \
                                     ((FLAG) == ETH_DMARxDesc_DE) || \
                                     ((FLAG) == ETH_DMARxDesc_SAF) || \
                                     ((FLAG) == ETH_DMARxDesc_LE) || \
                                     ((FLAG) == ETH_DMARxDesc_OE) || \
                                     ((FLAG) == ETH_DMARxDesc_VLAN) || \
                                     ((FLAG) == ETH_DMARxDesc_FS) || \
                                     ((FLAG) == ETH_DMARxDesc_LS) || \
                                     ((FLAG) == ETH_DMARxDesc_IPV4HCE) || \
                                     ((FLAG) == ETH_DMARxDesc_LC) || \
                                     ((FLAG) == ETH_DMARxDesc_FT) || \
                                     ((FLAG) == ETH_DMARxDesc_RWT) || \
                                     ((FLAG) == ETH_DMARxDesc_RE) || \
                                     ((FLAG) == ETH_DMARxDesc_DBE) || \
                                     ((FLAG) == ETH_DMARxDesc_CE) || \
                                     ((FLAG) == ETH_DMARxDesc_MAMPCE))

/* ETHERNET DMA PTP Rx descriptor extended flags  --------------------------------*/
#define IS_ETH_DMAPTPRxDESC_GET_EXTENDED_FLAG(FLAG) (((FLAG) == ETH_DMAPTPRxDesc_PTPV) || \
                                                 ((FLAG) == ETH_DMAPTPRxDesc_PTPFT) || \
                                                 ((FLAG) == ETH_DMAPTPRxDesc_PTPMT) || \
                                                 ((FLAG) == ETH_DMAPTPRxDesc_IPV6PR) || \
                                                 ((FLAG) == ETH_DMAPTPRxDesc_IPV4PR) || \
                                                 ((FLAG) == ETH_DMAPTPRxDesc_IPCB) || \
                                                 ((FLAG) == ETH_DMAPTPRxDesc_IPPE) || \
                                                 ((FLAG) == ETH_DMAPTPRxDesc_IPHE) || \
                                                 ((FLAG) == ETH_DMAPTPRxDesc_IPPT))

/**
* @}
*/

/** @defgroup ETH_DMA_Rx_descriptor_buffers_ 
* @{
*/
#define ETH_DMARxDesc_Buffer1     ((unsigned int)0x00000000)  /*!< DMA Rx Desc Buffer1 */
#define ETH_DMARxDesc_Buffer2     ((unsigned int)0x00000001)  /*!< DMA Rx Desc Buffer2 */
#define IS_ETH_DMA_RXDESC_BUFFER(BUFFER) (((BUFFER) == ETH_DMARxDesc_Buffer1) || \
                                      ((BUFFER) == ETH_DMARxDesc_Buffer2))

/**--------------------------------------------------------------------------**/
/** 
* @brief                           Ethernet DMA defines
*/
/**--------------------------------------------------------------------------**/
/**
* @}
*/

/** @defgroup ETH_Drop_TCP_IP_Checksum_Error_Frame 
* @{
*/
#define ETH_DropTCPIPChecksumErrorFrame_Enable   ((unsigned int)0x00000000)
#define ETH_DropTCPIPChecksumErrorFrame_Disable  ((unsigned int)0x04000000)
#define IS_ETH_DROP_TCPIP_CHECKSUM_FRAME(CMD) (((CMD) == ETH_DropTCPIPChecksumErrorFrame_Enable) || \
                                           ((CMD) == ETH_DropTCPIPChecksumErrorFrame_Disable))
/**
* @}
*/

/** @defgroup ETH_Receive_Store_Forward 
* @{
*/
#define ETH_ReceiveStoreForward_Enable      ((unsigned int)0x02000000)
#define ETH_ReceiveStoreForward_Disable     ((unsigned int)0x00000000)
#define IS_ETH_RECEIVE_STORE_FORWARD(CMD) (((CMD) == ETH_ReceiveStoreForward_Enable) || \
                                       ((CMD) == ETH_ReceiveStoreForward_Disable))
/**
* @}
*/

/** @defgroup ETH_Flush_Received_Frame 
* @{
*/
#define ETH_FlushReceivedFrame_Enable       ((unsigned int)0x00000000)
#define ETH_FlushReceivedFrame_Disable      ((unsigned int)0x01000000)
#define IS_ETH_FLUSH_RECEIVE_FRAME(CMD) (((CMD) == ETH_FlushReceivedFrame_Enable) || \
                                     ((CMD) == ETH_FlushReceivedFrame_Disable))
/**
* @}
*/

/** @defgroup ETH_Transmit_Store_Forward 
* @{
*/
#define ETH_TransmitStoreForward_Enable     ((unsigned int)0x00200000)
#define ETH_TransmitStoreForward_Disable    ((unsigned int)0x00000000)
#define IS_ETH_TRANSMIT_STORE_FORWARD(CMD) (((CMD) == ETH_TransmitStoreForward_Enable) || \
                                        ((CMD) == ETH_TransmitStoreForward_Disable))
/**
* @}
*/

/** @defgroup ETH_Transmit_Threshold_Control 
* @{
*/
#define ETH_TransmitThresholdControl_64Bytes     ((unsigned int)0x00000000)  /*!< threshold level of the MTL Transmit FIFO is 64 Bytes */
#define ETH_TransmitThresholdControl_128Bytes    ((unsigned int)0x00004000)  /*!< threshold level of the MTL Transmit FIFO is 128 Bytes */
#define ETH_TransmitThresholdControl_192Bytes    ((unsigned int)0x00008000)  /*!< threshold level of the MTL Transmit FIFO is 192 Bytes */
#define ETH_TransmitThresholdControl_256Bytes    ((unsigned int)0x0000C000)  /*!< threshold level of the MTL Transmit FIFO is 256 Bytes */
#define ETH_TransmitThresholdControl_40Bytes     ((unsigned int)0x00010000)  /*!< threshold level of the MTL Transmit FIFO is 40 Bytes */
#define ETH_TransmitThresholdControl_32Bytes     ((unsigned int)0x00014000)  /*!< threshold level of the MTL Transmit FIFO is 32 Bytes */
#define ETH_TransmitThresholdControl_24Bytes     ((unsigned int)0x00018000)  /*!< threshold level of the MTL Transmit FIFO is 24 Bytes */
#define ETH_TransmitThresholdControl_16Bytes     ((unsigned int)0x0001C000)  /*!< threshold level of the MTL Transmit FIFO is 16 Bytes */
#define IS_ETH_TRANSMIT_THRESHOLD_CONTROL(THRESHOLD) (((THRESHOLD) == ETH_TransmitThresholdControl_64Bytes) || \
                                                  ((THRESHOLD) == ETH_TransmitThresholdControl_128Bytes) || \
                                                  ((THRESHOLD) == ETH_TransmitThresholdControl_192Bytes) || \
                                                  ((THRESHOLD) == ETH_TransmitThresholdControl_256Bytes) || \
                                                  ((THRESHOLD) == ETH_TransmitThresholdControl_40Bytes) || \
                                                  ((THRESHOLD) == ETH_TransmitThresholdControl_32Bytes) || \
                                                  ((THRESHOLD) == ETH_TransmitThresholdControl_24Bytes) || \
                                                  ((THRESHOLD) == ETH_TransmitThresholdControl_16Bytes))
/**
* @}
*/

/** @defgroup ETH_Forward_Error_Frames 
* @{
*/
#define ETH_ForwardErrorFrames_Enable       ((unsigned int)0x00000080)
#define ETH_ForwardErrorFrames_Disable      ((unsigned int)0x00000000)
#define IS_ETH_FORWARD_ERROR_FRAMES(CMD) (((CMD) == ETH_ForwardErrorFrames_Enable) || \
                                      ((CMD) == ETH_ForwardErrorFrames_Disable))
/**
* @}
*/

/** @defgroup ETH_Forward_Undersized_Good_Frames 
* @{
*/
#define ETH_ForwardUndersizedGoodFrames_Enable   ((unsigned int)0x00000040)
#define ETH_ForwardUndersizedGoodFrames_Disable  ((unsigned int)0x00000000)
#define IS_ETH_FORWARD_UNDERSIZED_GOOD_FRAMES(CMD) (((CMD) == ETH_ForwardUndersizedGoodFrames_Enable) || \
                                                ((CMD) == ETH_ForwardUndersizedGoodFrames_Disable))

/**
* @}
*/

/** @defgroup ETH_Receive_Threshold_Control 
* @{
*/
#define ETH_ReceiveThresholdControl_64Bytes      ((unsigned int)0x00000000)  /*!< threshold level of the MTL Receive FIFO is 64 Bytes */
#define ETH_ReceiveThresholdControl_32Bytes      ((unsigned int)0x00000008)  /*!< threshold level of the MTL Receive FIFO is 32 Bytes */
#define ETH_ReceiveThresholdControl_96Bytes      ((unsigned int)0x00000010)  /*!< threshold level of the MTL Receive FIFO is 96 Bytes */
#define ETH_ReceiveThresholdControl_128Bytes     ((unsigned int)0x00000018)  /*!< threshold level of the MTL Receive FIFO is 128 Bytes */
#define IS_ETH_RECEIVE_THRESHOLD_CONTROL(THRESHOLD) (((THRESHOLD) == ETH_ReceiveThresholdControl_64Bytes) || \
                                                 ((THRESHOLD) == ETH_ReceiveThresholdControl_32Bytes) || \
                                                 ((THRESHOLD) == ETH_ReceiveThresholdControl_96Bytes) || \
                                                 ((THRESHOLD) == ETH_ReceiveThresholdControl_128Bytes))
/**
* @}
*/

/** @defgroup ETH_Second_Frame_Operate 
* @{
*/
#define ETH_SecondFrameOperate_Enable       ((unsigned int)0x00000004)
#define ETH_SecondFrameOperate_Disable      ((unsigned int)0x00000000)
#define IS_ETH_SECOND_FRAME_OPERATE(CMD) (((CMD) == ETH_SecondFrameOperate_Enable) || \
                                          ((CMD) == ETH_SecondFrameOperate_Disable))

/**
* @}
*/

/** @defgroup ETH_Address_Aligned_Beats 
* @{
*/
#define ETH_AddressAlignedBeats_Enable      ((unsigned int)0x02000000)
#define ETH_AddressAlignedBeats_Disable     ((unsigned int)0x00000000)
#define IS_ETH_ADDRESS_ALIGNED_BEATS(CMD) (((CMD) == ETH_AddressAlignedBeats_Enable) || \
                                           ((CMD) == ETH_AddressAlignedBeats_Disable))
/**
* @}
*/

/** @defgroup ETH_Fixed_Burst 
* @{
*/
#define ETH_FixedBurst_Enable     ((unsigned int)0x00010000)
#define ETH_FixedBurst_Disable    ((unsigned int)0x00000000)
#define IS_ETH_FIXED_BURST(CMD) (((CMD) == ETH_FixedBurst_Enable) || \
                                 ((CMD) == ETH_FixedBurst_Disable))

/**
* @}
*/

/** @defgroup ETH_Rx_DMA_Burst_Length 
* @{
*/
#define ETH_RxDMABurstLength_1Beat          ((unsigned int)0x00020000)  /*!< maximum number of beats to be transferred in one RxDMA transaction is 1 */
#define ETH_RxDMABurstLength_2Beat          ((unsigned int)0x00040000)  /*!< maximum number of beats to be transferred in one RxDMA transaction is 2 */
#define ETH_RxDMABurstLength_4Beat          ((unsigned int)0x00080000)  /*!< maximum number of beats to be transferred in one RxDMA transaction is 4 */
#define ETH_RxDMABurstLength_8Beat          ((unsigned int)0x00100000)  /*!< maximum number of beats to be transferred in one RxDMA transaction is 8 */
#define ETH_RxDMABurstLength_16Beat         ((unsigned int)0x00200000)  /*!< maximum number of beats to be transferred in one RxDMA transaction is 16 */
#define ETH_RxDMABurstLength_32Beat         ((unsigned int)0x00400000)  /*!< maximum number of beats to be transferred in one RxDMA transaction is 32 */
#define ETH_RxDMABurstLength_4xPBL_4Beat    ((unsigned int)0x01020000)  /*!< maximum number of beats to be transferred in one RxDMA transaction is 4 */
#define ETH_RxDMABurstLength_4xPBL_8Beat    ((unsigned int)0x01040000)  /*!< maximum number of beats to be transferred in one RxDMA transaction is 8 */
#define ETH_RxDMABurstLength_4xPBL_16Beat   ((unsigned int)0x01080000)  /*!< maximum number of beats to be transferred in one RxDMA transaction is 16 */
#define ETH_RxDMABurstLength_4xPBL_32Beat   ((unsigned int)0x01100000)  /*!< maximum number of beats to be transferred in one RxDMA transaction is 32 */
#define ETH_RxDMABurstLength_4xPBL_64Beat   ((unsigned int)0x01200000)  /*!< maximum number of beats to be transferred in one RxDMA transaction is 64 */
#define ETH_RxDMABurstLength_4xPBL_128Beat  ((unsigned int)0x01400000)  /*!< maximum number of beats to be transferred in one RxDMA transaction is 128 */

#define IS_ETH_RXDMA_BURST_LENGTH(LENGTH) (((LENGTH) == ETH_RxDMABurstLength_1Beat) || \
                                       ((LENGTH) == ETH_RxDMABurstLength_2Beat) || \
                                       ((LENGTH) == ETH_RxDMABurstLength_4Beat) || \
                                       ((LENGTH) == ETH_RxDMABurstLength_8Beat) || \
                                       ((LENGTH) == ETH_RxDMABurstLength_16Beat) || \
                                       ((LENGTH) == ETH_RxDMABurstLength_32Beat) || \
                                       ((LENGTH) == ETH_RxDMABurstLength_4xPBL_4Beat) || \
                                       ((LENGTH) == ETH_RxDMABurstLength_4xPBL_8Beat) || \
                                       ((LENGTH) == ETH_RxDMABurstLength_4xPBL_16Beat) || \
                                       ((LENGTH) == ETH_RxDMABurstLength_4xPBL_32Beat) || \
                                       ((LENGTH) == ETH_RxDMABurstLength_4xPBL_64Beat) || \
                                       ((LENGTH) == ETH_RxDMABurstLength_4xPBL_128Beat))

/**
* @}
*/

/** @defgroup ETH_Tx_DMA_Burst_Length 
* @{
*/
#define ETH_TxDMABurstLength_1Beat          ((unsigned int)0x00000100)  /*!< maximum number of beats to be transferred in one TxDMA (or both) transaction is 1 */
#define ETH_TxDMABurstLength_2Beat          ((unsigned int)0x00000200)  /*!< maximum number of beats to be transferred in one TxDMA (or both) transaction is 2 */
#define ETH_TxDMABurstLength_4Beat          ((unsigned int)0x00000400)  /*!< maximum number of beats to be transferred in one TxDMA (or both) transaction is 4 */
#define ETH_TxDMABurstLength_8Beat          ((unsigned int)0x00000800)  /*!< maximum number of beats to be transferred in one TxDMA (or both) transaction is 8 */
#define ETH_TxDMABurstLength_16Beat         ((unsigned int)0x00001000)  /*!< maximum number of beats to be transferred in one TxDMA (or both) transaction is 16 */
#define ETH_TxDMABurstLength_32Beat         ((unsigned int)0x00002000)  /*!< maximum number of beats to be transferred in one TxDMA (or both) transaction is 32 */
#define ETH_TxDMABurstLength_4xPBL_4Beat    ((unsigned int)0x01000100)  /*!< maximum number of beats to be transferred in one TxDMA (or both) transaction is 4 */
#define ETH_TxDMABurstLength_4xPBL_8Beat    ((unsigned int)0x01000200)  /*!< maximum number of beats to be transferred in one TxDMA (or both) transaction is 8 */
#define ETH_TxDMABurstLength_4xPBL_16Beat   ((unsigned int)0x01000400)  /*!< maximum number of beats to be transferred in one TxDMA (or both) transaction is 16 */
#define ETH_TxDMABurstLength_4xPBL_32Beat   ((unsigned int)0x01000800)  /*!< maximum number of beats to be transferred in one TxDMA (or both) transaction is 32 */
#define ETH_TxDMABurstLength_4xPBL_64Beat   ((unsigned int)0x01001000)  /*!< maximum number of beats to be transferred in one TxDMA (or both) transaction is 64 */
#define ETH_TxDMABurstLength_4xPBL_128Beat  ((unsigned int)0x01002000)  /*!< maximum number of beats to be transferred in one TxDMA (or both) transaction is 128 */

#define IS_ETH_TXDMA_BURST_LENGTH(LENGTH) (((LENGTH) == ETH_TxDMABurstLength_1Beat) || \
                                       ((LENGTH) == ETH_TxDMABurstLength_2Beat) || \
                                       ((LENGTH) == ETH_TxDMABurstLength_4Beat) || \
                                       ((LENGTH) == ETH_TxDMABurstLength_8Beat) || \
                                       ((LENGTH) == ETH_TxDMABurstLength_16Beat) || \
                                       ((LENGTH) == ETH_TxDMABurstLength_32Beat) || \
                                       ((LENGTH) == ETH_TxDMABurstLength_4xPBL_4Beat) || \
                                       ((LENGTH) == ETH_TxDMABurstLength_4xPBL_8Beat) || \
                                       ((LENGTH) == ETH_TxDMABurstLength_4xPBL_16Beat) || \
                                       ((LENGTH) == ETH_TxDMABurstLength_4xPBL_32Beat) || \
                                       ((LENGTH) == ETH_TxDMABurstLength_4xPBL_64Beat) || \
                                       ((LENGTH) == ETH_TxDMABurstLength_4xPBL_128Beat))
/** 
* @brief  ETH DMA Descriptor SkipLength
*/
#define IS_ETH_DMA_DESC_SKIP_LENGTH(LENGTH) ((LENGTH) <= 0x1F)

/**
* @}
*/

/** @defgroup ETH_DMA_Arbitration 
* @{
*/
#define ETH_DMAArbitration_RoundRobin_RxTx_1_1   ((unsigned int)0x00000000)
#define ETH_DMAArbitration_RoundRobin_RxTx_2_1   ((unsigned int)0x00004000)
#define ETH_DMAArbitration_RoundRobin_RxTx_3_1   ((unsigned int)0x00008000)
#define ETH_DMAArbitration_RoundRobin_RxTx_4_1   ((unsigned int)0x0000C000)
#define ETH_DMAArbitration_RxPriorTx             ((unsigned int)0x00000002)
#define IS_ETH_DMA_ARBITRATION_ROUNDROBIN_RXTX(RATIO) (((RATIO) == ETH_DMAArbitration_RoundRobin_RxTx_1_1) || \
                                                   ((RATIO) == ETH_DMAArbitration_RoundRobin_RxTx_2_1) || \
                                                   ((RATIO) == ETH_DMAArbitration_RoundRobin_RxTx_3_1) || \
                                                   ((RATIO) == ETH_DMAArbitration_RoundRobin_RxTx_4_1) || \
                                                   ((RATIO) == ETH_DMAArbitration_RxPriorTx))
/**
* @}
*/

/** @defgroup ETH_DMA_Flags 
* @{
*/
#define ETH_DMA_FLAG_TST               ((unsigned int)0x20000000)  /*!< Time-stamp trigger interrupt (on DMA) */
#define ETH_DMA_FLAG_PMT               ((unsigned int)0x10000000)  /*!< PMT interrupt (on DMA) */
#define ETH_DMA_FLAG_MMC               ((unsigned int)0x08000000)  /*!< MMC interrupt (on DMA) */
#define ETH_DMA_FLAG_DataTransferError ((unsigned int)0x00800000)  /*!< Error bits 0-Rx DMA, 1-Tx DMA */
#define ETH_DMA_FLAG_ReadWriteError    ((unsigned int)0x01000000)  /*!< Error bits 0-write trnsf, 1-read transfr */
#define ETH_DMA_FLAG_AccessError       ((unsigned int)0x02000000)  /*!< Error bits 0-data buffer, 1-desc. access */
#define ETH_DMA_FLAG_NIS               ((unsigned int)0x00010000)  /*!< Normal interrupt summary flag */
#define ETH_DMA_FLAG_AIS               ((unsigned int)0x00008000)  /*!< Abnormal interrupt summary flag */
#define ETH_DMA_FLAG_ER                ((unsigned int)0x00004000)  /*!< Early receive flag */
#define ETH_DMA_FLAG_FBE               ((unsigned int)0x00002000)  /*!< Fatal bus error flag */
#define ETH_DMA_FLAG_ET                ((unsigned int)0x00000400)  /*!< Early transmit flag */
#define ETH_DMA_FLAG_RWT               ((unsigned int)0x00000200)  /*!< Receive watchdog timeout flag */
#define ETH_DMA_FLAG_RPS               ((unsigned int)0x00000100)  /*!< Receive process stopped flag */
#define ETH_DMA_FLAG_RBU               ((unsigned int)0x00000080)  /*!< Receive buffer unavailable flag */
#define ETH_DMA_FLAG_R                 ((unsigned int)0x00000040)  /*!< Receive flag */
#define ETH_DMA_FLAG_TU                ((unsigned int)0x00000020)  /*!< Underflow flag */
#define ETH_DMA_FLAG_RO                ((unsigned int)0x00000010)  /*!< Overflow flag */
#define ETH_DMA_FLAG_TJT               ((unsigned int)0x00000008)  /*!< Transmit jabber timeout flag */
#define ETH_DMA_FLAG_TBU               ((unsigned int)0x00000004)  /*!< Transmit buffer unavailable flag */
#define ETH_DMA_FLAG_TPS               ((unsigned int)0x00000002)  /*!< Transmit process stopped flag */
#define ETH_DMA_FLAG_T                 ((unsigned int)0x00000001)  /*!< Transmit flag */

#define IS_ETH_DMA_FLAG(FLAG) ((((FLAG) & (unsigned int)0xFFFE1800) == 0x00) && ((FLAG) != 0x00))
#define IS_ETH_DMA_GET_FLAG(FLAG) (((FLAG) == ETH_DMA_FLAG_TST) || ((FLAG) == ETH_DMA_FLAG_PMT) || \
                               ((FLAG) == ETH_DMA_FLAG_MMC) || ((FLAG) == ETH_DMA_FLAG_DataTransferError) || \
                               ((FLAG) == ETH_DMA_FLAG_ReadWriteError) || ((FLAG) == ETH_DMA_FLAG_AccessError) || \
                               ((FLAG) == ETH_DMA_FLAG_NIS) || ((FLAG) == ETH_DMA_FLAG_AIS) || \
                               ((FLAG) == ETH_DMA_FLAG_ER) || ((FLAG) == ETH_DMA_FLAG_FBE) || \
                               ((FLAG) == ETH_DMA_FLAG_ET) || ((FLAG) == ETH_DMA_FLAG_RWT) || \
                               ((FLAG) == ETH_DMA_FLAG_RPS) || ((FLAG) == ETH_DMA_FLAG_RBU) || \
                               ((FLAG) == ETH_DMA_FLAG_R) || ((FLAG) == ETH_DMA_FLAG_TU) || \
                               ((FLAG) == ETH_DMA_FLAG_RO) || ((FLAG) == ETH_DMA_FLAG_TJT) || \
                               ((FLAG) == ETH_DMA_FLAG_TBU) || ((FLAG) == ETH_DMA_FLAG_TPS) || \
                               ((FLAG) == ETH_DMA_FLAG_T))
/**
* @}
*/

/** @defgroup ETH_DMA_Interrupts 
* @{
*/
#define ETH_DMA_IT_TST       ((unsigned int)0x20000000)  /*!< Time-stamp trigger interrupt (on DMA) */
#define ETH_DMA_IT_PMT       ((unsigned int)0x10000000)  /*!< PMT interrupt (on DMA) */
#define ETH_DMA_IT_MMC       ((unsigned int)0x08000000)  /*!< MMC interrupt (on DMA) */
#define ETH_DMA_IT_NIS       ((unsigned int)0x00010000)  /*!< Normal interrupt summary */
#define ETH_DMA_IT_AIS       ((unsigned int)0x00008000)  /*!< Abnormal interrupt summary */
#define ETH_DMA_IT_ER        ((unsigned int)0x00004000)  /*!< Early receive interrupt */
#define ETH_DMA_IT_FBE       ((unsigned int)0x00002000)  /*!< Fatal bus error interrupt */
#define ETH_DMA_IT_ET        ((unsigned int)0x00000400)  /*!< Early transmit interrupt */
#define ETH_DMA_IT_RWT       ((unsigned int)0x00000200)  /*!< Receive watchdog timeout interrupt */
#define ETH_DMA_IT_RPS       ((unsigned int)0x00000100)  /*!< Receive process stopped interrupt */
#define ETH_DMA_IT_RBU       ((unsigned int)0x00000080)  /*!< Receive buffer unavailable interrupt */
#define ETH_DMA_IT_R         ((unsigned int)0x00000040)  /*!< Receive interrupt */
#define ETH_DMA_IT_TU        ((unsigned int)0x00000020)  /*!< Underflow interrupt */
#define ETH_DMA_IT_RO        ((unsigned int)0x00000010)  /*!< Overflow interrupt */
#define ETH_DMA_IT_TJT       ((unsigned int)0x00000008)  /*!< Transmit jabber timeout interrupt */
#define ETH_DMA_IT_TBU       ((unsigned int)0x00000004)  /*!< Transmit buffer unavailable interrupt */
#define ETH_DMA_IT_TPS       ((unsigned int)0x00000002)  /*!< Transmit process stopped interrupt */
#define ETH_DMA_IT_T         ((unsigned int)0x00000001)  /*!< Transmit interrupt */

#define IS_ETH_DMA_IT(IT) ((((IT) & (unsigned int)0xFFFE1800) == 0x00) && ((IT) != 0x00))
#define IS_ETH_DMA_GET_IT(IT) (((IT) == ETH_DMA_IT_TST) || ((IT) == ETH_DMA_IT_PMT) || \
                           ((IT) == ETH_DMA_IT_MMC) || ((IT) == ETH_DMA_IT_NIS) || \
                           ((IT) == ETH_DMA_IT_AIS) || ((IT) == ETH_DMA_IT_ER) || \
                           ((IT) == ETH_DMA_IT_FBE) || ((IT) == ETH_DMA_IT_ET) || \
                           ((IT) == ETH_DMA_IT_RWT) || ((IT) == ETH_DMA_IT_RPS) || \
                           ((IT) == ETH_DMA_IT_RBU) || ((IT) == ETH_DMA_IT_R) || \
                           ((IT) == ETH_DMA_IT_TU) || ((IT) == ETH_DMA_IT_RO) || \
                           ((IT) == ETH_DMA_IT_TJT) || ((IT) == ETH_DMA_IT_TBU) || \
                           ((IT) == ETH_DMA_IT_TPS) || ((IT) == ETH_DMA_IT_T))

/**
* @}
*/

/** @defgroup ETH_DMA_transmit_process_state_ 
* @{
*/
#define ETH_DMA_TransmitProcess_Stopped     ((unsigned int)0x00000000)  /*!< Stopped - Reset or Stop Tx Command issued */
#define ETH_DMA_TransmitProcess_Fetching    ((unsigned int)0x00100000)  /*!< Running - fetching the Tx descriptor */
#define ETH_DMA_TransmitProcess_Waiting     ((unsigned int)0x00200000)  /*!< Running - waiting for status */
#define ETH_DMA_TransmitProcess_Reading     ((unsigned int)0x00300000)  /*!< Running - reading the data from host memory */
#define ETH_DMA_TransmitProcess_Suspended   ((unsigned int)0x00600000)  /*!< Suspended - Tx Descriptor unavailable */
#define ETH_DMA_TransmitProcess_Closing     ((unsigned int)0x00700000)  /*!< Running - closing Rx descriptor */

/**
* @}
*/


/** @defgroup ETH_DMA_receive_process_state_ 
* @{
*/
#define ETH_DMA_ReceiveProcess_Stopped      ((unsigned int)0x00000000)  /*!< Stopped - Reset or Stop Rx Command issued */
#define ETH_DMA_ReceiveProcess_Fetching     ((unsigned int)0x00020000)  /*!< Running - fetching the Rx descriptor */
#define ETH_DMA_ReceiveProcess_Waiting      ((unsigned int)0x00060000)  /*!< Running - waiting for packet */
#define ETH_DMA_ReceiveProcess_Suspended    ((unsigned int)0x00080000)  /*!< Suspended - Rx Descriptor unavailable */
#define ETH_DMA_ReceiveProcess_Closing      ((unsigned int)0x000A0000)  /*!< Running - closing descriptor */
#define ETH_DMA_ReceiveProcess_Queuing      ((unsigned int)0x000E0000)  /*!< Running - queuing the receive frame into host memory */

/**
* @}
*/

/** @defgroup ETH_DMA_overflow_ 
* @{
*/
#define ETH_DMA_Overflow_RxFIFOCounter      ((unsigned int)0x10000000)  /*!< Overflow bit for FIFO overflow counter */
#define ETH_DMA_Overflow_MissedFrameCounter ((unsigned int)0x00010000)  /*!< Overflow bit for missed frame counter */
#define IS_ETH_DMA_GET_OVERFLOW(OVERFLOW) (((OVERFLOW) == ETH_DMA_Overflow_RxFIFOCounter) || \
                                       ((OVERFLOW) == ETH_DMA_Overflow_MissedFrameCounter))

/**--------------------------------------------------------------------------**/
/** 
* @brief                           Ethernet PMT defines
*/
/**--------------------------------------------------------------------------**/
/**
* @}
*/

/** @defgroup ETH_PMT_Flags 
* @{
*/
#define ETH_PMT_FLAG_WUFFRPR      ((unsigned int)0x80000000)  /*!< Wake-Up Frame Filter Register Pointer Reset */
#define ETH_PMT_FLAG_WUFR         ((unsigned int)0x00000040)  /*!< Wake-Up Frame Received */
#define ETH_PMT_FLAG_MPR          ((unsigned int)0x00000020)  /*!< Magic Packet Received */
#define IS_ETH_PMT_GET_FLAG(FLAG) (((FLAG) == ETH_PMT_FLAG_WUFR) || \
                                   ((FLAG) == ETH_PMT_FLAG_MPR))

/**--------------------------------------------------------------------------**/
/** 
* @brief                           Ethernet MMC defines
*/
/**--------------------------------------------------------------------------**/
/**
* @}
*/

/** @defgroup ETH_MMC_Tx_Interrupts 
* @{
*/
#define ETH_MMC_IT_TGF       ((unsigned int)0x00200000)  /*!< When Tx good frame counter reaches half the maximum value */
#define ETH_MMC_IT_TGFMSC    ((unsigned int)0x00008000)  /*!< When Tx good multi col counter reaches half the maximum value */
#define ETH_MMC_IT_TGFSC     ((unsigned int)0x00004000)  /*!< When Tx good single col counter reaches half the maximum value */

/**
* @}
*/

/** @defgroup ETH_MMC_Rx_Interrupts 
* @{
*/
#define ETH_MMC_IT_RGUF      ((unsigned int)0x10020000)  /*!< When Rx good unicast frames counter reaches half the maximum value */
#define ETH_MMC_IT_RFAE      ((unsigned int)0x10000040)  /*!< When Rx alignment error counter reaches half the maximum value */
#define ETH_MMC_IT_RFCE      ((unsigned int)0x10000020)  /*!< When Rx crc error counter reaches half the maximum value */
#define IS_ETH_MMC_IT(IT) (((((IT) & (unsigned int)0xFFDF3FFF) == 0x00) || (((IT) & (unsigned int)0xEFFDFF9F) == 0x00)) && \
                           ((IT) != 0x00))
#define IS_ETH_MMC_GET_IT(IT) (((IT) == ETH_MMC_IT_TGF) || ((IT) == ETH_MMC_IT_TGFMSC) || \
                           ((IT) == ETH_MMC_IT_TGFSC) || ((IT) == ETH_MMC_IT_RGUF) || \
                           ((IT) == ETH_MMC_IT_RFAE) || ((IT) == ETH_MMC_IT_RFCE))
/**
* @}
*/

/** @defgroup ETH_MMC_Registers 
* @{
*/
#define ETH_MMCCR            ((unsigned int)0x00000100)  /*!< MMC CR register */
#define ETH_MMCRIR           ((unsigned int)0x00000104)  /*!< MMC RIR register */
#define ETH_MMCTIR           ((unsigned int)0x00000108)  /*!< MMC TIR register */
#define ETH_MMCRIMR          ((unsigned int)0x0000010C)  /*!< MMC RIMR register */
#define ETH_MMCTIMR          ((unsigned int)0x00000110)  /*!< MMC TIMR register */
#define ETH_MMCTGFSCCR       ((unsigned int)0x0000014C)  /*!< MMC TGFSCCR register */
#define ETH_MMCTGFMSCCR      ((unsigned int)0x00000150)  /*!< MMC TGFMSCCR register */
#define ETH_MMCTGFCR         ((unsigned int)0x00000168)  /*!< MMC TGFCR register */
#define ETH_MMCRFCECR        ((unsigned int)0x00000194)  /*!< MMC RFCECR register */
#define ETH_MMCRFAECR        ((unsigned int)0x00000198)  /*!< MMC RFAECR register */
#define ETH_MMCRGUFCR        ((unsigned int)0x000001C4)  /*!< MMC RGUFCR register */

/** 
* @brief  ETH MMC registers
*/
#define IS_ETH_MMC_REGISTER(REG) (((REG) == ETH_MMCCR)  || ((REG) == ETH_MMCRIR) || \
                              ((REG) == ETH_MMCTIR)  || ((REG) == ETH_MMCRIMR) || \
                              ((REG) == ETH_MMCTIMR) || ((REG) == ETH_MMCTGFSCCR) || \
                              ((REG) == ETH_MMCTGFMSCCR) || ((REG) == ETH_MMCTGFCR) || \
                              ((REG) == ETH_MMCRFCECR) || ((REG) == ETH_MMCRFAECR) || \
                              ((REG) == ETH_MMCRGUFCR))

/**--------------------------------------------------------------------------**/
/** 
* @brief                           Ethernet PTP defines
*/
/**--------------------------------------------------------------------------**/
/**
* @}
*/

/** @defgroup ETH_PTP_time_update_method 
* @{
*/
#define ETH_PTP_FineUpdate        ((unsigned int)0x00000001)  /*!< Fine Update method */
#define ETH_PTP_CoarseUpdate      ((unsigned int)0x00000000)  /*!< Coarse Update method */
#define IS_ETH_PTP_UPDATE(UPDATE) (((UPDATE) == ETH_PTP_FineUpdate) || \
                                   ((UPDATE) == ETH_PTP_CoarseUpdate))

/**
* @}
*/


/** @defgroup ETH_PTP_Flags 
* @{
*/
#define ETH_PTP_FLAG_TSARU        ((unsigned int)0x00000020)  /*!< Addend Register Update */
#define ETH_PTP_FLAG_TSITE        ((unsigned int)0x00000010)  /*!< Time Stamp Interrupt Trigger */
#define ETH_PTP_FLAG_TSSTU        ((unsigned int)0x00000008)  /*!< Time Stamp Update */
#define ETH_PTP_FLAG_TSSTI        ((unsigned int)0x00000004)  /*!< Time Stamp Initialize */

#define ETH_PTP_FLAG_TSTTR        ((unsigned int)0x10000002)  /* Time stamp target time reached */
#define ETH_PTP_FLAG_TSSO         ((unsigned int)0x10000001)  /* Time stamp seconds overflow */

#define IS_ETH_PTP_GET_FLAG(FLAG) (((FLAG) == ETH_PTP_FLAG_TSARU) || \
                                ((FLAG) == ETH_PTP_FLAG_TSITE) || \
                                ((FLAG) == ETH_PTP_FLAG_TSSTU) || \
                                ((FLAG) == ETH_PTP_FLAG_TSSTI) || \
                                ((FLAG) == ETH_PTP_FLAG_TSTTR) || \
                                ((FLAG) == ETH_PTP_FLAG_TSSO))

/** 
* @brief  ETH PTP subsecond increment
*/
#define IS_ETH_PTP_SUBSECOND_INCREMENT(SUBSECOND) ((SUBSECOND) <= 0xFF)

/**
* @}
*/


/** @defgroup ETH_PTP_time_sign 
* @{
*/
#define ETH_PTP_PositiveTime      ((unsigned int)0x00000000)  /*!< Positive time value */
#define ETH_PTP_NegativeTime      ((unsigned int)0x80000000)  /*!< Negative time value */
#define IS_ETH_PTP_TIME_SIGN(SIGN) (((SIGN) == ETH_PTP_PositiveTime) || \
                                    ((SIGN) == ETH_PTP_NegativeTime))

/** 
* @brief  ETH PTP time stamp low update
*/
#define IS_ETH_PTP_TIME_STAMP_UPDATE_SUBSECOND(SUBSECOND) ((SUBSECOND) <= 0x7FFFFFFF)

/** 
* @brief  ETH PTP registers
*/
#define ETH_PTPTSCR     ((unsigned int)0x00000700)  /*!< PTP TSCR register */
#define ETH_PTPSSIR     ((unsigned int)0x00000704)  /*!< PTP SSIR register */
#define ETH_PTPTSHR     ((unsigned int)0x00000708)  /*!< PTP TSHR register */
#define ETH_PTPTSLR     ((unsigned int)0x0000070C)  /*!< PTP TSLR register */
#define ETH_PTPTSHUR    ((unsigned int)0x00000710)  /*!< PTP TSHUR register */
#define ETH_PTPTSLUR    ((unsigned int)0x00000714)  /*!< PTP TSLUR register */
#define ETH_PTPTSAR     ((unsigned int)0x00000718)  /*!< PTP TSAR register */
#define ETH_PTPTTHR     ((unsigned int)0x0000071C)  /*!< PTP TTHR register */
#define ETH_PTPTTLR     ((unsigned int)0x00000720)  /* PTP TTLR register */

#define ETH_PTPTSSR     ((unsigned int)0x00000728)  /* PTP TSSR register */

#define IS_ETH_PTP_REGISTER(REG) (((REG) == ETH_PTPTSCR) || ((REG) == ETH_PTPSSIR) || \
                               ((REG) == ETH_PTPTSHR) || ((REG) == ETH_PTPTSLR) || \
                               ((REG) == ETH_PTPTSHUR) || ((REG) == ETH_PTPTSLUR) || \
                               ((REG) == ETH_PTPTSAR) || ((REG) == ETH_PTPTTHR) || \
                               ((REG) == ETH_PTPTTLR) || ((REG) == ETH_PTPTSSR))

/** 
* @brief  ETHERNET PTP clock
*/
#define ETH_PTP_OrdinaryClock                   ((unsigned int)0x00000000)  /* Ordinary Clock */
#define ETH_PTP_BoundaryClock                   ((unsigned int)0x00010000)  /* Boundary Clock */
#define ETH_PTP_EndToEndTransparentClock        ((unsigned int)0x00020000)  /* End To End Transparent Clock */
#define ETH_PTP_PeerToPeerTransparentClock      ((unsigned int)0x00030000)  /* Peer To Peer Transparent Clock */

#define IS_ETH_PTP_TYPE_CLOCK(CLOCK) (((CLOCK) == ETH_PTP_OrdinaryClock) || \
                      ((CLOCK) == ETH_PTP_BoundaryClock) || \
                      ((CLOCK) == ETH_PTP_EndToEndTransparentClock) || \
                                  ((CLOCK) == ETH_PTP_PeerToPeerTransparentClock))
/** 
* @brief  ETHERNET snapshot
*/
#define ETH_PTP_SnapshotMasterMessage           ((unsigned int)0x00008000)  /* Time stamp snapshot for message relevant to master enable */
#define ETH_PTP_SnapshotEventMessage            ((unsigned int)0x00004000)  /* Time stamp snapshot for event message enable */
#define ETH_PTP_SnapshotIPV4Frames              ((unsigned int)0x00002000)  /* Time stamp snapshot for IPv4 frames enable */
#define ETH_PTP_SnapshotIPV6Frames              ((unsigned int)0x00001000)  /* Time stamp snapshot for IPv6 frames enable */
#define ETH_PTP_SnapshotPTPOverEthernetFrames   ((unsigned int)0x00000800)  /* Time stamp snapshot for PTP over ethernet frames enable */
#define ETH_PTP_SnapshotAllReceivedFrames       ((unsigned int)0x00000100)  /* Time stamp snapshot for all received frames enable */

#define IS_ETH_PTP_SNAPSHOT(SNAPSHOT) (((SNAPSHOT) == ETH_PTP_SnapshotMasterMessage) || \
                       ((SNAPSHOT) == ETH_PTP_SnapshotEventMessage) || \
                       ((SNAPSHOT) == ETH_PTP_SnapshotIPV4Frames) || \
                       ((SNAPSHOT) == ETH_PTP_SnapshotIPV6Frames) || \
                       ((SNAPSHOT) == ETH_PTP_SnapshotPTPOverEthernetFrames) || \
                       ((SNAPSHOT) == ETH_PTP_SnapshotAllReceivedFrames))

/**
* @}
*/
/* ETHERNET MAC address offsets */
#define ETH_MAC_ADDR_HBASE      (ETH_BASE + 0x40)  /* ETHERNET MAC address high offset */
#define ETH_MAC_ADDR_LBASE      (ETH_BASE + 0x44)  /* ETHERNET MAC address low offset */

/* ETHERNET MACMIIAR register Mask */
#define MACMIIAR_CR_MASK        ((unsigned int)0xFFFFFFE3)

/* ETHERNET MACCR register Mask */
#define MACCR_CLEAR_MASK        ((unsigned int)0xFF20810F)

/* ETHERNET MACFCR register Mask */
#define MACFCR_CLEAR_MASK       ((unsigned int)0x0000FF41)


/* ETHERNET DMAOMR register Mask */
#define DMAOMR_CLEAR_MASK       ((unsigned int)0xF8DE3F23)


/* ETHERNET Remote Wake-up frame register length */
#define ETH_WAKEUP_REGISTER_LENGTH                          8

/* ETHERNET Missed frames counter Shift */
#define  ETH_DMA_RX_OVERFLOW_MISSEDFRAMES_COUNTERSHIFT      17

/* ETHERNET DMA Tx descriptors Collision Count Shift */
#define  ETH_DMATXDESC_COLLISION_COUNTSHIFT                 3

/* ETHERNET DMA Tx descriptors Buffer2 Size Shift */
#define  ETH_DMATXDESC_BUFFER2_SIZESHIFT                    16

/* ETHERNET DMA Rx descriptors Frame Length Shift */
#define  ETH_DMARXDESC_FRAME_LENGTHSHIFT                    16

/* ETHERNET DMA Rx descriptors Buffer2 Size Shift */
#define  ETH_DMARXDESC_BUFFER2_SIZESHIFT                    16

/* ETHERNET errors */
#define  ETH_ERROR              ((unsigned int)0)
#define  ETH_SUCCESS            ((unsigned int)1)

#endif
/**
* @}
*/
void ETH_SoftwareReset(void);
void ETH_DMAClearITPendingBit(uint32_t ETH_DMA_IT);
void ETH_StructInit(ETH_InitTypeDef *ETH_InitStruct);
void RGMII_TXC_Delay(uint8_t clock_polarity,uint8_t delay_time);
uint16_t ETH_ReadPHYRegister(uint16_t PHYAddress, uint16_t PHYReg);
void ETH_DMAITConfig(uint32_t ETH_DMA_IT, FunctionalState NewState);
uint32_t ETH_WritePHYRegister(uint16_t PHYAddress, uint16_t PHYReg, uint16_t PHYValue);
void ETH_DMATxDescChainInit(ETH_DMADESCTypeDef *DMATxDescTab, uint8_t* TxBuff, uint32_t TxBuffCount);
void ETH_DMARxDescChainInit(ETH_DMADESCTypeDef *DMARxDescTab, uint8_t *RxBuff, uint32_t RxBuffCount);

#ifdef __cplusplus
}
#endif


