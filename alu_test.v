`timescale 1ns/1ns

module ALUTest;
  
  reg signed [7:0] A = 8'b11100101;
  reg [7:0] B = 8'b00000111;
  reg carry_in = 1, is_shift = 0, clk = 0;
  reg[1:0] scode = 2'b00;
  reg[2:0] acode = 3'b000;

  wire zero, carry_out;
  wire[7:0] R;

  
  initial begin
    B = 8'b11000111;
    $dumpfile("ALUTest.vcd");
    $dumpvars(0, ALUTest);
    forever begin
      #10 clk = ~clk;
      if(acode == 3'b111) begin
        #5 $stop;
      end
      acode = acode + 1;
    end
  end

  ALU alu(A, B, carry_in, is_shift, scode, acode, R, zero, carry_out);

  always @(A, B, carry_in, acode, R, zero, carry_out) begin
    $display("");
      $display("A:  %b , B:  %b", A , B);
      $display("acode:  %b", acode);
      $display("R:  %b", R);
      $display("zero:  %b, carry_out:  %b", zero, carry_out);
    $display("");
  end

endmodule
