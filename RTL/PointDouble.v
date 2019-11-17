module PointDouble(point, clk, load, sum);	
	input [13:0] point;
	input load, clk;
	output [13:0] sum;

	wire [6:0] pointx;
	wire [6:0] pointy;
	wire [6:0] point3x;
	wire [6:0] point3y;
	wire [6:0] partial;
	wire [6:0] partial2;
	wire [6:0] partial3;
	wire [6:0] slope;
	wire [6:0] slopeSquared;

	// Extract the point values out of the 14 bit inputs
 	assign pointx = point[6:0];
	assign pointy = point[13:7];

	// calculate slope λ = (x^2 + y) / x = x + y/x
	Inverse divider(pointx, partial2, clk, load);
	Mastrovito7 mult2(partial2, pointy, partial3);
	assign slope = pointx ^ partial3;

	// calculate x3 = λ2 + λ + x1 + x2 + 1
	Squarer square2(slope, slopeSquared);
	assign point3x = (slopeSquared ^ slope ^ 7'b1);

	// calculate y3 = λ(x1 + x3) + x3 + y1
	wire [6:0] out;
	assign partial = pointx ^ point3x;
	Mastrovito7 mult(slope, partial, out);
	assign point3y = ((out ^ point3x) ^ pointy);

	// concatenate the points to output
	assign sum = {point3y, point3x};
endmodule 