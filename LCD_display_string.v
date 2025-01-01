module LCD_display_string(clk, rst, ID_data, index, out);
	input 			  	clk, rst;
	input 		[4:0]	index;
	input 		[255:0] ID_data;
	output reg 	[7:0]	out;	

	reg [7:0] displayreg [31:0];
	

	always@(posedge clk)begin
		
		displayreg[0] 	<= ID_data[127:120];
		displayreg[1] 	<= ID_data[119:112];
		displayreg[2] 	<= ID_data[111:104]; 
		displayreg[3] 	<= ID_data[103: 96];
		displayreg[4] 	<= ID_data[ 95: 88];
		displayreg[5] 	<= ID_data[ 87: 80];
		displayreg[6] 	<= ID_data[ 79: 72];
		displayreg[7] 	<= ID_data[ 71: 64];
		displayreg[8] 	<= ID_data[ 63: 56];
		displayreg[9] 	<= ID_data[ 55: 48];
		displayreg[10] 	<= ID_data[ 47: 40];
		displayreg[11] 	<= ID_data[ 39: 32]; 
		displayreg[12] 	<= ID_data[ 31: 24];
		displayreg[13] 	<= ID_data[ 23: 16];
		displayreg[14] 	<= ID_data[ 15:  8];
		displayreg[15] 	<= ID_data[  7:  0];

			// Line 2
		displayreg[16] 	<= ID_data[255:248];	
		displayreg[17] 	<= ID_data[247:240];
		displayreg[18] 	<= ID_data[239:232]; 
		displayreg[19] 	<= ID_data[231:224];
		displayreg[20] 	<= ID_data[223:216];
		displayreg[21] 	<= ID_data[215:208];
		displayreg[22] 	<= ID_data[207:200];
		displayreg[23] 	<= ID_data[199:192];
		displayreg[24] 	<= ID_data[191:184];
		displayreg[25] 	<= ID_data[183:176];
		displayreg[26] 	<= ID_data[175:168];
		displayreg[27] 	<= ID_data[167:160]; 
		displayreg[28] 	<= ID_data[159:152];
		displayreg[29] 	<= ID_data[151:144];
		displayreg[30] 	<= ID_data[143:136];
		displayreg[31] 	<= ID_data[135:128];			
	end
	always@(*)begin
		out = displayreg[index];
	end
			 
endmodule