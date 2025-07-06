
/*
# Team ID:          < eYRC##3149>
# Theme:            < Ecomender bot >
# Author List:      < Advay Kunte, Samruddhee Jadhav , Pulkit Gupta ,Prabhat Sati >
# Filename:         < line_follower >
# File Description: < Module describing motor control using LFA sensor values based on path >
# Global variables: < None >
*/


module line_follower(
	input start,
	input clk_50M, dout,
	output adc_clk_out,
	output adc_cs_n, din,
	output reg ena,               // PWM output for Motor A
   output reg enb,               // PWM output for Motor B
   output reg in1, in2, in3, in4,   // Direction control signals
	output reg [1:0]j,				//lap number
	output reg [2:0] i,				//node number
	output reg node_sig,				//node signal: control signal
	input [1:0] path_mode,
	input start_node, end_node, current_node, next_node,
	output complete,
	output reg ctime
	);
		
Frequency_Scaling fs1 (clk_50M,adc_clk_out);																		//Scaling clock to 1MHz
ADC_controller adc1 (dout, adc_clk_out,adc_cs_n, din,left_value, center_value, right_value);		// Gaining left , right and senter values using ADC connections

reg [7:0] speeda,speedb; //speeds of motors a and b
reg [7:0] pwm_counter;	 //PWM counter
wire [11:0] left_value, center_value, right_value; //values of LFA sensor

reg [4:0] node_array [0:15];	//array of nodes in FSU
reg [1:0] turn_decision [0:15];

reg [31:0] delay_counter;		//control counter
reg state ;				//control signal used for switching on when Node entered for detecting Node
reg s;					//control signal which ensures line following starts post start signal
reg turn ;		     //control signal for turning at certain nodes
reg [3:0] number_nodes;
reg [3:0] m  ;


initial begin 
					 ena <= 0;
					 enb <= 0;
					 pwm_counter = 0;
					 in1 <= 0;
                in2 <= 0;
                in3 <= 0;
                in4 <= 0;
					 i<= 0;
					 j<= 0;
					 speeda <= 205;
					 speedb <= 205;					 
		node_array[0]= 5'd11;
		node_array[1]= 5'd19;
		node_array[2]= 5'd18;
		node_array[3]= 5'd21;
		node_array[4]= 5'd23;
		node_array[5]= 5'd24;
		node_array[6]= 5'd10;
		state = 0;
		s= 0;
		turn <= 1;
//		for(m = 0 ; (m < number_nodes) ; m = m+1) begin
//			//turn_decision naming convention --> 0:forward ; 1:right ; 2:left ; 3:uturn 
//			if(0<m <= 9) begin
//			case(node_array[m]) 
//			0: begin
//				if(node_array[m-1] == 6) begin
//					if(node_array[m+1] == 10) begin
//						turn_decision[m] = 0;
//					end
//					else if (node_array[m+1] == 1) begin
//						turn_decision[m] = 1;
//					end
//				end
//				else if (node_array[m-1] == 10) begin 
//					if(node_array[m+1] == 6) begin
//						turn_decision[m] = 0;
//					end
//					else if (node_array[m+1] == 1) begin
//						turn_decision[m] = 2;
//					end
//				end
//				else if (node_array[m-1] == 1) begin 
//					if(node_array[m+1] == 10) begin
//						turn_decision[m] = 1;
//					end
//					else if (node_array[m+1] == 6) begin
//						turn_decision[m] = 2;
//					end
//				end
//				
//				end
////			1:
////			2:
////			3:
////			4:
////			5:
////			6:
////			7:
////			8:
////			9:
////			10:
////			11:
////			12:
////			13:
////			14:
////			15:
////			16:
////			17:
////			18:
////			19:
////			20:
////			21:
////			22:
////			23:
////			24:
////			25:
////			26:
////			27:
////			28:
////			29:
////			30:
////			31:
//		endcase
//		end
		for(m = 0; (m < number_nodes); m = m + 1) begin
    // turn_decision naming convention --> 0:forward ; 1:right ; 2:left ; 3:uturn 
    if((m > 0) && (m <= 9)) begin
        case(node_array[m])
        0: begin
            if(node_array[m-1] == 6) begin
                if(node_array[m+1] == 10) begin
                    turn_decision[m] = 0;
                end
                else if (node_array[m+1] == 1) begin
                    turn_decision[m] = 1;
                end
            end
            else if (node_array[m-1] == 10) begin 
                if(node_array[m+1] == 6) begin
                    turn_decision[m] = 0;
                end
                else if (node_array[m+1] == 1) begin
                    turn_decision[m] = 2;
                end
            end
            else if (node_array[m-1] == 1) begin 
                if(node_array[m+1] == 10) begin
                    turn_decision[m] = 1;
                end
                else if (node_array[m+1] == 6) begin
                    turn_decision[m] = 2;
                end
            end
        end
        // Add cases for other node_array[m] values as needed
        endcase
    end
