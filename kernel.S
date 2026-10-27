 
 
 
 ; File          : kernel.s
 ; Author        : MD. Faridul Islam (faridmdislam@gmail.com)
 ; Source        : https://github.com/farid132097/STM32G030_RTOS
 ; Description   : ARM Cortex M0+ kernel for bare-metal RTOS
 ; Devices       : Tested on STM32G030F6P6
 ; Created       : Sep 02, 2025, 09:30 PM
 ; Last Modified : Oct 28, 2026, 12:44 AM




;;=============================system type definition starting===============================;; 
                        THUMB                                        ;enable thumb mode
                        PRESERVE8                                    ;8 bytes stack alignment
;;===============================system type definition end==================================;; 





;;============================constant area definition starting==============================;; 
                        AREA       |.constdata|, DATA, READONLY
;;==============================constant area definition end=================================;; 





;;==================================kernel config starting===================================;; 
DEF_KERNEL_VER_MAJOR    EQU        0x00000002                        ;set kernel version major
DEF_KERNEL_VER_MINOR    EQU        0x00000001                        ;set kernel version minor
DEF_KERNEL_VER_PATCH    EQU        0x00000000                        ;set kernel version patch
DEF_64MHZ_PLL_ENABLE    EQU        0x00000001                        ;enable/disable PLL 64MHz
DEF_KER_MAX_THREADS     EQU        0x0000000C                        ;number of maximum threads
DEF_DBG_GPIO_TICK_EN    EQU        0x00000001                        ;enable/disable gpio toggle
DEF_DBG_GPIO_PORT       EQU        0x00000001                        ;value 00-05h,00->A, 01->B..
DEF_DBG_GPIO_PIN        EQU        0x00000007                        ;pin number, value 00-0fh
;;====================================kernel config end======================================;;





;;==============================kernel system config starting================================;; 
DEF_KER_STK_SZ          EQU        0x00000180                        ;stack size for each thread
DEF_KER_TCB_SZ          EQU        0x00000020                        ;task control block size
DEF_KER_TCB_LSFT        EQU        0x00000005                        ;TCB sz = (1 << LSFT)
;;=================================kernel system config end==================================;; 





;;===============================define address bases starting===============================;; 
DEF_PERIPHERAL_BASE     EQU        0x40000000                        ;peripheral start address
DEF_AHB_BASE            EQU        DEF_PERIPHERAL_BASE + 0x00020000  ;AHB start address
DEF_IOPORT_BASE         EQU        DEF_PERIPHERAL_BASE + 0x10000000  ;IO port start address
DEF_GPIO_BASE           EQU        DEF_IOPORT_BASE     + 0x00000000  ;GPIO start address
DEF_RCC_BASE            EQU        DEF_AHB_BASE        + 0x00001000  ;RCC start address
DEF_FLASH_BASE          EQU        DEF_AHB_BASE        + 0x00002000  ;Flash start address
DEF_SCS_BASE            EQU        0xE000E010                        ;SCS start address
DEF_SCB_BASE            EQU        0xE000ED00                        ;SCB start address
;;=================================define address bases end==================================;; 





;;==============================define flash addresses starting==============================;; 
DEF_FLASH_ACR           EQU        DEF_FLASH_BASE      + 0x00000000  ;Flash start address
;;================================define flash addresses end=================================;; 





;;===============================define rcc addresses starting===============================;; 
DEF_RCC_CR              EQU        DEF_RCC_BASE        + 0x00000000  ;RCC->CR start address
DEF_RCC_CFGR            EQU        DEF_RCC_BASE        + 0x00000008  ;RCC->CFGR start address
DEF_RCC_PLLCFGR         EQU        DEF_RCC_BASE        + 0x0000000C  ;RCC->PLLCFGR start address
;;==================================define rcc addresses end=================================;; 





;;============================define systick addresses starting==============================;; 
DEF_STK_CTRL            EQU        DEF_SCS_BASE        + 0x00000000  ;Systick->CTRL start address
DEF_STK_LOAD            EQU        DEF_SCS_BASE        + 0x00000004  ;Systick->LOAD start address
DEF_STK_VAL             EQU        DEF_SCS_BASE        + 0x00000008  ;Systick->VAL start address
;;===============================define systick addresses end================================;;





;;===============================define SCB addresses starting===============================;; 
DEF_SCB_ICSR            EQU        DEF_SCB_BASE        + 0x00000004  ;SCB->ICSR start address
DEF_SCB_SHPR3           EQU        DEF_SCB_BASE        + 0x00000020  ;SCB->SHPR3 start address
;;==================================define SCB addresses end=================================;;





;;===========================define GPIO related addresses starting==========================;; 
DEF_RCC_IOPENR          EQU        DEF_RCC_BASE        + 0x00000034  ;RCC->IOPENR start address
DEF_DBG_OFF             EQU        DEF_DBG_GPIO_PORT   * 0x00000400  ;calculate offset
DEF_DBG_GPIO_BASE       EQU        DEF_GPIO_BASE       + DEF_DBG_OFF ;calculate offset
DEF_DBG_GPIO_MODER      EQU        DEF_DBG_GPIO_BASE   + 0x00000000  ;calculate MODER addr
DEF_DBG_GPIO_BSRR       EQU        DEF_DBG_GPIO_BASE   + 0x00000018  ;calculate BSRR addr
DEF_DBG_GPIO_PORT_BM    EQU        ( 1 << DEF_DBG_GPIO_PORT )        ;calculate port bit mask
DEF_DBG_GPIO_PIN_BM     EQU        ( 1 << DEF_DBG_GPIO_PIN )         ;calculate bit mask value
DEF_DBG_GPIO_GM_OFF     EQU        ( DEF_DBG_GPIO_PIN << 1 )         ;calculate group offset
DEF_DBG_GPIO_PIN_GM     EQU        ( 3 << DEF_DBG_GPIO_GM_OFF )      ;calculate group mask value
DEF_DBG_GPIO_PIN_OUT    EQU        ( 1 << DEF_DBG_GPIO_GM_OFF )      ;calculate out group value
DEF_DBG_BSRR_BS_VAL     EQU        ( DEF_DBG_GPIO_PIN_BM   )         ;calculate BS val
DEF_DBG_BSRR_BR_OFF     EQU        ( DEF_DBG_GPIO_PIN + 16 )         ;calculate BR offset
DEF_DBG_BSRR_BR_VAL     EQU        ( 1 << DEF_DBG_BSRR_BR_OFF )      ;calculate BR val
;;=============================define GPIO related addresses end=============================;; 





