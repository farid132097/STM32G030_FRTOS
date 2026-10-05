
#include "stm32g030xx.h"
#include "asm_test.h"
#include "c_test.h"
#include "kernel.h"
#include "threads.h"
#include "debug.h"

int main(void)
{
    /*
    Kernel_Init();
    Kernel_Thread_Create(Threads_SysThread, 0);
    Kernel_Thread_Create(Threads_Thread1, 1);
    Kernel_Thread_Create(Threads_Thread2, 2);
    Kernel_Thread_Create(Threads_Thread3, 3);
    Kernel_Thread_Run_All();
    */
    
	C_Test_Startup_Delay(4000);
	C_Test_RTC_Init();
	
	
    while(1)
    {
    
		C_Test_Deep_Sleep();
        
        
    }
}






