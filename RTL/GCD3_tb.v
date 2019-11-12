// GCD3 Testbench

module GCD3_tb();
	
	reg [2:0] a, b;
	wire [2:0] c;
	reg clk, load;

	GCD3 gcd3(clk, a, b, c, load);
	
	initial begin
		a = 3'b000;
		b = 3'b000;
		load = 0;
		clk = 0;
	end

	always begin
		#10 clk = ~clk;
	end

	always begin
		#100;
		a = 3'b110;
		b = 3'b011;
		load = 1;
		#20;
		load = 0;
		#100;
	end

endmodule