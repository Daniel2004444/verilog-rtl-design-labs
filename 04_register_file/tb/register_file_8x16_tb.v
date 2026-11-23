`timescale 1ns/1ps
module register_file_8x16_tb;
 reg clk=0,rst=1,wren=0,rden=0;
 reg [2:0] address=0;
 reg [15:0] wrdata=0;
 wire [15:0] rdata;
 integer i,passed=0,failed=0;
 reg [15:0] expected[0:7];
 reg_8x16 dut(.clk(clk),.rst(rst),.wren(wren),.rden(rden),.address(address),.wrdata(wrdata),.rdata(rdata));
 always #5 clk=~clk;
 task write_word;
  input [2:0] addr; input [15:0] val;
  begin @(negedge clk);address=addr;wrdata=val;wren=1;rden=0;@(posedge clk);#1;end
 endtask
 task check_read;
  input [2:0] addr;input [15:0] val;
  begin @(negedge clk);address=addr;wren=0;rden=1;@(posedge clk);#1;
   if(rdata===val)passed=passed+1;
   else begin failed=failed+1;$display("FAIL register %0d: got=%h expected=%h",addr,rdata,val);end
  end
 endtask
 initial begin
  #2 rst=0;#1;
  if(rdata===16'h0000)passed=passed+1;
  else begin failed=failed+1;$display("FAIL reset output");end
  @(negedge clk);rst=1;
  for(i=0;i<8;i=i+1)begin expected[i]=16'hA500+i;write_word(i[2:0],expected[i]);end
  for(i=0;i<8;i=i+1)check_read(i[2:0],expected[i]);
  @(negedge clk);address=2;wrdata=16'hDEAD;wren=1;rden=1;
  @(posedge clk);#1;
  check_read(2,expected[2]);
  @(negedge clk);wren=0;rden=0;address=7;
  @(posedge clk);#1;
  if(rdata===expected[2])passed=passed+1;
  else begin failed=failed+1;$display("FAIL output hold");end
  @(negedge clk);rst=0;#1;
  if(rdata===0)passed=passed+1;
  else begin failed=failed+1;$display("FAIL asynchronous reset");end
  @(negedge clk);rst=1;
  for(i=0;i<8;i=i+1)check_read(i[2:0],16'h0000);
  $display("REGISTER FILE: %0d PASS, %0d FAIL",passed,failed);$finish;
 end
endmodule
