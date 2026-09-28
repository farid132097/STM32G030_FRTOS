
#include "stm32g030xx.h"
#include "macro_test.h"
#include "kernel.h"
#include "threads.h"


int main(void){
	
	/*
	Macro_Test_GPIO_Init();
	Macro_Test_GPIO_High();
	Macro_Test_GPIO_Low();
	*/
	
	Kernel_Init();
	Kernel_Thread_Create(Threads_SysThread, 0);
	Kernel_Thread_Create(Threads_Thread1, 1);
	Kernel_Thread_Create(Threads_Thread2, 2);
	Kernel_Thread_Create(Threads_Thread3, 3);
	Kernel_Thread_Run_All();
	
	/*
	OS Environment  : F-RTOS
	OS Platform     : ARM Cortex M0+
	Source Code     : github.com/farid132097
	Author Email    : faridmdislam@gmail.com
	Kernel Version  : 1.1.0
	Max Threads     : 10
	Stack Model     : Unified
	Stack Size      : 1024 B
	GPIO Tick Debug : Disabled
  CPU PLL 64MHz   : Disabled
	*/
	
	
	while(1){
		
		
	}
	
}


