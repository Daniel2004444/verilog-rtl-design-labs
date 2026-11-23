`timescale 1ns/1ps
module alu_top_selfcheck_tb;
 reg clk=0,rst=0;
 reg signed [15:0] A=0,B=0;
 reg [3:0] ALU_FUN=0;
 wire signed [31:0] a_out;
 wire [15:0] l_out,c_out,s_out;
 wire arith_flag,logic_flag,cmp_flag,shift_flag;
 integer passed=0,failed=0;
 ALU_TOP dut(.clk(clk),.rst(rst),.A(A),.B(B),.ALU_FUN(ALU_FUN),
             .a_out(a_out),.l_out(l_out),.c_out(c_out),.s_out(s_out),
             .arith_flag(arith_flag),.logic_flag(logic_flag),.cmp_flag(cmp_flag),.shift_flag(shift_flag));
 always #5 clk=~clk;
 task check;
  input [3:0] f;input signed [15:0] va,vb;
  input signed [31:0] ea;input [15:0] el,ec,es;input [3:0] ef;
  begin
   @(negedge clk);ALU_FUN=f;A=va;B=vb;
   @(posedge clk);#1;
   if(a_out===ea && l_out===el && c_out===ec && s_out===es &&
      {arith_flag,logic_flag,cmp_flag,shift_flag}===ef)passed=passed+1;
   else begin failed=failed+1;
    $display("FAIL FUN=%b A=%0d B=%0d: actual %0d/%h/%h/%h flag=%b expected %0d/%h/%h/%h flag=%b",
     f,va,vb,a_out,l_out,c_out,s_out,{arith_flag,logic_flag,cmp_flag,shift_flag},ea,el,ec,es,ef);
   end
  end
 endtask
 initial begin
  #2; rst=1;
  check(4'h0, -4, -10, -14, 16'h0000, 16'h0000, 16'h0000, 4'b1000);
  check(4'h0, 10, -4, 6, 16'h0000, 16'h0000, 16'h0000, 4'b1000);
  check(4'h0, -4, 10, 6, 16'h0000, 16'h0000, 16'h0000, 4'b1000);
  check(4'h0, 10, 4, 14, 16'h0000, 16'h0000, 16'h0000, 4'b1000);
  check(4'h1, -4, -10, 6, 16'h0000, 16'h0000, 16'h0000, 4'b1000);
  check(4'h1, 10, -4, 14, 16'h0000, 16'h0000, 16'h0000, 4'b1000);
  check(4'h1, -4, 10, -14, 16'h0000, 16'h0000, 16'h0000, 4'b1000);
  check(4'h1, 10, 4, 6, 16'h0000, 16'h0000, 16'h0000, 4'b1000);
  check(4'h2, -4, -10, 40, 16'h0000, 16'h0000, 16'h0000, 4'b1000);
  check(4'h2, 10, -4, -40, 16'h0000, 16'h0000, 16'h0000, 4'b1000);
  check(4'h2, -4, 10, -40, 16'h0000, 16'h0000, 16'h0000, 4'b1000);
  check(4'h2, 10, 4, 40, 16'h0000, 16'h0000, 16'h0000, 4'b1000);
  check(4'h3, -20, -4, 5, 16'h0000, 16'h0000, 16'h0000, 4'b1000);
  check(4'h3, 20, -4, -5, 16'h0000, 16'h0000, 16'h0000, 4'b1000);
  check(4'h3, -20, 4, -5, 16'h0000, 16'h0000, 16'h0000, 4'b1000);
  check(4'h3, 20, 4, 5, 16'h0000, 16'h0000, 16'h0000, 4'b1000);
  check(4'h4, 243, 15, 0, 16'h0003, 16'h0000, 16'h0000, 4'b0100);
  check(4'h5, 243, 15, 0, 16'h00ff, 16'h0000, 16'h0000, 4'b0100);
  check(4'h6, 243, 15, 0, 16'hfffc, 16'h0000, 16'h0000, 4'b0100);
  check(4'h7, 243, 15, 0, 16'hff00, 16'h0000, 16'h0000, 4'b0100);
  check(4'h8, 7, 3, 0, 16'h0000, 16'h0000, 16'h0000, 4'b0010);
  check(4'h9, 7, 7, 0, 16'h0000, 16'h0001, 16'h0000, 4'b0010);
  check(4'ha, 7, 3, 0, 16'h0000, 16'h0002, 16'h0000, 4'b0010);
  check(4'hb, 3, 7, 0, 16'h0000, 16'h0003, 16'h0000, 4'b0010);
  check(4'hc, 8, 4, 0, 16'h0000, 16'h0000, 16'h0004, 4'b0001);
  check(4'hd, 8, 4, 0, 16'h0000, 16'h0000, 16'h0010, 4'b0001);
  check(4'he, 8, 4, 0, 16'h0000, 16'h0000, 16'h0002, 4'b0001);
  check(4'hf, 8, 4, 0, 16'h0000, 16'h0000, 16'h0008, 4'b0001);
  check(4'h3, 15, 0, 0, 16'h0000, 16'h0000, 16'h0000, 4'b1000);
  $display("MODULAR ALU: %0d/29 PASS, %0d FAIL",passed,failed);$finish;
 end
endmodule
