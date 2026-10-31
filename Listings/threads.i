# 1 "threads.c"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 382 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "threads.c" 2


# 1 ".\\stm32g030xx.h" 1
# 69 ".\\stm32g030xx.h"
typedef enum
{

  NonMaskableInt_IRQn = -14,
  HardFault_IRQn = -13,
  SVCall_IRQn = -5,
  PendSV_IRQn = -2,
  SysTick_IRQn = -1,

  WWDG_IRQn = 0,
  RTC_TAMP_IRQn = 2,
  FLASH_IRQn = 3,
  RCC_IRQn = 4,
  EXTI0_1_IRQn = 5,
  EXTI2_3_IRQn = 6,
  EXTI4_15_IRQn = 7,
  DMA1_Channel1_IRQn = 9,
  DMA1_Channel2_3_IRQn = 10,
  DMA1_Ch4_5_DMAMUX1_OVR_IRQn = 11,
  ADC1_IRQn = 12,
  TIM1_BRK_UP_TRG_COM_IRQn = 13,
  TIM1_CC_IRQn = 14,
  TIM3_IRQn = 16,
  TIM14_IRQn = 19,
  TIM16_IRQn = 21,
  TIM17_IRQn = 22,
  I2C1_IRQn = 23,
  I2C2_IRQn = 24,
  SPI1_IRQn = 25,
  SPI2_IRQn = 26,
  USART1_IRQn = 27,
  USART2_IRQn = 28,
} IRQn_Type;





# 1 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\core_cm0plus.h" 1
# 27 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\core_cm0plus.h" 3







# 1 "C:\\Keil\\ARM\\ARMCLANG\\bin\\..\\include\\stdint.h" 1 3
# 56 "C:\\Keil\\ARM\\ARMCLANG\\bin\\..\\include\\stdint.h" 3
typedef signed char int8_t;
typedef signed short int int16_t;
typedef signed int int32_t;
typedef signed long long int int64_t;


typedef unsigned char uint8_t;
typedef unsigned short int uint16_t;
typedef unsigned int uint32_t;
typedef unsigned long long int uint64_t;





typedef signed char int_least8_t;
typedef signed short int int_least16_t;
typedef signed int int_least32_t;
typedef signed long long int int_least64_t;


typedef unsigned char uint_least8_t;
typedef unsigned short int uint_least16_t;
typedef unsigned int uint_least32_t;
typedef unsigned long long int uint_least64_t;




typedef signed int int_fast8_t;
typedef signed int int_fast16_t;
typedef signed int int_fast32_t;
typedef signed long long int int_fast64_t;


typedef unsigned int uint_fast8_t;
typedef unsigned int uint_fast16_t;
typedef unsigned int uint_fast32_t;
typedef unsigned long long int uint_fast64_t;






typedef signed int intptr_t;
typedef unsigned int uintptr_t;



typedef signed long long intmax_t;
typedef unsigned long long uintmax_t;
# 35 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\core_cm0plus.h" 2 3
# 63 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\core_cm0plus.h" 3
# 1 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\cmsis_version.h" 1 3
# 27 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\cmsis_version.h" 3
# 64 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\core_cm0plus.h" 2 3
# 116 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\core_cm0plus.h" 3
# 1 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\cmsis_compiler.h" 1 3
# 32 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\cmsis_compiler.h" 3
# 1 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\cmsis_armclang.h" 1 3
# 29 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\cmsis_armclang.h" 3


# 1 "C:\\Keil\\ARM\\ARMCLANG\\bin\\..\\include\\arm_acle.h" 1 3
# 45 "C:\\Keil\\ARM\\ARMCLANG\\bin\\..\\include\\arm_acle.h" 3
static __inline__ void __attribute__((__always_inline__, __nodebug__)) __wfi(void) {
  __builtin_arm_wfi();
}



static __inline__ void __attribute__((__always_inline__, __nodebug__)) __wfe(void) {
  __builtin_arm_wfe();
}



static __inline__ void __attribute__((__always_inline__, __nodebug__)) __sev(void) {
  __builtin_arm_sev();
}



static __inline__ void __attribute__((__always_inline__, __nodebug__)) __sevl(void) {
  __builtin_arm_sevl();
}



static __inline__ void __attribute__((__always_inline__, __nodebug__)) __yield(void) {
  __builtin_arm_yield();
}







static __inline__ uint32_t __attribute__((__always_inline__, __nodebug__))
__swp(uint32_t __x, volatile uint32_t *__p) {
  uint32_t v;
  do
    v = __builtin_arm_ldrex(__p);
  while (__builtin_arm_strex(__x, __p));
  return v;
}
# 113 "C:\\Keil\\ARM\\ARMCLANG\\bin\\..\\include\\arm_acle.h" 3
static __inline__ void __attribute__((__always_inline__, __nodebug__)) __nop(void) {
  __builtin_arm_nop();
}





static __inline__ uint32_t __attribute__((__always_inline__, __nodebug__))
__ror(uint32_t __x, uint32_t __y) {
  __y %= 32;
  if (__y == 0)
    return __x;
  return (__x >> __y) | (__x << (32 - __y));
}

static __inline__ uint64_t __attribute__((__always_inline__, __nodebug__))
__rorll(uint64_t __x, uint32_t __y) {
  __y %= 64;
  if (__y == 0)
    return __x;
  return (__x >> __y) | (__x << (64 - __y));
}

static __inline__ unsigned long __attribute__((__always_inline__, __nodebug__))
__rorl(unsigned long __x, uint32_t __y) {

  return __ror(__x, __y);



}



static __inline__ unsigned int __attribute__((__always_inline__, __nodebug__))
__clz(uint32_t __t) {
  return __builtin_arm_clz(__t);
}

static __inline__ unsigned int __attribute__((__always_inline__, __nodebug__))
__clzl(unsigned long __t) {

  return __builtin_arm_clz(__t);



}

