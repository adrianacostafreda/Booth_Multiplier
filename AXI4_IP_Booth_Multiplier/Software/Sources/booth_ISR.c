#include <stdio.h>
#include "../Project_Headers/address_registers.h"
#include "../Project_Headers/address_map_arm.h"
#include "../Project_Headers/exceptions.h"





extern volatile int operationComplete;
volatile int *slv_reg3 = (int *)0xFF20000C;

//int operationComplete;
/***************************************************************************************
 * Booth - Interrupt Service Routine

 *
 * This routine clears the interrupt and set the operationComplete flag to 1
 *
 * This function should first clear the interrupt by writing a value 1 and then
 * a value 0 on bit 2 of slv_reg3 (ack input of the multiplier). Then, a global flag should be
 * set in order to let the application program know that an interrupt coming from the
 * multiplier has been received.
 *
****************************************************************************************/


void booth_ISR(void)
{
    printf("\nWe are on the interrupt vector table\n");
    
    /* The ack signal should be activated and then deactivated to reset the irq signal */
    *slv_reg3 = *(slv_reg3) | (1 << 2); 	//  set ack
    *slv_reg3 = *(slv_reg3) & ~(1 << 2); 	// clear ack

    /* Set operationComplete flag to 1 */
    operationComplete = 1; 

    return;
}
