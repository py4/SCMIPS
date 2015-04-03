`timescale 1ns/1ns
module RegisterFile(input[2:0] reg_read_1, input [2:0] reg_read_2, input [2:0] reg_write, input read_write, clk, input[7:0] in_data, output reg [7:0] out_data_1, output reg [7:0] out_data_2);
  
  reg[7:0] registers[7:0];
  always @(reg_read_1, reg_read_2, reg_write, read_write, in_data, posedge clk) begin
    if(read_write == 0) begin
      out_data_1 = registers[reg_read_1];
      out_data_2 = registers[reg_read_2];
    end else if(clk) begin
      registers[reg_write] = in_data;
    end
  end
  
endmodule