static __inline__ unsigned int __attribute__((__always_inline__, __nodebug__))
__clzll(uint64_t __t) {
  return __builtin_arm_clz64(__t);
}


static __inline__ unsigned int __attribute__((__always_inline__, __nodebug__))
__cls(uint32_t __t) {
  return __builtin_arm_cls(__t);
}

static __inline__ unsigned int __attribute__((__always_inline__, __nodebug__))
__clsl(unsigned long __t) {

  return __builtin_arm_cls(__t);



}

static __inline__ unsigned int __attribute__((__always_inline__, __nodebug__))
__clsll(uint64_t __t) {
  return __builtin_arm_cls64(__t);
}


static __inline__ uint32_t __attribute__((__always_inline__, __nodebug__))
__rev(uint32_t __t) {
  return __builtin_bswap32(__t);
}

static __inline__ unsigned long __attribute__((__always_inline__, __nodebug__))
__revl(unsigned long __t) {

  return __builtin_bswap32(__t);



}

static __inline__ uint64_t __attribute__((__always_inline__, __nodebug__))
__revll(uint64_t __t) {
  return __builtin_bswap64(__t);
}


static __inline__ uint32_t __attribute__((__always_inline__, __nodebug__))
__rev16(uint32_t __t) {
  return __ror(__rev(__t), 16);
}

static __inline__ uint64_t __attribute__((__always_inline__, __nodebug__))
__rev16ll(uint64_t __t) {
  return (((uint64_t)__rev16(__t >> 32)) << 32) | (uint64_t)__rev16((uint32_t)__t);
}

static __inline__ unsigned long __attribute__((__always_inline__, __nodebug__))
__rev16l(unsigned long __t) {

    return __rev16(__t);



}


static __inline__ int16_t __attribute__((__always_inline__, __nodebug__))
__revsh(int16_t __t) {
  return (int16_t)__builtin_bswap16((uint16_t)__t);
}


static __inline__ uint32_t __attribute__((__always_inline__, __nodebug__))
__rbit(uint32_t __t) {
  return __builtin_arm_rbit(__t);
}

static __inline__ uint64_t __attribute__((__always_inline__, __nodebug__))
__rbitll(uint64_t __t) {

  return (((uint64_t)__builtin_arm_rbit(__t)) << 32) |
         __builtin_arm_rbit(__t >> 32);



}

static __inline__ unsigned long __attribute__((__always_inline__, __nodebug__))
__rbitl(unsigned long __t) {

  return __rbit(__t);



}
# 32 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\cmsis_armclang.h" 2 3
# 71 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\cmsis_armclang.h" 3
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wpacked"
  struct __attribute__((packed, aligned(1))) T_UINT16_WRITE { uint16_t v; };
#pragma clang diagnostic pop



#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wpacked"
  struct __attribute__((packed, aligned(1))) T_UINT16_READ { uint16_t v; };
#pragma clang diagnostic pop



#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wpacked"
  struct __attribute__((packed, aligned(1))) T_UINT32_WRITE { uint32_t v; };
#pragma clang diagnostic pop



#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wpacked"
  struct __attribute__((packed, aligned(1))) T_UINT32_READ { uint32_t v; };
#pragma clang diagnostic pop
# 282 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\cmsis_armclang.h" 3
__attribute__((always_inline)) static inline int32_t __SSAT(int32_t val, uint32_t sat)
{
  if ((sat >= 1U) && (sat <= 32U))
  {
    const int32_t max = (int32_t)((1U << (sat - 1U)) - 1U);
    const int32_t min = -1 - max ;
    if (val > max)
    {
      return (max);
    }
    else if (val < min)
    {
      return (min);
    }
  }
  return (val);
}
# 308 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\cmsis_armclang.h" 3
__attribute__((always_inline)) static inline uint32_t __USAT(int32_t val, uint32_t sat)
{
  if (sat <= 31U)
  {
    const uint32_t max = ((1U << sat) - 1U);
    if (val > (int32_t)max)
    {
      return (max);
    }
    else if (val < 0)
    {
      return (0U);
    }
  }
  return ((uint32_t)val);
}
# 621 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\cmsis_armclang.h" 3
__attribute__((always_inline)) static inline void __enable_irq(void)
{
  __asm volatile ("cpsie i" : : : "memory");
}
# 634 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\cmsis_armclang.h" 3
__attribute__((always_inline)) static inline void __disable_irq(void)
{
  __asm volatile ("cpsid i" : : : "memory");
}
# 670 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\cmsis_armclang.h" 3
__attribute__((always_inline)) static inline uint32_t __get_FPSCR(void)
{



  return (0U);

}







__attribute__((always_inline)) static inline void __set_FPSCR(uint32_t fpscr)
{



  (void)fpscr;

}
# 702 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\cmsis_armclang.h" 3
# 1 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\./m-profile/cmsis_armclang_m.h" 1 3
# 27 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\./m-profile/cmsis_armclang_m.h" 3
# 128 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\./m-profile/cmsis_armclang_m.h" 3
__attribute__((always_inline)) static inline uint32_t __get_CONTROL(void)
{
  uint32_t result;

  __asm volatile ("MRS %0, control" : "=r" (result) );
  return (result);
}
# 158 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\./m-profile/cmsis_armclang_m.h" 3
__attribute__((always_inline)) static inline void __set_CONTROL(uint32_t control)
{
  __asm volatile ("MSR control, %0" : : "r" (control) : "memory");
  __builtin_arm_isb(0xF);
}
# 184 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\./m-profile/cmsis_armclang_m.h" 3
__attribute__((always_inline)) static inline uint32_t __get_IPSR(void)
{
  uint32_t result;

  __asm volatile ("MRS %0, ipsr" : "=r" (result) );
  return (result);
}







