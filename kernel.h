


/*
 * File          : kernel.h
 * Author        : Md. Faridul Islam (faridmdislam@gmail.com)
 * Source        : https://github.com/farid132097/STM32G030_FRTOS
 * Description   : ARM Cortex M0+ kernel for bare-metal RTOS
 * Created       : Sep 02, 2025, 09:30 PM
 * Last Modified : Nov 14, 2026, 02:42 PM
 *
 */




#ifndef  _KERNEL_H_
#define  _KERNEL_H_


#include "stdint.h"


/*
 * Notes
 *  - Priority is an int8_t, the lowest value runs first. Idle uses 127, so user
 *    threads must use -128 to 126. Negative priorities (system threads) can
 *    preempt a thread that is inside an atomic section. System thread can be
 *    positive priority, in that case, no preemption is possible during atomic.
 *  - Thread IDs follow creation order: idle is 0, the first created thread is 1.
 *  - Thread functions must never return.
 *  - Tick unit is 1 ms. All times below are in milliseconds.
 *  - Functions that act on "the calling thread" must be called from thread mode.
 */


/* Configures clock, kernel variables and creates the idle thread. Call first. */
void     Kernel_Init(void);



/* Creates a thread. Returns 1 on success, 0 if fptr is NULL or all slots are used.
 * Call before Kernel_Thread_Run_All(). 
 */
uint8_t  Kernel_Thread_Create(void (*fptr)(void), int8_t prio);



/* Blocks the calling thread for val ms and yields at once. Thread mode only,
 * never from an ISR and never with PRIMASK set.
 */
void     Kernel_Thread_Sleep(uint32_t val);



/* Records a heartbeat for the calling thread. Call at least once per health
 * timeout of that thread.
 */
void     Kernel_Thread_Heartbeat(void);



/* Enables health monitoring for the calling thread and records a first
 * heartbeat. tout is the allowed time between heartbeats in ms, health is the
 * starting health count (0 to 255, stored in 8 bits).
 */
void     Kernel_Thread_Health_Set(uint32_t tout, uint32_t health);



/* Returns the remaining health count of thread thread_id.*/
uint8_t  Kernel_Thread_Health_Get(uint8_t thread_id);



/* Call periodically from a supervisor thread. Each monitored thread (ID 2 and
 * above) whose last heartbeat is older than its timeout loses 1 health point
 * per call. Returns 1 while all are healthy, 0 once any thread has run out of
 * health. The result stays 0 after that.
 */
uint8_t  Kernel_Thread_Health_Check(void);



/* Starts the SysTick and switches to the idle thread. Does not return.
 * Kernel_Init() and the Kernel_Thread_Create() calls must come before it.
 */
void     Kernel_Thread_Run_All(void);



/* Begins / ends an atomic section for the calling thread. The owner keeps the
 * CPU against threads of priority 0 and above, system threads (negative
 * priority) can still preempt it. If the owner sleeps inside the section, idle
 * runs. Sections cannot be nested.
 */
void     Kernel_Atomic_Start(void);
void     Kernel_Atomic_End(void);



/* Returns the 64-bit millisecond tick counted since the scheduler started.*/
uint64_t Kernel_Tick_SubSeconds_Get(void);



/* Returns the seconds counter since the scheduler started. */
uint32_t Kernel_Tick_Seconds_Get(void);



/* Starts a timeout of val ms for the calling thread (0 to 65535). */
void     Kernel_Timeout_Set(uint16_t val);



/* Returns 1 if the calling thread's timeout has expired, otherwise 0. A thread
 * that never called Kernel_Timeout_Set() reads as expired.
 */
uint8_t  Kernel_Timeout_Status_Get(void);



/* Returns the average CPU usage in percent (0 to 100). It is measured over
 * 1 s windows and averaged with the previous window.
 */
uint8_t  Kernel_CPU_Usage_Get(void);



/* Kernel version numbers. */
uint8_t  Kernel_Version_Major_Get(void);
uint8_t  Kernel_Version_Minor_Get(void);
uint8_t  Kernel_Version_Patch_Get(void);



#endif
