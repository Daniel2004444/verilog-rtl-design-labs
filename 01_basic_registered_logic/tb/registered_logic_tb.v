`timescale 1ns/1ps
module registered_logic_tb;
 reg clk=0,in1=0,in2=0,in3=0,in4=0;
 wire out1,out2,out3;
 reg [3:0] vec;
 reg [2:0] expected;
 integer i,passed=0,failed=0;
 DigCt dut (.CLK(clk),.IN1(in1),.IN2(in2),.IN3(in3),.IN4(in4),.OUT1(out1),.OUT2(out2),.OUT3(out3));
 always #5 clk=~clk;
 initial begin
  for(i=0;i<16;i=i+1) begin
   @(negedge clk);vec=i;{in1,in2,in3,in4}=vec;
   expected={~(vec[3]|vec[2]),~(vec[2]&vec[1]),(vec[1]|vec[0])};
   @(posedge clk);#1;
   if({out1,out2,out3}===expected)passed=passed+1;
   else begin failed=failed+1;$display("FAIL input=%b got=%b expected=%b",vec,{out1,out2,out3},expected);end
  end
  $display("REGISTERED LOGIC: %0d/16 PASS, %0d FAIL",passed,failed);$finish;
 end
endmodule