end

end


always @(posedge adc_clk_out)	begin

		/*
Purpose:
---
Controlling the motor signals at the clock which is used to sample valyes from the LFA sensor
*/

		  if(!start) begin 
			s = 1;
		  end
		  if(s) begin 				// s enabled once start signal received
		  if ( j != 1) begin
        pwm_counter <= pwm_counter + 1;

        // Generate PWM signals for Motor A and Motor B
        ena <= (pwm_counter < speeda) ? 1 : 0; // Compare counter with speed_a
        enb <= (pwm_counter < speedb) ? 1 : 0; // Compare counter with speed_b
		  
		  if(state == 0) delay_counter <= 0;		// By default system in state 0
		  
		  else if (state ==1) begin 					// Once node detected after 2s state 0 switched on.
				delay_counter <= delay_counter+1 ; 	//State 2 supposed to handle the node duration contro/
				
				if(delay_counter == 1) begin 
					turn <= 1;
				end
				else if(delay_counter == 600000) begin
					turn  <= 0;      
					end				
				else if(delay_counter == 6250000) begin
					state <= 0;      
				end
		  end

if (turn_decision[i] == 2 && turn == 1)	//Specific sharp left turn for nodes for specified duration
 begin  
					  in1 <= 0;
					  in2 <= 1;
					  in3 <= 1;
					  in4 <= 0;
					  speeda <= 0;
					  speedb <= 255;
end

else if (turn_decision[i] == 1 && turn == 1)	//Specific sharp right turn for nodes for specified duration
 begin  
					  in1 <= 1;
					  in2 <= 0;
					  in3 <= 0;
					  in4 <= 1;
					  speeda <= 255;
					  speedb <= 0;
end
else if (turn_decision[i] == 0 && turn == 1)	//Specific sharp right turn for nodes for specified duration
 begin  
					  in1 <= 1;
					  in2 <= 0;
					  in3 <= 1;
					  in4 <= 0;
					  speeda <= 205;
					  speedb <= 205;
end

else begin
if (left_value<900 && center_value>900 && right_value<900) //Straight forward control signals
				begin 
						 in1 <= 1;
						 in2 <= 0;
						 in3 <= 1;
						 in4 <= 0;
						 speeda <= 205;
						 speedb <= 205;
						 node_sig <= 0;
				end 

			else if(left_value<900 && center_value>900 && right_value>600) //Turn Right control
				begin 
						node_sig <= 0;
						in1 <= 1;
					   in2 <= 0;
                  in3 <= 0;
                  in4 <= 1;
					 speeda <= 205;
						 speedb <= 205;
				end 
			else if(left_value>600 && center_value>900 && right_value<900) //Turn left control
				begin 
					node_sig <= 0;
					  in1 <= 0;
					  in2 <= 1;
					  in3 <= 1;
					  in4 <= 0;
					 speeda <= 205;
						 speedb <= 205;
				end 		
			else if (left_value>900 && center_value>900 && right_value>900) begin //NODE detected
				 node_sig <= 1;

				if(state == 0)	begin					//As node entered it is detected
					if(i ==number_nodes) begin 							
					j <= 1;
					end
					else begin							// i value which determines the sequencng of the nodes crossed
					i <= i+1;
					end
				state <= 1;								//transient state for nodes
				end
				end
				end
				end
				else begin 
					  node_sig <= 0;
					  in1 <= 0;
					  in2 <= 0;
					  in3 <= 0;
					  in4 <= 0;
				end
				end
				end

