/********************************** (C) COPYRIGHT *******************************
* File Name          : CH56x_eth.c
* Author             : WCH
* Version            : V1.0
* Date               : 2023/03/03
* Description        : This file provides all the ETH firmware functions.
*********************************************************************************
* Copyright (c) 2021 Nanjing Qinheng Microelectronics Co., Ltd.
* Attention: This software (modified or not) and binary are used for 
* microcontroller manufactured by Nanjing Qinheng Microelectronics.
*******************************************************************************/

#include "CH56x_common.h"

ETH_DMADESCTypeDef *DMATxDescToSet;
ETH_DMADESCTypeDef *DMARxDescToGet;

/*********************************************************************
 * @fn      ETH_StructInit
 *
 * @brief   Fills each ETH_InitStruct member with its default value.
 *
 * @param   ETH_InitStruct - pointer to a ETH_InitTypeDef structure
 *        which will be initialized.
 *
 * @return  none
 */
void ETH_StructInit(ETH_InitTypeDef *ETH_InitStruct)
{
    /*------------------------   MAC   -----------------------------------*/
    ETH_InitStruct->ETH_AutoNegotiation = ETH_AutoNegotiation_Disable;
    ETH_InitStruct->ETH_Watchdog = ETH_Watchdog_Enable;
    ETH_InitStruct->ETH_Jabber = ETH_Jabber_Enable;
    ETH_InitStruct->ETH_InterFrameGap = ETH_InterFrameGap_96Bit;
    ETH_InitStruct->ETH_CarrierSense = ETH_CarrierSense_Enable;
    ETH_InitStruct->ETH_Speed = ETH_Speed_10M;
    ETH_InitStruct->ETH_ReceiveOwn = ETH_ReceiveOwn_Enable;
    ETH_InitStruct->ETH_LoopbackMode = ETH_LoopbackMode_Disable;
    ETH_InitStruct->ETH_Mode = ETH_Mode_HalfDuplex;
    ETH_InitStruct->ETH_ChecksumOffload = ETH_ChecksumOffload_Disable;
    ETH_InitStruct->ETH_RetryTransmission = ETH_RetryTransmission_Enable;
    ETH_InitStruct->ETH_AutomaticPadCRCStrip = ETH_AutomaticPadCRCStrip_Disable;
    ETH_InitStruct->ETH_BackOffLimit = ETH_BackOffLimit_10;
    ETH_InitStruct->ETH_DeferralCheck = ETH_DeferralCheck_Disable;
    ETH_InitStruct->ETH_ReceiveAll = ETH_ReceiveAll_Disable;
    ETH_InitStruct->ETH_SourceAddrFilter = ETH_SourceAddrFilter_Disable;
    ETH_InitStruct->ETH_PassControlFrames = ETH_PassControlFrames_BlockAll;
    ETH_InitStruct->ETH_BroadcastFramesReception = ETH_BroadcastFramesReception_Disable;
    ETH_InitStruct->ETH_DestinationAddrFilter = ETH_DestinationAddrFilter_Normal;
    ETH_InitStruct->ETH_PromiscuousMode = ETH_PromiscuousMode_Disable;
    ETH_InitStruct->ETH_MulticastFramesFilter = ETH_MulticastFramesFilter_Perfect;
    ETH_InitStruct->ETH_UnicastFramesFilter = ETH_UnicastFramesFilter_Perfect;
    ETH_InitStruct->ETH_HashTableHigh = 0x0;
    ETH_InitStruct->ETH_HashTableLow = 0x0;
    ETH_InitStruct->ETH_PauseTime = 0x0;
    ETH_InitStruct->ETH_ZeroQuantaPause = ETH_ZeroQuantaPause_Disable;
    ETH_InitStruct->ETH_PauseLowThreshold = ETH_PauseLowThreshold_Minus4;
    ETH_InitStruct->ETH_UnicastPauseFrameDetect = ETH_UnicastPauseFrameDetect_Disable;
    ETH_InitStruct->ETH_ReceiveFlowControl = ETH_ReceiveFlowControl_Disable;
    ETH_InitStruct->ETH_TransmitFlowControl = ETH_TransmitFlowControl_Disable;
    ETH_InitStruct->ETH_VLANTagComparison = ETH_VLANTagComparison_16Bit;
    ETH_InitStruct->ETH_VLANTagIdentifier = 0x0;
    /*------------------------   DMA   -----------------------------------*/
    ETH_InitStruct->ETH_DropTCPIPChecksumErrorFrame = ETH_DropTCPIPChecksumErrorFrame_Disable;
    ETH_InitStruct->ETH_ReceiveStoreForward = ETH_ReceiveStoreForward_Enable;
    ETH_InitStruct->ETH_FlushReceivedFrame = ETH_FlushReceivedFrame_Enable;
    ETH_InitStruct->ETH_TransmitStoreForward = ETH_TransmitStoreForward_Enable;
    ETH_InitStruct->ETH_TransmitThresholdControl = ETH_TransmitThresholdControl_64Bytes;
    ETH_InitStruct->ETH_ForwardErrorFrames = ETH_ForwardErrorFrames_Disable;
    ETH_InitStruct->ETH_ForwardUndersizedGoodFrames = ETH_ForwardUndersizedGoodFrames_Disable;
    ETH_InitStruct->ETH_ReceiveThresholdControl = ETH_ReceiveThresholdControl_64Bytes;
    ETH_InitStruct->ETH_SecondFrameOperate = ETH_SecondFrameOperate_Disable;
    ETH_InitStruct->ETH_AddressAlignedBeats = ETH_AddressAlignedBeats_Enable;
    ETH_InitStruct->ETH_FixedBurst = ETH_FixedBurst_Disable;
    ETH_InitStruct->ETH_RxDMABurstLength = ETH_RxDMABurstLength_1Beat;
    ETH_InitStruct->ETH_TxDMABurstLength = ETH_TxDMABurstLength_1Beat;
    ETH_InitStruct->ETH_DescriptorSkipLength = 0x0;
    ETH_InitStruct->ETH_DMAArbitration = ETH_DMAArbitration_RoundRobin_RxTx_1_1;
}

