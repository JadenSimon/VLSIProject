// Divides value by X
module Halver(a, b);
	input [6:0] a;
	output [6:0] b;

	assign b[0] = a[1] ^ a[0];
	assign b[1] = a[2];
	assign b[2] = a[3];
	assign b[3] = a[4];
	assign b[4] = a[5];
	assign b[5] = a[6];
	assign b[6] = a[0];

endmodule 

// Does squaring over fields 2^m
// Can be found by squaring an arbitrary bit vector then finding the bit values
module Squarer(a, b);	
	input [6:0] a;
	output [6:0] b;

	assign b[0] = a[0];
	assign b[1] = a[4];
	assign b[2] = a[4] ^ a[1];
	assign b[3] = a[5];
	assign b[4] = a[5] ^ a[2];
	assign b[5] = a[6];
	assign b[6] = a[6] ^ a[3];

endmodule 

// 7-bit Mastrovito multiplier
// Primitive polynomial to use: x^7 + x + 1
// Resources: 
// https://pdfs.semanticscholar.org/501f/856a68c5231d93c82ce89456bff55842b13b.pdf
// https://online.tugraz.at/tug_online/voe_main2.getvolltext?pCurrPk=43036
module Mastrovito7(a, b, c);

	input [6:0] a, b;
	output wire [6:0] c;
	wire s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12;
	
	assign s0 = a[0] & b[0];
	assign s1 = (a[1] & b[0]) ^ (a[0] & b[1]);
	assign s2 = (a[2] & b[0]) ^ (a[1] & b[1]) ^ (a[0] & b[2]);
	assign s3 = (a[3] & b[0]) ^ (a[2] & b[1]) ^ (a[1] & b[2]) ^ (a[0] & b[3]);
	assign s4 = (a[4] & b[0]) ^ (a[3] & b[1]) ^ (a[2] & b[2]) ^ (a[1] & b[3]) ^ (a[0] & b[4]);
	assign s5 = (a[5] & b[0]) ^ (a[4] & b[1]) ^ (a[3] & b[2]) ^ (a[2] & b[3]) ^ (a[1] & b[4]) ^ (a[0] & b[5]);
	assign s6 = (a[6] & b[0]) ^ (a[5] & b[1]) ^ (a[4] & b[2]) ^ (a[3] & b[3]) ^ (a[2] & b[4]) ^ (a[1] & b[5]) ^ (a[0] & b[6]);
	assign s7 = (a[6] & b[1]) ^ (a[5] & b[2]) ^ (a[4] & b[3]) ^ (a[3] & b[4]) ^ (a[2] & b[5]) ^ (a[1] & b[6]);
	assign s8 = (a[6] & b[2]) ^ (a[5] & b[3]) ^ (a[4] & b[4]) ^ (a[3] & b[5]) ^ (a[2] & b[6]);
	assign s9 = (a[6] & b[3]) ^ (a[5] & b[4]) ^ (a[4] & b[5]) ^ (a[3] & b[6]);
	assign s10 = (a[6] & b[4]) ^ (a[5] & b[5]) ^ (a[4] & b[6]);
	assign s11 = (a[6] & b[5]) ^ (a[5] & b[6]);
	assign s12 = (a[6] & b[6]);

	assign c[0] = s7 ^ s0;
	assign c[1] = s8 ^ s7 ^ s1;
	assign c[2] = s9 ^ s8 ^ s2;
	assign c[3] = s10 ^ s9 ^ s3;
	assign c[4] = s11 ^ s10 ^ s4;
	assign c[5] = s12 ^ s11 ^ s5;
	assign c[6] = s12 ^ s6;
	
endmodule 

