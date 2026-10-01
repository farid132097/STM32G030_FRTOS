
#include "stm32g030xx.h"
#include "macro_test.h"
#include "kernel.h"
#include "threads.h"
#include "debug.h"

int main(void){
	
	
	Kernel_Init();
	Kernel_Thread_Create(Threads_SysThread, 0);
	Kernel_Thread_Create(Threads_Thread1, 1);
	//Kernel_Thread_Create(Threads_Thread2, 2);
	//Kernel_Thread_Create(Threads_Thread3, 3);
	Kernel_Thread_Run_All();
	
	
	while(1){
		
		
	}
	
}