;;==========================define stack size related value starting=========================;; 
DEF_KER_SYS_THRD        EQU        DEF_KER_MAX_THREADS + 1           ;add 1 for idle 
DEF_KER_STK_SPC         EQU        DEF_KER_SYS_THRD * DEF_KER_STK_SZ ;max stack size
;;============================define stack size related value end============================;; 





;;================================define system macro starting===============================;; 
THREAD_STS_READY        EQU        0x00                              ;ready state                 
THREAD_STS_BLOCKED      EQU        0x01                              ;blocked state               
THREAD_STS_SUSPENDED    EQU        0x02                              ;suspended state             
THREAD_STS_CONS_LAT     EQU        0x03                              ;constant latency state      
THREAD_STS_EXECUTING    EQU        0x04                              ;executing state             
;;===================================define system macro end=================================;; 





;;==============================RAM area definition starting=================================;; 
                        AREA       |.data|, DATA, READWRITE, ALIGN=3
;;================================RAM area definition end====================================;; 





;;=========================global variable declaration starting==============================;; 
                        EXPORT     KER_THREAD_STK
                        EXPORT     KER_THREAD_CB         
                        EXPORT     KER_SYS_VARS
;;===========================global variable declaration end=================================;; 





;;===========================global variable definition starting=============================;; 
;only 3 base addresses will be used to make it easy to load and store with immediate,
;fields under the bases are described bellow, offsets are inside braces (byte offset)
;ThrdSTK : stack space for all threads including idle thread, idle thread id is 0
;ThrdCB  : ThrdCBPSP(0), ThrdCBPrio(4), ThrdCBSts(8), ThrdCBSlp(12), ThrdCBToutL:H(16, 20)
;SysVars : SysVarsTCnt(0), SysVarsCTID(4), SysVarsHiPrio(8), SysVarsPrioTID(12)
;SysVars : SysVarsYield(16), SysVarsLST(20), SysVarsNxtWkupL:H(24, 28)
;SysVars : SysVarsTmrSS64L:H(32, 36), SysVarsTmrSS32(40), SysVarsTmrS(44), SysVarsUsgTotTick(48)
;SysVars : SysVarsUsgActTick(52), SysVarsUsg(56), SysVarsUsgAvg(60), SysVarsSystkRld(64)
;SysVars : SysVarsAtmOp(68) Reserved(72, 76) -> system feature related variables will be added
KER_THREAD_STK          SPACE      DEF_KER_STK_SPC                   ;thread stack space
KER_THREAD_CB           SPACE      DEF_KER_TCB_SZ * DEF_KER_SYS_THRD ;thread control block
KER_SYS_VARS            SPACE      80                                ;system variables
;;=============================global variable definition end================================;; 





;;==============================code area definition starting================================;; 
                        AREA       |.code|, CODE, READONLY, ALIGN=4
;;=================================code area definition end==================================;; 





;;=========================global function declaration starting==============================;; 
                        EXPORT     Kernel_Init
                        EXPORT     Kernel_Thread_Create
                        EXPORT     Kernel_Thread_Idle
                        EXPORT     Kernel_Thread_Sleep
                        EXPORT     Kernel_Thread_Run_All
						EXPORT     Kernel_Atomic_Operation_Start
						EXPORT     Kernel_Atomic_Operation_End
                        EXPORT     Kernel_Tick_SS32_Get
                        EXPORT     Kernel_Tick_SS64_Get
                        EXPORT     Kernel_Tick_S_Get
                        EXPORT     Kernel_Timeout_Set
                        EXPORT     Kernel_Timeout_Status
                        EXPORT     Kernel_CPU_Usage_Get
                        EXPORT     Kernel_CPU_Usage_Avg_Get
						EXPORT     Kernel_CPU_Usage_x10_Get
                        EXPORT     Kernel_CPU_Usage_Avg_x10_Get
                        EXPORT     Kernel_Version_Major_Get
                        EXPORT     Kernel_Version_Minor_Get
                        EXPORT     Kernel_Version_Patch_Get
                        EXPORT     SysTick_Handler
                        EXPORT     PendSV_Handler
;;===========================global function declaration end=================================;; 





