 
 
 
 ; File          : kernel.s
 ; Author        : MD. Faridul Islam (faridmdislam@gmail.com)
 ; Source        : https://github.com/farid132097/STM32G030_FRTOS
 ; Description   : ARM Cortex M0+ kernel for bare-metal RTOS
 ; Devices       : Tested on STM32G030F6P6
 ; Created       : Sep 02, 2025, 09:30 PM
 ; Last Modified : Nov 14, 2026, 02:42 PM




;;=============================system type definition starting===============================;; 
                        THUMB                                        ;enable thumb mode
                        PRESERVE8                                    ;8 bytes stack alignment
;;===============================system type definition end==================================;; 





;;============================constant area definition starting==============================;; 
                        AREA       |.constdata|, DATA, READONLY
;;==============================constant area definition end=================================;; 





;;==================================kernel config starting===================================;; 
DEF_KERNEL_VER_MAJOR    EQU        0x00000003                        ;set kernel version major
DEF_KERNEL_VER_MINOR    EQU        0x00000000                        ;set kernel version minor
DEF_KERNEL_VER_PATCH    EQU        0x00000000                        ;set kernel version patch
DEF_64MHZ_PLL_ENABLE    EQU        0x00000001                        ;enable/disable PLL 64MHz
DEF_KER_MAX_THREADS     EQU        0x0000000B                        ;number of maximum threads
DEF_DBG_GPIO_TICK_EN    EQU        0x00000001                        ;enable/disable gpio toggle
DEF_DBG_GPIO_PORT       EQU        0x00000000                        ;value 00-05h,00->A, 01->B..
DEF_DBG_GPIO_PIN        EQU        0x00000003                        ;pin number, value 00-0fh
;;====================================kernel config end======================================;;





;;==============================kernel system config starting================================;; 
DEF_KER_STK_SZ          EQU        0x00000180                        ;stack size for each thread
DEF_KER_TCB_SZ          EQU        0x00000020                        ;thread control block size
DEF_KER_ERR_LOG_SZ      EQU        0x00000020                        ;total error log size
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





;;===================================define offsets starting=================================;; 
DEF_TB_OFF_PRIO         EQU        0x00                              ;Prio offset from TCB   
DEF_TB_OFF_STS          EQU        0x01                              ;status offset from TCB   
DEF_TB_OFF_HLTH         EQU        0x02                              ;health offset from TCB   
DEF_TB_OFF_HLTHS        EQU        0x03                              ;health sts offset from TCB
DEF_TB_OFF_PSP          EQU        0x04                              ;PSP offset from TCB   
DEF_TB_OFF_SLP          EQU        0x08                              ;sleep offset from TCB   
DEF_TB_OFF_TOUT         EQU        0x0C                              ;timeout val offset from TCB
DEF_TB_OFF_TSTMPL       EQU        0x10                              ;timestamp offset from TCB   
DEF_TB_OFF_TSTMPH       EQU        0x14                              ;timestamp offset from TCB  
DEF_TB_OFF_HBCNT        EQU        0x18                              ;Heartbeat offset from TCB   
DEF_TB_OFF_WDT          EQU        0x1C                              ;watchdog offset from TCB   
DEF_SV_OFF_TCNT         EQU        0x00                              ;thread cnt offset from SV   
DEF_SV_OFF_CTID         EQU        0x04                              ;curr tid offset from SV  
DEF_SV_OFF_YIELD        EQU        0x08                              ;yield offset from SV  
DEF_SV_OFF_TMRSS64L     EQU        0x0C                              ;ss64 offset from SV  
DEF_SV_OFF_TMRSS64H     EQU        0x10                              ;ss64 offset from SV  
DEF_SV_OFF_TMRSS32      EQU        0x14                              ;ss32 offset from SV  
DEF_SV_OFF_TMRS32       EQU        0x18                              ;s32 offset from SV  
DEF_SV_OFF_TOTTK        EQU        0x1C                              ;tot tick offset from SV  
DEF_SV_OFF_ACTTK        EQU        0x20                              ;act tick offset from SV  
DEF_SV_OFF_USG          EQU        0x24                              ;cpu usg offset from SV  
DEF_SV_OFF_USGAVG       EQU        0x28                              ;cpu usg avg offset from SV  
DEF_SV_OFF_STKRLD       EQU        0x2C                              ;stk reload offset from SV  
DEF_SV_OFF_ATOP         EQU        0x30                              ;atomic op offset from SV  
DEF_SV_OFF_ATOPTID      EQU        0x34                              ;atomic op tid offset from SV  
DEF_SV_OFF_HLTHOK       EQU        0x38                              ;health ok offset from SV  
;;======================================define offsets end===================================;; 





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
;only 3 base addresses will be used to make it easy to load and store with immediate
;fields under the bases are described bellow, offsets are inside braces (byte offset)
;ThrdSTK : stack space for all threads including idle thread, idle thread id is 0
;ThrdCB  : ThrdCBPrio(0), ThrdCBSts(1), ThrdCBHlth(2), ThrdCBHlthSet(3), ThrdCBPSP(4),
;ThrdCB  : ThrdCBSlp(8), ThrdCBTout(12), ThrdCBTStmpL:H(16, 20), ThrdCBHbCnt(24),
;ThrdCB  : ThrdCBWdt(28), TCB size is 32 bytes, first 4 fields are 1 byte wide
;SysVars : SysVarsTCnt(0), SysVarsCTID(4), SysVarsYield(8), SysVarsTmrSS64L:H(12, 16),
;SysVars : SysVarsTmrSS32(20), SysVarsTmrS(24), SysVarsUsgTotTick(28), SysVarsUsgActTick(32),
;SysVars : SysVarsUsg(36), SysVarsUsgAvg(40), SysVarsSystkRld(44), SysVarsAtmOp(48),
;SysVars : SysVarsAtmOpTID(52), SysVarsHlthOk(56), 60 bytes used (see KER_SYS_VARS size)
;ErrLogs : ErrLogsTID(0) + ErrLogsEID(1), ErrLogsTID(2) + ErrLogsEID(3)....
KER_THREAD_STK          SPACE      DEF_KER_STK_SPC                   ;thread stack space
KER_THREAD_CB           SPACE      DEF_KER_TCB_SZ * DEF_KER_SYS_THRD ;thread control block
KER_SYS_VARS            SPACE      80                                ;system variables
KER_ERR_LOG             SPACE      DEF_KER_ERR_LOG_SZ * 2            ;error logs for threads
;;=============================global variable definition end================================;; 





