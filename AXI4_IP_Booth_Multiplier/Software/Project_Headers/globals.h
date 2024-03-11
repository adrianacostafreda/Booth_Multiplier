/*!
 * @file globals.h
 * @brief This module contains global variables
 * @author Miguel Sanchez
 * @date 10/11/2023
 */

#ifndef GLOBALS_H_
#define GLOBALS_H_

#include "address_registers.h"
//extern volatile int operationComplete = 0;

volatile int *slv_reg0 = (int *)REG0_BASE_ADDRESS;
volatile int *slv_reg1 = (int *)REG1_BASE_ADDRESS;
volatile int *slv_reg2 = (int *)REG2_BASE_ADDRESS;
volatile int *slv_reg3 = (int *)REG3_BASE_ADDRESS;

#endif /* GLOBALS_H_ */
