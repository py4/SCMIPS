//MASK operation is still left
// in datapath: take care of extending shift value as B input

`timescale 1ns/1ns
module ALU(input signed [7:0] A, [7:0] B, input carry_in, is_shift, input[1:0] scode, [2:0] acode, output [7:0] R, output zero, carry_out);
  reg [8:0] temp;
  
  always @(A, B, acode) begin
    case(is_shift)
      1'b0: begin
        case(acode)
          3'b000: temp = A + B;
          3'b001: temp = A + B + carry_in; 
          3'b010: temp = A - B;
          3'b011: temp = A - B + carry_in;
          3'b100: temp = A & B;
          3'b110: temp = A ^ B;
        endcase
        R = temp[7:0];
        carry_out = temp[8];
      end
      1'b1: 
        if(B == 8'b0)
          R = A;
        else
          case(scode)
            2'b00: R = A <<< B;
            2'b01: R = A >>> B;
            2'b10: R = {A[7-B:0], A[7:7-B+1]};
            2'b11: R = {A[7:7-B+1], A[7-B:0]};
          endcase
    endcase
    zero = (R == 8'b0);
  end


endmodule
