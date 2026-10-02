
#include "stm32g030xx.h"
#include "macro_test.h"
#include "kernel.h"
#include "threads.h"
#include "debug.h"

int main(void)
{
    /*
    Kernel_Init();
    Kernel_Thread_Create(Threads_SysThread, 0);
    Kernel_Thread_Create(Threads_Thread1, 1);
    Kernel_Thread_Create(Threads_Thread2, 2);
    Kernel_Thread_Create(Threads_Thread3, 3);
    Kernel_Thread_Run_All();
    */
    
	
    RCC->APBENR1 |= RCC_APBENR1_PWREN;
    PWR->CR1  |=  PWR_CR1_DBP;
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
	if(RTC->CR & RTC_CR_WUTE)
	{
		RTC->CR   &=~ RTC_CR_WUTE;
		while ((RTC->ICSR & RTC_ICSR_WUTWF) == 0U)
		{
		}
	}
    RTC->CR   &=~ RTC_CR_WUCKSEL_Msk;
    RTC->SR   &=~ RTC_SR_WUTF;
    RTC->CR   |=  RTC_CR_WUTIE;
    NVIC_ClearPendingIRQ(RTC_TAMP_IRQn);
    NVIC_SetPriority(RTC_TAMP_IRQn, 0);
    NVIC_EnableIRQ(RTC_TAMP_IRQn);
	
    
    
    while(1)
    {
    
		if(RTC->CR & RTC_CR_WUTE)
		{
			RTC->CR   &=~ RTC_CR_WUTE;
			while ((RTC->ICSR & RTC_ICSR_WUTWF) == 0U)
			{
			}
		}
        RTC->SR   &=~ RTC_SR_WUTF;
        RTC->WUTR = (uint16_t)(500 - 1U);
        RTC->CR |= RTC_CR_WUTE;
        SCB->SCR |= SCB_SCR_SLEEPDEEP_Msk;
        
        __DSB();
        __WFI();
        __ISB();
        
    }
}



void RTC_TAMP_IRQHandler(void)
{
    if (RTC->SR & RTC_SR_WUTF)
    {
        RTC->SR &=~ RTC_SR_WUTF;
    }
}


