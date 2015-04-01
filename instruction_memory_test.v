`timescale 1ns/1ns
module InstructionMemoryTest;

  reg[1:0] temp1 = 2'b01;
  reg[1:0] temp2 = 2'b10;

  reg[11:0] address = 12'b0;
  reg[18:0] data;
  reg read_write = 1;
  wire[18:0] instruction;

  InstructionMemory inst_memory(address, data, read_write, instruction);

  initial begin
    $dumpfile("InstructionMemoryTest.vcd");
    $dumpvars(0, InstructionMemoryTest);

    forever begin

      #10;

      temp1 = ~temp1;
      temp2 = ~temp2;

      data = {15'b0, temp1, temp2};
      address = address + 1;

      if(address == 12'b000000001010) begin
        if(read_write == 0) #5 $stop;

        read_write = 0;
        address = 0;
      end

    end
    
  end
  
endmodule
