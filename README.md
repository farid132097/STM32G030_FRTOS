# STM32G030 F-RTOS

A tiny preemptive, priority-based RTOS kernel written entirely in ARM assembly for the **Cortex-M0+** (tested on the **STM32G030F6P6**).

- **Version:** 3.0.0

---

## Features

### Scheduler
- Preemptive, priority-based scheduling driven by a 1 ms SysTick
- Context switching is done in **PendSV** at the lowest interrupt priority, so it never delays other ISRs
- Signed 8-bit priorities: **lower value = higher priority**
  - `0x7F` (127) is reserved for the idle thread, so user threads use -128 to 126
  - Negative priorities are treated as *system threads* and can preempt atomic sections
- Equal priorities are resolved by lowest thread ID (no round-robin)
- Thread IDs follow creation order: idle is 0, the first created thread is 1
- Idle thread (ID 0) runs when no other thread is ready
- Manual R4-R11 save/restore (Cortex-M0+ cannot push/pop the high registers in one instruction)

### Threads and memory
- Up to **11 user threads + 1 idle thread** by default (`DEF_KER_MAX_THREADS`, configurable)
- Fully static allocation, no heap
- Unified stack model: **384 bytes per thread** (`DEF_KER_STK_SZ`)
- 32-byte task control block per thread
- `Kernel_Thread_Create` returns 1 on success, 0 if the pointer is NULL or all slots are used

### Sleep and timing
- `Kernel_Thread_Sleep(ms)` blocks a thread for a number of milliseconds and yields immediately
- 64-bit millisecond tick counter (`Kernel_Tick_SubSeconds_Get`) and a 32-bit seconds counter (`Kernel_Tick_Seconds_Get`) for uptime and timestamps
- Per-thread timeouts of 0-65535 ms (`Kernel_Timeout_Set` / `Kernel_Timeout_Status_Get`), using a 32-bit deadline

### Atomic sections
- `Kernel_Atomic_Start()` / `Kernel_Atomic_End()` lock the **scheduler**, not the interrupts. ISRs keep running.
- While active, the owner thread keeps the CPU even if a higher-priority thread becomes ready
- System threads (negative priority) can still preempt
- If the owner sleeps inside the section, the scheduler runs idle rather than switching to another thread
- Interrupt state is saved and restored around the update (PRIMASK)

### Thread heartbeat and health monitoring
- `Kernel_Thread_Health_Set(timeout, health)` enables monitoring for the calling thread and records a first heartbeat
- `Kernel_Thread_Heartbeat()` stamps the calling thread with the current 64-bit tick; call it at least once per timeout
- `Kernel_Thread_Health_Check()` is meant to be called periodically from a supervisor thread. Each monitored thread (ID 2 and above) whose last heartbeat is older than its timeout loses 1 health point per call. It returns 1 while all threads are healthy and 0 once any thread has run out of health (the result stays 0 after that).
- Health points are not replenished by later heartbeats
- `Kernel_Thread_Health_Get(id)` returns the remaining health of a thread

### System utilities
- CPU usage measurement over a 1000-tick window, smoothed with a 2-point average, returned in percent
- Optional **64 MHz PLL** from HSI16 (2 flash wait states); otherwise runs at 16 MHz. SysTick reload is adjusted automatically.
- Debug GPIO that goes high on PendSV entry and low on exit, for measuring context-switch time with a scope or logic analyzer
- Kernel info banner (`Kernel_Print_Info`) and version getters

---

## Performance

Context-switch time measured on the debug GPIO pin (PendSV entry to exit) with the kernel features enabled (tick counters, CPU usage, atomic-section check, sleep handling):

| Threads | Context switch time |
|--------:|--------------------:|
| 5       | **3.5 µs**          |
| 10      | **4.5 µs**          |

The cost grows by roughly 0.2 µs per additional thread, because the scheduler walks the TCB list once per switch. These figures were measured before the heartbeat and health additions and have not been re-measured.

---

## Configuration

Set these constants at the top of `kernel.S`:

| Constant | Default | Description |
|---|---|---|
| `DEF_KER_MAX_THREADS` | 11 (0x0B) | Maximum user threads (idle is added automatically) |
| `DEF_KER_STK_SZ` | 0x180 (384 B) | Stack size per thread |
| `DEF_64MHZ_PLL_ENABLE` | 1 | 1 = 64 MHz PLL, 0 = 16 MHz HSI |
| `DEF_DBG_GPIO_TICK_EN` | 0 | Enable the debug GPIO toggle in PendSV |
| `DEF_DBG_GPIO_PORT` | 0 | Debug pin port (0 = A, 1 = B, ...) |
| `DEF_DBG_GPIO_PIN` | 3 | Debug pin number (0-15) |
| `DEF_INFO_BLOCK_SIZE` | 0x200 | Size of the info banner block |

