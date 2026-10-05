


#ifndef  _C_TEST_H_
#define  _C_TEST_H_

#include "stdint.h"

void     C_Test_Startup_Delay(uint32_t ms);
void 	 C_Test_RTC_Init(void);
void 	 C_Test_Sleep(uint16_t ms);
void 	 C_Test_Deep_Sleep(void);
void	 RTC_TAMP_IRQHandler(void);




#endif


