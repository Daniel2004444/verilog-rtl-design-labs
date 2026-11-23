`timescale 1ns/1ps
module down_counter_tb;
 reg clk=0,latch=0,dec=0;
 reg [3:0] data_in=0;
 wire [3:0] count;
 wire zero;
 integer passed=0,failed=0,i;
 Down_Counter dut(.clock(clk),.in(data_in),.latch(latch),.dec(dec),.counter(count),.zero(zero));
 always #5 clk=~clk;
 task check_cycle;
  input ld,de;input [3:0] val,expected;
  begin
   @(negedge clk);latch=ld;dec=de;data_in=val;
   @(posedge clk);#1;
   if(count===expected && zero===(expected==0))passed=passed+1;
   else begin failed=failed+1;$display("FAIL count=%d zero=%b expected=%d",count,zero,expected);end
  end
 endtask
 initial begin
  check_cycle(1,0,10,10);
  check_cycle(0,0,0,10);
  check_cycle(1,1,10,10);
  check_cycle(0,1,0,9);
  for(i=8;i>=0;i=i-1)check_cycle(0,1,0,i[3:0]);
  check_cycle(0,1,0,0);
  check_cycle(1,0,15,15);
  check_cycle(0,1,0,14);
  $display("DOWN COUNTER: %0d PASS, %0d FAIL",passed,failed);$finish;
 end
endmodule
