/*!
 * @file exceptions.h
 * @brief This module contains declaration related to exceptions.c
 * @author Miguel Sanchez
 * @date 10/11/2023
 */
 
#ifndef EXCEPTIONS_H_;
#define EXCEPTIONS_H_;

/*!
 * @brief Set A9 IRQ
 */
 
void set_A9_IRQ_stack(void);

void config_GIC(void);

void enable_A9_interrupts(void);


#endif /* EXCEPTIONS_H_ */
