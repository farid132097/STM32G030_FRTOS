

#include "stm32g030xx.h"
#include "kernel.h"
#include "threads.h"
#include "debug.h"
#include "gpio.h"
#include "wdt.h"




__attribute__((noreturn)) 
void THREAD1_SysSVC(void)
{
	Debug_Init(115200);
	Kernel_Print_Info(Debug_Tx_Byte);
	Debug_Tx_Parameter_Hex_NL("SysRst", RCC->CSR);
	RCC->CSR |= RCC_CSR_RMVF;
	WDT_Init(2000);
	WDT_Reload();
	
	while(1)
	{
		
		if(Kernel_Thread_Health_Check())
		{
			WDT_Reload();
			Debug_Tx_Parameter_NL("Thrd2Health", Kernel_Thread_Health_Get(2));
			Debug_Tx_Parameter_NL("Thrd3Health", Kernel_Thread_Health_Get(3));
			Debug_Tx_Parameter_NL("Thrd4Health", Kernel_Thread_Health_Get(4));
			Debug_Tx_Parameter_NL("Thrd5Health", Kernel_Thread_Health_Get(5));
			Debug_Tx_Parameter_NL("Thrd6Health", Kernel_Thread_Health_Get(6));
		}
		
		Kernel_Thread_Sleep(1000);
		
	}
}



__attribute__((noreturn)) 
void THREAD2_Thread(void)
{
	
	Kernel_Thread_Health_Set(500, 10);
	
	while(1)
	{
		
		Kernel_Atomic_Start();
		Debug_Tx_Text_NL("Thrd2");
		Kernel_Atomic_End();
		
		Kernel_Thread_Heartbeat();
		Kernel_Thread_Sleep(20);
		
	}
}



__attribute__((noreturn)) 
void THREAD3_Thread(void)
{
	
	Kernel_Thread_Health_Set(500, 10);
	
	while(1)
	{
		
		Kernel_Atomic_Start();
		Debug_Tx_Text_NL("Thrd3");
		Kernel_Atomic_End();
		
		Kernel_Thread_Heartbeat();
		Kernel_Thread_Sleep(22);
		
	}
}



__attribute__((noreturn)) 
void THREAD4_Thread(void)
{
	
	Kernel_Thread_Health_Set(500, 10);
	
	while(1)
	{
		
		Kernel_Atomic_Start();
		Debug_Tx_Text_NL("Thrd4");
		Kernel_Atomic_End();
		
		Kernel_Thread_Heartbeat();
		Kernel_Thread_Sleep(25);
		
	}
}



__attribute__((noreturn)) 
void THREAD5_Thread(void)
{
	
	Kernel_Thread_Health_Set(1000, 10);
	
	while(1)
	{
		
		Kernel_Atomic_Start();
		Debug_Tx_Text_NL("Thrd5");
		Kernel_Atomic_End();
		
		Kernel_Thread_Heartbeat();
		Kernel_Thread_Sleep(430);
		
	}
}



__attribute__((noreturn)) 
void THREAD6_Thread(void)
{
	
	Kernel_Thread_Health_Set(1000, 10);
	
	while(1)
	{
		
		Kernel_Atomic_Start();
		Debug_Tx_Text_NL("Thrd6");
		Kernel_Atomic_End();
		
		Kernel_Thread_Heartbeat();
		Kernel_Thread_Sleep(540);
		
	}
}





