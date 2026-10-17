
#include "stm32g030xx.h"
#include "kernel.h"
#include "threads.h"


int main(void)
{
	
	
	Kernel_Init();
	Kernel_Thread_Create(THREAD_SysSVC, 0);
	Kernel_Thread_Create(THREAD_Thread1, 1);
	Kernel_Thread_Create(THREAD_Thread2, 2);
	Kernel_Thread_Create(THREAD_Thread3, 3);
	Kernel_Thread_Create(THREAD_Thread2, 2);
	Kernel_Thread_Create(THREAD_Thread3, 3);
	Kernel_Thread_Run_All();
	
	
	while(1)
	{
		
		
	}
}






