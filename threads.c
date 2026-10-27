

#include "stm32g030xx.h"
#include "kernel.h"
#include "threads.h"
#include "debug.h"
#include "gpio.h"

uint8_t comp1 = 1, comp2 = 1;

__attribute__((noreturn)) 
void THREAD_SysSVC(void)
{
	Debug_Init(38400);
	
	//add watchdog
	//add thread heartbeat checker
	//add thread progress notifier
	//add system health checker
	
	while(1)
	{
		
		//Debug_Tx_Parameter_NL("SS64 ", Kernel_Tick_SS64_Get());
		//Debug_Tx_Parameter_NL("S32  ", Kernel_Tick_S_Get());
		//Debug_Tx_Parameter_NL("CPUUC", Kernel_CPU_Usage_x10_Get());
		//Debug_Tx_Parameter_NL("CPUUA", Kernel_CPU_Usage_Avg_x10_Get());
		Kernel_Thread_Sleep(5000);
		
	}
}



__attribute__((noreturn)) 
void THREAD_Thread1(void)
{
	
	
	while(1)
	{
		Kernel_Atomic_Operation_Start();
		Debug_Tx_Text_NL("Thrd1");
		Kernel_Atomic_Operation_End();
		
		Kernel_Thread_Sleep(100);
		
	}
}



__attribute__((noreturn)) 
void THREAD_Thread2(void)
{
	
	
	
	while(1)
	{
		Kernel_Atomic_Operation_Start();
		Debug_Tx_Text_NL("Thrd2");
		Kernel_Atomic_Operation_End();
		
		Kernel_Thread_Sleep(210);
		
	}
}



__attribute__((noreturn)) 
void THREAD_Thread3(void)
{
	
	
	
	while(1)
	{
		
		Kernel_Atomic_Operation_Start();
		Debug_Tx_Text_NL("Thrd3");
		Kernel_Atomic_Operation_End();
		
		Kernel_Thread_Sleep(320);
		
	}
}

__attribute__((noreturn)) 
void THREAD_Thread4(void)
{
	
	while(1)
	{
		Kernel_Atomic_Operation_Start();
		Debug_Tx_Text_NL("Thrd4");
		Kernel_Atomic_Operation_End();
		
		Kernel_Thread_Sleep(430);
		
	}
}

__attribute__((noreturn)) 
void THREAD_Thread5(void)
{
	
	while(1)
	{
		Kernel_Atomic_Operation_Start();
		Debug_Tx_Text_NL("Thrd5");
		Kernel_Atomic_Operation_End();
		
		Kernel_Thread_Sleep(540);
		
	}
}

__attribute__((noreturn)) 
void THREAD_Thread6(void)
{
	
	
	while(1)
	{
		Kernel_Atomic_Operation_Start();
		Debug_Tx_Text_NL("Thrd6");
		Kernel_Atomic_Operation_End();
		
		Kernel_Thread_Sleep(650);
		
	}
}


__attribute__((noreturn)) 
void THREAD_Thread7(void)
{
	
	
	while(1)
	{
		Kernel_Atomic_Operation_Start();
		Debug_Tx_Text_NL("Thrd7");
		Kernel_Atomic_Operation_End();
		
		Kernel_Thread_Sleep(760);
		
	}
}


__attribute__((noreturn)) 
void THREAD_Thread8(void)
{
	
	
	while(1)
	{
		Kernel_Atomic_Operation_Start();
		Debug_Tx_Text_NL("Thrd8");
		Kernel_Atomic_Operation_End();
		
		Kernel_Thread_Sleep(870);
		
	}
}


__attribute__((noreturn)) 
void THREAD_Thread9(void)
{
	
	
	while(1)
	{
		Kernel_Atomic_Operation_Start();
		Debug_Tx_Text_NL("Thrd9");
		Kernel_Atomic_Operation_End();
		
		Kernel_Thread_Sleep(980);
		
	}
}