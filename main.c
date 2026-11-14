
#include "stm32g030xx.h"
#include "asm_test.h"
#include "c_test.h"
#include "kernel.h"
#include "threads.h"
#include "debug.h"

int main(void)
{
	
	Kernel_Init();
	Kernel_Thread_Create(THREAD1_SysSVC, -1);
	Kernel_Thread_Create(THREAD2_Thread, 1);
	Kernel_Thread_Create(THREAD3_Thread, 2);
	Kernel_Thread_Create(THREAD4_Thread, 3);
	Kernel_Thread_Create(THREAD5_Thread, 4);
	Kernel_Thread_Create(THREAD6_Thread, 5);
	Kernel_Thread_Run_All();
	
	while(1)
	{
		
		
		
	}
}






