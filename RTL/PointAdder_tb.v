// PointAdder Testbench

module PointAdder_tb();
	
	reg [13:0] point1, point2;
	wire [13:0] sum;
	reg clk, load;

	PointAdder pa(clk, point1, point2, load, sum);
	
	initial begin
		point1 = 14'b01110000111010;
		point2 = 14'b11110011110001;
		load = 0;
		clk = 0;
	end

	always begin
		#10 clk = ~clk;
	end

	always begin
		#100;
		load = 1;
		#20;
		load = 0;
		#10000;
	end

endmodule