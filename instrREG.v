`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:32:28 05/23/2020 
// Design Name: 
// Module Name:    instrREG 
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
module instrREG(
    data_out,
    adr
    );
input [6:0] adr;
output [11:0] data_out; 
reg [11:0] mem [127:0];
assign data_out=mem[adr];

//initializing memory
initial 
	begin
$readmemb("instr_bank.mem",mem);
	end

endmodule
