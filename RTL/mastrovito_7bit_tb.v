// MASTRIVITO Testbench

module mastrovito_7bit_tb();
	
	reg [6:0] a, b;
	wire [6:0] c;

	Mastrovito7 m(a, b, c);
	
	initial begin
		a = 7'b1111111;
		b = 7'b1111111;
	end

	always begin
		#100;
		#20;
		#10000;
	end

endmodule