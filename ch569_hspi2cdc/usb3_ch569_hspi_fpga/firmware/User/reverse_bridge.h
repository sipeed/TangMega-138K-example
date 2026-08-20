#pragma once

#include "CH56x_common.h"

void Reverse_Bridge_Init(void);
void Reverse_Bridge_Start(void);
UINT8 Reverse_Bridge_Active(void);
void Reverse_USB_OUT_Complete(UINT16 length);
void Reverse_HSPI_IRQHandler(UINT8 flags);
UINT8 Reverse_Report_Active(void);
void Reverse_Report_USB_Done(void);
