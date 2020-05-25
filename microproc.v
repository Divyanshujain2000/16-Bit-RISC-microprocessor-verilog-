`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:06:20 05/23/2020 
// Design Name: 
// Module Name:    microproc 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module microproc(
    input clk1,
    input clk2,
	 output hlt
    );
assign hlt=halted; //for debuging can be reoved afterwards
wire [11:0] presentINSTR; //go into IR
reg halted,skip;
reg [6:0] PC;
instrREG INSTR_BANK(presentINSTR,PC);

wire [15:0] data1,data2;
reg [15:0] data_in;
reg [6:0] adr1,adr2,adrw;
reg write;
dataREG DATA_BANK(data1,data2,1'b1,1'b1,adr1,adr2,data_in,write,adrw,clk1);

//fetch
reg [11:0] IR;
reg [11:0] FD_IR;
reg [6:0] FD_ADR;

//decode
reg [4:0] DE_command;
reg [6:0] DE_adr;
reg [6:0] adr;
reg [15:0] DE_temp;
parameter CLA=4'h0,
			 CLE=4'h1,
			 CMA=4'h2,
			 CME=4'h3,
			 CIR=4'h4,
			 CIL=4'h5,
			 INC=4'h6,
			 SPA=4'h7,
			 SNA=4'h8,
			 SZA=4'h9,
			 SZE=4'ha,
			 HLT=4'hb,
			 AND=4'h0, // used same value but dosnt matter right now as we will first check the higher bit to determine the type RR or MR
			 OR=4'h1,
			 XOR=4'h2,
			 ADD=4'h3,
			 SUB=4'h4,
			 LDA=4'h5,
			 STA=4'h6,
			 ISZ=4'h7;

//execute
reg [15:0] AC;
reg E;
initial begin PC=0; /*presentINSTR=0;*/ halted=0; end
//fetch
always@(posedge clk1)
if(halted==0)
begin
	FD_IR=presentINSTR; //fetchinf from regbank
	adr1=FD_IR[6:0];    //address for prefench in case of indirect
	#2	FD_ADR=data1[6:0];
		PC=PC+7'b0000001; //increment pc
end
//decode
always@(posedge clk2)
if(halted==0)
begin
	#2 adr2=(FD_IR[11])?FD_ADR:FD_IR[6:0]; //if direct then adress from instuction code else from feched agin
	DE_temp=data2;				//data from dataregbank on which memory operation is to be performed
	DE_adr=adr2;				
	
	if(FD_IR[10:7]==4'b1111) //register refernce
	DE_command={1'b1,FD_IR[3:0]};							//creting a common command for both reg ref and meme ref
	else 						//memory refernce
	DE_command={1'b0,FD_IR[10:7]};	
end	
//execute
always@(posedge clk1)
if(halted==0)
begin
if(skip==0)			//if skiped from spa sna sza sze or isz
 begin
	if(write==1) write=0; //if previously written to memory
	
	if(DE_command[4]==1)
	case(DE_command[3:0])
	CLA:	AC=0;
	CLE:	E=0;
	CMA:	AC=~AC;
	CME:	E=~E;
	CIR:	{E,AC}={AC[0],E,AC[14:0]};
	CIL:	{E,AC}={AC,E};
	INC:	AC=AC+16'h0001;
	SPA:  if(AC[15]==0) skip=1;
	SNA:	if(AC[15]==1) skip=1;
	SZA:  if(AC==0) skip=1;
	SZE:  if(E==0) skip=1;
	HLT:	halted=1;
	endcase
	else
	case(DE_command[3:0])
	AND:	AC=AC & DE_temp;
	OR:	AC=AC | DE_temp;
	XOR:	AC=AC ^ DE_temp;
	ADD:	{E,AC}=AC + DE_temp;
	SUB:	AC=AC -(DE_temp);
	LDA:	AC=DE_temp;
	STA:	begin	data_in=AC; adrw=DE_adr; write=1; end
	ISZ:	begin AC=DE_temp+16'h0001; data_in=AC; adrw=DE_adr; write=1; if(AC==0) skip=1; end
	endcase
 end
else #4 skip=0; //else of skip command to reset skip bit to continue next instruction
end // end of non-halted begin
endmodule
