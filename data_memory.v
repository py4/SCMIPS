`timescale 1ns/1ns
module DataMemory(input[7:0] address, input[7:0] write_data, input read_write, clk, output reg[7:0] read_data);

  reg[7:0] data[255:0];
  always @(address, read_write, posedge clk) begin
    if(read_write == 0) read_data = data[address];
    else if(clk) begin 
      data[address] = write_data;
      $display("writing %d to %b", write_data, address);
    end
  end

endmodule
