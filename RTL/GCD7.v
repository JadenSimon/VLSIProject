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

	always@(posedge clk) begin
		if (load) begin
			u = a;
			v = b;
			acc = 0;
		end	

		if (u[0] == 0 && v[0] == 0) begin
			acc = acc + 1'b1;
			u = u >> 2;
			v = v >> 2;
		end
		else if (u[0] == 0 && v[0] == 1) begin
			u = u >> 2;
		end
		else if (u[0] == 1 && v[0] == 0) begin
			v = v >> 2;
		end
		else begin
			if (u >= v) begin
				u = (u ^ v) >> 2;
			end
			else begin
				temp = u;
				u = (v ^ u) >> 2;
				v = temp;
			end
		end

		if (u == v || u == 0) begin
			c = v << acc;
		end
		else begin
			c = c;
		end
	end

endmodule