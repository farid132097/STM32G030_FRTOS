

#include "stm32g030xx.h"
#include "kernel.h"
#include "threads.h"
#include "gpio.h"

__attribute__((noreturn)) void Threads_Thread1(void){
	  
	  GPIO_PA1_Init();
	  
	  while(1){
		
		    GPIO_PA1_Set();
		    Kernel_Thread_Sleep(500);
			  GPIO_PA1_Clear();
			  Kernel_Thread_Sleep(500);
		    
	  }
}

__attribute__((noreturn)) void Threads_Thread2(void){
	  
	  GPIO_PA2_Init();
	  
	  while(1){
		
		    GPIO_PA2_Set();
		    Kernel_Thread_Sleep(1000);
			  GPIO_PA2_Clear();
			  Kernel_Thread_Sleep(1000);
		    
	  }
}

__attribute__((noreturn)) void Threads_Thread3(void){
	  
	  GPIO_PA3_Init();
	  
	  while(1){
		
		    GPIO_PA3_Set();
		    Kernel_Thread_Sleep(2000);
			  GPIO_PA3_Clear();
			  Kernel_Thread_Sleep(2000);
		    
	  }
}