__attribute__((always_inline)) static inline uint32_t __get_APSR(void)
{
  uint32_t result;

  __asm volatile ("MRS %0, apsr" : "=r" (result) );
  return (result);
}







__attribute__((always_inline)) static inline uint32_t __get_xPSR(void)
{
  uint32_t result;

  __asm volatile ("MRS %0, xpsr" : "=r" (result) );
  return (result);
}







__attribute__((always_inline)) static inline uint32_t __get_PSP(void)
{
  uint32_t result;

  __asm volatile ("MRS %0, psp" : "=r" (result) );
  return (result);
}
# 256 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\./m-profile/cmsis_armclang_m.h" 3
__attribute__((always_inline)) static inline void __set_PSP(uint32_t topOfProcStack)
{
  __asm volatile ("MSR psp, %0" : : "r" (topOfProcStack) : );
}
# 280 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\./m-profile/cmsis_armclang_m.h" 3
__attribute__((always_inline)) static inline uint32_t __get_MSP(void)
{
  uint32_t result;

  __asm volatile ("MRS %0, msp" : "=r" (result) );
  return (result);
}
# 310 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\./m-profile/cmsis_armclang_m.h" 3
__attribute__((always_inline)) static inline void __set_MSP(uint32_t topOfMainStack)
{
  __asm volatile ("MSR msp, %0" : : "r" (topOfMainStack) : );
}
# 361 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\./m-profile/cmsis_armclang_m.h" 3
__attribute__((always_inline)) static inline uint32_t __get_PRIMASK(void)
{
  uint32_t result;

  __asm volatile ("MRS %0, primask" : "=r" (result) );
  return (result);
}
# 391 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\./m-profile/cmsis_armclang_m.h" 3
__attribute__((always_inline)) static inline void __set_PRIMASK(uint32_t priMask)
{
  __asm volatile ("MSR primask, %0" : : "r" (priMask) : "memory");
}
# 703 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\cmsis_armclang.h" 2 3
# 33 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\cmsis_compiler.h" 2 3
# 117 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\core_cm0plus.h" 2 3
# 211 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\core_cm0plus.h" 3
typedef union
{
  struct
  {
    uint32_t _reserved0:28;
    uint32_t V:1;
    uint32_t C:1;
    uint32_t Z:1;
    uint32_t N:1;
  } b;
  uint32_t w;
} APSR_Type;
# 241 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\core_cm0plus.h" 3
typedef union
{
  struct
  {
    uint32_t ISR:9;
    uint32_t _reserved0:23;
  } b;
  uint32_t w;
} IPSR_Type;
# 259 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\core_cm0plus.h" 3
typedef union
{
  struct
  {
    uint32_t ISR:9;
    uint32_t _reserved0:15;
    uint32_t T:1;
    uint32_t _reserved1:3;
    uint32_t V:1;
    uint32_t C:1;
    uint32_t Z:1;
    uint32_t N:1;
  } b;
  uint32_t w;
} xPSR_Type;
# 298 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\core_cm0plus.h" 3
typedef union
{
  struct
  {
    uint32_t nPRIV:1;
    uint32_t SPSEL:1;
    uint32_t _reserved1:30;
  } b;
  uint32_t w;
} CONTROL_Type;
# 329 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\core_cm0plus.h" 3
typedef struct
{
  volatile uint32_t ISER[1U];
        uint32_t RESERVED0[31U];
  volatile uint32_t ICER[1U];
        uint32_t RESERVED1[31U];
  volatile uint32_t ISPR[1U];
        uint32_t RESERVED2[31U];
  volatile uint32_t ICPR[1U];
        uint32_t RESERVED3[31U];
        uint32_t RESERVED4[64U];
  volatile uint32_t IPR[8U];
} NVIC_Type;
# 356 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\core_cm0plus.h" 3
typedef struct
{
  volatile const uint32_t CPUID;
  volatile uint32_t ICSR;

  volatile uint32_t VTOR;



  volatile uint32_t AIRCR;
  volatile uint32_t SCR;
  volatile uint32_t CCR;
        uint32_t RESERVED1;
  volatile uint32_t SHPR[2U];
  volatile uint32_t SHCSR;
} SCB_Type;
# 473 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\core_cm0plus.h" 3
typedef struct
{
  volatile uint32_t CTRL;
  volatile uint32_t LOAD;
  volatile uint32_t VAL;
  volatile const uint32_t CALIB;
} SysTick_Type;
# 525 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\core_cm0plus.h" 3
typedef struct
{
  volatile const uint32_t TYPE;
  volatile uint32_t CTRL;
  volatile uint32_t RNR;
  volatile uint32_t RBAR;
  volatile uint32_t RASR;
} MPU_Type;
# 757 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\core_cm0plus.h" 3
static inline void __NVIC_EnableIRQ(IRQn_Type IRQn)
{
  if ((int32_t)(IRQn) >= 0)
  {
    __asm volatile("":::"memory");
    ((NVIC_Type *) ((0xE000E000UL) + 0x0100UL) )->ISER[0U] = (uint32_t)(1UL << (((uint32_t)IRQn) & 0x1FUL));
    __asm volatile("":::"memory");
  }
}
# 776 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\core_cm0plus.h" 3
static inline uint32_t __NVIC_GetEnableIRQ(IRQn_Type IRQn)
{
  if ((int32_t)(IRQn) >= 0)
  {
    return((uint32_t)(((((NVIC_Type *) ((0xE000E000UL) + 0x0100UL) )->ISER[0U] & (1UL << (((uint32_t)IRQn) & 0x1FUL))) != 0UL) ? 1UL : 0UL));
  }
  else
  {
    return(0U);
  }
}
# 795 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\core_cm0plus.h" 3
static inline void __NVIC_DisableIRQ(IRQn_Type IRQn)
{
  if ((int32_t)(IRQn) >= 0)
  {
    ((NVIC_Type *) ((0xE000E000UL) + 0x0100UL) )->ICER[0U] = (uint32_t)(1UL << (((uint32_t)IRQn) & 0x1FUL));
    __builtin_arm_dsb(0xF);
    __builtin_arm_isb(0xF);
  }
}
# 814 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\core_cm0plus.h" 3
static inline uint32_t __NVIC_GetPendingIRQ(IRQn_Type IRQn)
{
  if ((int32_t)(IRQn) >= 0)
  {
    return((uint32_t)(((((NVIC_Type *) ((0xE000E000UL) + 0x0100UL) )->ISPR[0U] & (1UL << (((uint32_t)IRQn) & 0x1FUL))) != 0UL) ? 1UL : 0UL));
  }
  else
  {
    return(0U);
  }
}
# 833 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\core_cm0plus.h" 3
static inline void __NVIC_SetPendingIRQ(IRQn_Type IRQn)
{
  if ((int32_t)(IRQn) >= 0)
  {
    ((NVIC_Type *) ((0xE000E000UL) + 0x0100UL) )->ISPR[0U] = (uint32_t)(1UL << (((uint32_t)IRQn) & 0x1FUL));
  }
}
# 848 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\core_cm0plus.h" 3
static inline void __NVIC_ClearPendingIRQ(IRQn_Type IRQn)
{
  if ((int32_t)(IRQn) >= 0)
  {
    ((NVIC_Type *) ((0xE000E000UL) + 0x0100UL) )->ICPR[0U] = (uint32_t)(1UL << (((uint32_t)IRQn) & 0x1FUL));
  }
}
# 866 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\core_cm0plus.h" 3
static inline void __NVIC_SetPriority(IRQn_Type IRQn, uint32_t priority)
{
  if ((int32_t)(IRQn) >= 0)
  {
    ((NVIC_Type *) ((0xE000E000UL) + 0x0100UL) )->IPR[( (((uint32_t)(int32_t)(IRQn)) >> 2UL) )] = ((uint32_t)(((NVIC_Type *) ((0xE000E000UL) + 0x0100UL) )->IPR[( (((uint32_t)(int32_t)(IRQn)) >> 2UL) )] & ~(0xFFUL << ( ((((uint32_t)(int32_t)(IRQn)) ) & 0x03UL) * 8UL))) |
       (((priority << (8U - 2U)) & (uint32_t)0xFFUL) << ( ((((uint32_t)(int32_t)(IRQn)) ) & 0x03UL) * 8UL)));
  }
  else
  {
    ((SCB_Type *) ((0xE000E000UL) + 0x0D00UL) )->SHPR[( (((((uint32_t)(int32_t)(IRQn)) & 0x0FUL)-8UL) >> 2UL) )] = ((uint32_t)(((SCB_Type *) ((0xE000E000UL) + 0x0D00UL) )->SHPR[( (((((uint32_t)(int32_t)(IRQn)) & 0x0FUL)-8UL) >> 2UL) )] & ~(0xFFUL << ( ((((uint32_t)(int32_t)(IRQn)) ) & 0x03UL) * 8UL))) |
       (((priority << (8U - 2U)) & (uint32_t)0xFFUL) << ( ((((uint32_t)(int32_t)(IRQn)) ) & 0x03UL) * 8UL)));
  }
}
# 890 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\core_cm0plus.h" 3
static inline uint32_t __NVIC_GetPriority(IRQn_Type IRQn)
{

  if ((int32_t)(IRQn) >= 0)
  {
    return((uint32_t)(((((NVIC_Type *) ((0xE000E000UL) + 0x0100UL) )->IPR[ ( (((uint32_t)(int32_t)(IRQn)) >> 2UL) )] >> ( ((((uint32_t)(int32_t)(IRQn)) ) & 0x03UL) * 8UL) ) & (uint32_t)0xFFUL) >> (8U - 2U)));
  }
  else
  {
    return((uint32_t)(((((SCB_Type *) ((0xE000E000UL) + 0x0D00UL) )->SHPR[( (((((uint32_t)(int32_t)(IRQn)) & 0x0FUL)-8UL) >> 2UL) )] >> ( ((((uint32_t)(int32_t)(IRQn)) ) & 0x03UL) * 8UL) ) & (uint32_t)0xFFUL) >> (8U - 2U)));
  }
}
# 915 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\core_cm0plus.h" 3
static inline uint32_t NVIC_EncodePriority (uint32_t PriorityGroup, uint32_t PreemptPriority, uint32_t SubPriority)
{
  uint32_t PriorityGroupTmp = (PriorityGroup & (uint32_t)0x07UL);
  uint32_t PreemptPriorityBits;
  uint32_t SubPriorityBits;

  PreemptPriorityBits = ((7UL - PriorityGroupTmp) > (uint32_t)(2U)) ? (uint32_t)(2U) : (uint32_t)(7UL - PriorityGroupTmp);
  SubPriorityBits = ((PriorityGroupTmp + (uint32_t)(2U)) < (uint32_t)7UL) ? (uint32_t)0UL : (uint32_t)((PriorityGroupTmp - 7UL) + (uint32_t)(2U));

  return (
           ((PreemptPriority & (uint32_t)((1UL << (PreemptPriorityBits)) - 1UL)) << SubPriorityBits) |
           ((SubPriority & (uint32_t)((1UL << (SubPriorityBits )) - 1UL)))
         );
}
# 942 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\core_cm0plus.h" 3
static inline void NVIC_DecodePriority (uint32_t Priority, uint32_t PriorityGroup, uint32_t* const pPreemptPriority, uint32_t* const pSubPriority)
{
  uint32_t PriorityGroupTmp = (PriorityGroup & (uint32_t)0x07UL);
  uint32_t PreemptPriorityBits;
  uint32_t SubPriorityBits;

  PreemptPriorityBits = ((7UL - PriorityGroupTmp) > (uint32_t)(2U)) ? (uint32_t)(2U) : (uint32_t)(7UL - PriorityGroupTmp);
  SubPriorityBits = ((PriorityGroupTmp + (uint32_t)(2U)) < (uint32_t)7UL) ? (uint32_t)0UL : (uint32_t)((PriorityGroupTmp - 7UL) + (uint32_t)(2U));

  *pPreemptPriority = (Priority >> SubPriorityBits) & (uint32_t)((1UL << (PreemptPriorityBits)) - 1UL);
  *pSubPriority = (Priority ) & (uint32_t)((1UL << (SubPriorityBits )) - 1UL);
}
# 966 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\core_cm0plus.h" 3
static inline void __NVIC_SetVector(IRQn_Type IRQn, uint32_t vector)
{

  uint32_t *vectors = (uint32_t *) ((uintptr_t) ((SCB_Type *) ((0xE000E000UL) + 0x0D00UL) )->VTOR);
  vectors[(int32_t)IRQn + 16] = vector;





}
# 987 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\core_cm0plus.h" 3
static inline uint32_t __NVIC_GetVector(IRQn_Type IRQn)
{

  uint32_t *vectors = (uint32_t *) ((uintptr_t) ((SCB_Type *) ((0xE000E000UL) + 0x0D00UL) )->VTOR);
  return vectors[(int32_t)IRQn + 16];




}






