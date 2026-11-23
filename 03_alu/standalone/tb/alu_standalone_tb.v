`timescale 1ns/1ps
module ALU_TB;
 reg clk=0;reg [15:0] A=0,B=0;reg [3:0] fun=0;
 wire [15:0] result;wire carry,arith,logic_flag,cmp,shift;
 integer passed=0,failed=0;
 ALU dut(.CLK(clk),.A(A),.B(B),.ALU_FUN(fun),.ALU_OUT(result),.c_flag(carry),
         .arth_flag(arith),.logic_flag(logic_flag),.cmp_flag(cmp),.shift_flag(shift));
 always #5 clk=~clk;
 task check;
  input [3:0] f; input [15:0] a_val,b_val,answer;
  input carry_expected;input [3:0] flags;
  begin
   @(negedge clk);fun=f;A=a_val;B=b_val;
   @(posedge clk);#1;
   if(result===answer && carry===carry_expected && {arith,logic_flag,cmp,shift}===flags)passed=passed+1;
   else begin failed=failed+1;
    $display("FAIL function=%h: got %h carry=%b flags=%b expected %h carry=%b flags=%b",f,result,carry,{arith,logic_flag,cmp,shift},answer,carry_expected,flags);
   end
  end
 endtask
 initial begin
  check(0,10,5,15,0,4'b1000);check(1,10,5,5,0,4'b1000);
  check(2,10,5,50,0,4'b1000);check(3,10,5,2,0,4'b1000);
  check(4,10,5,0,0,4'b0100);check(5,10,5,15,0,4'b0100);
  check(6,10,5,16'hffff,0,4'b0100);check(7,10,5,16'hfff0,0,4'b0100);
  check(8,10,5,15,0,4'b0100);check(9,10,5,16'hfff0,0,4'b0100);
  check(10,10,10,1,0,4'b0010);check(11,20,10,2,0,4'b0010);
  check(12,5,10,3,0,4'b0010);check(13,16,10,8,0,4'b0001);
  check(14,16,10,32,0,4'b0001);check(15,16,10,0,0,4'b0000);
  check(0,16'hffff,1,0,1,4'b1000);check(1,5,10,16'hfffb,1,4'b1000);
  check(3,10,0,0,0,4'b1000);
  $display("STANDALONE ALU: %0d PASS, %0d FAIL",passed,failed);$finish;
 end
endmodule
