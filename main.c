
#include "stm32g030xx.h"
#include "macro_test.h"
#include "kernel.h"
#include "tasks.h"


int main(void){
	
	Macro_Test_GPIO_Init();
	Macro_Test_GPIO_High();
	Macro_Test_GPIO_Low();
	
	/*Kernel_Init();
	Kernel_Task_Create(Tasks_Task1, 2);
	Kernel_Task_Create(Tasks_Task2, 0);
	Kernel_Task_Create(Tasks_Task3, 1);
	Kernel_Start_Tasks();*/
	
	while(1){
		
		
	}
	
}