__attribute__((__noreturn__)) static inline void __NVIC_SystemReset(void)
{
  __builtin_arm_dsb(0xF);

  ((SCB_Type *) ((0xE000E000UL) + 0x0D00UL) )->AIRCR = ((0x5FAUL << 16U) |
                 (1UL << 2U));
  __builtin_arm_dsb(0xF);

  for(;;)
  {
    __nop();
  }
}







# 1 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\m-profile/armv7m_mpu.h" 1 3
# 30 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\m-profile/armv7m_mpu.h" 3
# 181 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\m-profile/armv7m_mpu.h" 3
typedef struct {
  uint32_t RBAR;
  uint32_t RASR;
} ARM_MPU_Region_t;




static inline void ARM_MPU_Enable(uint32_t MPU_Control)
{
  __builtin_arm_dmb(0xF);
  ((MPU_Type *) ((0xE000E000UL) + 0x0D90UL) )->CTRL = MPU_Control | (1UL );



  __builtin_arm_dsb(0xF);
  __builtin_arm_isb(0xF);
}



static inline void ARM_MPU_Disable(void)
{
  __builtin_arm_dmb(0xF);



  ((MPU_Type *) ((0xE000E000UL) + 0x0D90UL) )->CTRL &= ~(1UL );
  __builtin_arm_dsb(0xF);
  __builtin_arm_isb(0xF);
}




