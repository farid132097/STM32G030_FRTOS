# STM32G030 F-RTOS

A small preemptive, priority-based RTOS kernel for the ARM Cortex-M0+ (ARMv6-M), written entirely in assembly (armasm syntax), with a C header (`kernel.h`) for use from application code.

- **Version:** 3.0.0
- **Tested on:** STM32G030F6P6

## Overview

- Preemptive scheduling driven by a 1 ms SysTick. SysTick only pends PendSV, and the context switch runs in PendSV (lowest priority).
- Fixed-priority scheduling with a signed 8-bit priority (`int8_t`). The lowest number wins, and the lowest thread ID wins ties (no round-robin among equals).
- Thread 0 is the idle thread (priority `127`), so user threads must use priorities from `-128` to `126`.
- Negative priorities are "system" priorities. They can preempt a thread that is inside an atomic section.
- `Kernel_Thread_Sleep` blocks the caller for N ticks and yields immediately.
- 64-bit sub-second tick, seconds counter, per-thread timeouts and CPU usage.
- Per-thread health monitoring (heartbeat, timeout, health count) that can drive a hardware watchdog from a supervisor thread.
- Atomic sections that keep the calling thread on the CPU.
- 16 MHz (HSI16) or 64 MHz (PLL) system clock, selected with `DEF_64MHZ_PLL_ENABLE`.

## Quick start

```c
#include "kernel.h"

int main(void)
{
    Kernel_Init();                                   /* clock, SysTick config values, idle thread */
    Kernel_Thread_Create(THREAD1_SysSVC,  -1);       /* thread ID 1, system priority */
    Kernel_Thread_Create(THREAD2_Thread,   1);       /* thread ID 2 */
    Kernel_Thread_Create(THREAD3_Thread,   2);       /* thread ID 3 */
    Kernel_Thread_Run_All();                         /* does not return */
}
```

Thread IDs are assigned in creation order (idle is 0, the first created thread is 1). `Kernel_Thread_Create` returns 1 on success and 0 if the entry pointer is null or the thread table is full. Thread functions must never return.

## API

All functions are declared in `kernel.h`.

| Function | Description |
|---|---|
| `Kernel_Init()` | Configures the clock, initializes kernel variables and creates the idle thread. |
| `Kernel_Thread_Create(fptr, prio)` | Creates a thread. Returns 1 on success, 0 if `fptr` is null or all slots are used. |
| `Kernel_Thread_Run_All()` | Starts SysTick and switches to the idle thread. Does not return. |
| `Kernel_Thread_Sleep(ticks)` | Blocks the calling thread for `ticks` ms. Thread mode only. |
| `Kernel_Thread_Heartbeat()` | Records the current tick and increments the heartbeat counter for the calling thread. |
| `Kernel_Thread_Health_Set(tout, health)` | Enables health monitoring for the calling thread: timeout in ms and a starting health count (0 to 255). Also records a first heartbeat. |
| `Kernel_Thread_Health_Get(tid)` | Returns the remaining health count of thread `tid`. |
| `Kernel_Thread_Health_Check()` | Returns 1 if every monitored thread is healthy, 0 once any has run out of health. |
| `Kernel_Atomic_Start()` / `Kernel_Atomic_End()` | Begin and end an atomic section for the calling thread. Not nestable. |
| `Kernel_Tick_SubSeconds_Get()` | Returns the 64-bit millisecond tick. |
| `Kernel_Tick_Seconds_Get()` | Returns the seconds counter. |
| `Kernel_Timeout_Set(ms)` | Starts a timeout for the calling thread. The argument is 16-bit (0 to 65,535 ms). |
| `Kernel_Timeout_Status_Get()` | Returns 1 once the calling thread's timeout has expired, otherwise 0. |
| `Kernel_CPU_Usage_Get()` | Returns the average CPU usage in percent. |
| `Kernel_Version_Major_Get()`, `_Minor_Get()`, `_Patch_Get()` | Return the kernel version numbers. |

### Health monitoring

