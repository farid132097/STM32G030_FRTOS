
#include "stm32g030xx.h"
#include "asm_test.h"
#include "c_test.h"
#include "kernel.h"
#include "threads.h"
#include "debug.h"

int main(void)
{
	
	Kernel_Init();
	Kernel_Thread_Create(THREAD_SysSVC, -1);
	Kernel_Thread_Create(THREAD_Thread1, 1);
	Kernel_Thread_Create(THREAD_Thread2, 2);
	Kernel_Thread_Create(THREAD_Thread3, 3);
	Kernel_Thread_Create(THREAD_Thread4, 4);
	Kernel_Thread_Create(THREAD_Thread5, 5);
	Kernel_Thread_Run_All();
	
	while(1)
	{
		
		
		
	}
}






