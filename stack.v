`timescale 1ns/1ns
module Stack(input push_sig, pop_sig, clk, input[11:0] push_data, output reg overflow, output reg [11:0] pop_data);

  reg[11:0] data[7:0];
  reg[3:0] stack_pointer = 4'b0;
  always @(posedge clk) begin
    if(push_sig == 1) begin
      if(stack_pointer == 4'b1000) begin
        overflow = 1;
      end else begin
        data[stack_pointer] = push_data;
        stack_pointer = stack_pointer + 1;
      end
    end else if(pop_sig == 1) begin
      if(stack_pointer != 4'b0) begin
        pop_data = data[stack_pointer - 1];
        stack_pointer = stack_pointer - 1;
      end
    end
  end
  
endmodule
