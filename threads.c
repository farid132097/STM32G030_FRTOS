

#include "stm32g030xx.h"
#include "kernel.h"
#include "threads.h"
#include "debug.h"
#include "gpio.h"


__attribute__((noreturn)) 
void THREAD_SysSVC(void)
{
	Debug_Init(38400);
	
	//add watchdog
	//add thread heartbeat checker
	//add thread progress notifier
	//add system health checker
	
	while(1)
	{
		
		Kernel_Thread_Sleep(60000);
		
	}
}



__attribute__((noreturn)) 
void THREAD_Thread1(void)
{
	GPIO_PA1_Init();
	
	while(1)
	{
		
		GPIO_PA1_Set();
		Kernel_Thread_Sleep(500);
		GPIO_PA1_Clear();
		Kernel_Thread_Sleep(500);
		
	}
}



__attribute__((noreturn)) 
void THREAD_Thread2(void)
{
	
	GPIO_PA2_Init();
	
	while(1)
	{
		
		GPIO_PA2_Set();
		Kernel_Thread_Sleep(1000);
		GPIO_PA2_Clear();
		Kernel_Thread_Sleep(1000);
		
	}
}



__attribute__((noreturn)) 
void THREAD_Thread3(void)
{
	
	GPIO_PA3_Init();
	
	while(1)
	{
		GPIO_PA3_Set();
		Kernel_Thread_Sleep(2000);
		GPIO_PA3_Clear();
		Kernel_Thread_Sleep(2000);
		
	}
}