/*******************************************************************************
 * @fn     ETH_SoftwareReset
 *
 * @brief  ETH software reset
 *
 * @return   None
 */
void ETH_SoftwareReset(void)
{
    /* Set the SWR bit: resets all MAC subsystem internal registers and logic */
    /* After reset all the registers holds their respective reset values */
    ETH->DMABMR |= ETH_DMABMR_SR;
}

/*******************************************************************************
 * @fn       RGMII_TXC_Delay
 *
 * @brief    ETH send clock polarity and timing adjustment
 *
 * @param    clock_polarity - send clock polarity
 *           delay_time - delay time(unit - half nanosecond)
 *
 * @return   None
 */
void RGMII_TXC_Delay(uint8_t clock_polarity,uint8_t delay_time)
{
    if(clock_polarity)
        ETH->MACCR |= (uint32_t)(1<<1);
    else
        ETH->MACCR &= ~(uint32_t)(1<<1);

    if(delay_time <= 7)
        ETH->MACCR |= (uint32_t)(delay_time<<29);
    else
        printf("Error:delay_time is out of range!\n");
}

/*******************************************************************************
 * @fn     ETH_ReadPHYRegister
 *
 * @brief  Read PHY register
 *
 * @param   PHYAddress - PHY address
 *          PHYReg - PHY register address
 *
 * @return   Value of PHY register
 */
uint16_t ETH_ReadPHYRegister(uint16_t PHYAddress, uint16_t PHYReg)
{
    uint32_t tmpreg = 0;
    uint32_t timeout = 0;

    /* Get the ETHERNET MACMIIAR value */
    tmpreg = ETH->MACMIIAR;
    /* Keep only the CSR Clock Range CR[2:0] bits value */
    tmpreg &= ~MACMIIAR_CR_MASK;
    /* Prepare the MII address register value */
    tmpreg |= (((uint32_t)PHYAddress<<11) & ETH_MACMIIAR_PA); /* Set the PHY device address */
    tmpreg |= (((uint32_t)PHYReg<<6) & ETH_MACMIIAR_MR);      /* Set the PHY register address */
    tmpreg &= ~ETH_MACMIIAR_MW;                              /* Set the read mode */
    tmpreg |= ETH_MACMIIAR_MB;                               /* Set the MII Busy bit */
    /* Write the result value into the MII Address register */
    ETH->MACMIIAR = tmpreg;
    /* Check for the Busy flag */
    do
    {
        timeout++;
        tmpreg = ETH->MACMIIAR;
    } while ((tmpreg & ETH_MACMIIAR_MB) && (timeout < (uint32_t)PHY_READ_TO));
    /* Return ERROR in case of timeout */
    if(timeout == PHY_READ_TO)
    {
        return (uint16_t)ETH_ERROR;
    }
    /* Return data register value */
    return (uint16_t)(ETH->MACMIIDR);
}

/*******************************************************************************
 * @fn      ETH_WritePHYRegister
 *
 * @brief   Write PHY register
 *
 * @param   PHYAddress - PHY address
 *          PHYReg - PHY register address
 *          PHYValue - Value will be written of PHY register
 *
 * @return   Execution status
 */