static inline void ARM_MPU_ClrRegion(uint32_t rnr)
{
  ((MPU_Type *) ((0xE000E000UL) + 0x0D90UL) )->RNR = rnr;
  ((MPU_Type *) ((0xE000E000UL) + 0x0D90UL) )->RASR = 0U;
}





static inline void ARM_MPU_SetRegion(uint32_t rbar, uint32_t rasr)
{
  ((MPU_Type *) ((0xE000E000UL) + 0x0D90UL) )->RBAR = rbar;
  ((MPU_Type *) ((0xE000E000UL) + 0x0D90UL) )->RASR = rasr;
}






static inline void ARM_MPU_SetRegionEx(uint32_t rnr, uint32_t rbar, uint32_t rasr)
{
  ((MPU_Type *) ((0xE000E000UL) + 0x0D90UL) )->RNR = rnr;
  ((MPU_Type *) ((0xE000E000UL) + 0x0D90UL) )->RBAR = rbar;
  ((MPU_Type *) ((0xE000E000UL) + 0x0D90UL) )->RASR = rasr;
}






static inline void ARM_MPU_OrderedMemcpy(volatile uint32_t* dst, const uint32_t* __restrict src, uint32_t len)
{
  uint32_t i;
  for (i = 0U; i < len; ++i)
  {
    dst[i] = src[i];
  }
}





static inline void ARM_MPU_Load(ARM_MPU_Region_t const* table, uint32_t cnt)
{
  const uint32_t rowWordSize = sizeof(ARM_MPU_Region_t)/4U;
  while (cnt > 1U) {
    ARM_MPU_OrderedMemcpy(&(((MPU_Type *) ((0xE000E000UL) + 0x0D90UL) )->RBAR), &(table->RBAR), 1U*rowWordSize);
    table += 1U;
    cnt -= 1U;
  }
  ARM_MPU_OrderedMemcpy(&(((MPU_Type *) ((0xE000E000UL) + 0x0D90UL) )->RBAR), &(table->RBAR), cnt*rowWordSize);
}
# 1024 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\core_cm0plus.h" 2 3
# 1043 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\core_cm0plus.h" 3
static inline uint32_t SCB_GetFPUType(void)
{
    return 0U;
}
# 1074 "C:/Keil/ARM/CMSIS/6.3.0/CMSIS/Core/Include\\core_cm0plus.h" 3
static inline uint32_t SysTick_Config(uint32_t ticks)
{
  if ((ticks - 1UL) > (0xFFFFFFUL ))
  {
    return (1UL);
  }

  ((SysTick_Type *) ((0xE000E000UL) + 0x0010UL) )->LOAD = (uint32_t)(ticks - 1UL);
  __NVIC_SetPriority (SysTick_IRQn, (1UL << 2U) - 1UL);
  ((SysTick_Type *) ((0xE000E000UL) + 0x0010UL) )->VAL = 0UL;
  ((SysTick_Type *) ((0xE000E000UL) + 0x0010UL) )->CTRL = (1UL << 2U) |
                   (1UL << 1U) |
                   (1UL );
  return (0UL);
}
# 108 ".\\stm32g030xx.h" 2
# 1 ".\\system_stm32g0xx.h" 1
# 56 ".\\system_stm32g0xx.h"
extern uint32_t SystemCoreClock;

