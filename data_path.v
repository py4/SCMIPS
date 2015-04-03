// take care of reg and wire, specially zero and carry and carry_out
`timescale 1ns/1ns
module MIPSDataPath(input reg2_read_source, branch, mem_read_write, mem_or_alu, is_shift, alu_src, reg_read_write, stack_push, stack_pop, clk, input [1:0] pc_src, input [1:0] scode, input [2:0] acode, output zero, stack_overflow, output reg carry, output [18:0] instruction);

  reg[11:0] pc = 12'b0;
  wire[7:0] reg_out_1, reg_out_2;
  wire alu_carry_out;
  wire[7:0] alu_result, data_memory_out;
  wire[11:0] stack_out;

  always @(posedge clk) begin
    carry = alu_carry_out;
    case(pc_src)
      2'b00: pc = pc + 1;
      2'b01: pc = instruction[11:0];
      2'b10: pc = stack_out;
      2'b11: pc = pc + 1 + {{4{instruction[7]}},instruction[7:0]};
    endcase
  end

  InstructionMemory instruction_memory(pc, instruction);

  RegisterFile register_file(instruction[10:8], reg2_read_source ? instructions[13:11] : instructions[7:5], instruction[13:11],reg_read_write, clk, mem_or_alu ? data_memory_out : alu_result, reg_out_1, reg_out_2);

  ALU alu(reg_out_1, (alu_src ? instruction[7:0] : (is_shift ? {5'b0,instruction[7:5]} : reg_out_2)), carry, is_shift, scode, acode, alu_result, zero, alu_carry_out);

  DataMemory data_memory(alu_result, reg_out_2, mem_read_write, clk, data_memory_out);

  Stack stack(stack_push, stack_pop, clk, pc + {11'b0,1'b1}, stack_overflow, stack_out);

endmodule