;;==============================code area definition starting================================;; 
                        AREA       |.code|, CODE, READONLY, ALIGN=4
;;=================================code area definition end==================================;; 





;;=========================global function declaration starting==============================;; 
                        EXPORT     Kernel_Init
                        EXPORT     Kernel_Thread_Create
                        EXPORT     Kernel_Thread_Sleep
                        EXPORT     Kernel_Thread_Heartbeat
                        EXPORT     Kernel_Thread_Health_Set
                        EXPORT     Kernel_Thread_Health_Get
                        EXPORT     Kernel_Thread_Health_Check
                        EXPORT     Kernel_Thread_Run_All
                        EXPORT     Kernel_Atomic_Start
                        EXPORT     Kernel_Atomic_End
                        EXPORT     Kernel_Tick_SubSeconds_Get
                        EXPORT     Kernel_Tick_Seconds_Get
                        EXPORT     Kernel_Timeout_Set
                        EXPORT     Kernel_Timeout_Status_Get
                        EXPORT     Kernel_CPU_Usage_Get
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
                        MOVS       R2,   #0x01                       ;set val 1
                        LDR        R3,   =1000                       ;load downcount val
                        STR        R1,   [R0, #DEF_SV_OFF_TCNT]      ;store SysVarsTCnt val
                        STR        R1,   [R0, #DEF_SV_OFF_CTID]      ;store SysVarsCTID val
                        STR        R1,   [R0, #DEF_SV_OFF_YIELD]     ;store SysVarsYield val
                        STR        R1,   [R0, #DEF_SV_OFF_TMRSS64L]  ;store SysVarsTmrSS64L val
                        STR        R1,   [R0, #DEF_SV_OFF_TMRSS64H]  ;store SysVarsTmrSS64H val
                        STR        R1,   [R0, #DEF_SV_OFF_TMRSS32]   ;store SysVarsTmrSS32 val
                        STR        R1,   [R0, #DEF_SV_OFF_TMRS32]    ;store SysVarsTmrS val
                        STR        R3,   [R0, #DEF_SV_OFF_TOTTK]     ;store SysVarsUsgTotTick
                        STR        R1,   [R0, #DEF_SV_OFF_ACTTK]     ;store SysVarsUsgActTick
                        STR        R1,   [R0, #DEF_SV_OFF_USG]       ;store SysVarsUsg val
                        STR        R1,   [R0, #DEF_SV_OFF_USGAVG]    ;store SysVarsUsgAvg val
                        STR        R1,   [R0, #DEF_SV_OFF_STKRLD]    ;store SysVarsSystkRld val
                        STR        R1,   [R0, #DEF_SV_OFF_ATOP]      ;store SysVarsAtmOp val
                        STR        R1,   [R0, #DEF_SV_OFF_ATOPTID]   ;store SysVarsAtmOpTid val
                        STR        R2,   [R0, #DEF_SV_OFF_HLTHOK]    ;store SysVarsHlthOk val
                        MEND                                         ;macro end
;;==========================macro for system variable init end===============================;; 





;;==========================macro for debug gpio init starting===============================;; 
                        MACRO                                        ;macro start
                        MACRO_GPIO_INIT                              ;macro name
                        IF         DEF_DBG_GPIO_TICK_EN == 0x01      ;if debug enabled
                        ;enable clock from rcc                       ;rcc config
                        LDR        R0,   =DEF_RCC_IOPENR             ;load IOPENR address
                        LDR        R1,   [R0]                        ;load IOPENR val
                        LDR        R2,   =DEF_DBG_GPIO_PORT_BM       ;load bit mask val
                        ORRS       R1,   R1, R2                      ;set bit WRT PORT
                        STR        R1,   [R0]                        ;store val to IOPENR
                        ;set BSRR->BR->pin low                       ;output config
                        LDR        R0,   =DEF_DBG_GPIO_BSRR          ;load BSRR address
                        LDR        R1,   =DEF_DBG_BSRR_BR_VAL        ;load BSRR->BR val
                        STR        R1,   [R0]                        ;store val
                        ;set pin as general purpose i/o              ;mode config
                        LDR        R0,   =DEF_DBG_GPIO_MODER         ;load MODER address
                        LDR        R1,   [R0]                        ;load MODER val
                        LDR        R2,   =DEF_DBG_GPIO_PIN_GM        ;load MODER group mask val
                        MVNS       R2,   R2                          ;invert bits
                        ANDS       R1,   R1, R2                      ;clear mode bits
                        LDR        R2,   =DEF_DBG_GPIO_PIN_OUT       ;load MODER ->out val
                        ORRS       R1,   R1, R2                      ;set output mode
                        STR        R1,   [R0]                        ;store val to MODER
                        ENDIF                                        ;config end
                        MEND                                         ;macro end
;;==========================macro for debug gpio init end====================================;; 





;;===========================macro for gpio set starting=====================================;; 
                        MACRO                                        ;macro start
                        MACRO_GPIO_SET                               ;macro name
                        IF         DEF_DBG_GPIO_TICK_EN == 0x01      ;if debug enabled
                        LDR        R0,   =DEF_DBG_GPIO_BSRR          ;load BSRR address
                        LDR        R1,   =DEF_DBG_BSRR_BS_VAL        ;load bit set val
                        STR        R1,   [R0]                        ;store val
                        ENDIF                                        ;pin set end
                        MEND                                         ;macro end
;;=============================macro for gpio set end========================================;; 





;;===========================macro for gpio clear starting===================================;; 
                        MACRO                                        ;macro start
                        MACRO_GPIO_CLEAR                             ;macro name
                        IF         DEF_DBG_GPIO_TICK_EN == 0x01      ;if debug enabled
                        LDR        R0,   =DEF_DBG_GPIO_BSRR          ;load BSRR address
                        LDR        R1,   =DEF_DBG_BSRR_BR_VAL        ;load bit clear val
                        STR        R1,   [R0]                        ;store val
                        ENDIF                                        ;pin clear end
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
                        STR        R1,   [R0, #DEF_SV_OFF_STKRLD]    ;store SysVarsSystkRld
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
                        STR        R1,   [R0, #DEF_SV_OFF_STKRLD]    ;store SysVarsSystkRld
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
                        LDR        R0,   [R0, #DEF_SV_OFF_STKRLD]    ;load SysVarsSystkRld
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





;;=============================macro for context save starting===============================;; 
                        MACRO                                        ;macro start
                        MACRO_CONTEXT_SAVE                           ;macro name
                        MRS        R0,   PSP                         ;load PSP in R0
                        SUBS       R0,   #32                         ;subtract 32 bytes
                        STMIA      R0!,  {R4-R7}                     ;store R4-R7
                        MOV        R4,   R8                          ;copy R8
                        MOV        R5,   R9                          ;copy R9
                        MOV        R6,   R10                         ;copy R10
                        MOV        R7,   R11                         ;copy R11
                        STMIA      R0!,  {R4-R7}                     ;store R8-R11
                        SUBS       R0,   #32                         ;subtract 32 bytes
                        LDR        R1,   =KER_THREAD_CB              ;R1 ThrdCB base        [R]
                        LDR        R2,   =KER_SYS_VARS               ;R2 SysVars base       [R]
                        LDR        R3,   [R2, #DEF_SV_OFF_YIELD]     ;R3 SysVarsYield       [R]
                        LDR        R4,   [R2, #DEF_SV_OFF_CTID]      ;load SysVarsCTID
                        LSLS       R4,   R4,  #DEF_KER_TCB_LSFT      ;multiply by TCB size
                        ADDS       R4,   R4,  #DEF_TB_OFF_PSP        ;compute PSP offset
                        STR        R0,   [R1, R4]                    ;store ThrdCBPSP top
                        MEND                                         ;macro end
;;================================macro for context save end=================================;; 





;;============================macro for context restore starting=============================;; 
                        MACRO                                        ;macro start
                        MACRO_CONTEXT_RESTORE                        ;macro name
                        LDR        R4,   [R2, #DEF_SV_OFF_CTID]      ;load SysVarsCTID      [R]
                        LSLS       R4,   R4,  #DEF_KER_TCB_LSFT      ;multiply by TCB size
                        ADDS       R4,   R4,  #DEF_TB_OFF_PSP        ;compute PSP offset
                        LDR        R0,   [R1, R4]                    ;load ThrdCBPSP top    [R]
                        ADDS       R0,   #16                         ;point R8-R11 slots
                        LDMIA      R0!,  {R4-R7}                     ;load R8-R11
                        MOV        R8,   R4                          ;copy R8
                        MOV        R9,   R5                          ;copy R9
                        MOV        R10,  R6                          ;copy R10
                        MOV        R11,  R7                          ;copy R11
                        SUBS       R0,   #32                         ;back to R4-R7 slots
                        LDMIA      R0!,  {R4-R7}                     ;load R4-R7
                        ADDS       R0,   #16                         ;skip R8-R11 slots
                        MSR        PSP,  R0                          ;update new top of stack
                        MEND                                         ;macro end
;;==============================macro for context restore end================================;; 





;;============================macro for scheduler starting===================================;; 
                        MACRO                                        ;macro start
                        MACRO_KER_RUN_SCHEDULER $ML                  ;macro name, local label
                        LDR        R7,   [R2, #DEF_SV_OFF_TCNT]      ;load SysVarsTCnt      [R]
                        LSLS       R7,   R7, #DEF_KER_TCB_LSFT       ;TCnt * TCB size
                        ADDS       R7,   R7, R1                      ;compute end pointer
                        MOV        R8,   R7                          ;copy end pointer to R8
                        MOVS       R6,   R1                          ;R6 = TCB 0 (idle)
                        ADDS       R6,   #DEF_KER_TCB_SZ             ;starts at TCB=1
                        MOVS       R5,   R1                          ;best TCB = idle
                        MOVS       R4,   #0x7F                       ;best prio = lowest
                        SUBS       R0,   R3, #1                      ;if yield, r0 = 0      [R]
                        CMP        R6,   R8                          ;any user thread?
                        BHS        $ML.DONE                          ;only thread is idle
                        ALIGN      8                                 ;align loop head
$ML.LOOP                                                             ;loop starting
                        LDR        R7,   [R6, #DEF_TB_OFF_SLP]       ;load ThrdCBSlp
                        TST        R7,   R7                          ;test if 0
                        BEQ        $ML.TREADY                        ;not sleeping
                        ADDS       R7,   R7, R0                      ;if not yield, r0 = -1
                        STR        R7,   [R6, #DEF_TB_OFF_SLP]       ;store ThrdCBSlp
                        BNE        $ML.TNEXT                         ;still sleeping
$ML.TREADY                                                           ;thread is ready
                        LDRB       R7,   [R6, #DEF_TB_OFF_PRIO]      ;load ThrdCBPrio
                        SXTB       R7,   R7                          ;sign-extend to int32
                        CMP        R7,   R4                          ;compare with best
                        BGE        $ML.TNEXT                         ;not better, skip
                        MOVS       R4,   R7                          ;new best prio
                        MOVS       R5,   R6                          ;new best TCB
$ML.TNEXT                                                            ;goto next thread
                        ADDS       R6,   #DEF_KER_TCB_SZ             ;next TCB
                        CMP        R6,   R8                          ;reached end?
                        BLO        $ML.LOOP                          ;if no, continue
$ML.DONE                                                             ;iteration done
                        SUBS       R5,   R5, R1                      ;byte offset of winner
                        LSRS       R5,   R5, #DEF_KER_TCB_LSFT       ;divide/size = thread id
                        MEND                                         ;macro end
;;================================macro for scheduler end====================================;; 





;;=========================macro for scheduler exception starting============================;; 
                        MACRO                                        ;macro start
                        MACRO_KER_SCHEDULER_EXC $ML                  ;macro name, local label
                        LDR        R0,   [R2, #DEF_SV_OFF_ATOP]      ;load SysVarsAtmOp     [R]
                        TST        R0,   R0                          ;atomic operation?
                        BEQ        $ML.STORECTID                     ;if no, take R5
                        CMP        R4,   #0                          ;check if prio is neg
                        BLT        $ML.STORECTID                     ;system thread preempts
                        LDR        R6,   [R2, #DEF_SV_OFF_ATOPTID]   ;owner ->SysVarsAtmOpTID
                        LSLS       R0,   R6, #DEF_KER_TCB_LSFT       ;owner offset
                        ADDS       R0,   R0, R1                      ;owner TCB
                        LDR        R0,   [R0, #DEF_TB_OFF_SLP]       ;owner ThrdCBSlp
                        TST        R0,   R0                          ;owner asleep?
                        BNE        $ML.OWNERSLEEP                    ;yes
                        MOVS       R5,   R6                          ;owner keeps the CPU
                        B          $ML.STORECTID                     ;store it
$ML.OWNERSLEEP                                                       ;owner sleep inside lock
                        MOVS       R5,   #0x00                       ;run idle
$ML.STORECTID                                                        ;store thread ID
                        STR        R5,   [R2, #DEF_SV_OFF_CTID]      ;select SysVarsCTID    [R]
                        MEND                                         ;macro end
;;============================macro for scheduler exception end==============================;; 





;;=====================macro for sub-seconds & seconds counter starting======================;; 
                        MACRO                                        ;macro start
                        MACRO_TMR_UPDT   $ML                         ;macro name
                        TST        R3,   R3                          ;test val, Yield flag  [R]
                        BNE        $ML.EXIT                          ;jmp to label
                        LDR        R4,   [R2, #DEF_SV_OFF_TMRSS64L]  ;load SysVarsTmrSS64L  [R]
                        ADDS       R4,   R4,  #1                     ;increment val
                        STR        R4,   [R2, #DEF_SV_OFF_TMRSS64L]  ;store SysVarsTmrSS64L [R]
                        BNE        $ML.S_CNT_START                   ;jmp to label
                        LDR        R4,   [R2, #DEF_SV_OFF_TMRSS64H]  ;load SysVarsTmrSS64H  [R]
                        ADDS       R4,   R4,  #1                     ;increment val
                        STR        R4,   [R2, #DEF_SV_OFF_TMRSS64H]  ;store SysVarsTmrSS64H [R]
$ML.S_CNT_START                                                      ;start of second counter
                        LDR        R4,   [R2, #DEF_SV_OFF_TMRSS32]   ;load SysVarsTmrSS32   [R]
                        ADDS       R4,   R4,  #1                     ;increment val
                        LDR        R5,   =1000                       ;compare with 1000ms
                        CMP        R4,   R5                          ;compare with val
                        BLO        $ML.SAVE_TICK                     ;no need to inc sec
                        MOVS       R4,   #0x00                       ;clear counter
                        LDR        R5,   [R2, #DEF_SV_OFF_TMRS32]    ;load SysVarsTmrS      [R]
                        ADDS       R5,   R5,  #1                     ;increment val
                        STR        R5,   [R2, #DEF_SV_OFF_TMRS32]    ;store SysVarsTmrS     [R]
$ML.SAVE_TICK                                                        ;save current tick
                        STR        R4,   [R2, #DEF_SV_OFF_TMRSS32]   ;store SysVarsTmrSS32  [R]
$ML.EXIT                                                             ;macro exit
                        MEND                                         ;macro end
;;=======================macro for sub-seconds & seconds counter end=========================;; 





;;========================macro for cpu usage calculation starting===========================;; 
                        MACRO                                        ;macro start
                        MACRO_CPU_USAGE  $ML                         ;macro name
                        TST        R3,   R3                          ;test val, Yield       [R]
                        BNE        $ML.EXIT                          ;jmp to label
                        LDR        R4,   [R2, #DEF_SV_OFF_CTID]      ;load SysVarsCTID      [R]
                        TST        R4,   R4                          ;check val
                        LDR        R4,   [R2, #DEF_SV_OFF_ACTTK]     ;ldr SysVarsUsgActTick [R] 
                        BEQ        $ML.SKIP_INC                      ;if thread is idle, skip
                        ADDS       R4,   R4,  #1                     ;increment val
                        STR        R4,   [R2, #DEF_SV_OFF_ACTTK]     ;str SysVarsUsgActTick [R]
$ML.SKIP_INC                                                         ;label->no increment
                        LDR        R5,   [R2, #DEF_SV_OFF_TOTTK]     ;total ticks left      [R]
                        SUBS       R5,   R5,  #1                     ;count down
                        STR        R5,   [R2, #DEF_SV_OFF_TOTTK]     ;store total ticks left
                        BNE        $ML.EXIT                          ;window not over, done
                        STR        R4,   [R2, #DEF_SV_OFF_USG]       ;store SysVarsUsg      [R]
                        LDR        R6,   [R2, #DEF_SV_OFF_USGAVG]    ;load SysVarsUsgAvg    [R]
                        ADDS       R4,   R4, R6                      ;curr = prev + curr
                        LSRS       R4,   R4, #1                      ;curr = curr / 2
                        STR        R4,   [R2, #DEF_SV_OFF_USGAVG]    ;store SysVarsUsgAvg   [R]
                        MOVS       R6,   #0x00                       ;clear reg
                        STR        R6,   [R2, #DEF_SV_OFF_ACTTK]     ;SysVarsUsgActTick 0   [R]
                        LDR        R5,   =1000                       ;reload total tick cnt
                        STR        R5,   [R2, #DEF_SV_OFF_TOTTK]     ;SysVarsUsgTotTick     [R]
$ML.EXIT                                                             ;label->exit
                        MEND                                         ;macro end
;;===========================macro for cpu usage calculation end=============================;; 





;;===========================macro for clear yield flag starting=============================;; 
                        MACRO                                        ;macro start
                        MACRO_CLR_YIELD                              ;macro name
                        MOVS       R4,   #0x00                       ;clear reg
                        STR        R4,   [R2, #DEF_SV_OFF_YIELD]     ;store SysVarsYield
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
                        MACRO_GPIO_SET                               ;debug pin set
                        MACRO_CONTEXT_SAVE                           ;save context
                        MACRO_KER_RUN_SCHEDULER ISRLBL1              ;run scheduler, local label
                        MACRO_KER_SCHEDULER_EXC ISRLBL2              ;exception handler
                        MACRO_TMR_UPDT          ISRLBL3              ;ss and seconds counter
                        MACRO_CPU_USAGE         ISRLBL4              ;calculate cpu usage
                        MACRO_CLR_YIELD                              ;clear yield flag
                        MACRO_CONTEXT_RESTORE                        ;restore context
                        MACRO_GPIO_CLEAR                             ;debug pin clear
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
                        MACRO_GPIO_INIT                              ;gpio init for debug
                        MACRO_SYS_VAR_INIT                           ;system variable init
                        MACRO_64MHZ_PLL_CONFIG  PLBL1                ;config pll if enabled
                        LDR        R0,   =DEF_SCB_SHPR3              ;load SHPR3 addr
                        LDR        R1,   [R0]                        ;load SHPR3 val
                        LDR        R2,   =0xFF<<16                   ;set lowest priority
                        ORRS       R1,   R2                          ;set all bits
                        STR        R1,   [R0]                        ;store val
                        LDR        R0,   =Kernel_Thread_Idle         ;load idle thread addr
                        MOVS       R1,   #0x7F                       ;lowest priority
                        BL         Kernel_Thread_Create              ;create idle thread
                        POP        {R4, PC}                          ;return
;;====================================kernel init end========================================;; 





;;===============================emit literal pool starting==================================;; 
                        ALIGN      4
                        LTORG
;;=================================emit literal pool end=====================================;; 





;;=================================thread create starting====================================;; 
Kernel_Thread_Create
                        CMP        R0,   #0                          ;check null val
                        BEQ        KER_FPTR_NULL                     ;null function pointer
                        LDR        R2,   =KER_SYS_VARS               ;load SysVars addr
                        LDR        R2,   [R2, #DEF_SV_OFF_TCNT]      ;current thread count
                        CMP        R2,   #DEF_KER_SYS_THRD           ;slots incl. idle
                        BLO        KER_TCNT_OK                       ;jump to thread create
KER_FPTR_NULL                                                        ;return from this func
                        MOVS       R0,   #0                          ;set 0 (failed)
                        BX         LR                                ;return
KER_TCNT_OK                                                          ;jmp poin tcnt ok
                        ;calculate stack top for this thread (R0:R1 are used by arguments)
                        LDR        R2,   =DEF_KER_STK_SZ             ;load each stack size
                        LDR        R3,   =KER_SYS_VARS               ;load SysVars addr
                        LDR        R3,   [R3, #DEF_SV_OFF_TCNT]      ;load SysVarsTCnt
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
                        LDR        R0,   =KER_SYS_VARS               ;load SysVars addr
                        LDR        R0,   [R0, #DEF_SV_OFF_TCNT]      ;SysVarsTCnt
                        LSLS       R0,   R0, #DEF_KER_TCB_LSFT       ;TCB offset
                        LDR        R3,   =KER_THREAD_CB              ;load ThrdCB addr
                        ADDS       R3,   R3, R0                      ;TCB address
                        STR        R2,   [R3, #DEF_TB_OFF_PSP]       ;store ThrdCBPSP
                        STRB       R1,   [R3, #DEF_TB_OFF_PRIO]      ;store ThrdCBPrio
                        MOVS       R1,   #THREAD_STS_READY           ;set flag
                        STRB       R1,   [R3, #DEF_TB_OFF_STS]       ;store ThrdCBSts
                        MOVS       R0,   #0                          ;clear reg
                        STR        R0,   [R3, #DEF_TB_OFF_SLP]       ;store ThrdCBSlp
                        STR        R0,   [R3, #DEF_TB_OFF_TOUT]      ;store ThrdCBTout
                        STR        R0,   [R3, #DEF_TB_OFF_TSTMPL]    ;store ThrdCBTStmpL
                        STR        R0,   [R3, #DEF_TB_OFF_TSTMPH]    ;store ThrdCBTStmpH
                        STR        R0,   [R3, #DEF_TB_OFF_HBCNT]     ;store ThrdCBHbCnt
                        STR        R0,   [R3, #DEF_TB_OFF_WDT]       ;store ThrdCBWdt
                        STRB       R0,   [R3, #DEF_TB_OFF_HLTH]      ;store ThrdCBHlth
                        STRB       R0,   [R3, #DEF_TB_OFF_HLTHS]     ;store ThrdCBHlthSet
                        LDR        R0,   =KER_SYS_VARS               ;load SysVars addr
                        LDR        R1,   [R0, #DEF_SV_OFF_TCNT]      ;load SysVarsTCnt
                        ADDS       R1,   R1, #1                      ;increment SysVarsTCnt
                        STR        R1,   [R0, #DEF_SV_OFF_TCNT]      ;store SysVarsTCnt
                        MOVS       R0,   #1                          ;set 1 (success)
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
                        LDR        R2,   [R1, #DEF_SV_OFF_CTID]      ;load SysVarsCTID
                        LSLS       R2,   R2, #DEF_KER_TCB_LSFT       ;multiply by TCB size
                        LDR        R3,   =KER_THREAD_CB              ;load ThrdCB addr
                        ADDS       R2,   R2, R3                      ;base + offset
                        MRS        R3,   PRIMASK                     ;store interrupt state
                        CPSID      I                                 ;disable interrupts
                        STR        R0,   [R2, #DEF_TB_OFF_SLP]       ;store ThrdCBSlp
                        MOVS       R0,   #THREAD_STS_BLOCKED         ;set status blocked
                        STRB       R0,   [R2, #DEF_TB_OFF_STS]       ;store ThrdCBSts
                        MOVS       R0,   #0x01                       ;set flag
                        STR        R0,   [R1, #DEF_SV_OFF_YIELD]     ;store SysVarsYields
                        LDR        R0,   =DEF_SCB_ICSR               ;load SCB->ICSR addr
                        LDR        R1,   =0x10000000                 ;load set_PendSV bit
                        STR        R1,   [R0]                        ;store val
                        MSR        PRIMASK, R3                       ;restore interrupt
                        DSB                                          ;data sync barrier
                        ISB                                          ;instruction sync barrier
                        BX         LR                                ;return
;;=================================kernel thread sleep end===================================;; 





;;============================kernel thread heartbeat starting===============================;; 
Kernel_Thread_Heartbeat
                        PUSH       {R4, LR}                          ;push, 8 bytes alignment
                        BL         Kernel_Tick_SubSeconds_Get        ;call function
                        LDR        R2,   =KER_SYS_VARS               ;load SysVars addr
                        LDR        R2,   [R2, #DEF_SV_OFF_CTID]      ;SysVarsCTID
                        LSLS       R2,   R2, #DEF_KER_TCB_LSFT       ;in thread offset
                        LDR        R3,   =KER_THREAD_CB              ;load ThrdCB addr
                        ADDS       R2,   R2, R3                      ;my TCB
                        LDR        R3,   [R2, #DEF_TB_OFF_HBCNT]     ;load ThrdCBHbCnt
                        ADDS       R3,   R3, #1                      ;increment val
                        MRS        R4,   PRIMASK                     ;store interrupt state
                        CPSID      I                                 ;disable interrupts
                        STR        R0,   [R2, #DEF_TB_OFF_TSTMPL]    ;store ThrdCBTStmpL
                        STR        R1,   [R2, #DEF_TB_OFF_TSTMPH]    ;store ThrdCBTStmpH
                        STR        R3,   [R2, #DEF_TB_OFF_HBCNT]     ;store ThrdCBHbCnt
                        MSR        PRIMASK, R4                       ;restore interrupt
                        POP        {R4, PC}                          ;return
;;===============================kernel thread heartbeat end=================================;; 





;;=================================start threads starting====================================;; 
Kernel_Thread_Run_All
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
                        MACRO_SYSTICK_CONFIG                         ;configure systick
                        B          Kernel_Thread_Idle                ;call a thread
;;====================================start threads end======================================;; 





;;=============================kernel atomic operation starting==============================;; 
Kernel_Atomic_Start
                        LDR        R0,   =KER_SYS_VARS               ;load SysVars addr
                        MOVS       R1,   #0x01                       ;set atomic operation flag
                        MRS        R2,   PRIMASK                     ;store interrupt state
                        CPSID      I                                 ;disable interrupts
                        STR        R1,   [R0, #DEF_SV_OFF_ATOP]      ;store SysVarsAtmOp
                        LDR        R3,   [R0, #DEF_SV_OFF_CTID]      ;load SysVarsCTID
                        STR        R3,   [R0, #DEF_SV_OFF_ATOPTID]   ;store SysVarsAtmOpTID
                        MSR        PRIMASK, R2                       ;restore interrupt
                        BX         LR                                ;return
;;===============================kernel atomic operation end=================================;; 





;;=============================kernel atomic operation starting==============================;; 
Kernel_Atomic_End
                        LDR        R0,   =KER_SYS_VARS               ;load SysVars addr
                        MOVS       R1,   #0x00                       ;set atomic operation flag
                        STR        R1,   [R0, #DEF_SV_OFF_ATOP]      ;store SysVarsAtmOp
                        BX         LR                                ;return
;;===============================kernel atomic operation end=================================;; 





;;==========================kernel tick 64bit SS val get starting============================;;   
Kernel_Tick_SubSeconds_Get
                        LDR        R3,   =KER_SYS_VARS               ;load SysVars addr
KER_TICK_SS64_RETRY                                                  ;retry label
                        LDR        R1,   [R3, #DEF_SV_OFF_TMRSS64H]  ;load SysVarsTmrSS64H
                        LDR        R0,   [R3, #DEF_SV_OFF_TMRSS64L]  ;load SysVarsTmrSS64L
                        LDR        R2,   [R3, #DEF_SV_OFF_TMRSS64H]  ;load SysVarsTmrSS64H
                        CMP        R1,   R2                          ;changed during the read?
                        BNE        KER_TICK_SS64_RETRY               ;SysVarsTmrSS64H diff, rty
                        BX         LR                                ;return
;;============================kernel tick 64bit SS val get end===============================;; 





;;==========================kernel tick seconds val get starting=============================;; 
Kernel_Tick_Seconds_Get
                        LDR        R0,   =KER_SYS_VARS               ;load SysVars addr
                        LDR        R0,   [R0, #DEF_SV_OFF_TMRS32]    ;load SysVarsTmrS
                        BX         LR                                ;return
;;============================kernel tick seconds val get end================================;; 





;;===========================kernel thread health set starting===============================;; 
Kernel_Thread_Health_Set
                        PUSH       {R4, R5, R6, LR}                  ;push, 8 bytes alignment
                        MOVS       R4,   R0                          ;copy timeout
                        MOVS       R5,   R1                          ;copy health
                        BL         Kernel_Thread_Heartbeat           ;first beat as setup
                        LDR        R2,   =KER_SYS_VARS               ;load SysVars addr
                        LDR        R2,   [R2, #DEF_SV_OFF_CTID]      ;load SysVarsCTID
                        LSLS       R2,   R2,  #DEF_KER_TCB_LSFT      ;multiply by TCB size
                        LDR        R3,   =KER_THREAD_CB              ;load ThrdCB addr
                        ADDS       R2,   R2, R3                      ;base + offset
                        MOVS       R3,   #1                          ;set flag
                        MRS        R6,   PRIMASK                     ;store interrupt state
                        CPSID      I                                 ;disable interrupts
                        STR        R4,   [R2, #DEF_TB_OFF_WDT]       ;store ThrdCBWdt
                        STRB       R5,   [R2, #DEF_TB_OFF_HLTH]      ;store ThrdCBHlth
                        STRB       R3,   [R2, #DEF_TB_OFF_HLTHS]     ;store ThrdCBHlthSet
                        MSR        PRIMASK, R6                       ;restore interrupt
                        POP        {R4, R5, R6, PC}                  ;return
;;=============================kernel thread health set end==================================;; 





;;===========================kernel thread health get starting===============================;; 
Kernel_Thread_Health_Get
                        LDR        R1,   =KER_THREAD_CB              ;load ThrdCB addr
                        LSLS       R0,   R0, #DEF_KER_TCB_LSFT       ;multiply by TCB size
                        ADDS       R0,   R1, R0                      ;base + offset
                        LDRB       R0,   [R0, #DEF_TB_OFF_HLTH]      ;load ThrdCBHlth
                        BX         LR                                ;return
;;=============================kernel thread health get end==================================;; 





;;========================kernel thread watchdog timeout starting============================;; 
Kernel_Thread_Health_Check
                        PUSH       {R4, R5, R6, LR}                  ;push, 8 bytes alignment
                        MOVS       R0,   #2                          ;thread id counter
                        LDR        R1,   =KER_THREAD_CB              ;load ThrdCB addr
                        LDR        R2,   =KER_SYS_VARS               ;load SysVars addr
                        LDR        R3,   [R2, #DEF_SV_OFF_TMRSS64L]  ;load SysVarsTmrSS64L
KER_HLTH_CHK_LOOP
                        MOVS       R4,   R0                          ;copy val
                        LSLS       R4,   R4,  #DEF_KER_TCB_LSFT      ;multiply by TCB size
                        ADDS       R4,   R4, R1                      ;base + offset
                        LDRB       R5,   [R4, #DEF_TB_OFF_HLTHS]     ;load ThrdCBTHlthSet
                        TST        R5,   R5                          ;check if 0
                        BEQ        KER_THRD_HLTH_NEXT                ;skip 
                        LDR        R5,   [R4, #DEF_TB_OFF_TSTMPL]    ;load ThrdCBTStampL
                        SUBS       R5,   R3, R5                      ;current-timestamp
                        LDR        R6,   [R4, #DEF_TB_OFF_WDT]       ;load ThrdCBWdt
                        CMP        R5,   R6                          ;compare with ThrdCBWdt
                        BLS        KER_THRD_HLTH_NEXT                ;no need to update flags
                        LDRB       R5,   [R4, #DEF_TB_OFF_HLTH]      ;load ThrdCBHlth
                        TST        R5,   R5                          ;check if 0
                        BEQ        KER_THRD_HLTH_NULL                ;health is 0
                        SUBS       R5,   R5,  #1                     ;decrease
                        STRB       R5,   [R4, #DEF_TB_OFF_HLTH]      ;store ThrdCBHlth
                        BNE        KER_THRD_HLTH_NEXT                ;jmp to next iteration   
KER_THRD_HLTH_NULL
                        MOVS       R4,   #0x00                       ;clear flag
                        STR        R4,   [R2, #DEF_SV_OFF_HLTHOK]    ;store SysVarsHlthOk
KER_THRD_HLTH_NEXT
                        ADDS       R0,   R0,  #1                     ;increment TID counter
                        LDR        R4,   [R2, #DEF_SV_OFF_TCNT]      ;load SysVarsTCnt
                        CMP        R0,   R4                          ;compare with TID counter
                        BLO        KER_HLTH_CHK_LOOP                 ;next iteration
                        LDR        R0,   [R2, #DEF_SV_OFF_HLTHOK]    ;load SysVarsHlthOk
                        POP        {R4, R5, R6, PC}                  ;return
;;===========================kernel thread watchdog timeout end==============================;; 





;;==============================kernel timeout set starting==================================;; 
Kernel_Timeout_Set
                        UXTH       R0,   R0                          ;make only 16 bit
                        LDR        R1,   =KER_SYS_VARS               ;load SysVars addr
                        LDR        R2,   [R1, #DEF_SV_OFF_TMRSS64L]  ;current time
                        ADDS       R2,   R2, R0                      ;deadline = now + tout
                        LDR        R1,   [R1, #DEF_SV_OFF_CTID]      ;load SysVarsCTID
                        LSLS       R1,   R1,  #DEF_KER_TCB_LSFT      ;multiply by TCB size
                        LDR        R3,   =KER_THREAD_CB              ;load ThrdCB addr
                        ADDS       R3,   R3, R1                      ;base + offset
                        STR        R2,   [R3, #DEF_TB_OFF_TOUT]      ;store deadline
                        BX         LR                                ;return
;;=================================kernel timeout set end====================================;; 





;;===============================emit literal pool starting==================================;; 
                        ALIGN      4
                        LTORG
;;=================================emit literal pool end=====================================;; 





;;============================kernel timeout status get starting=============================;; 
Kernel_Timeout_Status_Get 
                        LDR        R0,   =KER_SYS_VARS               ;load SysVars addr
                        LDR        R1,   [R0, #DEF_SV_OFF_TMRSS64L]  ;current time
                        LDR        R0,   [R0, #DEF_SV_OFF_CTID]      ;load SysVarsCTID
                        LSLS       R0,   R0,  #DEF_KER_TCB_LSFT      ;multiply by TCB size
                        LDR        R2,   =KER_THREAD_CB              ;load ThrdCB addr
                        ADDS       R0,   R0, R2                      ;base + offset
                        LDR        R0,   [R0, #DEF_TB_OFF_TOUT]      ;deadline
                        SUBS       R0,   R0, R1                      ;deadline - now
                        LSRS       R0,   R0, #31                     ;1 if negative
                        BX         LR                                ;return

;;==============================kernel timeout status get end================================;; 





;;==============================kernel cpu usage get starting================================;; 
Kernel_CPU_Usage_Get
                        LDR        R0,   =KER_SYS_VARS               ;load SysVars addr
                        LDR        R0,   [R0, #DEF_SV_OFF_USGAVG]    ;load SysVarsUsgAvg val
                        MOVS       R1,   #205                        ;load constant
                        MULS       R0,   R1, R0                      ;multiplied by 205
                        LSRS       R0,   R0, #11                     ;divide by 2048
                        BX         LR                                ;return
;;=================================kernel cpu usage get end==================================;; 





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