Each thread opts in by calling `Kernel_Thread_Health_Set` once, then calls `Kernel_Thread_Heartbeat` at least once per timeout. A supervisor thread calls `Kernel_Thread_Health_Check` periodically.

- On each check, a monitored thread whose last heartbeat is older than its timeout loses 1 health point.
- Health is never restored. When a thread's health reaches 0, the check result stays 0 permanently.
- `Kernel_Thread_Health_Check` starts at thread ID 2. Thread 1 is meant to be the supervisor and is not monitored.
- A typical use is to reload a hardware watchdog only when `Kernel_Thread_Health_Check` returns 1, so a stalled thread leads to a watchdog reset.
- The elapsed time is computed from the low 32 bits of the tick, so a thread silent for more than 49.7 days would look healthy again.

### Atomic sections

Between `Kernel_Atomic_Start` and `Kernel_Atomic_End`, the owner thread keeps the CPU against threads of priority 0 and above. Threads with a negative priority can still preempt it. If the owner sleeps inside the section, the idle thread runs until it wakes. Sections cannot be nested.

### Timeouts

`Kernel_Timeout_Set` stores a 32-bit deadline (`now + ms`). `Kernel_Timeout_Status_Get` returns the sign of `deadline - now`, so the comparison stays correct across the 32-bit tick wrap. The argument is limited to 16 bits, well below the 2^31 ms the method supports.

## Register conventions

### Public functions (AAPCS)

| Register | Role |
|---|---|
| R0-R3 | Arguments and scratch. R0 (and R1 for 64-bit values) carry results. |
| R4-R11 | Callee-saved. A function that uses them must push and restore them. |
| R12 | Scratch. |
| SP | 8-byte aligned at every call (`PRESERVE8`). A function that pushes only LR pads the push, for example `PUSH {R4, LR}`. |
| LR | Return address. Saved around any `BL`. |

### Function signatures

| Function | In | Out | Clobbers |
|---|---|---|---|
| `Kernel_Init` | none | none | R0-R3 |
| `Kernel_Thread_Create` | R0 = entry address, R1 = priority (signed byte) | R0 = 1 success, 0 null pointer or table full | R0-R3 |
| `Kernel_Thread_Run_All` | none | does not return | R0-R2 |
| `Kernel_Thread_Sleep` | R0 = ticks (thread mode only) | none | R0-R3 |
| `Kernel_Thread_Heartbeat` | none | none | R0-R3 |
| `Kernel_Thread_Health_Set` | R0 = timeout (ms), R1 = health | none | R0-R3 |
| `Kernel_Thread_Health_Get` | R0 = thread ID | R0 = health | R0-R1 |
| `Kernel_Thread_Health_Check` | none | R0 = 1 if all healthy, else 0 | R0-R3 |
| `Kernel_Atomic_Start` | none | none | R0-R3 |
| `Kernel_Atomic_End` | none | none | R0-R1 |
| `Kernel_Tick_SubSeconds_Get` | none | R0 = low word, R1 = high word | R2-R3 |
| `Kernel_Tick_Seconds_Get` | none | R0 = seconds | none |
| `Kernel_Timeout_Set` | R0 = ticks from now (low 16 bits used) | none | R0-R3 |
| `Kernel_Timeout_Status_Get` | none | R0 = 1 if the timeout has expired, else 0 | R0-R2 |
| `Kernel_CPU_Usage_Get` | none | R0 = average usage in percent | R0-R1 |
| `Kernel_Version_*_Get` | none | R0 = version number | none |

`Kernel_Thread_Sleep` must be called from a thread with PRIMASK clear and never from an ISR. From an ISR it would block the interrupted thread, and with PRIMASK set the thread stays marked blocked while it keeps running.

### PendSV register plan

After `MACRO_CONTEXT_SAVE` all of R0-R12 are free inside the handler except R1-R3, which hold the base pointers and the yield flag. The CPU reloads R0-R3 and R12 from the hardware frame on exception return, and R4-R11 are restored by the restore macro. The only values to preserve are SP and LR (EXC_RETURN), so **no `BL` is allowed inside PendSV**.

