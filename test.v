module test(clk, rst, IRDA_RXD, LCD_DATA, LCD_EN, LCD_RW, LCD_RS, LED,KEY,SW);
    input               clk, rst;
    input               IRDA_RXD;
    inout       [7:0]   LCD_DATA;
	 input 	     [2:0] KEY;
	 input [17:0]SW;
	 output  reg         LCD_EN, LCD_RS, LCD_RW;
    output  reg [17:0]   LED;
	
/////////////////////////////////////////////////////
//                                                 //
//                       DIV                       //
//                                                 //
/////////////////////////////////////////////////////

    wire            clk400;
    div400 	div_400HZ(.clk50M(clk), .rst(rst), .clk400(clk400));

/////////////////////////////////////////////////////
//                                                 //
//                       IR                        //
//                                                 //
/////////////////////////////////////////////////////

////////////////////////DONT MOVE///////////////////////
    wire            IR_READY;
    wire    [31:0]  IR_DATA;

    IR_RECEIVE IR(  .iCLK(clk), .iRST_n(rst),
                    .iIRDA(IRDA_RXD), .oDATA_READY(IR_READY), .oDATA(IR_DATA));
////////////////////////////////////////////////////

    always @(negedge IR_READY or negedge rst)begin
        if (!rst)begin
            LED <= 8'd1;
        end
        else begin
            case(IR_DATA[23:16])
                8'h14 : LED <= (LED[7] == 1'd1) ? {{7{1'd0}}, 1'd1} : LED << 1;
                8'h18 : LED <= (LED[0] == 1'd1) ? {1'd1, {7{1'd0}}} : LED >> 1;
            endcase
        end
    end

/////////////////////////////////////////////////////
//                                                 //
//                       LCD                       //
//                                                 //
/////////////////////////////////////////////////////

////////////////////////DONT MOVE///////////////////////
    reg     [3:0]   	state, next_command;
    reg     [4:0]   	CHAR_COUNT;
    reg 		[7:0] 	DATA_BUS_VALUE;
    reg     [255:0] 	ID_data;
    reg     [127:0] 	num_Data;
    wire    [127:0] 	org_num;
    reg     [127:0] 	crypto_num;
    reg 		[5:0] 	font_addr;
    wire 	[7:0]		font_data;
    wire    [7:0]   	Next_Char;

    assign LCD_DATA = LCD_RW ? 8'bZZZZZZZZ : DATA_BUS_VALUE;

    Custom_font_ROM cr(.addr(font_addr), .out_data(font_data));
    LCD_display_string LCD( .clk(clk), .rst(rst), 
                            .index(CHAR_COUNT), .ID_data(ID_data), .out(Next_Char));
/////////////////////////////////////////////////////

	parameter   space   =   8'h20,
					N       =   8'h4e,
					C       =   8'h43,
					L       =   8'h4c,
					A       =   8'h41,
					B       =   8'h42,
					zero    =   8'h30,
					one     =   8'h31,
					two     =   8'h32,
					three   =   8'h33,
					four    =   8'h34,
					eight   =   8'h38;

	always @(negedge IR_READY or negedge rst)begin
		 if (!rst)begin
				ID_data[127:0] <= {16{space}}; 	  	
				ID_data[255:128] <= {16{space}};   	
 		 end														
		 else begin
			  case (IR_DATA[23:16])
					8'h01 : begin
						 ID_data[127:0] <= {{5{space}}, N, C, L, A, B, space, 8'h00, 8'h01, {3{space}}};
						 ID_data[255:128] <= {16{space}};
					end
					8'h02 : begin
						 ID_data[127:0] <= {16{space}};
						 ID_data[255:128] <= {two, zero, two, four, space, one, one, space, two, eight, {6{space}}};
					end 
			  endcase
		 end
	end

