

;;=============================system type definition starting===============================;; 
                      THUMB                                        ;enable thumb mode
				      PRESERVE8                                    ;8 bytes stack alignment
;;===============================system type definition end==================================;; 





;;============================constant area definition starting==============================;; 
                      AREA       |.constdata|, DATA, READONLY
;;==============================constant area definition end=================================;; 







;;==================================kernel config starting===================================;; 
DEF_KERNEL_VER_MAJOR  EQU        0x00000001                        ;set kernel version major
DEF_KERNEL_VER_MINOR  EQU        0x00000000                        ;set kernel version minor
DEF_KERNEL_VER_PATCH  EQU        0x00000000                        ;set kernel version patch
DEF_64MHZ_PLL_ENABLE  EQU        0x00000000                        ;enable/disable PLL 64MHz
DEF_KER_MAX_NTASK     EQU        0x00000003                        ;number of maximum tasks
DEF_KER_STACK_SIZE    EQU        0x00000080                        ;stack size for each task
DEF_DBG_GPIO_TICK_EN  EQU        0x00000000                        ;enable/disable gpio toggle
DEF_DBG_GPIO_PORT     EQU        0x00000002                        ;value 00-05h,00->A, 01->B..
DEF_DBG_GPIO_PIN      EQU        0x0000000F                        ;pin number, value 00-0fh
;;====================================kernel config end======================================;;





;;===============================define address bases starting===============================;; 
DEF_PERIPHERAL_BASE   EQU        0x40000000                        ;peripheral start address
DEF_AHB_BASE          EQU        DEF_PERIPHERAL_BASE + 0x00020000  ;AHB start address
DEF_IOPORT_BASE       EQU        DEF_PERIPHERAL_BASE + 0x10000000  ;IO port start address
DEF_GPIO_BASE         EQU        DEF_IOPORT_BASE     + 0x00000000  ;GPIO start address
DEF_RCC_BASE          EQU        DEF_AHB_BASE        + 0x00001000  ;RCC start address
DEF_FLASH_BASE        EQU        DEF_AHB_BASE        + 0x00002000  ;Flash start address
DEF_SCS_BASE          EQU        0xE000E010                        ;SCS start address
DEF_SCB_BASE          EQU        0xE000ED00                        ;SCB start address
;;=================================define address bases end==================================;; 





;;==============================define flash addresses starting==============================;; 
DEF_FLASH_ACR         EQU        DEF_FLASH_BASE      + 0x00000000  ;Flash start address
;;================================define flash addresses end=================================;; 





;;===============================define rcc addresses starting===============================;; 
DEF_RCC_CR            EQU        DEF_RCC_BASE        + 0x00000000  ;RCC->CR start address
DEF_RCC_CFGR          EQU        DEF_RCC_BASE        + 0x00000008  ;RCC->CFGR start address
DEF_RCC_PLLCFGR       EQU        DEF_RCC_BASE        + 0x0000000C  ;RCC->PLLCFGR start address
;;==================================define rcc addresses end=================================;; 





;;============================define systick addresses starting==============================;; 
DEF_STK_CTRL          EQU        DEF_SCS_BASE        + 0x00000000  ;Systick->CTRL start address
DEF_STK_LOAD          EQU        DEF_SCS_BASE        + 0x00000004  ;Systick->LOAD start address
DEF_STK_VAL           EQU        DEF_SCS_BASE        + 0x00000008  ;Systick->VAL start address
;;===============================define systick addresses end================================;;





;;===============================define SCB addresses starting===============================;; 
DEF_SCB_ICSR          EQU        DEF_SCB_BASE        + 0x00000004  ;SCB->ICSR start address
DEF_SCB_SHPR3         EQU        DEF_SCB_BASE        + 0x00000020  ;SCB->SHPR3 start address
;;==================================define SCB addresses end=================================;;





