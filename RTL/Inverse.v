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