uint32_t ETH_WritePHYRegister(uint16_t PHYAddress, uint16_t PHYReg, uint16_t PHYValue)
{
    uint32_t tmpreg = 0;
    uint32_t timeout = 0;

    /* Get the ETHERNET MACMIIAR value */
    tmpreg = ETH->MACMIIAR;
    /* Keep only the CSR Clock Range CR[2:0] bits value */
    tmpreg &= ~MACMIIAR_CR_MASK;
    /* Prepare the MII register address value */
    tmpreg |= (((uint32_t)PHYAddress<<11) & ETH_MACMIIAR_PA); /* Set the PHY device address */
    tmpreg |= (((uint32_t)PHYReg<<6) & ETH_MACMIIAR_MR);      /* Set the PHY register address */
    tmpreg |= ETH_MACMIIAR_MW;                               /* Set the write mode */
    tmpreg |= ETH_MACMIIAR_MB;                               /* Set the MII Busy bit */
    /* Give the value to the MII data register */
    ETH->MACMIIDR = PHYValue;
    /* Write the result value into the MII Address register */
    ETH->MACMIIAR = tmpreg;
    /* Check for the Busy flag */
    do
    {
        timeout++;
        tmpreg = ETH->MACMIIAR;
    } while ((tmpreg & ETH_MACMIIAR_MB) && (timeout < (uint32_t)PHY_WRITE_TO));
    /* Return ERROR in case of timeout */
    if(timeout == PHY_WRITE_TO)
    {
        return ETH_ERROR;
    }
    /* Return SUCCESS */
    return ETH_SUCCESS;
}

/*******************************************************************************
 * @fn     ETH_DMAITConfig
 *
 * @brief  Configuration DMA interrupt
 *
 * @param   ETH_DMA_IT - Type of DMA interrupt
 *          NewState - Enable DMA interrupt or Disable DMA interrupt
 *
 * @return   None
 */
void ETH_DMAITConfig(uint32_t ETH_DMA_IT, FunctionalState NewState)
{
    if (NewState != DISABLE)
    {
        /* Enable the selected ETHERNET DMA interrupts */
        ETH->DMAIER |= ETH_DMA_IT;
    }
    else
    {
        /* Disable the selected ETHERNET DMA interrupts */
        ETH->DMAIER &= ~(uint32_t)ETH_DMA_IT;
    }
}

/*******************************************************************************
 * @fn     ETH_DMAClearITPendingBit
 *
 * @brief  Clear DMA interrupt flag
 *
 * @param   ETH_DMA_IT - Type of DMA interrupt
 *
 * @return   None
 */
void ETH_DMAClearITPendingBit(uint32_t ETH_DMA_IT)
{
    /* Clear the selected ETHERNET DMA IT */
    ETH->DMASR = (uint32_t) ETH_DMA_IT;
}

/*******************************************************************************
 * @fn     ETH_DMATxDescChainInit
 *
 * @brief  transmit descriptor initialization
 *
 * @param   DMARxDescTab - pointer to the transmit descriptor table
 *          RxBuff - pointer to the transmit buffer (transmit queue)
 *          RxBuffCount - Number of transmit descriptor or transmit queue
 *
 * @return   None
 */
void ETH_DMATxDescChainInit(ETH_DMADESCTypeDef *DMATxDescTab, uint8_t* TxBuff, uint32_t TxBuffCount)
{
    uint8_t i = 0;
    ETH_DMADESCTypeDef *DMATxDesc;

    DMATxDescToSet = DMATxDescTab;

    for(i = 0; i < TxBuffCount; i++)
    {
        DMATxDesc = DMATxDescTab + i;
        DMATxDesc->Status = ETH_DMATxDesc_TCH | ETH_DMATxDesc_IC;
        DMATxDesc->Buffer1Addr = (uint32_t)(&TxBuff[i * ETH_MAX_PACKET_SIZE]);

        if(i < (TxBuffCount - 1))
        {
            DMATxDesc->Buffer2NextDescAddr = (uint32_t)(DMATxDescTab + i + 1);
        }
        else
        {
            DMATxDesc->Buffer2NextDescAddr = (uint32_t)DMATxDescTab;
        }
    }

    ETH->DMATDLAR = (uint32_t)DMATxDescTab;
}

/*******************************************************************************
 * @fn     ETH_DMARxDescChainInit
 *
 * @brief  Receive descriptor initialization
 *
 * @param   DMARxDescTab - pointer to the receive descriptor table
 *          RxBuff - pointer to the receive buffer (receive queue)
 *          RxBuffCount - Number of receive descriptor or receive queue
 *
 * @return   None
 **/
void ETH_DMARxDescChainInit(ETH_DMADESCTypeDef *DMARxDescTab, uint8_t *RxBuff, uint32_t RxBuffCount)
{
    uint8_t i = 0;
    ETH_DMADESCTypeDef *DMARxDesc;

    DMARxDescToGet = DMARxDescTab;

    for(i = 0; i < RxBuffCount; i++)
    {
        DMARxDesc = DMARxDescTab + i;
        DMARxDesc->Status = ETH_DMARxDesc_OWN;
        DMARxDesc->ControlBufferSize = (uint32_t)ETH_MAX_PACKET_SIZE;
        DMARxDesc->Buffer1Addr = (uint32_t)(&RxBuff[i * ETH_MAX_PACKET_SIZE]);

        if(i < (RxBuffCount - 1))
        {
            DMARxDesc->Buffer2NextDescAddr = (uint32_t)(DMARxDescTab + i + 1);
        }
        else
        {
            DMARxDesc->Buffer2NextDescAddr = (uint32_t)(DMARxDescTab);
        }
    }

    ETH->DMARDLAR = (uint32_t)DMARxDescTab;
}
