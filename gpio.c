

#include "stm32g030xx.h"
#include "gpio.h"


void GPIO_PA1_Init(void)
{
	RCC->IOPENR  |= RCC_IOPENR_GPIOAEN;
	GPIOA->MODER &=~GPIO_MODER_MODE1_Msk;
	GPIOA->MODER |= GPIO_MODER_MODE1_0;
}

void GPIO_PA1_Set(void)
{
	GPIOA->BSRR |= GPIO_BSRR_BS1;
}

void GPIO_PA1_Clear(void)
{
	GPIOA->BSRR |= GPIO_BSRR_BR1;
}



void GPIO_PA2_Init(void)
{
	RCC->IOPENR  |= RCC_IOPENR_GPIOAEN;
	GPIOA->MODER &=~GPIO_MODER_MODE2_Msk;
	GPIOA->MODER |= GPIO_MODER_MODE2_0;
}

void GPIO_PA2_Set(void)
{
	GPIOA->BSRR |= GPIO_BSRR_BS2;
}

void GPIO_PA2_Clear(void)
{
	GPIOA->BSRR |= GPIO_BSRR_BR2;
}




void GPIO_PA3_Init(void)
{
	RCC->IOPENR  |= RCC_IOPENR_GPIOAEN;
	GPIOA->MODER &=~GPIO_MODER_MODE3_Msk;
	GPIOA->MODER |= GPIO_MODER_MODE3_0;
}

void GPIO_PA3_Set(void)
{
	GPIOA->BSRR |= GPIO_BSRR_BS3;
}

void GPIO_PA3_Clear(void)
{
	GPIOA->BSRR |= GPIO_BSRR_BR3;
}