| Register | Holds | Valid from | Notes |
|---|---|---|---|
| R1 | `KER_THREAD_CB` base | context save | Must not change until context restore |
| R2 | `KER_SYS_VARS` base | context save | Must not change until context restore |
| R3 | Yield flag (`SysVarsYield`) | context save | Must not change until `MACRO_CLR_YIELD` |
| R0 | Outgoing PSP in the save, incoming PSP in the restore. In the scheduler it is 0 on a yield and -1 otherwise, used to decrement sleep counts. | | |
| R4 | Best priority found by the scheduler | scheduler | Read by `MACRO_KER_SCHEDULER_EXC` |
| R5 | Best TCB, then selected thread ID | scheduler | Stored as the current thread ID |
| R6-R8 | Scheduler scratch (TCB iterator, end pointer) | scheduler | Free afterwards |

Rules for editing PendSV macros:

1. Between `MACRO_CONTEXT_SAVE` and `MACRO_CONTEXT_RESTORE`, only use R0 and R4-R12 as scratch. R1-R3 are read-only.
2. Do not use `BL`, because it overwrites LR.
3. `MACRO_GPIO_SET` runs before the save and `MACRO_GPIO_CLEAR` after the restore, and both clobber R0 and R1.
4. The handler runs with interrupts disabled (`CPSID I`), so the yield flag and tick state cannot change mid-switch.

PendSV order: save context, run the scheduler, apply the atomic-section exception, update the tick counters, update CPU usage, clear the yield flag, restore context. The tick counters and CPU usage are skipped when the entry was caused by a yield.

### Memory layout

Only three base addresses are used (`KER_THREAD_STK`, `KER_THREAD_CB`, `KER_SYS_VARS`), so every field is reachable with an immediate offset. Offsets are `DEF_TB_OFF_*` and `DEF_SV_OFF_*` constants in `kernel.S`.

**Thread control block** (`KER_THREAD_CB`, 32 bytes each, `1 << DEF_KER_TCB_LSFT`):

| Offset | Size | Field |
|---|---|---|
| 0 | 1 (signed) | Priority |
| 1 | 1 | Status |
| 2 | 1 | Health |
| 3 | 1 | Health set (monitoring enabled) |
| 4 | 4 | Saved PSP |
| 8 | 4 | Sleep count (ticks) |
| 12 | 4 | Timeout deadline (32-bit) |
| 16 / 20 | 4 / 4 | Heartbeat timestamp low / high |
| 24 | 4 | Heartbeat count |
| 28 | 4 | Health timeout (ms) |

The four byte fields must be accessed with `LDRB`/`STRB`. The context switch adds `DEF_TB_OFF_PSP` to the TCB offset, so the saved PSP can sit anywhere in the block.

**System variables** (`KER_SYS_VARS`, 60 bytes used):

| Offset | Field | Offset | Field |
|---|---|---|---|
| 0 | Thread count | 28 | Usage total ticks |
| 4 | Current thread ID | 32 | Usage active ticks |
| 8 | Yield flag | 36 | Usage (permille) |
| 12 / 16 | 64-bit tick low / high | 40 | Usage average (permille) |
| 20 | Sub-second counter (32-bit, ms) | 44 | SysTick reload value |
| 24 | Seconds | 48 | Atomic operation flag |
| | | 52 | Atomic owner thread ID |
| | | 56 | Health OK flag |

**Thread stack frame** (initial frame is 16 words, saved PSP points at the lowest address):

| Offset | Content | Saved by |
|---|---|---|
| 0-28 | R4, R5, R6, R7, R8, R9, R10, R11 | PendSV (software) |
| 32-60 | R0, R1, R2, R3, R12, LR, PC, xPSR | CPU (hardware) |

New threads start with an initial xPSR of `0x01000000` (Thumb bit set) and PC set to the entry address. All other registers, including LR, are zero, so a thread must never return from its entry function.

## Performance

