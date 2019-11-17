// Performs the computation scalar * point using a combination of point adders and point doublers
// Start signal starts the computation, sets done to 1 when complete.
module PointMultiplier(point, scalar, clk, start, result, done);
	input [13:0] point;
	input [6:0] scalar;
	input clk, start;
	output reg [13:0] result;
	output reg done;

	reg [8:0] counter;
	reg [13:0] accumulator;
	reg [13:0] currentP;
	reg [6:0] currentS;
	reg cycle;

	wire [13:0] doubledPoint;
	wire [13:0] addedPoint;

	PointDouble doubler(currentP, clk, cycle, doubledPoint);
	PointAdder adder(clk, currentP, accumulator, cycle, addedPoint);

	always@(posedge clk) begin
		if (start) begin
			counter = 9'b0;
			accumulator = point;
			currentP = point;
			currentS = scalar;
			cycle = 1'b1;
			result = 14'b0;
			done = 1'b0;
		end else begin
			if (counter[8:6] == 3'b111) begin // Terminate
				result = accumulator;
				done = 1'b1;
			end else if (counter[5:0] == 6'b111111) begin // Upon completion of a cycle, update registers
				if (currentS[0] == 1'b1 && counter[8:6] != 3'b000)
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