//////////////////////LCD_state//////////////////////
//////////////////////DONT MOVE/////////////////////////
    parameter  RESET 			= 4'd0,
	            DROP_LCD_E 		= 4'd1,
	            HOLD 				= 4'd2,
	            DISPLAY_CLEAR 	= 4'd3,
	            MODE_SET 		= 4'd4,
	            Print_String 	= 4'd5,
	            LINE2 			= 4'd6,
	            RETURN_HOME 	= 4'd7,
	            CG_RAM_HOME 	= 4'd8,
	            write_CG 		= 4'd9;

    always @(posedge clk400 or negedge rst)begin
		if (!rst)begin
			state <= RESET;
		end
		else begin
			case (state)
				RESET : begin  // Set Function to 8-bit transfer and 2 line display with 5x8 Font size
					LCD_EN 			<= 1'b1;
					LCD_RS 			<= 1'b0;
					LCD_RW 			<= 1'b0;
					DATA_BUS_VALUE 	<= 8'h38;
					state 			<= DROP_LCD_E;
					next_command 	<= DISPLAY_CLEAR;
					CHAR_COUNT 		<= 5'b00000;
				end

				// Clear Display (also clear DDRAM content)
				DISPLAY_CLEAR : begin
					LCD_EN 			<= 1'b1;
					LCD_RS 			<= 1'b0;
					LCD_RW 			<= 1'b0;
					DATA_BUS_VALUE 	<= 8'h01;
					state 			<= DROP_LCD_E;
					next_command 	<= MODE_SET;
				end

				// Set write mode to auto increment address and move cursor to the right
				MODE_SET : begin
					LCD_EN 			<= 1'b1;
					LCD_RS 			<= 1'b0;
					LCD_RW 			<= 1'b0;
					DATA_BUS_VALUE 	<= 8'h06;
					state 			<= DROP_LCD_E;
					next_command 	<= CG_RAM_HOME;
				end

				// Write ASCII hex character in first LCD character location
				Print_String : begin
					state 			<= DROP_LCD_E;
					LCD_EN 			<= 1'b1;
					LCD_RS 			<= 1'b1;
					LCD_RW 			<= 1'b0;
					DATA_BUS_VALUE 	<= Next_Char;
					
					// Loop to send out 32 characters to LCD Display  (16 by 2 lines)
					if (CHAR_COUNT < 31)
						CHAR_COUNT <= CHAR_COUNT + 1'b1;
					else
						CHAR_COUNT <= 5'b00000; 

					// Jump to second line?
					if (CHAR_COUNT == 15)
						next_command <= LINE2;
					// Return to first line?
					else if (CHAR_COUNT == 31)
						next_command <= RETURN_HOME;
					else
						next_command <= Print_String;
				end

				// Set write address to line 2 character 1
				LINE2 : begin
					LCD_EN 			<= 1'b1;
					LCD_RS 			<= 1'b0;
					LCD_RW 			<= 1'b0;
					DATA_BUS_VALUE 	<= 8'hC0; //line 2 character 2 ==> 8'hC1
					state 			<= DROP_LCD_E;
					next_command 	<= Print_String;
				end

				// Return write address to first character postion on line 1
				RETURN_HOME : begin
					LCD_EN 			<= 1'b1;
					LCD_RS 			<= 1'b0;
					LCD_RW 			<= 1'b0;
					DATA_BUS_VALUE 	<= 8'h80; //line 1 character 2 ==> 8'h81
					state 			<= DROP_LCD_E;
					next_command 	<= Print_String;
				end
				CG_RAM_HOME : begin
					LCD_EN 			<= 1'b1;
					LCD_RS 			<= 1'b0;
					LCD_RW 			<= 1'b0;
					DATA_BUS_VALUE 	<= 8'h40; //CGRAM begin address = 6'h00
					font_addr		<= 6'd0;//
					state 			<= DROP_LCD_E;
					next_command 	<= write_CG;
				end
				write_CG : begin
					state 			<= DROP_LCD_E;
					LCD_EN 			<= 1'b1;
					LCD_RS 			<= 1'b1;
					LCD_RW 			<= 1'b0;
					DATA_BUS_VALUE 	<= font_data;

					if(font_addr == 6'b111111)begin
						next_command 	<= RETURN_HOME;
					end else begin
						font_addr		<= font_addr + 6'b1;
						next_command 	<= write_CG;
					end
				end

				DROP_LCD_E : begin
					LCD_EN 	<= 1'b0;
					state 	<= HOLD;
				end
				
				HOLD : begin
					state 	<= next_command;
				end
			endcase
		end
	end

////////////////////////////////////////////////////

endmodule