---

## API

See `kernel.h` for full documentation of each function.

```c
void     Kernel_Init(void);
uint8_t  Kernel_Thread_Create(void (*fptr)(void), int8_t prio);
void     Kernel_Thread_Sleep(uint32_t ms);
void     Kernel_Thread_Run_All(void);

void     Kernel_Thread_Heartbeat(void);
void     Kernel_Thread_Health_Set(uint32_t tout, uint32_t health);
uint8_t  Kernel_Thread_Health_Get(uint8_t thread_id);
uint8_t  Kernel_Thread_Health_Check(void);

void     Kernel_Atomic_Start(void);
void     Kernel_Atomic_End(void);

uint64_t Kernel_Tick_SubSeconds_Get(void);
uint32_t Kernel_Tick_Seconds_Get(void);

void     Kernel_Timeout_Set(uint16_t ms);
uint8_t  Kernel_Timeout_Status_Get(void);

uint8_t  Kernel_CPU_Usage_Get(void);

uint8_t  Kernel_Version_Major_Get(void);
uint8_t  Kernel_Version_Minor_Get(void);
uint8_t  Kernel_Version_Patch_Get(void);

void     Kernel_Print_Info(void (*fptr)(uint8_t));
```

---

## Quick start

```c
#include "kernel.h"

void Task_Blink(void)
{
    while (1) {
        /* toggle LED */
        Kernel_Thread_Sleep(500);
    }
}

void Task_Sensor(void)
{
    while (1) {
        Kernel_Atomic_Start();
        /* read a shared resource without being preempted */
        Kernel_Atomic_End();
        Kernel_Thread_Sleep(100);
    }
}

int main(void)
{
    Kernel_Init();                          /* clocks, PendSV priority, idle thread */
    Kernel_Thread_Create(Task_Blink,  1);   /* lower number = higher priority */
    Kernel_Thread_Create(Task_Sensor, 2);
    Kernel_Thread_Run_All();                /* start scheduling, never returns */
}
```

### Timeouts

```c
Kernel_Timeout_Set(250);                    /* 250 ms from now, for the calling thread */
while (!Kernel_Timeout_Status_Get()) {
    /* wait for an event */
    Kernel_Thread_Sleep(1);
}
```

### Health monitoring

```c
void Task_Worker(void)
{
    Kernel_Thread_Health_Set(500, 3);       /* beat at least every 500 ms, 3 health points */
    while (1) {
        /* do work */
        Kernel_Thread_Sleep(100);
        Kernel_Thread_Heartbeat();
    }
}

void Task_Supervisor(void)                  /* created first, so it is thread ID 1 */
{
    while (1) {
        if (!Kernel_Thread_Health_Check()) {
            /* a thread has run out of health, reset or log it */
        }
        Kernel_Thread_Sleep(500);
    }
}
```

---

## Notes and limitations

- Atomic sections do **not** nest. An inner `Kernel_Atomic_End()` also ends the outer section.
- System threads (negative priority) can preempt an atomic owner. They should not use atomic sections themselves, as that overwrites the owner and clears the lock.
- There is no stack overflow detection. Keep an eye on the 384-byte per-thread stacks.
- Equal-priority threads are not time-sliced.
- `Kernel_Thread_Health_Check` monitors thread IDs 2 and above, so create the supervisor thread first (ID 1).
- A tick can occasionally be dropped when `Kernel_Thread_Sleep` and SysTick coincide, which can cause 1 ms drift.
- `Kernel_Timeout_Status_Get` reports a thread that never set a timeout as expired only for the first ~24.8 days of uptime.
- Raise `DEF_KER_MAX_THREADS` if you need more than 11 user threads, and check that total RAM (`(threads + 1) * stack size`) fits your device.

---

## Hardware

| Item | Value |
|---|---|
| Core | ARM Cortex-M0+ |
| Tested device | STM32G030F6P6 |
| Tick source | SysTick, 1 ms |
| Context switch | PendSV (lowest priority) |
| Toolchain | Keil / armasm syntax |
