module booth_multiplier (clk, resetn, start, busy, irq_enable, irq, data_a, data_b, result,ack);
// This module implements the functionality of a 16-bit binary x 16-bit radix-4 Booth multiplier 
// with synchronous reset (active low) and start (rising edge) to indicate the start of the multiplication. 
// While the multiplication is in progress, the multiplier will activate (high level) the output busy. 
// When the multiplication is completed the multiplier will activate (high level) the output irq. 
// When input ack is active both irq and busy will be deactivated.
// The clock signal has a frequency of 50 MHz.

input clk; 								// global clock signal, 100 MHz frequency
input resetn; 							// global reset signal, active low
input start;							// signal that activates the multiplication process by rising edge
input ack;								// input used to deassert the IRQ and busy outputs
input irq_enable; 						// at high level will activate the irq output of the multiplier
input signed [15:0] data_a;				// First 16-bit operand
input signed [15:0] data_b;				// Second 16-bit operand
output busy;							// output that indicates that a multiplication process is in progress
output irq;								// IRQ signal activated when the multiplication has completed
output signed [31:0] result; 			// result of the multiplication

// Variables initialized for the multiplication process

logic [16:0] multiplicand;				// 17-bit multiplicand for data_a sign extension
 
logic signed [16:0] partial_product; 	// partial product of the multiplication 
										//which will be added to the accumulator result in each clock cycle

logic busy_reg; 						// register for the output signal busy that indicates that the multiplication 
										// process is in progress
logic irq_reg; 							// register for the output signal irq that is activated when the multiplication 
										// has completed

logic signed [33:0] accumulator; 		// register for the accumulation result of the multiplication
logic [2:0] bits_inspect; 				// inspection of 3 bits of the multiplier
logic [3:0] count; 						// counter for the multiplication

// Assignation of the process variables to the outputs of the module

assign multiplicand = {{data_a[15]}, data_a}; // we extend the sign of the multiplicand by concatenating the MSB of data_a[15] with data_a
assign result = accumulator[31:0]; 		// assign the accumulator to the output RESULT for the multiplication
assign busy = busy_reg;					// assign busy reg to the output BUSY of the module
assign irq = irq_reg;					// assign irq reg to the output IRQ of the module

// 3-bit inspection of the data_b (multiplier). Each clock cycle as a function of count we make a different 
					// assignment to the 3 bits inspect variable which will be evaluated. For instance when
					// count = 0, we will inspect the two first values of the multiplier and we will add a '0'. 
always @(*) begin
	case (count)
		3'd0: bits_inspect = {data_b[1:0], 1'b0};
		3'd1: bits_inspect = data_b[3:1];
		3'd2: bits_inspect = data_b[5:3];
		3'd3: bits_inspect = data_b[7:5];
		3'd4: bits_inspect = data_b[9:7];
		3'd5: bits_inspect = data_b[11:9];
		3'd6: bits_inspect = data_b[13:11];
		default: bits_inspect = data_b[15:13];
	endcase
end

// Combinational logic assigning the corresponding multiplier action according to the value of bits_inspect 
// and following the 4-radix multiplier table. Each clock cycle the value of bits_inspect will be updated
// as a consequence of count and the partial product will be updated as well with the corresponding action 
// to be performed. 
always_comb begin
	case (bits_inspect)
		3'd001: partial_product = multiplicand;				// add multiplicand
		3'd010: partial_product = multiplicand;				// add multiplicand
		3'd011: partial_product = {multiplicand, 1'b0};		// add 2x multiplicand
		3'd100: partial_product = {~multiplicand+1,1'b0}; 	// subtract 2x multiplicand
		3'd101: partial_product = ~multiplicand+1;			// subtract multiplicand
		3'd110: partial_product = ~multiplicand+1;			// subtract multiplicand
		3'd000: partial_product = 17'b0; 					// none
		3'b111: partial_product = 17'b0;					// none
	endcase
end

// Description of the sequential logic for the system
always @(posedge clk) 
begin
	if (!resetn) 						// reset detection (active-low)
	begin
		irq_reg    <= 1'b0; 			// initialize the IRQ signal register to 0 when reset-active detected
		busy_reg   <= 1'b0;				// initialize the BUSY signal register to 0 when reset-active detected
		accumulator <= 34'b0; 			// initialize the accumulator result of the multiplication to be updated each cycle. 
		count     <= 4'b0; 				// initialize the counter of cycles for the multiplication
	end
	else 
		if (start || busy_reg) begin 	// multiplication enabled with start rising edge or output busy signal
			
			if (count < 4'b1000)		// if counter is lower than 8 cycles, the multiplication will be performed
			begin
			busy_reg <= 1'b1; 			// set busy active when multiplication starts and is in progress
			
			accumulator <= {{2{accumulator[31]}},accumulator[31:2]} 
							+ {{1{partial_product[16]}},partial_product,14'b0}; 
									// Each clock cycle we add the partial product corresponding to 
									// the 3-bits inspect evaluation and we shift 2x to the right 
									// the accumulator. Moreover we will add the partial product with its corresponding
									// etxtended bit to ensure the sign is kept. 
																									
			count = count + 1'd1;	// we update the counter each clock cycle
		
				if (count == 4'b1000) 	// when we arrive to 8 cycles the multiplication is finished
					
					begin
					
					if (irq_enable == 1'b1) begin 	// if the irq_enable input is high it will activate the IRQ output 
													                // of the multiplier 
													
						irq_reg <= 1'b1; 			// IRQ output register is set active when multiplication is completed 
													        // & irq_enable is high
					end
					else							// add default else to avoid latches, if no irq_enable is high
													  // irq will remain the same
						irq_reg <= irq_reg;
					end
					
				else begin
					irq_reg <= irq_reg;				// add default else to avoid latches, if no irq_enable is high
													          // irq will remain the same
				end
			
			end else begin 
				if (ack) begin		// When input ack is active (at high level) the outputs busy and 
													// irq will be deactivated
					irq_reg <= 1'b0;
					busy_reg <= 1'b0;
				end
				else begin				// add default else to avoid latches, if no ack signal is high
													// irq and busy signal will remain the same
					irq_reg <= irq_reg;
					busy_reg <= busy_reg;			
				end
			end
		
		end
		
		else begin 						// No rising edge of START detected, both accumulator and counter
													// will be set to 0
			accumulator <= 0;
			count <= 4'b0; 
		end
		
	end
endmodule 