;;===========================define GPIO related addresses starting==========================;; 
DEF_RCC_IOPENR        EQU        DEF_RCC_BASE        + 0x00000034  ;RCC->IOPENR start address
DEF_DBG_OFF           EQU        DEF_DBG_GPIO_PORT   * 0x00000400  ;calculate offset
DEF_DBG_GPIO_BASE     EQU        DEF_GPIO_BASE       + DEF_DBG_OFF ;calculate offset
DEF_DBG_GPIO_MODER    EQU        DEF_DBG_GPIO_BASE   + 0x00000000  ;calculate MODER addr
DEF_DBG_GPIO_BSRR     EQU        DEF_DBG_GPIO_BASE   + 0x00000018  ;calculate BSRR addr
DEF_DBG_GPIO_PORT_BM  EQU        ( 1 << DEF_DBG_GPIO_PORT )        ;calculate port bit mask
DEF_DBG_GPIO_PIN_BM   EQU        ( 1 << DEF_DBG_GPIO_PIN )         ;calculate bit mask value
DEF_DBG_GPIO_GM_OFF   EQU        ( DEF_DBG_GPIO_PIN << 1 )         ;calculate group offset
DEF_DBG_GPIO_PIN_GM   EQU        ( 3 << DEF_DBG_GPIO_GM_OFF )      ;calculate group mask value
DEF_DBG_GPIO_PIN_OUT  EQU        ( 1 << DEF_DBG_GPIO_GM_OFF )      ;calculate out group value
DEF_DBG_BSRR_BS_VAL   EQU        ( DEF_DBG_GPIO_PIN_BM   )         ;calculate BS val
DEF_DBG_BSRR_BR_OFF   EQU        ( DEF_DBG_GPIO_PIN + 16 )         ;calculate BR offset
DEF_DBG_BSRR_BR_VAL   EQU        ( 1 << DEF_DBG_BSRR_BR_OFF )      ;calculate BR val
;;=============================define GPIO related addresses end=============================;; 





;;==========================define stack size related value starting=========================;; 
DEF_KER_STACK_SPACE   EQU        DEF_KER_MAX_NTASK * DEF_KER_STACK_SIZE   ;max stack size
;;============================define stack size related value end============================;; 





;;================================define system macro starting===============================;; 
TASK_READY            EQU        0x00                              ;ready state                 
TASK_BLOCKED          EQU        0x01                              ;blocked state               
TASK_SUSPENDED        EQU        0x02                              ;suspended state             
TASK_CONS_LAT         EQU        0x03                              ;constant latency state      
TASK_EXECUTING        EQU        0x04                              ;executing state             
;;===================================define system macro end=================================;; 






;;==============================RAM area definition starting=================================;; 
					  AREA       |.data|, DATA, READWRITE, ALIGN=3
;;================================RAM area definition end====================================;; 





;;=========================global variable declaration starting==============================;; 
                      EXPORT     MACRO_TEST_VAR1
;;===========================global variable declaration end=================================;; 





;;===========================global variable definition starting=============================;; 
MACRO_TEST_VAR1       SPACE      8                                 ;64 bit sub-seconds counter
;;=============================global variable definition end================================;; 






;;==============================code area definition starting================================;; 
                      AREA       |.ram_code|, CODE, READONLY, ALIGN=4
;;=================================code area definition end==================================;; 





;;=========================global function declaration starting==============================;; 
					  EXPORT     Macro_Test_GPIO_Init
					  EXPORT     Macro_Test_GPIO_High
				      EXPORT     Macro_Test_GPIO_Low
;;===========================global function declaration end=================================;; 



;;============================macro test gpio init starting==================================;; 
Macro_Test_GPIO_Init
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
					  BX         LR                                ;return
;;==============================macro test gpio init end=====================================;; 







;;============================macro test gpio high starting==================================;; 
Macro_Test_GPIO_High
					  LDR        R0,   =DEF_DBG_GPIO_BSRR          ;load BSRR address
					  LDR        R1,   =DEF_DBG_BSRR_BS_VAL        ;load bit set val
					  STR        R1,   [R0]                        ;store val
					  BX         LR                                ;return
;;==============================macro test gpio high end=====================================;; 






;;=============================macro test gpio low starting==================================;; 
Macro_Test_GPIO_Low
					  LDR        R0,   =DEF_DBG_GPIO_BSRR          ;load BSRR address
					  LDR        R1,   =DEF_DBG_BSRR_BR_VAL        ;load bit clear val
					  STR        R1,   [R0]                        ;store val
					  BX         LR                                ;return
;;===============================macro test gpio low end=====================================;; 





					  ALIGN      4
					  END                                          ;end of file