// Main test bench for point multiplication
module PointMultiplier_tb();
	reg [13:0] point;
	reg [6:0] scalar;
	wire [13:0] result;
	wire done;
	reg clk, start;

	PointMultiplier pm(point, scalar, clk, start, result, done);
	
	initial begin
		point = 14'b11101111000001; // x = X6 + 1, y = X6 + X5 + X4 + X2 + X + 1
		scalar = 7'b0000011;
		start = 0;
		clk = 0;
	end

	always begin
		#10 clk = ~clk;
	end

	always begin
		#100;
		start = 1;
		#20;
		start = 0;
		#100000;
	end

endmodule