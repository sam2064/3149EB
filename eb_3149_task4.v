/*
# Team ID:          < eYRC##3149>
# Theme:            < Ecomender bot >
# Author List:      < Advay Kunte, Samruddhee Jadhav , Pulkit Gupta ,Prabhat Sati >
# Filename:         < eb_3149_task4 >
# File Description: < Top Level Module integrating and instantiating all files >
# Global variables: < None >
*/
module eb_3149_task4(
	input start,	//start push button pin
	input dout,
	output adc_clk_out,		//3.125MHz 
	output adc_cs_n, din,
	output ena,               // PWM output for Motor A
   output enb,               // PWM output for Motor B
   output in1, in2, in3, in4,	//direction signal for motor
	output OE_sig,	
	
   input clk_50MHz, 
   input cs_out, //input PWM from colour sensor
	output [1:0] filter, //S2,S3 for colour sensor IC
	output [1:0] scaling_frequency,//S2,S3 for colour sensor IC
	output OE, //enable of colour sensor
   output E1R, E1G, E1B,  // RGB for LED1
   output E2R, E2G, E2B,  // RGB for LED2
   output E3R, E3G, E3B,   // RGB for LED3
	
	output [1:0]j,		//variable for node number determination
	output [2:0] i,	//variable for lap number
	output node_sig,
	input rx,
   output tx,tx_done,
	output rx_complete	,
	output [1:0] ss		//save state signal
	);

assign OE = 0;	//active low enable of colour sensor
	
//line follower module instantiation 	
line_follower LF1 (start,clk_50MHz, dout,adc_clk_out,adc_cs_n, din,ena,enb,in1, in2, in3, in4, j, i, node_sig);

//colour detect module instantiation
clr_detect CLR_DET (clk_50MHz,cs_out,filter,scaling_frequency,E1R, E1G, E1B,E2R, E2G, E2B,E3R, E3G, E3B,j,i, color,ss);

//UART module instantiation
uart_rx_tx UART (rx,clk_50MHz,tx,tx_done,rx_complete, color, i, node_sig,sig, ss);

wire sig = (ss ==1 ) || (ss ==2) || (ss ==3);// control signal, becomes high whenever colour is detected

endmodule

