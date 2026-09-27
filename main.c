
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
	Kernel_Thread_Create(Threads_Thread1, 2);
	Kernel_Thread_Create(Threads_Thread2, 0);
	Kernel_Thread_Create(Threads_Thread3, 1);
	Kernel_Thread_Run_All();
	
	while(1){
		
		
	}
	
}


