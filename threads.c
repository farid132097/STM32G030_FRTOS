

#include "stm32g030xx.h"
#include "kernel.h"
#include "threads.h"
#include "debug.h"
#include "gpio.h"





__attribute__((noreturn)) 
void THREAD_SysSVC(void)
{
	Debug_Init(38400);
	Kernel_Print_Info(Debug_Tx_Byte);
	
	//add watchdog
	//add thread heartbeat checker
	//add thread progress notifier
	//add system health checker
	
	while(1)
	{
		
		Debug_Tx_Text_NL     ("SysSVC");
		Debug_Tx_Parameter_NL("UpTime", Kernel_Tick_SS64_Get());
		Debug_Tx_Parameter_NL("CPUUsg", Kernel_CPU_Usage_Get());
		Kernel_Thread_Sleep(1000);
		
	}
}



__attribute__((noreturn)) 
void THREAD_Thread1(void)
{
	
	
	while(1)
	{
		
		Kernel_Atomic_Start();
		Debug_Tx_Text_NL("Thrd1");
		Kernel_Atomic_End();
		
		Kernel_Thread_Sleep(20);
		
	}
}



__attribute__((noreturn)) 
void THREAD_Thread2(void)
{
	
	
	
	while(1)
	{
		
		Kernel_Atomic_Start();
		Debug_Tx_Text_NL("Thrd2");
		Kernel_Atomic_End();
		
		Kernel_Thread_Sleep(22);
		
	}
}



__attribute__((noreturn)) 
void THREAD_Thread3(void)
{
	
	
	
	while(1)
	{
		
		Kernel_Atomic_Start();
		Debug_Tx_Text_NL("Thrd3");
		Kernel_Atomic_End();
		
		Kernel_Thread_Sleep(25);
		
	}
}



__attribute__((noreturn)) 
void THREAD_Thread4(void)
{
	
	while(1)
	{
		
		Kernel_Atomic_Start();
		Debug_Tx_Text_NL("Thrd4");
		Kernel_Atomic_End();
		
		Kernel_Thread_Sleep(430);
		
	}
}



__attribute__((noreturn)) 
void THREAD_Thread5(void)
{
	
	while(1)
	{
		
		Kernel_Atomic_Start();
		Debug_Tx_Text_NL("Thrd5");
		Kernel_Atomic_End();
		
		Kernel_Thread_Sleep(540);
		
	}
}