endmodule



///*
//# Team ID:          < eYRC##3149>
//# Theme:            < Ecomender bot >
//# Author List:      < Advay Kunte, Samruddhee Jadhav , Pulkit Gupta ,Prabhat Sati >
//# Filename:         < line_follower >
//# File Description: < Module describing motor control using LFA sensor values based on path >
//# Global variables: < None >
//*/
//
//
//module line_follower(
//	input start,
//	input clk_50M, dout,
//	output adc_clk_out,
//	output adc_cs_n, din,
//	output reg ena,               // PWM output for Motor A
//   output reg enb,               // PWM output for Motor B
//   output reg in1, in2, in3, in4,   // Direction control signals
//	output reg [1:0]j,				//lap number
//	output reg [2:0] i,				//node number
//	output reg node_sig				//node signal: control signal
//	);
//		
//Frequency_Scaling fs1 (clk_50M,adc_clk_out);																		//Scaling clock to 1MHz
//ADC_controller adc1 (dout, adc_clk_out,adc_cs_n, din,left_value, center_value, right_value);		// Gaining left , right and senter values using ADC connections
//
//reg [7:0] speeda,speedb; //speeds of motors a and b
//reg [7:0] pwm_counter;	 //PWM counter
//wire [11:0] left_value, center_value, right_value; //values of LFA sensor
//
//reg [4:0] node_array [0:6];	//array of nodes in FSU
//reg [31:0] delay_counter;		//control counter
//reg state ;				//control signal used for switching on when Node entered for detecting Node
//reg s;					//control signal which ensures line following starts post start signal
//reg turn ;		     //control signal for turning at certain nodes
//
//initial begin 
//					 ena <= 0;
//					 enb <= 0;
//					 pwm_counter = 0;
//					 in1 <= 0;
//                in2 <= 0;
//                in3 <= 0;
//                in4 <= 0;
//					 i<= 0;
//					 j<= 0;
//					 speeda <= 205;
//					 speedb <= 205;					 
//		node_array[0]= 5'd11;
//		node_array[1]= 5'd19;
//		node_array[2]= 5'd18;
//		node_array[3]= 5'd21;
//		node_array[4]= 5'd23;
//		node_array[5]= 5'd24;
//		node_array[6]= 5'd10;
//		state = 0;
//		s= 0;
//		turn <= 1;
//end
//
//
//always @(posedge adc_clk_out)	begin
//
//		/*
//Purpose:
//---
//Controlling the motor signals at the clock which is used to sample valyes from the LFA sensor
//*/
//
//		  if(!start) begin 
//			s = 1;
//		  end
//		  if(s) begin 				// s enabled once start signal received
//		  if ( j != 2) begin
//        pwm_counter <= pwm_counter + 1;
//
//        // Generate PWM signals for Motor A and Motor B
//        ena <= (pwm_counter < speeda) ? 1 : 0; // Compare counter with speed_a
//        enb <= (pwm_counter < speedb) ? 1 : 0; // Compare counter with speed_b
//		  
//		  if(state == 0) delay_counter <= 0;		// By default system in state 0
//		  
//		  else if (state ==1) begin 					// Once node detected after 2s state 0 switched on.
//				delay_counter <= delay_counter+1 ; 	//State 2 supposed to handle the node duration contro/
//				
//				if(delay_counter == 1) begin 
//					turn <= 1;
//				end
//				
//				if (i != 0) begin
//					if(delay_counter == 781250) begin
//					turn  <= 0;      
//					end
//				end
//				
//				else begin
//					if(delay_counter == 400000) begin
//					turn <= 0;
//					end
//				end
//				
//				if(delay_counter == 6250000) begin
//					state <= 0;      
//				end
//		  end
//
//if ((i == 2 || i== 4 || i ==6 || (j==1& i==0) )&& turn == 1)	//Specific sharp left turn for nodes for specified duration
// begin  
//					  in1 <= 0;
//					  in2 <= 1;
//					  in3 <= 1;
//					  in4 <= 0;
//					  speeda <= 0;
//					  speedb <= 255;
//end
//
//else begin
//if (left_value<900 && center_value>900 && right_value<900) //Straight forward control signals
//				begin 
//						 in1 <= 1;
//						 in2 <= 0;
//						 in3 <= 1;
//						 in4 <= 0;
//						 speeda <= 205;
//						 speedb <= 205;
//						 node_sig <= 0;
//				end 
//
//			else if(left_value<900 && center_value>900 && right_value>600 && i != 6) //Turn Right control
//				begin 
//						node_sig <= 0;
//						in1 <= 1;
//					   in2 <= 0;
//                  in3 <= 0;
//                  in4 <= 1;
//					 speeda <= 205;
//						 speedb <= 205;
//				end 
//			else if(left_value<900 && center_value>900 && right_value>300 && i == 6) //Turn right control specifcally sensitive for crooked path between nodes 10 and 11
//				begin 
//						node_sig <= 0;
//						in1 <= 1;
//					   in2 <= 0;
//                  in3 <= 0;
//                  in4 <= 1;
//					 speeda <= 205;
//						 speedb <= 205;
//				end 
//			else if(left_value>600 && center_value>900 && right_value<900 && i != 6) //Turn left control
//				begin 
//					node_sig <= 0;
//					  in1 <= 0;
//					  in2 <= 1;
//					  in3 <= 1;
//					  in4 <= 0;
//					 speeda <= 205;
//						 speedb <= 205;
//				end 
//			
//				else if(left_value>300 && center_value>900 && right_value<900 && i == 6) //Turn left control specifcally sensitive for crooked path between nodes 10 and 11
//				begin 
//					node_sig <= 0;
//					  in1 <= 0;
//					  in2 <= 1;
//					  in3 <= 1;
//					  in4 <= 0;
//					 speeda <= 205;
//						 speedb <= 205;
//				end 	
//		
//			else if (left_value>900 && center_value>900 && right_value>900) begin //NODE detected
//				 node_sig <= 1;
//
//				if(state == 0)	begin					//As node entered it is detected
//					if(i ==6) begin 							
//					i <= 0;
//					j <= j+ 1;
//					end
//					
//					else begin							// i value which determines the sequencng of the nodes crossed
//					i <= i+1;
//					end
//				state <= 1;								//transient state for nodes
//				end
//						case(node_array[i])
//		
//							node_array[0]: 
//								if (j==0) begin		//first go straight, 
//										in1 <= 1;
//										in2 <= 0;
//										in3 <= 1;
//										in4 <= 0;
//								end
//								else if (j==1) begin 	//in second lap turn left
//										in1 <= 0;
//										in2 <= 1;
//										in3 <= 1;
//										in4 <= 0;
//								end
//
//							node_array[1]: begin 		//forward
//										in1 <= 1;
//										in2 <= 0;
//										in3 <= 1;
//										in4 <= 0;
//								end
//
//							node_array[3]:begin			//forward 
//										in1 <= 1;
//										in2 <= 0;
//										in3 <= 1;
//										in4 <= 0;
//								end 
//				
//							node_array[5]:begin			//forward
//										in1 <= 1;
//										in2 <= 0;
//										in3 <= 1;
//										in4 <= 0;
//								end 
//
//						endcase
//
//				end
//				end
//				end
//				else if ( j == 2) begin		//Once both laps completed
//					   in1 <= 0;
//						in2 <= 0;
//						in3 <= 0;
//						in4 <= 0;
//						node_sig = 0;
//				end
//				
//				end
//				end
//endmodule
