// Point addition module
// Make it purely combinational?
// We are working over the field of F_2^7
// Addition is just XOR
// Use Mastrovito multiplier for multiplication
// Need a divider that works over F_2^7

module PointAdder(clk, point1, point2, load, sum);
	input [13:0] point1;
	input [13:0] point2;
	input load, clk;
	output [13:0] sum;

	wire [6:0] point1x;
	wire [6:0] point1y;
	wire [6:0] point2x;
	wire [6:0] point2y;
	wire [6:0] point3x;
	wire [6:0] point3y;
	wire [6:0] partial;
	wire [6:0] numerator;
	wire [6:0] denominator;
	wire [6:0] denominator_inv;
	wire [6:0] slope;
	wire [6:0] slopeSquared;

	// Extract the point values out of the 14 bit inputs
 	assign point1x = point1[6:0];
	assign point1y = point1[13:7];
	assign point2x = point2[6:0];
	assign point2y = point2[13:7];

	// calculate slope λ = (y1 + y2)/(x1 + x2)
	assign numerator = point1y ^ point2y;
	assign denominator = point1x ^ point2x;
	Inverse divider(denominator, denominator_inv, clk, load);
	Mastrovito7 mult2(numerator, denominator_inv, slope);

	// calculate x3 = λ2 + λ + x1 + x2 + 1
	Mastrovito7 square(slope, slope, slopeSquared);
	assign point3x = (slopeSquared ^ slope) ^ (denominator ^ 7'b1);

	// calculate y3 = λ(x1 + x3) + x3 + y1
	wire [6:0] out;
	assign partial = point1x ^ point3x;
	Mastrovito7 mult(slope, partial, out);
	assign point3y = ((out ^ point3x) ^ point1y);

	// concatenate the points to output
	assign sum = {point3y, point3x};

endmodule
