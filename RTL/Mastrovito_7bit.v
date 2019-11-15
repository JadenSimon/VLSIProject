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