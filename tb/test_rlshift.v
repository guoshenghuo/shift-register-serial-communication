`timescale 1ns / 1ps
`include "modules/rlshift.v"
module test_rlshift;

	// Inputs
	reg [7:0] d;
	reg clk;
	reg lod;
	reg clr;
	reg s;
	reg dir;
	reg dil;

	// Outputs
	wire [7:0] q;

	// Instantiate the Unit Under Test (UUT)
	rlshift my_rlshift (
		.q(q),
		.d(d),
		.clk(clk),
		.clr(clr),
		.lod(lod),
		.s(s),
		.dir(dir),
		.dil(dil)
	);
	always #50 clk=~clk;
	always@(posedge clk) 
	begin
		d=d+1;
	end
	initial begin 
		// Initialize Inputs
		clk = 0;
		clr = 1;
		s = 0;
		lod = 0; 
		dir = 0;
		dil = 0;
		#20;
		clr = 0;
		s=1;
		d = 4'd0000;
		// Wait 100 ns for global reset to finish
		#150;
		clr = 1;
		#50;
      lod = 1;
		#180;
		lod = 0;
		#450;
		s = 0;
		// Add stimulus here

	end
      
endmodule

