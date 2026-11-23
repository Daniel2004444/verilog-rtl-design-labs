`timescale 1ns/1ps
module down_counter_ass2;
 reg clk=0,load=0,up=0,down=0;
 reg [4:0] data_in=0;
 wire [4:0] count;
 wire high,low;
 integer passed=0,failed=0;
 counter_5 dut(.clock(clk),.load(load),.up(up),.down(down),.in(data_in),.count(count),.high(high),.low(low));
 always #5 clk=~clk;
 task check_cycle;
  input ld,up_v,down_v;input [4:0] val,expected;
  begin
   @(negedge clk);load=ld;up=up_v;down=down_v;data_in=val;
   @(posedge clk);#1;
   if(count===expected && high===(expected==31) && low===(expected==0))passed=passed+1;
   else begin failed=failed+1;$display("FAIL count=%0d high=%b low=%b expected=%0d",count,high,low,expected);end
  end
 endtask
 initial begin
  check_cycle(1,0,0,20,20);
  check_cycle(0,0,1,0,19);
  check_cycle(0,1,1,0,18);
  check_cycle(0,1,0,0,19);
  check_cycle(1,0,0,31,31);
  check_cycle(0,1,0,0,31);
  check_cycle(1,0,0,0,0);
  check_cycle(0,0,1,0,0);
  check_cycle(0,1,1,0,0);
  check_cycle(1,1,1,12,12);
  check_cycle(0,0,0,0,12);
  $display("UP/DOWN COUNTER: %0d PASS, %0d FAIL",passed,failed);$finish;
 end
endmodule
