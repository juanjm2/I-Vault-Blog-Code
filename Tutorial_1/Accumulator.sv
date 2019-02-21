module Accumulator(
	input CLOCK_50,
	input [1:0] KEY,
	output logic [6:0] HEX0
);
/* How we declare our top level module */


/* Register to hold our value */
logic [3:0] accumulator;

/* Declaring our FSM module*/
fsm control_logic(
	.CLOCK_50(CLOCK_50),
	.KEY(~KEY[1:0]),
	.accumulator(accumulator)
);

/* Hex driver module that takes in a 4-bit  */
/* Value and outputs its hex value on board */
hexdriver HEX_0(
	.In(accumulator),
	.Out(HEX0)
);

/* how we finish defining our module */
endmodule : Accumulator