// Finds inverse of a polynomial mod P(X)
// Uses extended binary GCD algorithm
module Inverse(a, b, clk, load);
	input [6:0] a;
	output reg [6:0] b;
	input clk;
	input load;

	reg [7:0] s, t;
	reg [7:0] h1, h2, k1, k2;

	wire [6:0] adder1, adder2, adder3, adder4;
	wire [6:0] h1_half, h2_half, k1_half, k2_half;

	assign adder1 = (h1 ^ a);
	assign adder2 = (h2^ 7'b0000011);
	assign adder3 = (k1 ^ a);
	assign adder4 = (k2 ^ 7'b0000011);

	Halver halver1(adder1, h1_half);
	Halver halver2(adder2, h2_half);
	Halver halver3(adder3, k1_half);
	Halver halver4(adder4, k2_half);

	always@(posedge clk) begin
		if (load) begin
			s = 8'b10000011;
			t = a;
			h1 = 8'b1;
			h2 = 8'b0;
			k1 = 8'b0;
			k2 = 8'b1;
		end else if (s == 0) begin // If is s is 0, output the result
			b = k2[6:0];
		end else begin
			// If s is even then we can divde it by X
			// By doing so, we must then check our accumalators
			if (s[0] == 0) begin 
				s = s >> 1;

				if (h1[0] == 0 && h2[0] == 0) begin // If both accumalators are even, then just divide by X
					h1 = h1 >> 1;
					h2 = h2 >> 1;
				end else begin // Otherwise, we must add our original s and t to our accumalators, then halve them
					h1 = h1_half;
					h2 = h2_half ^ 7'b1000000;
				end
			end else if (t[0] == 0) begin // Same process for t
				t = t >> 1;

				if (k1[0] == 0 && k2[0] == 0) begin
					k1 = k1 >> 1;
					k2 = k2 >> 1;
				end else begin
					k1 = k1_half;
					k2 = k2_half ^ 7'b1000000;
				end
			end else if (s >= t) begin // If s is greater than t, just add everything up (which is subtraction in fields characteristic 2)
				s = s ^ t;
				h1 = h1 ^ k1;
				h2 = h2 ^ k2;
			end else begin // Otherwise, subtract s from t (same for accumulators)
				t = s ^ t;
				k1 = h1 ^ k1;
				k2 = h2 ^ k2;			
			end

			b = b;
		end
	end

endmodule 

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
	Squarer square(slope, slopeSquared);
	assign point3x = (slopeSquared ^ slope) ^ (denominator ^ 7'b1);

	// calculate y3 = λ(x1 + x3) + x3 + y1
	wire [6:0] out;
	assign partial = point1x ^ point3x;
	Mastrovito7 mult(slope, partial, out);
	assign point3y = ((out ^ point3x) ^ point1y);

	// concatenate the points to output
	assign sum = (point1 == 0) ? point2 : ((point2 == 0) ? point1 : ((point1x == point2x) ? 14'b0 : {point3y, point3x}));

endmodule

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
	// if pointx == 0 then return (0, 0)
	assign sum = (pointx == 0) ? 14'b0 : {point3y, point3x};
endmodule 

// Performs the computation scalar * point using a combination of point adders and point doublers
// Start signal starts the computation, sets done to 1 when complete.
// When x1 == x2 then the next point is the point at infinity
// For point doubling, this happens when x = 0
// Point at infinity is represented as 0,0 (needs to be implemented)

module PointMultiplier(point, scalar, clk, start, result, done);
	input [13:0] point;
	input [6:0] scalar;
	input clk, start;
	output reg [13:0] result;
	output reg done;

	reg [7:0] counter;
	reg [13:0] accumulator;
	reg [13:0] currentP;
	reg [6:0] currentS;
	reg cycle;

	wire [13:0] doubledPoint;
	wire [13:0] addedPoint;

	PointDouble doubler(currentP, clk, cycle, doubledPoint);
	PointAdder adder(clk, currentP, accumulator, cycle, addedPoint);

	// Takes 32 clock cycles per iteration
	always@(posedge clk) begin
		if (start) begin
			counter = 7'b0;
			accumulator = 14'b0;
			currentP = point;
			currentS = scalar;
			cycle = 1'b1;
			result = 14'b0;
			done = 1'b0;
		end else begin
			if (counter[7:5] == 3'b111) begin // Terminate
				result = accumulator;
				done = 1'b1;
			end else if (counter[4:0] == 5'b11111) begin // Upon completion of a cycle, update registers 
				if (currentS[0] == 1'b1)
					accumulator = addedPoint;

				counter = counter + 1'b1;
				cycle = 1'b1;

				// Double the point and halve scalar
				currentP = doubledPoint;
				currentS = currentS >> 1;

				result = 14'b0;
				done = 1'b0;
			end else begin
				counter = counter + 1'b1;
				cycle = 1'b0;
				result = 14'b0;
				done = 1'b0;
			end
		end
	end

endmodule 

