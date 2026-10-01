

#include "stm32g030xx.h"
#include "kernel.h"
#include "threads.h"
#include "debug.h"
#include "gpio.h"


__attribute__((noreturn)) 
void Threads_SysThread(void)
{
	  
	  Debug_Init(38400);
	  Debug_Tx_Text_NL("DebugStarted");
	  
	  //print all kernel info
	  Kernel_Print_Info(Debug_Tx_Byte);
	  
	  while(1){
		
		    
			  Kernel_Thread_Sleep(60000);
		    
	  }
}



__attribute__((noreturn)) 
void Threads_Thread1(void)
{
	  
	  GPIO_PA1_Init();
	  
	  while(1){
		
		    GPIO_PA1_Set();
		    Kernel_Thread_Sleep(500);
			  GPIO_PA1_Clear();
			  Kernel_Thread_Sleep(500);
		    
	  }
}



__attribute__((noreturn)) 
void Threads_Thread2(void)
{
	  
	  GPIO_PA2_Init();
	  
	  while(1){
		
		    GPIO_PA2_Set();
		    Kernel_Thread_Sleep(1000);
			  GPIO_PA2_Clear();
			  Kernel_Thread_Sleep(1000);
		    
	  }
}



__attribute__((noreturn)) 
void Threads_Thread3(void)
{
	  
	  GPIO_PA3_Init();
	  
	  while(1){
		
		    GPIO_PA3_Set();
		    Kernel_Thread_Sleep(2000);
			  GPIO_PA3_Clear();
			  Kernel_Thread_Sleep(2000);
		    
	  }
}


