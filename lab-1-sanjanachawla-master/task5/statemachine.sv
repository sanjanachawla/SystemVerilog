module statemachine(input slow_clock, input resetb,
                    input [3:0] dscore, input [3:0] pscore, input [3:0] pcard3,
                    output load_pcard1, output load_pcard2,output load_pcard3,
                    output load_dcard1, output load_dcard2, output load_dcard3,
                    output player_win_light, output dealer_win_light);

// The code describing your state machine will go here.  Remember that
// a state machine consists of next state logic, output logic, and the 
// registers that hold the state.  You will want to review your notes from
// CPEN 211 or equivalent if you have forgotten how to write a state machine.

typedef enum logic [4:0] {A,B,C,D,E,F,G,H,I,J,K,L,M} State;
State currentState, nextState;

//always_ff @(posedge slow_clock)
//	if (resetb == 0) currentState <= A;
//	else currentState <= nextState;
	
always @(posedge slow_clock or negedge resetb)
 
	begin
	 if(resetb == 0) currentState<= A;
	 else
			currentState <= nextState;

	end
			
	 

//making diagram
always_comb
	case(currentState)
	A : nextState <= B;
	B : nextState <= C;
	C : nextState <= D;
	
	D : if(pscore > 7 || dscore > 7) nextState <= E;
		 else if (pscore < 6) nextState = H;
		 else if (((pscore == 6) || (pscore ==7)) && (dscore < 6)) nextState <= F;
		 else nextState <= G; // (((pscore == 6) || (pscore ==7)) && ((dscore ==6) || (dscore ==7)))
		 
	E : if (pscore > dscore) nextState <= K;
		else if (dscore > pscore) nextState <= L;
		else nextState <=M; //if (pscore == dscore)
		
	F: if (pscore > dscore) nextState <= K;
		else if (dscore > pscore) nextState <= L;
		else  nextState <=M; //if (pscore == dscore)
		
	G:if (pscore > dscore) nextState <= K;
		else if (dscore > pscore) nextState <= L;
		else nextState <= M; // if (pscore == dscore)
		
	H: if (dscore == 7) nextState <=J;
		else if ((dscore == 6) && (5<pcard3<8)) nextState<= I;
		else if ((dscore == 5) && (3<pcard3<8)) nextState<= I;
		else if ((dscore == 4) && (1<pcard3<8)) nextState<= I;
		else if ((dscore == 3) && (0<pcard3<8)) nextState<= I;
		else if ((dscore < 3) && (pcard3<8)) nextState<= I;
		else nextState <= J;
		
	I : if (pscore > dscore) nextState <= K;
		else if (dscore > pscore) nextState <= L;
		else nextState <=M; //if (pscore == dscore)
	
	K: nextState <=K;
	L: nextState <=L;
	M: nextState <=M;
	default: nextState <=M;
	
	endcase
	// now we have to decide what to do in each state?
	
	//controlling the load_cards: 
	//case(currentState)
	

	//else load_dcard2 = 0;
	assign load_pcard1 =  currentState == A;
	
	assign load_dcard1  = currentState == B;
	
	assign load_pcard2 =  currentState == C;
	
	assign load_dcard2 = currentState == D;
	
	assign load_pcard3 = currentState == H;
	
	assign load_dcard3  = currentState == F || currentState == I;
	
	//controlling the LED's + game ending
	
	assign player_win_light  = currentState == K||currentState == M;
	
	assign dealer_win_light  = currentState == L||currentState == M;
	//endcase
endmodule

