`timescale 1ns/1ns
module InstructionMemory(input[11:0] address, input[18:0] data, input read_write, output reg[18:0] instruction);
  reg[18:0] instructions[4095:0];
  always @(read_write, address) begin
    if(read_write)
      instructions[address] = data;
    else
      instruction = instructions[address];
  end
endmodule

