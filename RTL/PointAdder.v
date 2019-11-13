// Point addition module
// Make it purely combinational?
// We are working over the field of F_2^7
// Addition is just XOR
// Use Mastrovito multiplier for multiplication
// Need a divider that works over F_2^7

module PointAdder(clk, point1, point2, sum);
	input [13:0] point1;
	input [13:0] point2;
	output [13:0] sum;

	wire [6:0] point1x;
	wire [6:0] point1y;
	wire [6:0] point2x;
	wire [6:0] point2y;
	wire [6:0] point3x;
	wire [6:0] point3y;
	wire [6:0] numerator;
	wire [6:0] denominator;
	reg [6:0] slope;
	reg [6:0] slopeSquared;

	// Extract the point values out of the 14 bit inputs
 	assign point1x = (point1 & 14'b11111110000000) >> 7;
	assign point1y = (point1 & 7'b1111111);
	assign point2x = (point2 & 14'b11111110000000) >> 7;
	assign point2y = (point2 & 7'b1111111);

	// calculate slope λ = (y1 + y2)/(x1 + x2)
	assign numerator = point1y ^ point2y;
	assign denominator = point1x ^ point2x;
	divider GCD3(clk, numerator, denominator, slope, 1'b1);

	// calculate x3 = λ2 + λ + x1 + x2 + 1
	square Mastrovito7(slope, slope, slopeSquared);
	assign point3x = (slopeSquared ^ slope) ^ (denominator ^ 7'b1);

	// calculate y3 = λ(x1 + x3) + x3 + y1
	wire [6:0] out;
	mult Mastrovito7(slope, (point1x ^ point3x), out);
	assign point3y = ((out ^ point3x) ^ pointy1);

	// concatenate the points to output
	assign sum = {point3x, point3y};

endmodule
