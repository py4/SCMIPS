// take care of reg and wire, specially zero and carry and carry_out
`timescale 1ns/1ns
module DataPath(input reg2_read_source, mem_read_write, mem_or_alu, input is_shift, input alu_src, update_z_c, reg_write_signal, stack_push, stack_pop, clk, input [1:0] pc_src, input [1:0] scode, input [2:0] acode, output zero, stack_overflow, output reg carry, output [18:0] instruction);

  reg start_loading_pc = 0;
  reg[11:0] pc = 12'b0;
  wire[7:0] reg_out_1, reg_out_2;
  wire alu_carry_out;
  wire[7:0] alu_result, data_memory_out;
  wire[11:0] stack_out;
  reg x; 
  
  always @(posedge clk) begin
    $display("");
    $display("$$$$$$$$ DATA PATH $$$$$$$$$");
    //$display("[data_path] reg2_read_source: %b", reg2_read_source); 
    //$display("[data_path] 13:11:  %b", instruction[13:11]);
    //$display("[data_path] 7:5:  %b", instruction[7:5]);
    //$display("[data_path] mem_or_alu:  %b", mem_or_alu);
    //$display("[data_path] data_memory_out:  %b", data_memory_out);
    //$display("[data_path] alu_result:  %b", alu_result); 
    $display("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
    $display("");

    carry = alu_carry_out;
    //if(start_loading_pc)
      case(pc_src)
        2'b00: pc = pc + 1;
        2'b01: pc = instruction[11:0];
        2'b10: pc = stack_out;
        2'b11: pc = pc + 1 + {{4{instruction[7]}},instruction[7:0]};
      endcase
    //else
    //  start_loading_pc = 1;
  end

  always @(reg_out_1) begin
    $display("reg_out_1:  %b", reg_out_1);
  end

  InstructionMemory instruction_memory(pc, instruction);

  RegisterFile register_file(instruction[10:8], reg2_read_source ? instruction[13:11] : instruction[7:5], instruction[13:11],reg_write_signal, clk, mem_or_alu ? alu_result : data_memory_out, reg_out_1, reg_out_2);
  
  ALU alu(reg_out_1, (alu_src ? instruction[7:0] : ( is_shift ? {5'b0,instruction[7:5]} : reg_out_2)), carry, is_shift, update_z_c, scode, acode, alu_result, zero, alu_carry_out);

  DataMemory data_memory(alu_result, reg_out_2, mem_read_write, clk, data_memory_out);

  Stack stack(stack_push, stack_pop, clk, pc + {11'b0,1'b1}, stack_overflow, stack_out);

endmodule
