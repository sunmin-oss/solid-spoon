module Custom_font_ROM(addr, out_data);
	input 	[5:0] addr;//8*8
	output 	[7:0] out_data;

	wire 	[7:0] data[63:0];

	assign out_data = data[addr];
    //8*5  can change
	//00
	assign data[00] = 8'b000_01100;
	assign data[01] = 8'b000_01100;
	assign data[02] = 8'b000_00000;
	assign data[03] = 8'b000_00001;
	assign data[04] = 8'b000_10000;
	assign data[05] = 8'b000_11000;
	assign data[06] = 8'b000_00110;
	assign data[07] = 8'b000_00011;
	//01
	assign data[08] = 8'b000_00110;
	assign data[09] = 8'b000_00110;
	assign data[10] = 8'b000_00000;
	assign data[11] = 8'b000_10000;
	assign data[12] = 8'b000_0001;
	assign data[13] = 8'b000_00011;
	assign data[14] = 8'b000_01100;
	assign data[15] = 8'b000_11000;
	//2
	assign data[16] = 8'b000_10000;
	assign data[17] = 8'b000_11000;
	assign data[18] = 8'b000_00110;
	assign data[19] = 8'b000_00001;
	assign data[20] = 8'b000_00000;
	assign data[21] = 8'b000_00000;
	assign data[22] = 8'b000_00000;
	assign data[23] = 8'b000_00000;
	//3
	assign data[24] = 8'b000_00001;
	assign data[25] = 8'b000_00011;
	assign data[26] = 8'b000_01100;
	assign data[27] = 8'b000_10000;
	assign data[28] = 8'b000_00000;
	assign data[29] = 8'b000_00000;
	assign data[30] = 8'b000_00000;
	assign data[31] = 8'b000_00000;
	//4
	assign data[32] = 8'b000_00000;
	assign data[33] = 8'b000_00000;
	assign data[34] = 8'b000_00000;
	assign data[35] = 8'b000_00000;
	assign data[36] = 8'b000_00000;
	assign data[37] = 8'b000_00000;
	assign data[38] = 8'b000_00000;
	assign data[39] = 8'b000_00000;
	//5
	assign data[40] = 8'b000_00000;
	assign data[41] = 8'b000_00000;
	assign data[42] = 8'b000_00000;
	assign data[43] = 8'b000_00000;
	assign data[44] = 8'b000_00000;
	assign data[45] = 8'b000_00000;
	assign data[46] = 8'b000_00000;
	assign data[47] = 8'b000_00000;
	//6
	assign data[48] = 8'b000_00000;
	assign data[49] = 8'b000_00000;
	assign data[50] = 8'b000_00000;
	assign data[51] = 8'b000_00000;
	assign data[52] = 8'b000_00000;
	assign data[53] = 8'b000_00000;
	assign data[54] = 8'b000_00000;
	assign data[55] = 8'b000_00000;
	//7
	assign data[56] = 8'b000_00000;
	assign data[57] = 8'b000_00000;
	assign data[58] = 8'b000_00000;
	assign data[59] = 8'b000_00000;
	assign data[60] = 8'b000_00000;
	assign data[61] = 8'b000_00000;
	assign data[62] = 8'b000_00000;
	assign data[63] = 8'b000_00000;
endmodule