The figures below were measured with the debug GPIO pulse (`DEF_DBG_GPIO_TICK_EN`) on an earlier revision of the kernel and have not been re-measured for version 3.0.0. The newer atomic-section check and byte-wide TCB fields change the cycle counts slightly. They are kept as a reference for scale.

Context switch time, from the start to the end of the PendSV handler, excludes exception entry and exit (roughly 30 cycles in total, estimated and not measured). "Optional features" refers to the 64-bit tick, seconds counter and CPU usage calculation.

| Clock | Threads | Optional features | Time (µs) | Cycles | Tick overhead |
|---|---|---|---|---|---|
| 16 MHz | 10 | On | 22.125 | 354 | 2.21 % |
| 16 MHz | 10 | Off | 19.750 | 316 | 1.98 % |
| 16 MHz | 5 | On | 15.563 | 249 | 1.56 % |
| 16 MHz | 5 | Off | 13.188 | 211 | 1.32 % |
| 64 MHz | 10 | On | 6.250 | 400 | 0.63 % |
| 64 MHz | 10 | Off | 5.438 | 348 | 0.54 % |
| 64 MHz | 5 | On | 4.438 | 284 | 0.44 % |
| 64 MHz | 5 | Off | 3.688 | 236 | 0.37 % |

Tick overhead is the switch time as a share of the 1 ms tick period.

### Derived figures

| Metric | 16 MHz | 64 MHz |
|---|---|---|
| Scheduler cost per thread (cycles) | 21 | 22.4 to 23.2 |
| Optional feature cost (cycles) | 38 | 48 to 52 |
| Speed-up from 16 MHz to 64 MHz | | 3.5x to 3.6x |
| Cycle increase at 64 MHz | | 10 % to 14 % |

The cycle count grows at 64 MHz because of flash wait states (2 wait states are set for 64 MHz). The prefetch buffer and instruction cache are enabled in `FLASH_ACR` to reduce this.

### Alignment sensitivity

When the kernel executes from flash, the switch time can change by about 1 µs at 64 MHz after unrelated edits, because code shifts relative to the 64-bit flash line. If timing moves for no visible reason, check the alignment of the scheduler loop and the address of `PendSV_Handler` in the map file. An `ALIGN 8` in front of a hot loop label (outside the loop) makes the timing independent of earlier edits.

## Build notes

- Assembler: armasm (Keil MDK / Arm Compiler). Thumb mode, `PRESERVE8`.
- Maximum threads: `DEF_KER_MAX_THREADS` (11), plus the idle thread, so 12 slots in total.
- Stack size per thread: `DEF_KER_STK_SZ` (384 bytes). It must be a multiple of 8 and `KER_THREAD_STK` must be 8-byte aligned. `KER_THREAD_STK` is `(DEF_KER_MAX_THREADS + 1) * DEF_KER_STK_SZ` bytes (4608).
- `DEF_KER_TCB_SZ` (32) must equal `1 << DEF_KER_TCB_LSFT` (5), and it must be at least 32 so every TCB field fits.
- `DEF_DBG_GPIO_TICK_EN`, `DEF_DBG_GPIO_PORT` and `DEF_DBG_GPIO_PIN` enable and place the debug pin that toggles during PendSV.

## Known limitations

- Equal-priority threads are not time-sliced, so a thread must sleep to let a lower-ID peer of the same priority run.
- A tick that coincides with a `Kernel_Thread_Sleep` call can be merged into the sleep's PendSV and skipped, losing 1 ms of timekeeping occasionally.
- The status field is written by create and sleep but never read by the scheduler. Readiness comes from the sleep count alone, so adding new states needs a guard in the scheduler.
- Stack overflow is not detected. Each stack is 384 bytes, which also has to cover the 64-byte context frame.
- Thread creation is intended before `Kernel_Thread_Run_All`. `Kernel_Thread_Create` returns 0 when no slot is left, and the caller has to check it.
- Atomic sections are not nestable.
- Health counts are not restored once lost, and the check result stays 0.
- `Kernel_Timeout_Set` takes a 16-bit argument. Larger values are truncated.
