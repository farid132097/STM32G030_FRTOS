


/*
 * File          : kernel.h
 * Author        : Md. Faridul Islam (faridmdislam@gmail.com)
 * Source        : https://github.com/farid132097/STM32G030_FRTOS
 * Description   : ARM Cortex M0+ kernel for bare-metal RTOS
 * Created       : Sep 02, 2025, 09:30 PM
 * Last Modified : Nov 11, 2026, 02:42 PM
 *
 */




#ifndef  _KERNEL_H_
#define  _KERNEL_H_


#include "stdint.h"


void     Kernel_Init(void);
uint8_t  Kernel_Thread_Create(void (*fptr)(void), int8_t prio);
void     Kernel_Thread_Sleep(uint32_t val);
void     Kernel_Thread_Heartbeat(void);
void     Kernel_Thread_Health_Set(uint32_t tout, uint32_t health);
uint8_t  Kernel_Thread_Health_Get(uint8_t thread_id);
uint8_t  Kernel_Thread_Health_Check(void);
void     Kernel_Thread_Run_All(void);
void     Kernel_Atomic_Start(void);
void     Kernel_Atomic_End(void);
uint64_t Kernel_Tick_SubSeconds_Get(void);
uint32_t Kernel_Tick_Seconds_Get(void);
void     Kernel_Timeout_Set(uint16_t val);
uint8_t  Kernel_Timeout_Status_Get(void);
uint8_t  Kernel_CPU_Usage_Get(void);
uint8_t  Kernel_Version_Major_Get(void);
uint8_t  Kernel_Version_Minor_Get(void);
uint8_t  Kernel_Version_Patch_Get(void);



#endif
