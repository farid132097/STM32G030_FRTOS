

/*
 * File:   debug.h
 * Author: MD. Faridul Islam
 * faridmdislam@gmail.com
 * LL Driver -> Debug Library
 * Rev 3.3 (23 Apr, 2025)
 * Created on December 12, 2024, 9:44 PM
 */
 



#ifndef  _DEBUG_H_
#define  _DEBUG_H_

#include "stm32g030xx.h"

//#define  DEBUG_ENABLE
#define  DEBUG_TX_PA2
//#define  DEBUG_TX_PB6


void     Debug_Struct_Init(void);
void     Debug_Config_GPIO(void);
void     Debug_Config_Clock(void);
void     Debug_Config_BAUD_Rate(uint32_t baud_rate);
void     Debug_Config_Tx(void);
void     Debug_Tx_Byte(uint8_t val);
void     Debug_Tx_Buf(volatile uint8_t *data, uint8_t start, uint8_t len);
void     Debug_Tx_NL(void);
void     Debug_Tx_SP(void);
void     Debug_Tx_CM(void);
void     Debug_Tx_Text(char *str);
void     Debug_Tx_Text_NL(char *str);
void     Debug_Tx_Text_SP(char *str);
void     Debug_Tx_Text_CM(char *str);
void     Debug_Determine_Digit_Numbers(uint32_t num);
void     Debug_Tx_Number_Digits(void);
void     Debug_Tx_Number(int32_t num);
void     Debug_Tx_Number_Hex_Raw(uint64_t val);
void     Debug_Tx_Number_Hex(uint64_t val);
void     Debug_Tx_Number_Bin_Raw(uint64_t val);
void     Debug_Tx_Number_Bin(uint64_t val);
void     Debug_Tx_Number_NL(int32_t num);
void     Debug_Tx_Number_SP(int32_t num);
void     Debug_Tx_Number_CM(int32_t num);
void     Debug_Tx_Number_Hex_NL(uint64_t num);
void     Debug_Tx_Number_Hex_SP(uint64_t num);
void     Debug_Tx_Number_Hex_CM(uint64_t num);
void     Debug_Tx_Number_Bin_NL(uint64_t num);
void     Debug_Tx_Number_Bin_SP(uint64_t num);
void     Debug_Tx_Number_Bin_CM(uint64_t num);
void     Debug_Tx_Parameter_NL(char *name, int32_t num);
void     Debug_Tx_Parameter_SP(char *name, int32_t num);
void     Debug_Tx_Parameter_CM(char *name, int32_t num);
void     Debug_Tx_Parameter_Hex_NL(char *name, uint64_t num);
void     Debug_Tx_Parameter_Hex_SP(char *name, uint64_t num);
void     Debug_Tx_Parameter_Hex_CM(char *name, uint64_t num);
void     Debug_Tx_Parameter_Bin_NL(char *name, uint64_t num);
void     Debug_Tx_Parameter_Bin_SP(char *name, uint64_t num);
void     Debug_Tx_Parameter_Bin_CM(char *name, uint64_t num);
void     Debug_Init(uint32_t baud);


#endif

