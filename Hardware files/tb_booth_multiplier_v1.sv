`timescale 1 ns / 1 ps

module tb_booth_multiplier;

// Testbench for the 4-radix both multiplier module 
// described in the booth_multiplier.sv file

	// internal signals used to apply stimuli

	logic clk, resetn, start, ack, busy, irq, irq_enable;
	logic [15:0] data_a;
	logic [15:0] data_b;
	logic [31:0] result;

	// instantiation of the radix-4 multiplier

	booth_multiplier booth_multiplier_instance(.clk(clk), .resetn(resetn), .start(start),
	.ack(ack), .irq(irq), .irq_enable(irq_enable), .busy(busy), .data_a(data_a), .data_b(data_b), .result(result));

	// generation of the clock signal

	always
		#10 clk = ~clk;

	// definition of the stimuli

	initial
	begin
		// initial conditions
		clk = 0; resetn = 1; start = 0; ack = 0;
		
		// First multiplication
		#5 resetn = 0; 		// reset for the system
		#40 resetn =1;

		// set data_a & data_b
		#5 data_a = 16'd2; 	// muliplicand
		#5 data_b = 16'd1; 	// multiplier

		// Add stimulus to start the system
		#20 irq_enable = 1;	// set high irq_enable
		#40 start = 1;		// start signal enabled
		#300 ack = 1;		// ack input signal enables
		#30 ack = 0;		// ack input signal = 0
		#40 start = 0;		// start signal disabled
		#20 irq_enable = 0;	// set low irq_enable

		
		// Second multiplication
		#5 resetn = 0; 		// reset for the system
		#40 resetn =1;

		// set data_a & data_b
		#5 data_a = 16'd2; 	// muliplicand
		#5 data_b = 16'd3; 	// multiplier

		// Add stimulus to start the system
		#20 irq_enable = 1;	// set high irq_enable
		#40 start = 1;		// start signal enabled
		#300 ack = 1;		// ack input signal enables
		#30 ack = 0;		// ack input signal = 0
		#40 start = 0;		// start signal disabled
		#20 irq_enable = 0;	// set low irq_enable

		
		// Third multiplication
		#5 resetn = 0; 		// reset for the system
		#40 resetn =1;

		// set data_a & data_b
		#5 data_a = 16'd2;	// muliplicand
		#5 data_b = 16'd7;	// muliplier

		// Add stimulus to start the system
		#20 irq_enable = 1;	// set high irq_enable
		#40 start = 1;		// start signal enabled
		#300 ack = 1;		// ack input signal enabled
		#30 ack = 0;		// ack input signal = 0
		#40 start = 0;		// start signal disabled
		#20 irq_enable = 0;	// set low irq_enable


		// Fourth multiplication
		#5 resetn = 0; 		// reset for the system
		#40 resetn =1;

		// set data_a & data_b
		#5 data_a = 16'd2;
		#5 data_b = 16'd15;

		// Add stimulus to start the system
		#20 irq_enable = 1;	// set high irq_enable
		#40 start = 1;		// start signal enabled
		#300 ack = 1;		// ack input signal enabled
		#30 ack = 0;		// ack input signal = 0
		#40 start = 0;		// start signal disabled
		#20 irq_enable = 0;	// set low irq_enable


		// Fifth Multiplication
		#5 resetn = 0; // reset for the system
		#40 resetn =1;

		// set data_a & data_b
		#5 data_a = 16'd89;
		#5 data_b = -16'd7;

		// Add stimulus to start the system
		#20 irq_enable = 1;	// set high irq_enable
		#40 start = 1;		// start signal enabled
		#300 ack = 1;		// ack input signal enabled
		#30 ack = 0;		// ack input signal = 0
		#40 start = 0;		// start signal disabled
		#20 irq_enable = 0;	// set low irq_enable


		// Sixth Multiplication
		#5 resetn = 0; // reset for the system
		#40 resetn =1;

		// set data_a & data_b
		#5 data_a = -16'd180;
		#5 data_b = 16'd29;

		// Add stimulus to start the system
		#20 irq_enable = 1;	// set high irq_enable
		#40 start = 1;		// start signal enabled
		#300 ack = 1;		// ack input signal enabled
		#30 ack = 0;		// ack input signal = 0
		#40 start = 0;		// start signal disabled
		#20 irq_enable = 0;	// set low irq_enable


		// Sixth Multiplication
		#5 resetn = 0; // reset for the system
		#40 resetn =1;

		// set data_a & data_b
		#5 data_a = -16'd190;
		#5 data_b = -16'd190;

		// Add stimulus to start the system
		#20 irq_enable = 1;	// set high irq_enable
		#40 start = 1;		// start signal enabled
		#300 ack = 1;		// ack input signal enabled
		#30 ack = 0;		// ack input signal = 0
		#40 start = 0;		// start signal disabled
		#20 irq_enable = 0;	// set low irq_enable


		// Seventh Multiplication
		#5 resetn = 0; // reset for the system
		#40 resetn =1;

		// set data_a & data_b
		#5 data_a = 16'b0111111111111111;
		#5 data_b = 16'b0111111111111111;

		// Add stimulus to start the system
		#20 irq_enable = 1;	// set high irq_enable
		#40 start = 1;		// start signal enabled
		#300 ack = 1;		// ack input signal enabled
		#30 ack = 0;		// ack input signal = 0
		#40 start = 0;		// start signal disabled
		#20 irq_enable = 0;	// set low irq_enable


		// Eight Multiplication
		#5 resetn = 0; // reset for the system
		#40 resetn =1;

		// set data_a & data_b
		#5 data_a = 16'b1000000000000000;
		#5 data_b = 16'b1000000000000000;

		// Add stimulus to start the system
		#20 irq_enable = 1;	// set high irq_enable
		#40 start = 1;		// start signal enabled
		#300 ack = 1;		// ack input signal enabled
		#30 ack = 0;		// ack input signal = 0
		#40 start = 0;		// start signal disabled
		#20 irq_enable = 0;	// set low irq_enable

	end

	// monitoring of results

	initial
		$monitor($time,,,"clk=%b resetn=%b start=%b ack=%b irq=%b busy =%b data_a=%d data_b=%d",clk,resetn,start, 
				 ack, irq, irq_enable, busy, data_a, data_b);
endmodule



