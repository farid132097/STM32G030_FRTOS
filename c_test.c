

#include "stm32g030xx.h"
#include "c_test.h"


void C_Test_Startup_Delay(uint32_t ms)
{
	uint32_t tmp;
	SystemCoreClockUpdate();
	tmp  = SystemCoreClock;
	tmp /= 1000;
	ms  *= tmp;
	
	while (ms--)
	{
		__NOP();
	}
}


void C_Test_RTC_Init(void)
{
    RCC->APBENR1 |= RCC_APBENR1_PWREN;
	PWR->CR1     &=~ PWR_CR1_LPMS_Msk;
	PWR->CR1     |=  (1 << PWR_CR1_LPMS_Pos);
    PWR->CR1     |=  PWR_CR1_DBP;
	if((RCC->CSR & RCC_CSR_LSIRDY) == 0)
	{
		RCC->CSR  |=  RCC_CSR_LSION;
		while ((RCC->CSR & RCC_CSR_LSIRDY) == 0U)
		{
		}
	}
    RCC->BDCR &=~ RCC_BDCR_RTCSEL;
    RCC->BDCR |=  RCC_BDCR_RTCSEL_1;
    RCC->BDCR |=  RCC_BDCR_RTCEN;
	
	RTC->WPR = 0xCA;
    RTC->WPR = 0x53;
	if(RTC->CR & RTC_CR_WUTE)
	{
		RTC->CR   &=~ RTC_CR_WUTE;
		while ((RTC->ICSR & RTC_ICSR_WUTWF) == 0U)
		{
		}
	}
	RTC->WUTR  =  (uint16_t)(10 - 1U);
    RTC->CR   &=~ RTC_CR_WUCKSEL_Msk;
    RTC->SR   &=~ RTC_SR_WUTF;
    RTC->CR   |=  RTC_CR_WUTIE;
    NVIC_ClearPendingIRQ(RTC_TAMP_IRQn);
    NVIC_SetPriority(RTC_TAMP_IRQn, 0);
    NVIC_EnableIRQ(RTC_TAMP_IRQn);
}

void C_Test_Sleep(uint16_t ms)
{
	RTC->WPR   =  0xCA;
	RTC->WPR   =  0x53;
	if(RTC->CR & RTC_CR_WUTE)
	{
		RTC->CR   &=~ RTC_CR_WUTE;
		while ((RTC->ICSR & RTC_ICSR_WUTWF) == 0U)
		{
		}
	}
	RTC->WUTR  =  (uint16_t)(ms - 1U);
	RTC->SR   &=~ RTC_SR_WUTF;
	RTC->CR   |=  RTC_CR_WUTIE;
	RTC->CR   |=  RTC_CR_WUTE;
}

void C_Test_Deep_Sleep(void)
{
	SCB->SCR  |= SCB_SCR_SLEEPDEEP_Msk;
	__DSB();
    __WFI();
    __ISB();
}





void RTC_TAMP_IRQHandler(void)
{
    if (RTC->SR & RTC_SR_WUTF)
    {
        RTC->SR &=~ RTC_SR_WUTF;
    }
}