
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
	  //Kernel_Thread_Create(Threads_Thread2, 2);
	  //Kernel_Thread_Create(Threads_Thread3, 3);
	  Kernel_Thread_Run_All();
	  */
	
	  RCC->APBENR1 |= RCC_APBENR1_PWREN;
	  PWR->CR1 |= PWR_CR1_DBP;
	  RCC->CSR |= RCC_CSR_LSION;
	  while ((RCC->CSR & RCC_CSR_LSIRDY) == 0U)
    {
    }
	  RCC->BDCR &= ~RCC_BDCR_RTCSEL;
    RCC->BDCR |= RCC_BDCR_RTCSEL_1;
		RCC->BDCR |= RCC_BDCR_RTCEN;
		RTC->CR &= ~RTC_CR_WUTE;
		while ((RTC->ISR & RTC_ISR_WUTWF) == 0U)
    {
    }
		RTC->CR &= ~RTC_CR_WUCKSEL;
    RTC->CR |= RTC_CR_WUCKSEL_2;
		RTC->ISR &= ~RTC_ISR_WUTF;
	  RTC->CR |= RTC_CR_WUTIE;
		NVIC_ClearPendingIRQ(RTC_WKUP_IRQn);
    NVIC_EnableIRQ(RTC_WKUP_IRQn);
		
		
		
	while(1){
		
		
	}
	
}


