

#ifndef  _WDT_H_
#define  _WDT_H_
#include "stdint.h"


void     WDT_Init(uint32_t timeout_ms);
void     WDT_Reload(void);



#endif



