
/*
 * File:   debug.c
 * Author: MD. Faridul Islam
 * faridmdislam@gmail.com
 * LL Driver -> Debug Library
 * Rev 3.3 (23 Apr, 2025)
 * Created on December 12, 2024, 9:44 PM
 */


//add includes according to hardware
#include "stm32g030xx.h"
#include "cdefs.h"

//must be included
#include "debug.h"


typedef struct debug_t
{
	uint8_t  Digits[8];
	uint8_t  InputNumDigits;
}debug_t;






//if debug is enabled from header
#ifdef DEBUG_ENABLE



static debug_t Debug;



/*******************Debug Structure Functions Start****************/

void Debug_Struct_Init(void)
{
	uint8_t loop_cnt = 0;
	for(loop_cnt = 0; loop_cnt < 8; loop_cnt++){
		Debug.Digits[loop_cnt] = NULL;
	}
	Debug.InputNumDigits = NULL;
}

/********************Debug Structure Functions End*****************/









/*********************Debug Init Functions Start******************/

void Debug_Config_GPIO(void)
{
	
	#ifdef DEBUG_TX_PA2
	if((RCC->IOPENR & RCC_IOPENR_GPIOAEN) != RCC_IOPENR_GPIOAEN)
	{
		RCC->IOPENR |= RCC_IOPENR_GPIOAEN;
	}
	
	//Select AFR PA2
	GPIOA->AFR[0]   &=~ GPIO_AFRL_AFSEL2_Msk;
	GPIOA->AFR[0]   |=  (0x01 << GPIO_AFRL_AFSEL2_Pos);
	//PA2 alternate function, USART2->TX
	GPIOA->MODER    &=~GPIO_MODER_MODE2_Msk;
	GPIOA->MODER    |= GPIO_MODER_MODE2_1;
	#endif
	
	#ifdef DEBUG_TX_PB6
	if((RCC->IOPENR & RCC_IOPENR_GPIOBEN) != RCC_IOPENR_GPIOBEN)
	{
		RCC->IOPENR |= RCC_IOPENR_GPIOBEN;
	}
	
	//Select AFR PB6
	GPIOB->AFR[0]   &=~ GPIO_AFRL_AFSEL6_Msk;
	GPIOB->AFR[0]   |=  (0x00 << GPIO_AFRL_AFSEL6_Pos);
	//PB6 alternate function, USART1->TX
	GPIOB->MODER    &=~GPIO_MODER_MODE6_Msk;
	GPIOB->MODER    |= GPIO_MODER_MODE6_1;
	#endif
	
}

void Debug_Config_Clock(void)
{
	//add clock config
	#ifdef DEBUG_TX_PA2
	RCC->APBENR1  |= RCC_APBENR1_USART2EN; 
	#endif
	
	#ifdef DEBUG_TX_PB6
	RCC->APBENR2  |= RCC_APBENR2_USART1EN; 
	#endif
}

void Debug_Config_BAUD_Rate(uint32_t baud_rate)
{
	SystemCoreClockUpdate();
	
	#ifdef DEBUG_TX_PA2
	if(USART2->CR1 & USART_CR1_UE)
	{
		USART2->CR1 &=~USART_CR1_UE;
	}
	USART2->BRR   = (uint16_t)(SystemCoreClock/baud_rate);
	#endif
	
	#ifdef DEBUG_TX_PB6
	if(USART1->CR1 & USART_CR1_UE)
	{
		USART1->CR1 &=~USART_CR1_UE;
	}
	USART1->BRR   = (uint16_t)(SystemCoreClock/baud_rate);
	#endif
}


void Debug_Config_Tx(void)
{
	#ifdef DEBUG_TX_PA2
	USART2->CR1   |= USART_CR1_TE;
	if((USART2->CR1 & USART_CR1_UE) != USART_CR1_UE)
	{
		USART2->CR1 |= USART_CR1_UE;
	}
	#endif
	
	#ifdef DEBUG_TX_PB6
	USART1->CR1   |= USART_CR1_TE;
	if((USART1->CR1 & USART_CR1_UE) != USART_CR1_UE)
	{
		USART1->CR1 |= USART_CR1_UE;
	}
	#endif
}



void Debug_Tx_Byte(uint8_t val)
{
	#ifdef DEBUG_TX_PA2
	while((USART2->ISR & USART_ISR_TXE_TXFNF) != USART_ISR_TXE_TXFNF);
	USART2->TDR = val;
	#endif
	
	#ifdef DEBUG_TX_PB6
	while((USART1->ISR & USART_ISR_TXE_TXFNF) != USART_ISR_TXE_TXFNF);
	USART1->TDR = val;
	#endif
}

/**********************Debug Init Functions End*******************/









/********************Buffer Tx Functions Start*******************/

