
#include "stm32g030xx.h"
#include "kernel.h"
#include "threads.h"


int main(void)
{
	
	
	Kernel_Init();
	Kernel_Thread_Create(THREAD1_SysSVC, -1);
	Kernel_Thread_Create(THREAD2_Thread, 1);
	Kernel_Thread_Create(THREAD3_Thread, 2);
	Kernel_Thread_Create(THREAD4_Thread, 3);
	Kernel_Thread_Create(THREAD5_Thread, 4);
	Kernel_Thread_Create(THREAD6_Thread, 5);
	Kernel_Thread_Create(THREAD7_Thread, 6);
	Kernel_Thread_Create(THREAD8_Thread, 7);
	Kernel_Thread_Create(THREAD9_Thread, 8);
	Kernel_Thread_Create(THREAD10_Thread, 9);
	Kernel_Thread_Run_All();
	
	
	while(1)
	{
		
		
	}
}






