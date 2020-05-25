`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:48:22 05/23/2020 
// Design Name: 
// Module Name:    dataREG 
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
module dataREG(
     data_out1,
     data_out2,
     read1,
     read2,
     adr1,
     adr2,
     data_in,
     write,
     adrW,
	  clk
    );
input clk;
input read1,read2,write;
input [6:0] adr1,adr2,adrW;
input [15:0] data_in;
output [15:0] data_out1,data_out2;
reg [15:0] memD [127:0];

assign data_out1=(read1)?memD[adr1]:16'hzzzz;
assign data_out2=(read2)?memD[adr2]:16'hzzzz;
//initializing memory
initial 
	begin
$readmemh("data_bank.mem",memD);
	end

always@(negedge clk)
begin
	if(write==1) memD[adrW]=data_in;
end
endmodule
