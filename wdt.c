


#include "stm32g030xx.h"
#include "wdt.h"


void WDT_Init(uint32_t timeout_ms)
{
	//1 Tick = 8ms
	timeout_ms /= 8;
	if((RCC->CSR & RCC_CSR_LSION) != RCC_CSR_LSION)
	{
		RCC->CSR |= RCC_CSR_LSION;
		while((RCC->CSR & RCC_CSR_LSIRDY) != RCC_CSR_LSIRDY);
	}
	IWDG->KR = 0x0000CCCC;
	IWDG->KR = 0x00005555;
	while(IWDG->SR != 0);
	//Prescaler 256, Freq 125Hz
	IWDG->PR = 0x00000007;
	while(IWDG->SR != 0);
	//RLR register is 12 bits
	IWDG->RLR = timeout_ms;
	while(IWDG->SR != 0);
	IWDG->KR = 0x0000AAAA;
}

void WDT_Reload(void)
{
	while(IWDG->SR != 0);
	IWDG->KR = 0x0000AAAA;
}



