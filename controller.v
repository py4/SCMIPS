`timescale 1ns/1ns
module Controller(input zero, carry, clk, input[18:0] instruction, output reg reg2_read_source, mem_read_write, mem_or_alu, is_shift, alu_src, reg_read_write, stack_push, stack_pop, output reg [1:0] pc_src, output reg [1:0] scode, output reg [2:0] acode);

  always @(posedge clk) begin
    reg2_read_source = 0; mem_read_write = 0; mem_or_alu = 0; is_shift = 0;
    alu_src = 0; reg_read_write = 0; stack_push = 0; stack_pop = 0; pc_src = 2'b0; scode = 2'b0; acode = 3'b0;

    if(instruction[18:17] == 2'b00) begin
      acode = instruction[16:14];
      mem_or_alu = 1;
      reg_read_write = 1;
    end
    
    if(instruction[18:17] == 2'b01) begin
      acode = instruction[16:14];
      alu_src = 1;
      mem_or_alu = 1;
      reg_read_write = 1;
    end

    if(instruction[18:16] == 3'b110) begin
      scode = instruction[15:14];
      is_shift = 1;
      mem_or_alu = 1;
      reg_read_write = 1;
    end

    if(instruction[18:16] == 3'b100) begin
      reg2_read_source = 1;
      mem_or_alu = 0;
      alu_src = 1;
      if(instruction[15:14] == 2'b0) begin //load
        mem_read_write = 0;
        reg_read_write = 1;
      end else if(instruction[15:14] == 2'b01) begin // store
        mem_read_write = 1;
        reg_read_write = 0;
      end
    end

    if(instruction[18:16] == 3'b101) begin
      case(instruction[15:14])
        2'b00: pc_src = zero == 1 ? 2'b1 : 2'b0;
        2'b01: pc_src = zero == 0 ? 2'b1 : 2'b0;
        2'b10: pc_src = carry == 1 ? 2'b1 : 2'b0;
        2'b11: pc_src = carry == 0 ? 2'b1 : 2'b0;
      endcase
    end

    if(instruction[18:15] == 4'b1110) begin // jump without condition
      pc_src = 2'b01; //jmp
      if(instruction[14] == 1) stack_push = 1; // jsb
    end

    if(instruction[18:13] == 6'b111100) begin // ret
      pc_src = 2'b10;
      stack_pop = 1;
    end
  end

endmodule

