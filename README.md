# STM32G030 F-RTOS

A tiny preemptive, priority-based RTOS kernel written entirely in ARM assembly for the **Cortex-M0+** (tested on the **STM32G030F6P6**).

- **Version:** 2.0.0

---

## Features

### Scheduler
- Preemptive, priority-based scheduling driven by a 1 ms SysTick
- Context switching is done in **PendSV** at the lowest interrupt priority, so it never delays other ISRs
- Signed 8-bit priorities: **lower value = higher priority**
  - `0x7F` is reserved for the idle thread
  - Negative priorities are treated as *system threads* and can preempt atomic sections
- Equal priorities are resolved by lowest thread ID (no round-robin)
- Idle thread (ID 0) runs when no other thread is ready
- Manual R4-R11 save/restore (Cortex-M0+ cannot push/pop the high registers in one instruction)

### Threads and memory
- Up to **6 user threads + 1 idle thread** by default (`DEF_KER_MAX_THREADS`, configurable)
- Fully static allocation, no heap
- Unified stack model: **384 bytes per thread** (`DEF_KER_STK_SZ`)
- 32-byte task control block per thread

### Sleep and timing
- `Kernel_Thread_Sleep(ms)` blocks a thread for a number of milliseconds and yields immediately
- 64-bit millisecond tick counter (for timestamps, thread health checking and heartbeats), 32-bit tick, and a seconds counter (for uptime)
- Per-thread 64-bit timeouts (`Kernel_Timeout_Set` / `Kernel_Timeout_Status`)

### Atomic sections
- `Kernel_Atomic_Start()` / `Kernel_Atomic_End()` lock the **scheduler**, not the interrupts. ISRs keep running.
- While active, the owner thread keeps the CPU even if a higher-priority thread becomes ready
- System threads or time critical threads (negative priority) can still preempt
- If the owner sleeps inside the section, the scheduler runs idle rather than switching to another thread
- Interrupt state is saved and restored around the update (PRIMASK)

### System utilities
- CPU usage measurement over a 1000-tick window, smoothed with a 2-point average, returned in percent
- Optional **64 MHz PLL** from HSI16 (2 flash wait states); otherwise runs at 16 MHz. SysTick reload is adjusted automatically.
- Debug GPIO that goes high on PendSV entry and low on exit, for measuring context-switch time with a scope or logic analyzer
- Kernel info banner (`Kernel_Print_Info`) and version getters

---

## Performance

Context-switch time measured on the debug GPIO pin (PendSV entry to exit) with **all kernel features enabled** (tick counters, CPU usage, atomic-section check, sleep handling):

| Threads | Context switch time |
|--------:|--------------------:|
| 5       | **3.5 µs**          |
| 10      | **4.5 µs**          |

The cost grows by roughly 0.2 µs per additional thread, because the scheduler walks the TCB list once per switch.

---

## Configuration

Set these constants at the top of `kernel.s`:

| Constant | Default | Description |
|---|---|---|
| `DEF_KER_MAX_THREADS` | 6 | Maximum user threads (idle is added automatically) |
| `DEF_KER_STK_SZ` | 0x180 (384 B) | Stack size per thread |
| `DEF_64MHZ_PLL_ENABLE` | 1 | 1 = 64 MHz PLL, 0 = 16 MHz HSI |
| `DEF_DBG_GPIO_TICK_EN` | 1 | Enable the debug GPIO toggle in PendSV |
| `DEF_DBG_GPIO_PORT` | 0 | Debug pin port (0 = A, 1 = B, ...) |
| `DEF_DBG_GPIO_PIN` | 3 | Debug pin number (0-15) |
| `DEF_INFO_BLOCK_SIZE` | 0x200 | Size of the info banner block |

---

## API

```c
void     Kernel_Init(void);
void     Kernel_Thread_Create(void (*func)(void), int8_t prio);
void     Kernel_Thread_Sleep(uint32_t ms);
void     Kernel_Thread_Run_All(void);

void     Kernel_Atomic_Start(void);
void     Kernel_Atomic_End(void);

uint32_t Kernel_Tick_SS32_Get(void);
uint64_t Kernel_Tick_SS64_Get(void);
uint32_t Kernel_Tick_S_Get(void);

void     Kernel_Timeout_Set(uint32_t ms);
uint8_t  Kernel_Timeout_Status(void);

uint8_t  Kernel_CPU_Usage_Get(void);

uint8_t  Kernel_Version_Major_Get(void);
uint8_t  Kernel_Version_Minor_Get(void);
uint8_t  Kernel_Version_Patch_Get(void);

uint8_t  Kernel_Info_Char_Get(uint32_t index);
void     Kernel_Print_Info(void (*func)(uint8_t));
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
while (!Kernel_Timeout_Status()) {
    /* wait for an event */
    Kernel_Thread_Sleep(1);
}
```

---

## Notes and limitations

- Atomic sections do **not** nest. An inner `Kernel_Atomic_End()` also ends the outer section.
- There is no stack overflow detection. Keep an eye on the 384-byte per-thread stacks.
- Equal-priority threads are not time-sliced.
- Raise `DEF_KER_MAX_THREADS` if you need more than 6 user threads, and check that total RAM (`(threads + 1) * stack size`) fits your device.

---

## Hardware

| Item | Value |
|---|---|
| Core | ARM Cortex-M0+ |
| Tested device | STM32G030F6P6 |
| Tick source | SysTick, 1 ms |
| Context switch | PendSV (lowest priority) |
| Toolchain | Keil / armasm syntax |
