`timescale 1ns/1ns
module MIPSCPU(input clk, rst, output zero, carry, stack_overflow);
  wire reg2_read_source, mem_read_write, mem_or_alu;
  wire is_shift;
  wire alu_src, update_z_c, reg_read_write, stack_pushs, stack_pop;
  wire [1:0] pc_src, scode;
  wire [2:0] acode;
  wire [18:0] instruction;

  DataPath data_path(reg2_read_source, mem_read_write, mem_or_alu, is_shift, alu_src, update_z_c, reg_read_write, stack_push, stack_pop, clk, pc_src, scode, acode, zero, stack_overflow, carry, instruction);

  Controller controller(zero, carry, clk, instruction, reg2_read_source, mem_read_write, mem_or_alu, is_shift, alu_src, update_z_c, reg_read_write, stack_push, stack_pop, pc_src, scode, acode);

endmodule
