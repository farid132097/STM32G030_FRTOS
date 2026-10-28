
#include "stm32g030xx.h"
#include "kernel.h"
#include "threads.h"


int main(void)
{
	
	
	Kernel_Init();
	Kernel_Thread_Create(THREAD_SysSVC,  -1);
	Kernel_Thread_Create(THREAD_Thread1, 1);
	Kernel_Thread_Create(THREAD_Thread2, 2);
	Kernel_Thread_Create(THREAD_Thread3, 3);
	//Kernel_Thread_Create(THREAD_Thread4, 4);
	//Kernel_Thread_Create(THREAD_Thread5, 5);
	//Kernel_Thread_Create(THREAD_Thread6, 6);
	//Kernel_Thread_Create(THREAD_Thread7, 7);
	//Kernel_Thread_Create(THREAD_Thread8, 8);
	//Kernel_Thread_Create(THREAD_Thread9, 9);
	Kernel_Thread_Run_All();
	
	
	while(1)
	{
		
		
	}
}