extern const uint32_t AHBPrescTable[16];
extern const uint32_t APBPrescTable[8];
# 85 ".\\system_stm32g0xx.h"
extern void SystemInit(void);
extern void SystemCoreClockUpdate(void);
# 109 ".\\stm32g030xx.h" 2
# 118 ".\\stm32g030xx.h"
typedef struct
{
  volatile uint32_t ISR;
  volatile uint32_t IER;
  volatile uint32_t CR;
  volatile uint32_t CFGR1;
  volatile uint32_t CFGR2;
  volatile uint32_t SMPR;
       uint32_t RESERVED1;
       uint32_t RESERVED2;
  volatile uint32_t AWD1TR;
  volatile uint32_t AWD2TR;
  volatile uint32_t CHSELR;
  volatile uint32_t AWD3TR;
       uint32_t RESERVED3[4];
  volatile uint32_t DR;
       uint32_t RESERVED4[23];
  volatile uint32_t AWD2CR;
  volatile uint32_t AWD3CR;
       uint32_t RESERVED5[3];
  volatile uint32_t CALFACT;
} ADC_TypeDef;

typedef struct
{
  volatile uint32_t CCR;
} ADC_Common_TypeDef;
# 157 ".\\stm32g030xx.h"
typedef struct
{
  volatile uint32_t DR;
  volatile uint32_t IDR;
  volatile uint32_t CR;
       uint32_t RESERVED1;
  volatile uint32_t INIT;
  volatile uint32_t POL;
} CRC_TypeDef;





typedef struct
{
  volatile uint32_t IDCODE;
  volatile uint32_t CR;
  volatile uint32_t APBFZ1;
  volatile uint32_t APBFZ2;
} DBG_TypeDef;




typedef struct
{
  volatile uint32_t CCR;
  volatile uint32_t CNDTR;
  volatile uint32_t CPAR;
  volatile uint32_t CMAR;
} DMA_Channel_TypeDef;

typedef struct
{
  volatile uint32_t ISR;
  volatile uint32_t IFCR;
} DMA_TypeDef;




typedef struct
{
  volatile uint32_t CCR;
}DMAMUX_Channel_TypeDef;

typedef struct
{
  volatile uint32_t CSR;
  volatile uint32_t CFR;
}DMAMUX_ChannelStatus_TypeDef;

typedef struct
{
  volatile uint32_t RGCR;
}DMAMUX_RequestGen_TypeDef;

typedef struct
{
  volatile uint32_t RGSR;
  volatile uint32_t RGCFR;
}DMAMUX_RequestGenStatus_TypeDef;




typedef struct
{
  volatile uint32_t RTSR1;
  volatile uint32_t FTSR1;
  volatile uint32_t SWIER1;
  volatile uint32_t RPR1;
  volatile uint32_t FPR1;
       uint32_t RESERVED1[3];
       uint32_t RESERVED2[5];
       uint32_t RESERVED3[11];
  volatile uint32_t EXTICR[4];
       uint32_t RESERVED4[4];
  volatile uint32_t IMR1;
  volatile uint32_t EMR1;
} EXTI_TypeDef;




typedef struct
{
  volatile uint32_t ACR;
       uint32_t RESERVED1;
  volatile uint32_t KEYR;
  volatile uint32_t OPTKEYR;
  volatile uint32_t SR;
  volatile uint32_t CR;
  volatile uint32_t ECCR;
       uint32_t RESERVED2;
  volatile uint32_t OPTR;
       uint32_t RESERVED3[2];
  volatile uint32_t WRP1AR;
  volatile uint32_t WRP1BR;
       uint32_t RESERVED4[2];
} FLASH_TypeDef;




typedef struct
{
  volatile uint32_t MODER;
  volatile uint32_t OTYPER;
  volatile uint32_t OSPEEDR;
  volatile uint32_t PUPDR;
  volatile uint32_t IDR;
  volatile uint32_t ODR;
  volatile uint32_t BSRR;
  volatile uint32_t LCKR;
  volatile uint32_t AFR[2];
  volatile uint32_t BRR;
} GPIO_TypeDef;





typedef struct
{
  volatile uint32_t CR1;
  volatile uint32_t CR2;
  volatile uint32_t OAR1;
  volatile uint32_t OAR2;
  volatile uint32_t TIMINGR;
  volatile uint32_t TIMEOUTR;
  volatile uint32_t ISR;
  volatile uint32_t ICR;
  volatile uint32_t PECR;
  volatile uint32_t RXDR;
  volatile uint32_t TXDR;
} I2C_TypeDef;




typedef struct
{
  volatile uint32_t KR;
  volatile uint32_t PR;
  volatile uint32_t RLR;
  volatile uint32_t SR;
  volatile uint32_t WINR;
} IWDG_TypeDef;






typedef struct
{
  volatile uint32_t CR1;
       uint32_t RESERVED0;
  volatile uint32_t CR3;
  volatile uint32_t CR4;
  volatile uint32_t SR1;
  volatile uint32_t SR2;
  volatile uint32_t SCR;
       uint32_t RESERVED1;
  volatile uint32_t PUCRA;
  volatile uint32_t PDCRA;
  volatile uint32_t PUCRB;
  volatile uint32_t PDCRB;
  volatile uint32_t PUCRC;
  volatile uint32_t PDCRC;
  volatile uint32_t PUCRD;
  volatile uint32_t PDCRD;
       uint32_t RESERVED2;
       uint32_t RESERVED3;
  volatile uint32_t PUCRF;
  volatile uint32_t PDCRF;
} PWR_TypeDef;




