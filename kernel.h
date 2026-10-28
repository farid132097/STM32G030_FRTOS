


/*
 * File          : kernel.h
 * Author        : MD. Faridul Islam (faridmdislam@gmail.com)
 * Source        : https://github.com/farid132097/STM32G030_FRTOS
 * Description   : ARM Cortex M0+ kernel for bare-metal RTOS
 * Created       : Sep 02, 2025, 09:30 PM
 * Last Modified : Oct 28, 2026, 04:30 AM
 *
*/




#ifndef  _KERNEL_H_
#define  _KERNEL_H_


#include "stdint.h"


void     Kernel_Init(void);
void     Kernel_Thread_Create(void (*func)(void), int8_t prio);
void     Kernel_Thread_Idle(void);
void     Kernel_Thread_Sleep(uint32_t val);
void     Kernel_Thread_Run_All(void);
void     Kernel_Atomic_Start(void);
void     Kernel_Atomic_End(void);
uint32_t Kernel_Tick_SS32_Get(void);
uint64_t Kernel_Tick_SS64_Get(void);
uint32_t Kernel_Tick_S_Get(void);
void     Kernel_Timeout_Set(uint32_t val);
uint8_t  Kernel_Timeout_Status(void);
uint8_t  Kernel_CPU_Usage_Get(void);
uint8_t  Kernel_Version_Major_Get(void);
uint8_t  Kernel_Version_Minor_Get(void);
uint8_t  Kernel_Version_Patch_Get(void);
uint8_t  Kernel_Info_Char_Get(uint32_t index);
void     Kernel_Print_Info(void (*func)(uint8_t));


#endif



