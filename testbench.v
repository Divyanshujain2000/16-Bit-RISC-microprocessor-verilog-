`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:05:42 05/24/2020 
// Design Name: 
// Module Name:    testbench 
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
module testbench;
reg clk1,clk2;
wire hlt;
integer i=0;
microproc DUT(clk1,clk2,hlt);

initial
begin
	for(i=0;i<127;i=i+1)
	$display($time," data[%d]=%b ",i,DUT.DATA_BANK.memD[i]);
end


always
begin
	#10 clk1=0; #10 clk1=1;
	#10 clk2=0; #10 clk2=1;
end

initial
begin
	$monitor($time," ,PC=%d ,IR=%h ,command=%b ,(E,AC)=%b%b ",DUT.PC,DUT.FD_IR,DUT.DE_command,DUT.E,DUT.AC);
end
initial
begin
	#1000;
	for(i=0;i<127;i=i+1)
	$display($time," data[%d]=%b ",i,DUT.DATA_BANK.memD[i]);
end

endmodule
