/*
# Team ID:          < eYRC##3149>
# Theme:            < Ecomender bot >
# Author List:      < Advay Kunte, Samruddhee Jadhav , Pulkit Gupta ,Prabhat Sati >
# Filename:         < t1b_cd_fd >
# File Description: < Top level module describing task 1B i.e. Color Detection >
# Global variables: < None >
*/

module t1b_cd_fd (                      // Module Declaration
    input  clk_1MHz, cs_out,            //Inputs : clk_1MHz, cs_out
    output reg [1:0] filter, color      //Output : filter, color
);

// red   -> color = 1;
// green -> color = 2;
// blue  -> color = 3;

//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE //////////////////
reg [7:0] red_freq;			// < red_freq >: < to keep record of frequency of cs _out during red filter >
reg [7:0] green_freq;		// < green_freq >: < to keep record of frequency of cs _out during green filter >
reg [7:0] blue_freq;		// < blue_freq >: < to keep record of frequency of cs _out during blue filter >

initial begin // editing this initial block is allowed
    filter = 3; color = 0; trigger= 1;
end
reg [10:0] counter = 0;		// < counter >: < to record number of cycles(frequency) of clk_1MHz >
reg [8:0] k = 0;				// < k >: < to record number of cycles(frequency) of cs_out >
reg trigger ;

always @(posedge clk_1MHz ) begin
/*
Purpose:
< to execute FSM where filter changes based on 'counter' instructions and color changes based on 'k' and frequency(red_freq, blue_freq and green_freq) instructions >
*/
	if(cs_out &&trigger) begin 
		k = k + 1;
		trigger = 0;
	end
	if(!cs_out) begin 
		trigger = 1;
	end
counter = counter + 1;
	if (counter <= 750)	begin
		filter = 3;
		green_freq = k ;		//calculation of frequency during green filter
		end
	else if (counter > 750 & counter <=1250) begin
		filter = 0;
		red_freq = k - green_freq ;		//calculation of frequency during red filter
		end
	else if(counter > 1250 & counter<=1500)begin
		filter = 1;
		blue_freq = k - green_freq - red_freq ;		//calculation of frequency during blue filter
		end
	else 
		begin
		filter = 2;
		k = 0;
		if (red_freq > blue_freq) begin		// comparison of frequencies to determine the detected color
			if(red_freq > green_freq)
					color = 1;
			else color = 2;
			end
		else begin
			if (blue_freq>green_freq) begin
				if(blue_freq<40) color = 3;
				else color = 0;
			end
			else color = 2;
		end
				
		end
	if (counter ==1501) begin
	counter=0;
	blue_freq =0;
	green_freq = 0;
	red_freq = 0;
	end

end

////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE //////////////////

endmodule
