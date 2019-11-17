// Sequential 3-bit implementation of Stein's algorithm
// https://en.wikipedia.org/wiki/Binary_GCD_algorithm
// Super unoptimized

module GCD7(clk, a, b, c, load);
	input [6:0] a;
	input [6:0] b;
	output reg [6:0] c;
	input clk;
	input load;
	reg [6:0] u;
	reg [6:0] v;
	reg [6:0] acc;
	reg [6:0] temp;

	wire [6:0] adder;
	wire [6:0] v_half;
	wire [6:0] u_half;
	wire [6:0] adder_half;
	assign adder = u ^ v;

	assign v_half = 7'b0;
	assign u_half = 7'b0;
	assign adder_half = v_half;
	always@(posedge clk) begin
		if (load) begin
			u = a;
			v = b;
			acc = 0;
		end else begin
			if (u[0] == 0 && v[0] == 0) begin
				acc = acc + 1'b1;
				u = u_half;
				v = v_half;
			end
			else if (u[0] == 0 && v[0] == 1) begin
				u = u_half;
			end
			else if (u[0] == 1 && v[0] == 0) begin
				v = v_half;
			end
			else begin
				if (u >= v) begin
					u = adder;
				end
				else begin
					temp = u;
					u = adder;
					v = temp;
				end
			end

			if (u == v || u == 0) begin
				c = v & acc;
			end
			else begin
				c = c;
			end
		end
	end

endmodule