typedef struct
{
  volatile uint32_t CR;
  volatile uint32_t ICSCR;
  volatile uint32_t CFGR;
  volatile uint32_t PLLCFGR;
  volatile uint32_t RESERVED0;
  volatile uint32_t RESERVED1;
  volatile uint32_t CIER;
  volatile uint32_t CIFR;
  volatile uint32_t CICR;
  volatile uint32_t IOPRSTR;
  volatile uint32_t AHBRSTR;
  volatile uint32_t APBRSTR1;
  volatile uint32_t APBRSTR2;
  volatile uint32_t IOPENR;
  volatile uint32_t AHBENR;
  volatile uint32_t APBENR1;
  volatile uint32_t APBENR2;
  volatile uint32_t IOPSMENR;
  volatile uint32_t AHBSMENR;
  volatile uint32_t APBSMENR1;
  volatile uint32_t APBSMENR2;
  volatile uint32_t CCIPR;
  volatile uint32_t RESERVED2;
  volatile uint32_t BDCR;
  volatile uint32_t CSR;
} RCC_TypeDef;




typedef struct
{
  volatile uint32_t TR;
  volatile uint32_t DR;
  volatile uint32_t SSR;
  volatile uint32_t ICSR;
  volatile uint32_t PRER;
  volatile uint32_t WUTR;
  volatile uint32_t CR;
       uint32_t RESERVED0;
       uint32_t RESERVED1;
  volatile uint32_t WPR;
  volatile uint32_t CALR;
  volatile uint32_t SHIFTR;
  volatile uint32_t TSTR;
  volatile uint32_t TSDR;
  volatile uint32_t TSSSR;
       uint32_t RESERVED2;
  volatile uint32_t ALRMAR;
  volatile uint32_t ALRMASSR;
  volatile uint32_t ALRMBR;
  volatile uint32_t ALRMBSSR;
  volatile uint32_t SR;
  volatile uint32_t MISR;
       uint32_t RESERVED3;
  volatile uint32_t SCR;
  volatile uint32_t OR;
} RTC_TypeDef;




typedef struct
{
  volatile uint32_t CR1;
  volatile uint32_t CR2;
       uint32_t RESERVED0;
  volatile uint32_t FLTCR;
       uint32_t RESERVED1[7];
  volatile uint32_t IER;
  volatile uint32_t SR;
  volatile uint32_t MISR;
       uint32_t RESERVED2;
  volatile uint32_t SCR;
       uint32_t RESERVED3[48];
  volatile uint32_t BKP0R;
  volatile uint32_t BKP1R;
  volatile uint32_t BKP2R;
  volatile uint32_t BKP3R;
  volatile uint32_t BKP4R;
} TAMP_TypeDef;




typedef struct
{
  volatile uint32_t CR1;
  volatile uint32_t CR2;
  volatile uint32_t SR;
  volatile uint32_t DR;
  volatile uint32_t CRCPR;
  volatile uint32_t RXCRCR;
  volatile uint32_t TXCRCR;
  volatile uint32_t I2SCFGR;
  volatile uint32_t I2SPR;
} SPI_TypeDef;




typedef struct
{
  volatile uint32_t CFGR1;
       uint32_t RESERVED0[5];
  volatile uint32_t CFGR2;
       uint32_t RESERVED1[25];
  volatile uint32_t IT_LINE_SR[32];
} SYSCFG_TypeDef;




typedef struct
{
  volatile uint32_t CR1;
  volatile uint32_t CR2;
  volatile uint32_t SMCR;
  volatile uint32_t DIER;
  volatile uint32_t SR;
  volatile uint32_t EGR;
  volatile uint32_t CCMR1;
  volatile uint32_t CCMR2;
  volatile uint32_t CCER;
  volatile uint32_t CNT;
  volatile uint32_t PSC;
  volatile uint32_t ARR;
  volatile uint32_t RCR;
  volatile uint32_t CCR1;
  volatile uint32_t CCR2;
  volatile uint32_t CCR3;
  volatile uint32_t CCR4;
  volatile uint32_t BDTR;
  volatile uint32_t DCR;
  volatile uint32_t DMAR;
  volatile uint32_t OR1;
  volatile uint32_t CCMR3;
  volatile uint32_t CCR5;
  volatile uint32_t CCR6;
  volatile uint32_t AF1;
  volatile uint32_t AF2;
  volatile uint32_t TISEL;
} TIM_TypeDef;




typedef struct
{
  volatile uint32_t CR1;
  volatile uint32_t CR2;
  volatile uint32_t CR3;
  volatile uint32_t BRR;
  volatile uint32_t GTPR;
  volatile uint32_t RTOR;
  volatile uint32_t RQR;
  volatile uint32_t ISR;
  volatile uint32_t ICR;
  volatile uint32_t RDR;
  volatile uint32_t TDR;
  volatile uint32_t PRESC;
} USART_TypeDef;





typedef struct
{
  volatile uint32_t CR;
  volatile uint32_t CFR;
  volatile uint32_t SR;
} WWDG_TypeDef;
# 4 "threads.c" 2
# 1 ".\\kernel.h" 1
# 23 ".\\kernel.h"
void Kernel_Init(void);
void Kernel_Thread_Create(void (*func)(void), uint32_t prio);
void Kernel_Thread_Idle(void);
void Kernel_Thread_Sleep(uint32_t val);
void Kernel_Thread_Run_All(void);
uint32_t Kernel_Tick_SS32_Get(void);
uint64_t Kernel_Tick_SS64_Get(void);
uint32_t Kernel_Tick_S_Get(void);
void Kernel_Timeout_Set(uint32_t val);
uint32_t Kernel_Timeout_Status(void);
uint32_t Kernel_CPU_Usage_x10_Get(void);
uint32_t Kernel_CPU_Usage_Avg_x10_Get(void);
uint8_t Kernel_Version_Major_Get(void);
uint8_t Kernel_Version_Minor_Get(void);
uint8_t Kernel_Version_Patch_Get(void);
uint8_t Kernel_Info_Char_Get(uint32_t index);
void Kernel_Print_Info(void (*func)(uint8_t));
# 5 "threads.c" 2
# 1 ".\\threads.h" 1








