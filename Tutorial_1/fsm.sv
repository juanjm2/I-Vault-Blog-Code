module fsm(
	input CLOCK_50,
	input [1:0] KEY,
	output logic [3:0] accumulator
);

/* Register to latch our accumulator's value */
logic [3:0] prev_accumulator;

/* Initializing our variables (this is done only once) */
initial begin
	accumulator = 4'd0;
	prev_accumulator = 4'd0;
end

/* Declaring our states based on our FSM design */
enum logic [1:0] {
	IDLE 		 = 2'd0,
	INCREMENT = 2'd1,
	DECREMENT = 2'd2,
	FIN		 = 2'd3
} state, next_state;

/* Assigning our latch variable to our current value of accumulator */
always_ff @(posedge CLOCK_50) begin
	prev_accumulator <= accumulator;
end

/* Logic for our state to take on the next_state */
always_ff @(posedge CLOCK_50) begin
	state <= next_state;
end

/* Combinational logic for next_state's assignment */
always_comb begin
	next_state = state;
	case (state)
		IDLE: begin
			if (KEY[1]) begin				
				next_state = INCREMENT; // If we press KEY[1] we transition to the INCREMENT state
			end
			else if (KEY[0]) begin
				next_state = DECREMENT; // If we press KEY[0] we transition to the DECREMENT state
			end
			else begin
				next_state = IDLE;		// If no keys are pressed then we stay in the IDLE state
			end
		end
		INCREMENT: next_state = FIN;	// Transition to the FIN state after we increment/decrement
		DECREMENT: next_state = FIN;
		
		/* If we are still pressing the button we must wait until we release the button to go back to the IDLE state*/
		FIN: next_state = (~KEY[0] & ~KEY[1]) ? IDLE : FIN;
	endcase
end

/* Combinational logic for current state assignments */
always_comb begin
	accumulator = prev_accumulator;	// By default accumulator will hold it's value it had last clock cycle.
	case(state)
		INCREMENT: accumulator = accumulator + 4'd1; // Increment accumulator's value by one
		DECREMENT: accumulator = accumulator - 4'd1; // Decrement accumulator's value by one
		default: ;
	endcase
end

endmodule : fsm
