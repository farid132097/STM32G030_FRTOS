# STM32G030 RTOS

A small preemptive, priority-based RTOS kernel for the ARM Cortex-M0+ (ARMv6-M), written entirely in assembly (armasm syntax).

- **Version:** 2.0.0
- **Tested on:** STM32G030F6P6

## Overview

- Preemptive scheduling driven by a 1 ms SysTick, with the context switch done in PendSV (lowest priority).
- Fixed-priority scheduling: the lowest priority number wins, and the lowest thread ID wins ties (no round-robin among equals).
- Thread 0 is the idle thread (priority `0xFF`), so user threads must use priorities below `0xFF`.
- `Kernel_Thread_Sleep` blocks the caller for N ticks and yields immediately.
- 64-bit sub-second tick, seconds counter, per-thread timeouts and CPU usage (x10) are optional features.
- 16 MHz (HSI16) or 64 MHz (PLL) system clock, selected with `DEF_64MHZ_PLL_ENABLE`.

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
| `Kernel_Thread_Create` | R0 = entry address, R1 = priority | none | R0-R3 |
| `Kernel_Thread_Run_All` | none | does not return | R0-R2 |
| `Kernel_Thread_Sleep` | R0 = ticks (thread mode only) | none | R0-R3 |
| `Kernel_Tick_SS32_Get` | none | R0 = low 32 bits of the sub-second tick | none |
| `Kernel_Tick_SS64_Get` | none | R0 = low word, R1 = high word | R2 |
| `Kernel_Tick_S_Get` | none | R0 = seconds | none |
| `Kernel_Timeout_Set` | R0 = ticks from now | none | R0-R3 |
| `Kernel_Timeout_Status` | none | R0 = 1 if the timeout has expired, else 0 | R0-R3 |
| `Kernel_CPU_Usage_x10_Get` | none | R0 = usage in 0.1 % units | none |
| `Kernel_CPU_Usage_Avg_x10_Get` | none | R0 = averaged usage in 0.1 % units | none |

`Kernel_Thread_Sleep` must be called from a thread with PRIMASK clear and never from an ISR. From an ISR it would block the interrupted thread, and with PRIMASK set the thread stays marked blocked while it keeps running.

### PendSV register plan

After `MACRO_CONTEXT_SAVE` all of R0-R12 are free inside the handler. The CPU reloads R0-R3 and R12 from the hardware frame on exception return, and R4-R11 are restored by the pop macro. The only values to preserve are SP and LR (EXC_RETURN), so **no `BL` is allowed inside PendSV**.

| Register | Holds | Valid from | Notes |
|---|---|---|---|
| R1 | `KER_THREAD_CB` base | context save | Must not change until context restore |
| R2 | `KER_SYS_VARS` base | context save | Must not change until context restore |
| R3 | Yield flag (`SysVarsYield`) | context save | Must not change until `MACRO_CLR_YIELD` |
| R0 | Scratch (outgoing PSP in the save, incoming PSP in the restore) | | |
| R4-R7 | Scratch for each macro | | Restored from the new thread's frame |
| R12 | Cached `SysVarsTCnt` in the scheduler | | |

Rules for editing PendSV macros:

1. Between `MACRO_CONTEXT_SAVE` and `MACRO_CONTEXT_RESTORE`, only use R0, R4-R7 and R12 as scratch. R1-R3 are read-only.
2. Do not use `BL`, because it overwrites LR.
3. `MACRO_GPIO_SET` runs before the save and `MACRO_GPIO_CLEAR` after the restore, and both clobber R0 and R1.
4. The handler runs with interrupts disabled (`CPSID I`), so the cached Yield flag and tick state cannot change mid-switch.

### Memory layout

Only three base addresses are used, so every field is reachable with an immediate offset.

**Thread control block** (`KER_THREAD_CB`, 32 bytes each, `1 << DEF_KER_TCB_LSFT`):

| Offset | Field |
|---|---|
| 0 | Saved PSP (must be first) |
| 4 | Priority |
| 8 | Status |
| 12 | Sleep count (ticks) |
| 16 / 20 | Timeout low / high |

**System variables** (`KER_SYS_VARS`):

| Offset | Field | Offset | Field |
|---|---|---|---|
| 0 | Thread count | 40 | Sub-second counter (32-bit, ms) |
| 4 | Current thread ID | 44 | Seconds |
| 8 | Highest priority | 48 | Usage total ticks |
| 12 | Highest priority thread ID | 52 | Usage active ticks |
| 16 | Yield flag | 56 | Usage (x10) |
| 32 / 36 | 64-bit sub-second tick low / high | 60 | Usage average (x10) |
| 64 | SysTick reload value | | |

**Thread stack frame** (16 words per thread, saved PSP points at the lowest address):

| Offset | Content | Saved by |
|---|---|---|
| 0-28 | R4, R5, R6, R7, R8, R9, R10, R11 | PendSV (software) |
| 32-60 | R0, R1, R2, R3, R12, LR, PC, xPSR | CPU (hardware) |

New threads start with an initial xPSR of `0x01000000` (Thumb bit set) and PC set to the entry address. LR is zero, so a thread must never return from its entry function.

## Performance

Context switch time, from the start to the end of the PendSV handler. Measured with the debug GPIO pulse (`DEF_DBG_GPIO_TICK_EN`), which excludes exception entry and exit (roughly 30 cycles in total, estimated and not measured). "Optional features" means the 64-bit tick, seconds counter and CPU usage calculation.

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
- Maximum threads: `DEF_KER_MAX_THREADS` (10), plus the idle thread.
- Stack size per thread: `DEF_KER_STK_SZ` (256 bytes). It must be a multiple of 8 and `KER_THREAD_STK` must be 8-byte aligned.
- `DEF_KER_TCB_SZ` must equal `1 << DEF_KER_TCB_LSFT`.

## Known limitations

- Equal-priority threads are not time-sliced, so a thread must sleep to let a lower-ID peer of the same priority run.
- A tick that coincides with a `Kernel_Thread_Sleep` call can be merged into the sleep's PendSV and skipped, losing 1 ms of timekeeping occasionally.
- Thread status is derived from the sleep count alone, so adding new states needs a guard in the scheduler.
- Threads are expected to be created before `Kernel_Thread_Run_All`.