void Debug_Tx_Buf(volatile uint8_t *data, uint8_t start, uint8_t len)
{
	uint16_t loop_cnt = 0;
	len += start;
	for(loop_cnt = 0; loop_cnt < len; loop_cnt++)
	{
		Debug_Tx_Byte( data[loop_cnt] );
	}
}

/*********************Buffer Tx Functions End********************/









/*******************End Char Functions Start******************/

void Debug_Tx_NL(void)
{
	Debug_Tx_Byte('\r');
	Debug_Tx_Byte('\n');
}

void Debug_Tx_SP(void)
{
	Debug_Tx_Byte(' ');
}

void Debug_Tx_CM(void)
{
	Debug_Tx_Byte(',');
}

/*******************End Char Functions End*******************/









/*********************Text Functions Start*******************/

void Debug_Tx_Text(char *str)
{
	uint16_t loop_cnt = 0;
	while(str[loop_cnt] != '\0')
	{
		Debug_Tx_Byte(str[loop_cnt]);
		loop_cnt++; 
	}
}

void Debug_Tx_Text_NL(char *str)
{
	Debug_Tx_Text(str);
	Debug_Tx_NL();
}

void Debug_Tx_Text_SP(char *str)
{
	Debug_Tx_Text(str);
	Debug_Tx_SP();
}

void Debug_Tx_Text_CM(char *str)
{
	Debug_Tx_Text(str);
	Debug_Tx_CM();
}

/*********************Text Functions End********************/









/*********************Number Functions Start********************/

void Debug_Determine_Digit_Numbers(uint32_t num)
{
	uint8_t loop_cnt = 0;
	if(num == 0)
	{
		Debug.Digits[0] = 0;
		Debug.InputNumDigits = 1;
	}
	else
	{
		while(num != 0)
		{
			Debug.Digits[loop_cnt] = num%10;
			num /= 10;
			loop_cnt++;
		}
		Debug.InputNumDigits = loop_cnt;
	}
}

void Debug_Tx_Number_Digits(void)
{
	uint8_t temp;
	int8_t  loop_cnt;
	for(loop_cnt = Debug.InputNumDigits; loop_cnt > 0; loop_cnt--)
	{
		temp  = loop_cnt;
		temp -= 1;
		temp  = Debug.Digits[temp];
		temp += 48;
		Debug_Tx_Byte(temp);
	}
}

void Debug_Tx_Number(int32_t num)
{
	if(num < 0)
	{
		Debug_Tx_Byte('-');
		num = -num;
	}
	Debug_Determine_Digit_Numbers((uint32_t)num);
	Debug_Tx_Number_Digits();
}

void Debug_Tx_Number_Hex_Raw(uint64_t val)
{
	uint8_t loop_counter, index, hex_digit, tmp;
	
	loop_counter = 0;
	
	if(val <= 0xFF)
	{
		index = 8;
		loop_counter = 2;
	}
	else if(val <= 0xFFFF)
	{
		index = 16;
		loop_counter = 4;
	}
	else if(val <= 0xFFFFFF)
	{
		index = 24;
		loop_counter = 6;
	}
	else if(val <= 0xFFFFFFFF)
	{
		index = 32;
		loop_counter = 8;
	}
	else if(val <= 0xFFFFFFFFFF)
	{
		index = 40;
		loop_counter = 10;
	}
	else if(val <= 0xFFFFFFFFFFFF)
	{
		index = 48;
		loop_counter = 12;
	}
	else if(val <= 0xFFFFFFFFFFFFFF)
	{
		index = 56;
		loop_counter = 14;
	}
	else
	{
		index = 64;
		loop_counter = 16;
	}
	for(tmp = 0; tmp < loop_counter; tmp++)
	{
		index -= 4;
		hex_digit = ((val >> index) & 0x0F);
		if(hex_digit > 9){
		hex_digit += 55;
	}
	else
	{
		hex_digit += 48;
	}
	Debug_Tx_Byte((uint8_t)hex_digit);
  }
}

void Debug_Tx_Number_Hex(uint64_t val)
{
	Debug_Tx_Byte('0');
	Debug_Tx_Byte('x');
	Debug_Tx_Number_Hex_Raw(val);
}


void Debug_Tx_Number_Bin_Raw(uint64_t val)
{
	uint8_t loop_counter = 0;
	if(val <= 0xFF)
	{
		loop_counter = 7;
	}
	else if(val <= 0xFFFF)
	{
		loop_counter = 15;     
	}
	else
	{
		loop_counter = 31;
	}
	
	if(val <= 0xFF)
	{
		loop_counter = 7;
	}
	else if(val <= 0xFFFF)
	{
		loop_counter = 15;     
	}
	else if(val <= 0xFFFFFF)
	{
		loop_counter = 23;     
	}
	else if(val <= 0xFFFFFFFF)
	{
		loop_counter = 31;     
	}
	else if(val <= 0xFFFFFFFFFF)
	{
		loop_counter = 39;     
	}
	else if(val <= 0xFFFFFFFFFFFF)
	{
		loop_counter = 47;     
	}
	else if(val <= 0xFFFFFFFFFFFFFF)
	{
		loop_counter = 55;     
	}
	else
	{
		loop_counter = 63;
	}
	
	for(int i = loop_counter; i >= 0; i--)
	{
		if( (val>>i) & 1)
		{
			Debug_Tx_Byte( 49 );   
		}
		else
		{
			Debug_Tx_Byte( 48 );         
		}
	}
}