;;=======================macro for system variable init starting=============================;; 
                        MACRO                                        ;macro start
                        MACRO_SYS_VAR_INIT                           ;macro name
                        LDR        R0,   =KER_SYS_VARS               ;load SysVars addr
                        MOVS       R1,   #0x00                       ;set val 0
                        STR        R1,   [R0, #0]                    ;store SysVarsTCnt val
                        STR        R1,   [R0, #4]                    ;store SysVarsCTID val
                        STR        R1,   [R0, #8]                    ;store SysVarsHiPrio val
                        STR        R1,   [R0, #12]                   ;store SysVarsPrioTID val
                        STR        R1,   [R0, #16]                   ;store SysVarsYield val
                        STR        R1,   [R0, #32]                   ;store SysVarsTmrSS64L val
                        STR        R1,   [R0, #36]                   ;store SysVarsTmrSS64H val
                        STR        R1,   [R0, #40]                   ;store SysVarsTmrSS32 val
                        STR        R1,   [R0, #44]                   ;store SysVarsTmrS val
                        STR        R1,   [R0, #48]                   ;store SysVarsUsgTotTick val
                        STR        R1,   [R0, #52]                   ;store SysVarsUsgActTick val
                        STR        R1,   [R0, #56]                   ;store SysVarsUsg val
                        STR        R1,   [R0, #60]                   ;store SysVarsUsgAvg val
                        STR        R1,   [R0, #64]                   ;store SysVarsSystkRld val
						STR        R1,   [R0, #68]                   ;store SysVarsAtmOp val
						LDR        R1,   =0xFFFFFFFF                 ;load 32 bit max val
						STR        R1,   [R0, #20]                   ;store SysVarsLST val
						STR        R1,   [R0, #24]                   ;store SysVarsNxtWkupL val
						STR        R1,   [R0, #28]                   ;store SysVarsNxtWkupH val
                        MEND                                         ;macro end
;;==========================macro for system variable init end===============================;; 





;;==========================macro for debug gpio init starting===============================;; 
                        MACRO                                        ;macro start
                        MACRO_GPIO_INIT  $ML                         ;macro name
                        ;if debug disabled, skip
                        MOVS       R0,   #DEF_DBG_GPIO_TICK_EN       ;load device config
                        BEQ        $ML.EXIT                          ;jump to exit
                        ;enable clock from rcc
                        LDR        R0,   =DEF_RCC_IOPENR             ;load IOPENR address
                        LDR        R1,   [R0]                        ;load IOPENR val
                        LDR        R2,   =DEF_DBG_GPIO_PORT_BM       ;load bit mask val
                        ORRS       R1,   R1, R2                      ;set bit WRT PORT
                        STR        R1,   [R0]                        ;store val to IOPENR
                        ;set BSRR->BR->pin low
                        LDR        R0,   =DEF_DBG_GPIO_BSRR          ;load BSRR address
                        LDR        R1,   =DEF_DBG_BSRR_BR_VAL        ;load BSRR->BR val
                        STR        R1,   [R0]                        ;store val
                        ;set pin as general purpose i/o
                        LDR        R0,   =DEF_DBG_GPIO_MODER         ;load MODER address
                        LDR        R1,   [R0]                        ;load MODER val
                        LDR        R2,   =DEF_DBG_GPIO_PIN_GM        ;load MODER group mask val
                        MVNS       R2,   R2                          ;invert bits
                        ANDS       R1,   R1, R2                      ;clear mode bits
                        LDR        R2,   =DEF_DBG_GPIO_PIN_OUT       ;load MODER ->out val
                        ORRS       R1,   R1, R2                      ;set output mode
                        STR        R1,   [R0]                        ;store val to MODER
$ML.EXIT                                                                                         
                        MEND                                         ;macro end
;;==========================macro for debug gpio init end====================================;; 





;;===========================macro for gpio set starting=====================================;; 
                        MACRO                                        ;macro start
                        MACRO_GPIO_SET   $ML                         ;macro name
                        ;if debug disabled, skip
                        MOVS       R0,   #DEF_DBG_GPIO_TICK_EN       ;load device config
                        BEQ        $ML.EXIT                          ;jump to exit
                        LDR        R0,   =DEF_DBG_GPIO_BSRR          ;load BSRR address
                        LDR        R1,   =DEF_DBG_BSRR_BS_VAL        ;load bit set val
                        STR        R1,   [R0]                        ;store val
$ML.EXIT
                        MEND                                         ;macro end
;;=============================macro for gpio set end========================================;; 





;;===========================macro for gpio clear starting===================================;; 
                        MACRO                                        ;macro start
                        MACRO_GPIO_CLEAR  $ML                        ;macro name
                        ;if debug disabled, skip
                        MOVS       R0,   #DEF_DBG_GPIO_TICK_EN       ;load device config
                        BEQ        $ML.EXIT                          ;jump to exit
                        LDR        R0,   =DEF_DBG_GPIO_BSRR          ;load BSRR address
                        LDR        R1,   =DEF_DBG_BSRR_BR_VAL        ;load bit clear val
                        STR        R1,   [R0]                        ;store val
$ML.EXIT
                        MEND                                         ;macro end
;;=============================macro for gpio clear end======================================;; 





;;========================macro for PLL Clock config starting================================;; 
                        MACRO                                        ;macro start
                        MACRO_64MHZ_PLL_CONFIG  $ML                  ;macro name
$ML.HSI16ON
                        LDR        R0,   =DEF_RCC_CR                 ;load addr
                        LDR        R1,   [R0]                        ;load val
                        LDR        R2,   =0x100                      ;bit8, HSI ON
                        ORRS       R1,   R1, R2                      ;R1 | R2
                        LDR        R2,   =0x3800                     ;bit 11,12,13 set
                        MVNS       R2,   R2                          ;invert all bits
                        ANDS       R1,   R1, R2                      ;clear HSIDIV
                        STR        R1,   [R0]                        ;store val
$ML.HSI16READY        
                        LDR        R1,   [R0]                        ;load val
                        LDR        R2,   =0x400                      ;bit10, HSIRDY
                        TST        R2,   R1                          ;check bit 10
                        BEQ        $ML.HSI16READY                    ;wait until ready
$ML.CHECKCONFIG        
                        MOVS       R0,   #DEF_64MHZ_PLL_ENABLE       ;load device config
                        BEQ        $ML.CLOCK16MHZ                    ;jump to 16Mhz if 0
$ML.CLOCK64MHZ        
                        LDR        R0,   =KER_SYS_VARS               ;load SysVars addr
                        LDR        R1,   =63999                      ;load val for 1ms
                        STR        R1,   [R0, #64]                   ;store SysVarsSystkRld
                        LDR        R0,   =DEF_FLASH_ACR              ;load addr
                        LDR        R1,   [R0]                        ;load data
                        LDR        R2,   =0x00000307                 ;LAT + PRFTEN + ICEN
                        BICS       R1,   R1, R2                      ;clear masked bits
                        LDR        R2,   =0x00000302                 ;2 WS + PRFTEN + ICEN
                        ORRS       R1,   R1, R2                      ;set 2 wait states
                        STR        R1,   [R0]                        ;store val
$ML.WAITSTATES        
                        LDR        R1,   [R0]                        ;load val
                        LDR        R2,   =0x00000307                 ;mask LAT + PRFTEN + ICEN
                        ANDS       R1,   R1, R2                      ;mask bits 0-2
                        LDR        R2,   =0x00000302                 ;expected val
                        CMP        R1,   R2                          ;compare
                        BNE        $ML.WAITSTATES                    ;jmp to label
$ML.PLLDISABLE        
                        LDR        R0,   =DEF_RCC_CR                 ;load addr
                        LDR        R1,   [R0]                        ;load val
                        LDR        R2,   =0x01000000                 ;bit 24, PLLON
                        MVNS       R2,   R2                          ;invert bits
                        ANDS       R1,   R2                          ;clear bit
                        STR        R1,   [R0]                        ;store val
$ML.PLLUNLOCK         
                        LDR        R1,   [R0]                        ;load val
                        LDR        R2,   =0x02000000                 ;bit 25, PLLRDY
                        ANDS       R1,   R2                          ;check bit
                        BNE        $ML.PLLUNLOCK                     ;wait until unlocked
$ML.PLLSETUP          
                        LDR        R0,   =DEF_RCC_PLLCFGR            ;load addr
                        LDR        R1,   =0x30000802                 ;R=2, N=8, N=1, REN, HSISRC
                        STR        R1,   [R0]                        ;store val
                        LDR        R0,   =DEF_RCC_CR                 ;load addr
                        LDR        R1,   [R0]                        ;load val
                        LDR        R2,   =0x01000000                 ;bit 24, PLLON
                        ORRS       R1,   R1, R2                      ;set bit 24
                        STR        R1,   [R0]                        ;store val
$ML.PLLLOCK           
                        LDR        R1,   [R0]                        ;load val
                        LDR        R2,   =0x02000000                 ;bit 25, PLLRDY
                        ANDS       R1,   R2                          ;check bit
                        BEQ        $ML.PLLLOCK                       ;wait until locked
$ML.SWPLLRSW           
                        LDR        R0,   =DEF_RCC_CFGR               ;load addr
                        LDR        R1,   [R0]                        ;load val
                        MOVS       R2,   #0x07                       ;set bit0-2
                        MVNS       R2,   R2                          ;invert all bits
                        ANDS       R1,   R1, R2                      ;clear SW bits
                        MOVS       R2,   #0x02                       ;PLLRCLK
                        ORRS       R1,   R1, R2                      ;set PLLRCLK
                        STR        R1,   [R0]                        ;store val
$ML.SWSPLLR           
                        LDR        R1,   [R0]                        ;load val
                        MOVS       R2,   #0x38                       ;set bit0-2
                        ANDS       R1,   R1, R2                      ;clear SW bits
                        MOVS       R2,   #0x10                       ;PLLRCLK
                        CMP        R1,   R2                          ;compare
                        BNE        $ML.SWSPLLR                       ;jmp to label
                        B          $ML.EXIT                          ;jmp to label
$ML.CLOCK16MHZ
                        LDR        R0,   =KER_SYS_VARS               ;load SysVars addr
                        LDR        R1,   =15999                      ;load val for 1ms
                        STR        R1,   [R0, #64]                   ;store SysVarsSystkRld
                        LDR        R0,   =DEF_RCC_CFGR               ;load addr
                        LDR        R1,   [R0]                        ;load val
                        MOVS       R2,   #0x07                       ;set bit0-2
                        MVNS       R2,   R2                          ;invert all bits
                        ANDS       R1,   R1, R2                      ;clear SW bits
                        STR        R1,   [R0]                        ;store val
$ML.SWSHSISYS         
                        LDR        R1,   [R0]                        ;load val
                        MOVS       R2,   #0x38                       ;bit 3,4,5 set
                        TST        R1,   R2                          ;check bits
                        BNE        $ML.SWSHSISYS                     ;wait until switched
$ML.EXIT
                        MEND                                         ;macro end
;;==========================macro for PLL Clock config end===================================;; 





;;===========================macro for systick config starting===============================;; 
                        MACRO                                        ;macro start
                        MACRO_SYSTICK_CONFIG                         ;macro name
                        LDR        R0,   =KER_SYS_VARS               ;load SysVars addr
                        LDR        R0,   [R0, #64]                   ;load SysVarsSystkRld
                        LDR        R1,   =DEF_STK_LOAD               ;load stk_load reg address
                        STR        R0,   [R1]                        ;set val to reg
                        LDR        R0,   =DEF_STK_VAL                ;load stk_val reg address
                        MOVS       R1,   #0x00                       ;clear reg
                        STR        R1,   [R0]                        ;clear stk_val reg
                        LDR        R0,   =DEF_STK_CTRL               ;load stk_ctrl reg address
                        MOVS       R1,   #0x07                       ;mask bit0, bit1 & bit2
                        STR        R1,   [R0]                        ;set val to stk_ctrl
                        MEND                                         ;macro end
;;=============================macro for systick config end==================================;; 





;;===========================macro for pushing R4-R11 starting===============================;; 
                        MACRO                                        ;macro start
                        MACRO_PUSH_R4_R11                            ;macro name
                        MRS        R0,   PSP                         ;load PSP in R0
                        SUBS       R0,   #32                         ;subtract 32 bytes
                        STR        R4,   [R0, #0]                    ;load data
                        STR        R5,   [R0, #4]                    ;load data
                        STR        R6,   [R0, #8]                    ;load data
                        STR        R7,   [R0, #12]                   ;load data
                        MOV        R1,   R8                          ;copy
                        STR        R1,   [R0, #16]                   ;load data
                        MOV        R1,   R9                          ;copy
                        STR        R1,   [R0, #20]                   ;load data
                        MOV        R1,   R10                         ;copy
                        STR        R1,   [R0, #24]                   ;load data
                        MOV        R1,   R11                         ;copy
                        STR        R1,   [R0, #28]                   ;load data
                        MEND                                         ;macro end
;;============================macro for pushing R4-R11 end===================================;; 





;;===========================macro for popping R4-R11 starting===============================;; 
                        MACRO                                        ;macro start
                        MACRO_POP_R11_R4                             ;macro name
                        LDR        R4,   [R0, #0]                    ;load data
                        LDR        R5,   [R0, #4]                    ;load data
                        LDR        R6,   [R0, #8]                    ;load data
                        LDR        R7,   [R0, #12]                   ;load data
                        LDR        R1,   [R0, #16]                   ;load data
                        MOV        R8,   R1                          ;copy
                        LDR        R1,   [R0, #20]                   ;load data
                        MOV        R9,   R1                          ;copy
                        LDR        R1,   [R0, #24]                   ;load data
                        MOV        R10,  R1                          ;copy
                        LDR        R1,   [R0, #28]                   ;load data
                        MOV        R11,  R1                          ;copy
                        ADDS       R0,   #32                         ;add 32 bytes
                        MSR        PSP,  R0                          ;update new top of stack
                        MEND                                         ;macro end
;;==============================macro for popping R4-R11 end=================================;; 





;;=============================macro for context save starting===============================;; 
                        MACRO                                        ;macro start
                        MACRO_CONTEXT_SAVE                           ;macro name
                        MACRO_PUSH_R4_R11                            ;push R4-R11, R0 Stk top
                        LDR        R1,   =KER_THREAD_CB              ;R1 ThrdCB base        [R]
                        LDR        R2,   =KER_SYS_VARS               ;R2 SysVars base       [R]
                        LDR        R3,   [R2, #16]                   ;R3 SysVarsYield       [R]
                        LDR        R4,   [R2, #4]                    ;load SysVarsCTID
                        LSLS       R4,   R4, #DEF_KER_TCB_LSFT       ;multiply by TCB size
                        STR        R0,   [R1, R4]                    ;store ThrdCBPSP top
                        MEND                                         ;macro end
;;================================macro for context save end=================================;; 





;;============================macro for context restore starting=============================;; 
                        MACRO                                        ;macro start
                        MACRO_CONTEXT_RESTORE                        ;macro name
                        LDR        R4,   [R2, #4]                    ;load SysVarsCTID      [R]
                        LSLS       R4,   R4,  #DEF_KER_TCB_LSFT      ;multiply by TCB size
                        LDR        R0,   [R1, R4]                    ;load thread PSP
                        MACRO_POP_R11_R4                             ;pop R11-R4 manually   [R]
                        MEND                                         ;macro end
;;==============================macro for context restore end================================;; 





;;============================macro for scheduler starting===================================;; 
                        MACRO                                        ;macro start
                        MACRO_KER_RUN_SCHEDULER $ML                  ;macro name, local label
                        LDR        R7,   [R2, #0]                    ;load SysVarsTCnt      [R]
                        LSLS       R7,   R7, #DEF_KER_TCB_LSFT       ;TCnt * TCB size
                        ADDS       R7,   R7, R1                      ;compute end pointer
                        MOV        R8,   R7                          ;copy end pointer to R8
                        MOVS       R6,   R1                          ;R6 = TCB 0 (idle)
                        ADDS       R6,   #DEF_KER_TCB_SZ             ;starts at TCB=1
                        MOVS       R5,   R1                          ;best TCB = idle
                        MOVS       R4,   #0xFF                       ;best prio = lowest
                        SUBS       R0,   R3, #1                      ;if not yield r0 is -1 [R]
                        CMP        R6,   R8                          ;any user thread?
                        BHS        $ML.DONE                          ;only thread is idle
                        ALIGN      8                                 ;align loop head
$ML.LOOP                                                             ;loop starting
                        LDR        R7,   [R6, #12]                   ;load ThrdCBSlp
                        TST        R7,   R7                          ;test if 0
                        BEQ        $ML.TREADY                        ;not sleeping
                        ADDS       R7,   R7, R0                      ;if yield, r0 is 0
                        STR        R7,   [R6, #12]                   ;store ThrdCBSlp
                        BNE        $ML.TNEXT                         ;still sleeping
$ML.TREADY                                                           ;thread is ready
                        LDR        R7,   [R6, #4]                    ;load ThrdCBPrio
                        CMP        R7,   R4                          ;compare with best
                        BHS        $ML.TNEXT                         ;not better, skip
                        MOVS       R4,   R7                          ;new best prio
                        MOVS       R5,   R6                          ;new best TCB
$ML.TNEXT                                                            ;goto next thread
                        ADDS       R6,   #DEF_KER_TCB_SZ             ;next TCB
                        CMP        R6,   R8                          ;reached end?
                        BLO        $ML.LOOP                          ;if no, continue
$ML.DONE                                                             ;iteration done
                        SUBS       R5,   R5, R1                      ;byte offset of winner
                        LSRS       R5,   R5, #DEF_KER_TCB_LSFT       ;divide/size = thread id
						LDR        R0,   [R2, #68]                   ;load SysVarsAtmOp     [R]
						TST        R0,   R0                          ;check if 0
						BNE        $ML.ATOMICOP                      ;skip storing SysVarsCTID
                        STR        R5,   [R2, #4]                    ;select SysVarsCTID    [R]
$ML.ATOMICOP                                                         ;skip if atomic operation
                        MEND                                         ;macro end
;;================================macro for scheduler end====================================;; 





;;=====================macro for sub-seconds & seconds counter starting======================;; 
                        MACRO                                        ;macro start
                        MACRO_TMR_UPDT   $ML                         ;macro name
                        TST        R3,   R3                          ;test val, Yield flag  [R]
                        BNE        $ML.EXIT                          ;jmp to label
                        LDR        R4,   [R2, #32]                   ;load SysVarsTmrSS64L  [R]
                        ADDS       R4,   R4,  #1                     ;increment val
                        STR        R4,   [R2, #32]                   ;store SysVarsTmrSS64L [R]
                        BNE        $ML.S_CNT_START                   ;jmp to label
                        LDR        R4,   [R2, #36]                   ;load SysVarsTmrSS64H  [R]
                        ADDS       R4,   R4,  #1                     ;increment val
                        STR        R4,   [R2, #36]                   ;store SysVarsTmrSS64H [R]
$ML.S_CNT_START                                                      ;start of second counter
                        LDR        R4,   [R2, #40]                   ;load SysVarsTmrSS32   [R]
                        ADDS       R4,   R4,  #1                     ;increment val
                        LDR        R5,   =1000                       ;compare with 1000ms
                        CMP        R4,   R5                          ;compare with val
                        BLO        $ML.SAVE_TICK                     ;no need to inc sec
                        MOVS       R4,   #0x00                       ;clear counter
                        LDR        R5,   [R2, #44]                   ;load SysVarsTmrS      [R]
                        ADDS       R5,   R5,  #1                     ;increment val
                        STR        R5,   [R2, #44]                   ;store SysVarsTmrS     [R]
$ML.SAVE_TICK                                                        ;save current tick
                        STR        R4,   [R2, #40]                   ;store SysVarsTmrSS32  [R]
$ML.EXIT                                                             ;macro exit
                        MEND                                         ;macro end
;;=======================macro for sub-seconds & seconds counter end=========================;; 





;;========================macro for cpu usage calculation starting===========================;; 
                        MACRO                                        ;macro start
                        MACRO_CPU_USAGE  $ML                         ;macro name
                        TST        R3,   R3                          ;test val, Yield       [R]
                        BNE        $ML.EXIT                          ;jmp to label
                        LDR        R4,   [R2, #4]                    ;load SysVarsCTID      [R]
                        TST        R4,   R4                          ;check val
                        LDR        R4,   [R2, #52]                   ;ldr SysVarsUsgActTick [R]
                        BEQ        $ML.SKIP_INC                      ;if thread is idle, skip
                        ADDS       R4,   R4,  #1                     ;increment val
                        STR        R4,   [R2, #52]                   ;str SysVarsUsgActTick [R]
$ML.SKIP_INC                                                         ;label->no increment
                        LDR        R5,   [R2, #48]                   ;ldr SysVarsUsgTotTick [R]
                        ADDS       R5,   R5,  #1                     ;increment val
                        LDR        R6,   =1000                       ;load compare val
                        CMP        R5,   R6                          ;compare values
                        BLO        $ML.SKIP_WRAP                     ;jmp to label
                        MOVS       R5,   #0x00                       ;SysVarsUsgTotTick to 0
                        STR        R4,   [R2, #56]                   ;store SysVarsUsg      [R]
                        LDR        R6,   [R2, #60]                   ;load SysVarsUsgAvg    [R]
                        ADDS       R4,   R4, R6                      ;curr = prev + curr
                        LSRS       R4,   R4, #1                      ;curr = curr / 2
                        STR        R4,   [R2, #60]                   ;store SysVarsUsgAvg   [R]
                        STR        R5,   [R2, #52]                   ;SysVarsUsgActTick 0   [R]
$ML.SKIP_WRAP                                                        ;label->no wrapping
                        STR        R5,   [R2, #48]                   ;str SysVarsUsgTotTick [R]
$ML.EXIT                                                             ;label->exit
                        MEND                                         ;macro end
;;===========================macro for cpu usage calculation end=============================;; 





;;===========================macro for clear yield flag starting=============================;; 
                        MACRO                                        ;macro start
                        MACRO_CLR_YIELD                              ;macro name
                        MOVS       R4,   #0x00                       ;clear reg
                        STR        R4,   [R2, #16]                   ;store SysVarsYield
                        MEND                                         ;macro end
;;=============================macro for clear yield flag end================================;; 





;;===============================emit literal pool starting==================================;; 
                        ALIGN      4
                        LTORG
;;=================================emit literal pool end=====================================;; 





;;=================================systick isr starting======================================;; 
SysTick_Handler
                        ;request for PendSV
                        LDR        R0,   =DEF_SCB_ICSR               ;load SCB->ICSR addr
                        LDR        R1,   =0x10000000                 ;load set_PendSV bit
                        STR        R1,   [R0]                        ;store val
                        BX         LR                                ;return
;;====================================systick isr end========================================;; 





;;=============================pending service isr starting==================================;; 
PendSV_Handler
                        ;Hardware pushed (address wise, high->low) xPSR,PC,LR,R12,R3-R0
                        ;Software pushed (address wise, high->low) R11-R4
                        CPSID      I                                 ;disable interrupts
                        MACRO_GPIO_SET          ISRLBL1              ;debug pin set
                        MACRO_CONTEXT_SAVE                           ;save context
                        MACRO_KER_RUN_SCHEDULER ISRLBL2              ;run scheduler, local label
                        MACRO_TMR_UPDT          ISRLBL3              ;ss and seconds counter
                        MACRO_CPU_USAGE         ISRLBL4              ;calculate cpu usage
                        MACRO_CLR_YIELD                              ;clear yield flag
                        MACRO_CONTEXT_RESTORE                        ;restore context
                        MACRO_GPIO_CLEAR        ISRLBL5              ;debug pin clear
                        CPSIE      I                                 ;enable interrupt
                        BX         LR                                ;return from interrupt
;;================================pending service isr end====================================;; 





;;===============================emit literal pool starting==================================;; 
                        ALIGN      4
                        LTORG
;;=================================emit literal pool end=====================================;; 





;;==================================kernel init starting=====================================;; 
Kernel_Init
                        PUSH       {R4, LR}                          ;push, 8 bytes alignment
                        MACRO_GPIO_INIT         PLBL1                ;gpio init for debug
                        MACRO_SYS_VAR_INIT                           ;system variable init
                        MACRO_64MHZ_PLL_CONFIG  PLBL2                ;config pll if enabled
                        ;set PendSV as lowest priority interrupt
                        LDR        R0,   =DEF_SCB_SHPR3              ;load SHPR3 addr
                        LDR        R1,   [R0]                        ;load SHPR3 val
                        LDR        R2,   =0xFF<<16                   ;set lowest priority
                        ORRS       R1,   R2                          ;set all bits
                        STR        R1,   [R0]                        ;store val
                        LDR        R0,   =Kernel_Thread_Idle         ;load idle thread addr
                        MOVS       R1,   #0xFF                       ;lowest priority
                        BL         Kernel_Thread_Create              ;create idle thread
                        POP        {R4, PC}                          ;return
;;====================================kernel init end========================================;; 





;;===============================emit literal pool starting==================================;; 
                        ALIGN      4
                        LTORG
;;=================================emit literal pool end=====================================;; 





;;=================================thread create starting====================================;; 
Kernel_Thread_Create
                        ;calculate stack top for this thread (R0:R1 are used by arguments)
                        LDR        R2,   =DEF_KER_STK_SZ             ;load each stack size
                        LDR        R3,   =KER_SYS_VARS               ;load SysVars addr
                        LDR        R3,   [R3, #0]                    ;load SysVarsTCnt
                        ADDS       R3,   R3, #1                      ;SysVarsTCnt+1
                        MULS       R2,   R3, R2                      ;(SysVarsTCnt+1)*size
                        LDR        R3,   =KER_THREAD_STK             ;stack base
                        ADDS       R2,   R2, R3                      ;stack top
                        ;create space for stack frame (R0:R1 arg, R2 stack top)
                        SUBS       R2,   #32                         ;space for R4-R11
                        SUBS       R2,   #32                         ;space for hardware frame
                        MOVS       R3,   #0x00                       ;clear reg
                        ;create software stack (R0:R1 arg, R2 stack top, R3 for clearing)
                        STR        R3,   [R2, #0]                    ;R4
                        STR        R3,   [R2, #4]                    ;R5
                        STR        R3,   [R2, #8]                    ;R6
                        STR        R3,   [R2, #12]                   ;R7
                        STR        R3,   [R2, #16]                   ;R8
                        STR        R3,   [R2, #20]                   ;R9
                        STR        R3,   [R2, #24]                   ;R10
                        STR        R3,   [R2, #28]                   ;R11
                        ;create hardware stack (R0:R1 arg, R2 stack top, R3 for clearing)
                        STR        R3,   [R2, #32]                   ;R0
                        STR        R3,   [R2, #36]                   ;R1
                        STR        R3,   [R2, #40]                   ;R2
                        STR        R3,   [R2, #44]                   ;R3
                        STR        R3,   [R2, #48]                   ;R12
                        STR        R3,   [R2, #52]                   ;LR
                        MOVS       R3,   R0                          ;thread entry addr
                        STR        R3,   [R2, #56]                   ;store as PC
                        LDR        R3,   =0x01000000                 ;thumb bit set
                        STR        R3,   [R2, #60]                   ;xPSR (Thumb)
                        ;update variables and flags
                        LDR        R0,   =KER_SYS_VARS              ;load SysVars addr
                        LDR        R0,   [R0, #0]                   ;SysVarsTCnt
                        LSLS       R0,   R0, #DEF_KER_TCB_LSFT      ;TCB offset
                        LDR        R3,   =KER_THREAD_CB             ;load ThrdCB addr
                        ADDS       R3,   R3, R0                     ;TCB address
                        STR        R2,   [R3, #0]                   ;store ThrdCBPSP
                        STR        R1,   [R3, #4]                   ;store ThrdCBPrio
                        MOVS       R1,   #THREAD_STS_READY          ;set flag
                        STR        R1,   [R3, #8]                   ;store ThrdCBSts
                        MOVS       R0,   #0                         ;clear reg
                        STR        R0,   [R3, #12]                  ;store ThrdCBSlp
                        STR        R0,   [R3, #16]                  ;store ThrdCBToutL
                        STR        R0,   [R3, #20]                  ;store ThrdCBToutH
                        LDR        R0,   =KER_SYS_VARS              ;load SysVars addr
                        LDR        R1,   [R0, #0]                   ;SysVarsTCnt
                        ADDS       R1,   R1, #1                     ;increment SysVarsTCnt
                        STR        R1,   [R0, #0]                   ;store SysVarsTCnt
                        BX         LR                                ;return
;;====================================thread create end======================================;; 





;;===================================idle thread starting====================================;; 
Kernel_Thread_Idle
                        ;Idle thread, does nothing
                        B          .                                 ;forever loop
;;=====================================idle thread end=======================================;; 





;;===============================emit literal pool starting==================================;; 
                        ALIGN      4
                        LTORG
;;=================================emit literal pool end=====================================;; 





;;==============================kernel thread sleep starting=================================;; 
Kernel_Thread_Sleep
                        LDR        R1,   =KER_SYS_VARS               ;load SysVars addr
                        LDR        R2,   [R1, #4]                    ;load SysVarsCTID
                        LSLS       R2,   R2, #DEF_KER_TCB_LSFT       ;multiply by TCB size
                        LDR        R3,   =KER_THREAD_CB              ;load ThrdCB addr
                        ADDS       R2,   R2, R3                      ;base + offset
                        MRS        R3,   PRIMASK                     ;store interrupt state
                        CPSID      I                                 ;disable interrupts
                        STR        R0,   [R2, #12]                   ;store ThrdCBSlp
                        MOVS       R0,   #THREAD_STS_BLOCKED         ;set status blocked
                        STR        R0,   [R2, #8]                    ;store ThrdCBSts
                        MOVS       R0,   #0x01                       ;set flag
                        STR        R0,   [R1, #16]                   ;store SysVarsYields
                        LDR        R0,   =DEF_SCB_ICSR               ;load SCB->ICSR addr
                        LDR        R1,   =0x10000000                 ;load set_PendSV bit
                        STR        R1,   [R0]                        ;store val
                        MSR        PRIMASK, R3                       ;restore interrupt
                        DSB                                          ;data sync barrier
                        ISB                                          ;instruction sync barrier
                        BX         LR                                ;return
;;=================================kernel thread sleep end===================================;; 





;;=================================start threads starting====================================;; 
Kernel_Thread_Run_All
                        ;configure SysTick timer
                        MACRO_SYSTICK_CONFIG                         ;configure systick
                        ;calculate stack top for this thread
                        LDR        R0,   =DEF_KER_STK_SZ             ;load each stack size
                        LDR        R1,   =KER_THREAD_STK             ;stack base
                        ADDS       R0,   R0, R1                      ;add offset
                        ;Setup PSP for main
                        MSR        PSP,  R0                          ;set PSP
                        MRS        R1,   CONTROL
                        MOVS       R2,   #0x02
                        ORRS       R1,   R1, R2                      ;CONTROL.SPSEL = 1
                        MSR        CONTROL, R1                       ;switch to PSP
                        ISB                                          ;instruction barrier
                        B          Kernel_Thread_Idle                ;call a thread
;;====================================start threads end======================================;; 





;;=============================kernel aomic operation starting===============================;; 
Kernel_Atomic_Operation_Start
                        LDR        R0,   =KER_SYS_VARS               ;load SysVars addr
						MOVS       R1,   #0x01                       ;set atomic operation flag
						STR        R1,   [R0, #68]                   ;store SysVarsAtmOp
                        BX         LR                                ;return
;;===============================kernel aomic operation end==================================;; 





;;=============================kernel aomic operation starting===============================;; 
Kernel_Atomic_Operation_End
                        LDR        R0,   =KER_SYS_VARS               ;load SysVars addr
						MOVS       R1,   #0x00                       ;set atomic operation flag
						STR        R1,   [R0, #68]                   ;store SysVarsAtmOp
                        BX         LR                                ;return
;;===============================kernel aomic operation end==================================;; 





;;==========================kernel tick 32bit SS val get starting============================;; 
Kernel_Tick_SS32_Get
                        LDR        R0,   =KER_SYS_VARS               ;load SysVars addr
                        LDR        R0,   [R0, #32]                   ;load SysVarsTmrSS64L
                        BX         LR                                ;return
;;============================kernel tick 32bit SS val get end===============================;; 





;;==========================kernel tick 64bit SS val get starting============================;;   
Kernel_Tick_SS64_Get
                        MRS        R2,   PRIMASK                     ;store interrupt state
                        CPSID      I                                 ;disable interrupts
                        LDR        R0,   =KER_SYS_VARS               ;load SysVars addr
                        LDR        R1,   [R0, #36]                   ;load SysVarsTmrSS64H
                        LDR        R0,   [R0, #32]                   ;load SysVarsTmrSS64L
                        MSR        PRIMASK, R2                       ;restore interrupt
                        BX         LR                                ;return
;;============================kernel tick 64bit SS val get end===============================;; 





;;==========================kernel tick seconds val get starting=============================;; 
Kernel_Tick_S_Get
                        LDR        R0,   =KER_SYS_VARS               ;load SysVars addr
                        LDR        R0,   [R0, #44]                   ;load SysVarsTmrS
                        BX         LR                                ;return
;;============================kernel tick seconds val get end================================;; 





;;==============================kernel timeout set starting==================================;; 
Kernel_Timeout_Set
                        PUSH       {R4, LR}                          ;push, 8 bytes alignment
                        MOV        R4,   R0                          ;copy arg
                        BL         Kernel_Tick_SS64_Get              ;get 64bit timestamp
                        MOVS       R2,   #0x00                       ;clear reg
                        ADDS       R0,   R0, R4                      ;SysVarsTmrSS64L + tout
                        ADCS       R1,   R1, R2                      ;SysVarsTmrSS64H + carry
                        LDR        R2,   =KER_SYS_VARS               ;load SysVars addr
                        LDR        R2,   [R2, #4]                    ;load SysVarsCTID
                        LSLS       R2,   R2, #DEF_KER_TCB_LSFT       ;multiply by TCB size
                        LDR        R3,   =KER_THREAD_CB              ;load ThrdCB addr
                        ADDS       R3,   R3, R2                      ;base + offset
                        MRS        R4,   PRIMASK                     ;store interrupt state
                        CPSID      I                                 ;disable interrupts
                        STR        R0,   [R3, #16]                   ;store ThrdCBToutL
                        STR        R1,   [R3, #20]                   ;store ThrdCBToutH
                        MSR        PRIMASK, R4                       ;restore interrupt
                        POP        {R4, PC}                          ;return
;;=================================kernel timeout set end====================================;; 





;;===============================emit literal pool starting==================================;; 
                        ALIGN      4
                        LTORG
;;=================================emit literal pool end=====================================;; 





;;============================kernel timeout status get starting=============================;; 
Kernel_Timeout_Status 
                        PUSH       {R4, LR}                          ;push, 8 bytes alignment
                        LDR        R0,   =KER_SYS_VARS               ;load SysVars addr
                        LDR        R0,   [R0, #4]                    ;load SysVarsCTID
                        LSLS       R0,   R0, #DEF_KER_TCB_LSFT       ;multiply by TCB size
                        LDR        R1,   =KER_THREAD_CB              ;load ThrdCB addr
                        ADDS       R4,   R1, R0                      ;base + offset
                        BL         Kernel_Tick_SS64_Get              ;get 64bit timestamp
                        MRS        R2,   PRIMASK                     ;store interrupt state
                        CPSID      I                                 ;disable interrupts
                        LDR        R3,   [R4, #16]                   ;load ThrdCBToutL
                        LDR        R4,   [R4, #20]                   ;load ThrdCBToutH
                        MSR        PRIMASK, R2                       ;restore interrupt
                        CMP        R1,   R4                          ;compare high words
                        BHI        KER_IS_TOUT_TRUE                  ;jump to true
                        BLO        KER_IS_TOUT_FALSE                 ;jump to false
                        CMP        R0,   R3                          ;compare low words
                        BHI        KER_IS_TOUT_TRUE                  ;jump to true
KER_IS_TOUT_FALSE                                                    ;timeout not occoured
                        MOVS       R0,   #0x00                       ;load false flag
                        B          KER_IS_TOUT_EXIT                  ;jump to exit
KER_IS_TOUT_TRUE                                                     ;timeout occoured
                        MOVS       R0,   #0x01                       ;load true flag
KER_IS_TOUT_EXIT                                                     ;exit label
                        POP        {R4, PC}                          ;return
;;==============================kernel timeout status get end================================;; 





;;==============================kernel cpu usage get starting================================;; 
Kernel_CPU_Usage_Get
                        LDR        R0,   =KER_SYS_VARS               ;load SysVars addr
                        LDR        R0,   [R0, #56]                   ;load SysVarsUsg val
						MOVS       R1,   #205                        ;load constant
						MULS       R0,   R1, R0                      ;multiplied by 205
						LSRS       R0,   R0, #11                     ;divide by 2048
                        BX         LR                                ;return
;;=================================kernel cpu usage get end==================================;; 





;;==========================kernel cpu usage average get starting============================;; 
Kernel_CPU_Usage_Avg_Get
                        LDR        R0,   =KER_SYS_VARS               ;load SysVars addr
						LDR        R0,   [R0, #60]                   ;load SysVarsUsgAvg val
                        MOVS       R1,   #205                        ;load constant
						MULS       R0,   R1, R0                      ;multiplied by 205
						LSRS       R0,   R0, #11                     ;divide by 2048
                        BX         LR                                ;return
;;============================kernel cpu usage average get end===============================;; 





;;==============================kernel cpu usage get starting================================;; 
Kernel_CPU_Usage_x10_Get
                        LDR        R0,   =KER_SYS_VARS               ;load SysVars addr
                        LDR        R0,   [R0, #56]                   ;load SysVarsUsg val
                        BX         LR                                ;return
;;=================================kernel cpu usage get end==================================;; 





;;==========================kernel cpu usage average get starting============================;; 
Kernel_CPU_Usage_Avg_x10_Get
                        LDR        R0,   =KER_SYS_VARS               ;load SysVars addr
                        LDR        R0,   [R0, #60]                   ;load SysVarsUsgAvg val
                        BX         LR                                ;return
;;============================kernel cpu usage average get end===============================;; 





;;============================kernel version major get starting==============================;; 
Kernel_Version_Major_Get
                        MOVS       R0,   #DEF_KERNEL_VER_MAJOR       ;load kernel ver major val
                        BX         LR                                ;return
;;==============================kernel version major get end=================================;; 





;;============================kernel version minor get starting==============================;; 
Kernel_Version_Minor_Get
                        MOVS       R0,   #DEF_KERNEL_VER_MINOR       ;load kernel ver minor val
                        BX         LR                                ;return
;;==============================kernel version minor get end=================================;; 





;;============================kernel version patch get starting==============================;; 
Kernel_Version_Patch_Get
                        MOVS       R0,   #DEF_KERNEL_VER_PATCH       ;load kernel ver patch val
                        BX         LR                                ;return
;;==============================kernel version patch get end=================================;; 





;;====================================kernel file end========================================;; 
                        ALIGN      4
                        END                                          ;end of file
;;====================================kernel file end========================================;; 