void THREAD_SysSVC(void);
void THREAD_Thread1(void);
void THREAD_Thread2(void);
void THREAD_Thread3(void);
void THREAD_Thread4(void);
void THREAD_Thread5(void);
void THREAD_Thread6(void);
void THREAD_Thread7(void);
void THREAD_Thread8(void);
void THREAD_Thread9(void);
# 6 "threads.c" 2
# 1 ".\\debug.h" 1
# 25 ".\\debug.h"
void Debug_Struct_Init(void);
void Debug_Config_GPIO(void);
void Debug_Config_Clock(void);
void Debug_Config_BAUD_Rate(uint32_t baud_rate);
void Debug_Config_Tx(void);
void Debug_Tx_Byte(uint8_t val);
void Debug_Tx_Buf(volatile uint8_t *data, uint8_t start, uint8_t len);
void Debug_Tx_NL(void);
void Debug_Tx_SP(void);
void Debug_Tx_CM(void);
void Debug_Tx_Text(char *str);
void Debug_Tx_Text_NL(char *str);
void Debug_Tx_Text_SP(char *str);
void Debug_Tx_Text_CM(char *str);
void Debug_Determine_Digit_Numbers(uint32_t num);
void Debug_Tx_Number_Digits(void);
void Debug_Tx_Number(int32_t num);
void Debug_Tx_Number_Hex_Raw(uint64_t val);
void Debug_Tx_Number_Hex(uint64_t val);
void Debug_Tx_Number_Bin_Raw(uint64_t val);
void Debug_Tx_Number_Bin(uint64_t val);
void Debug_Tx_Number_NL(int32_t num);
void Debug_Tx_Number_SP(int32_t num);
void Debug_Tx_Number_CM(int32_t num);
void Debug_Tx_Number_Hex_NL(uint64_t num);
void Debug_Tx_Number_Hex_SP(uint64_t num);
void Debug_Tx_Number_Hex_CM(uint64_t num);
void Debug_Tx_Number_Bin_NL(uint64_t num);
void Debug_Tx_Number_Bin_SP(uint64_t num);
void Debug_Tx_Number_Bin_CM(uint64_t num);
void Debug_Tx_Parameter_NL(char *name, int32_t num);
void Debug_Tx_Parameter_SP(char *name, int32_t num);
void Debug_Tx_Parameter_CM(char *name, int32_t num);
void Debug_Tx_Parameter_Hex_NL(char *name, uint64_t num);
void Debug_Tx_Parameter_Hex_SP(char *name, uint64_t num);
void Debug_Tx_Parameter_Hex_CM(char *name, uint64_t num);
void Debug_Tx_Parameter_Bin_NL(char *name, uint64_t num);
void Debug_Tx_Parameter_Bin_SP(char *name, uint64_t num);
void Debug_Tx_Parameter_Bin_CM(char *name, uint64_t num);
void Debug_Init(uint32_t baud);
# 7 "threads.c" 2
# 1 ".\\gpio.h" 1





void GPIO_PA1_Init(void);
void GPIO_PA1_Set(void);
void GPIO_PA1_Clear(void);
void GPIO_PA2_Init(void);
void GPIO_PA2_Set(void);
void GPIO_PA2_Clear(void);
void GPIO_PA3_Init(void);
void GPIO_PA3_Set(void);
void GPIO_PA3_Clear(void);
# 8 "threads.c" 2


__attribute__((noreturn))
void THREAD_SysSVC(void)
{
 Debug_Init(38400);






 while(1)
 {

  Debug_Tx_Parameter_NL("SS64 ", Kernel_Tick_SS64_Get());
  Debug_Tx_Parameter_NL("S32  ", Kernel_Tick_S_Get());
  Debug_Tx_Parameter_NL("CPUUC", Kernel_CPU_Usage_x10_Get());
  Debug_Tx_Parameter_NL("CPUUA", Kernel_CPU_Usage_Avg_x10_Get());
  Kernel_Thread_Sleep(5000);

 }
}



__attribute__((noreturn))
void THREAD_Thread1(void)
{


 while(1)
 {


  Kernel_Thread_Sleep(500);

  Kernel_Thread_Sleep(500);

 }
}



__attribute__((noreturn))
void THREAD_Thread2(void)
{



 while(1)
 {


  Kernel_Thread_Sleep(1000);

  Kernel_Thread_Sleep(1000);

 }
}



__attribute__((noreturn))
void THREAD_Thread3(void)
{



 while(1)
 {

  Kernel_Thread_Sleep(2000);

  Kernel_Thread_Sleep(2000);

 }
}

__attribute__((noreturn))
void THREAD_Thread4(void)
{

 while(1)
 {

  Kernel_Thread_Sleep(2000);

 }
}

__attribute__((noreturn))
void THREAD_Thread5(void)
{

 while(1)
 {

  Kernel_Thread_Sleep(2000);

 }
}

__attribute__((noreturn))
void THREAD_Thread6(void)
{


 while(1)
 {

  Kernel_Thread_Sleep(2000);

 }
}


__attribute__((noreturn))
void THREAD_Thread7(void)
{


 while(1)
 {

  Kernel_Thread_Sleep(2000);

 }
}


__attribute__((noreturn))
void THREAD_Thread8(void)
{


 while(1)
 {

  Kernel_Thread_Sleep(2000);

 }
}


__attribute__((noreturn))
void THREAD_Thread9(void)
{


 while(1)
 {

  Kernel_Thread_Sleep(2000);

 }
}
