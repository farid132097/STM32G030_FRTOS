


/*
 * File          : kernel.h
 * Author        : Md. Faridul Islam (faridmdislam@gmail.com)
 * Source        : https://github.com/farid132097/STM32G030_FRTOS
 * Description   : ARM Cortex M0+ kernel for bare-metal RTOS
 * Created       : Sep 02, 2025, 09:30 PM
 * Last Modified : Nov 02, 2026, 11:15 PM
 *
*/




#ifndef  _KERNEL_H_
#define  _KERNEL_H_


#include "stdint.h"


void     Kernel_Init(void);
void     Kernel_Thread_Create(void (*fptr)(void), int8_t prio);
void     Kernel_Thread_Idle(void);
void     Kernel_Thread_Sleep(uint32_t val);
void     Kernel_Thread_Heartbeat(void);
void     Kernel_Thread_Run_All(void);
void     Kernel_Atomic_Start(void);
void     Kernel_Atomic_End(void);
void     Kernel_Print_Info(void (*fptr)(uint8_t));
uint64_t Kernel_Tick_SubSeconds_Get(void);
uint32_t Kernel_Tick_Seconds_Get(void);
void     Kernel_Timeout_Set(uint32_t val);
uint8_t  Kernel_Timeout_Status(void);
uint8_t  Kernel_CPU_Usage_Get(void);
uint8_t  Kernel_Version_Major_Get(void);
uint8_t  Kernel_Version_Minor_Get(void);
uint8_t  Kernel_Version_Patch_Get(void);



#endif