void Debug_Tx_Number_Bin(uint64_t val)
{
	Debug_Tx_Byte('0');
	Debug_Tx_Byte('b');
	Debug_Tx_Number_Bin_Raw(val);
}
/*********************Number Functions End*********************/









/************Number with End Char Functions Start**************/

void Debug_Tx_Number_NL(int32_t num)
{
	Debug_Tx_Number(num);
	Debug_Tx_NL();
}

void Debug_Tx_Number_SP(int32_t num)
{
	Debug_Tx_Number(num);
	Debug_Tx_SP();
}

void Debug_Tx_Number_CM(int32_t num)
{
	Debug_Tx_Number(num);
	Debug_Tx_CM();
}

/*************Number with End Char Functions End***************/









/**********Hex Number with End Char Functions Start************/

void Debug_Tx_Number_Hex_NL(uint64_t num)
{
	Debug_Tx_Number_Hex(num);
	Debug_Tx_NL();
}

void Debug_Tx_Number_Hex_SP(uint64_t num)
{
	Debug_Tx_Number_Hex(num);
	Debug_Tx_SP();
}

void Debug_Tx_Number_Hex_CM(uint64_t num)
{
	Debug_Tx_Number_Hex(num);
	Debug_Tx_CM();
}

/***********Hex Number with End Char Functions End*************/









/**********Bin Number with End Char Functions Start************/

void Debug_Tx_Number_Bin_NL(uint64_t num)
{
	Debug_Tx_Number_Bin(num);
	Debug_Tx_NL();
}

void Debug_Tx_Number_Bin_SP(uint64_t num)
{
	Debug_Tx_Number_Bin(num);
	Debug_Tx_SP();
}

void Debug_Tx_Number_Bin_CM(uint64_t num)
{
	Debug_Tx_Number_Bin(num);
	Debug_Tx_CM();
}

/***********Bin Number with End Char Functions End*************/









/************Number with Parameter Functions Start*************/

void Debug_Tx_Parameter_NL(char *name, int32_t num)
{
	Debug_Tx_Text(name);
	Debug_Tx_SP();
	Debug_Tx_Number_NL(num);
}

void Debug_Tx_Parameter_SP(char *name, int32_t num)
{
	Debug_Tx_Text(name);
	Debug_Tx_SP();
	Debug_Tx_Number_SP(num);
}

void Debug_Tx_Parameter_CM(char *name, int32_t num)
{
	Debug_Tx_Text(name);
	Debug_Tx_SP();
	Debug_Tx_Number_CM(num);
}

/*************Number with Parameter Functions End**************/









/**********Hex Number with Parameter Functions Start***********/

void Debug_Tx_Parameter_Hex_NL(char *name, uint64_t num)
{
	Debug_Tx_Text(name);
	Debug_Tx_SP();
	Debug_Tx_Number_Hex_NL(num);
}

void Debug_Tx_Parameter_Hex_SP(char *name, uint64_t num)
{
	Debug_Tx_Text(name);
	Debug_Tx_SP();
	Debug_Tx_Number_Hex_SP(num);
}

void Debug_Tx_Parameter_Hex_CM(char *name, uint64_t num)
{
	Debug_Tx_Text(name);
	Debug_Tx_SP();
	Debug_Tx_Number_Hex_CM(num);
}

/***********Hex Number with Parameter Functions End************/









/**********Bin Number with Parameter Functions Start***********/

void Debug_Tx_Parameter_Bin_NL(char *name, uint64_t num)
{
	Debug_Tx_Text(name);
	Debug_Tx_SP();
	Debug_Tx_Number_Bin_NL(num);
}

void Debug_Tx_Parameter_Bin_SP(char *name, uint64_t num)
{
	Debug_Tx_Text(name);
	Debug_Tx_SP();
	Debug_Tx_Number_Bin_SP(num);
}

void Debug_Tx_Parameter_Bin_CM(char *name, uint64_t num)
{
	Debug_Tx_Text(name);
	Debug_Tx_SP();
	Debug_Tx_Number_Bin_CM(num);
}

/***********Bin Number with Parameter Functions End************/










/*****************Debug Init Functions Start****************/

void Debug_Init(uint32_t baud)
{
	Debug_Struct_Init();
	Debug_Config_GPIO();
	Debug_Config_Clock();
	Debug_Config_BAUD_Rate(baud);
	Debug_Config_Tx();
}

/******************Debug Init Functions End*****************/


#endif

