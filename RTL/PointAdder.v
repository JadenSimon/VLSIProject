// Point addition module
// Make it purely combinational?
// We are working over the field of F_2^7
// Addition is just XOR
// Use Mastrovito multiplier for multiplication
// Need a divider that works over F_2^7

module PointAdder(point1, point2, sum);
	input [13:0] point1;
	input [13:0] point2; 
	output [13:0] sum;
	
	reg [6:0] slope;
endmodule
