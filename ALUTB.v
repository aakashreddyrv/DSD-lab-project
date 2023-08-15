`timescale 1ns/1ns

module ALU_processor_tb();
parameter N = 32;

reg[3:0] opcode;
reg[N-1:0] op1, op2;
wire[N-1:0] out;
wire[3:0] ALU_flag_NZCV;
wire[3:0] old_ALU_flag_NZCV = 4'b0000;


//reg [N-1:0]temp;
ALU_processor alu1(opcode, op1, op2, out, old_ALU_flag_NZCV, ALU_flag_NZCV); 

initial begin
    $dumpfile("ALU.vcd");
    $dumpvars();
end

initial begin
	
	opcode = 4'd0;
	op1 = 32'b11001001110010011100100111001001;
	op2 = 32'b10100011101000111010001110100011;
	#100
	$display("%b & %b = %b , NZCV:%b", op1, op2, out, ALU_flag_NZCV);
	//Expected output=10000001100000011000000110000001
    
	opcode = 4'd1;
	op1 = 32'b11001001110010011100100111001001;
	op2 = 32'b10100011101000111010001110100011;#100 
	$display("%b ^ %b = %b , NZCV:%b", op1, op2, out, ALU_flag_NZCV);
	//Expected output=01101010011010100110101001101010

    opcode = 4'd2;
	op1 = 32'b11001001110010011100100111001001;
	op2 = 32'b10100011101000111010001110100011;	#100 
	$display("%b | %b = %b , NZCV : %b", op1, op2, out, ALU_flag_NZCV);
	//Expected output=11101011111010111110101111101011
	
    opcode = 4'd3;
	op1 = 32'b11001001110010011100100111001001;
	op2 = 32'b10100011101000111010001110100011;#100 
	$display("%b NOR %b = %b , NZCV : %b", op1, op2, out, ALU_flag_NZCV);
    //Expected output=00010100000101000001010000010100
	
	 
    opcode = 4'd4;
	op1 = 32'b11001001110010011100100111001001;
	op2 = 32'b10100011101000111010001110100011;#100
	$display("%b BIC %b = %b , NZCV : %b", op1, op2, out, ALU_flag_NZCV);
	//Expected output=01001000010010000100100001001000
	
	opcode = 4'd5;
	op1 = 32'd1234;
	op2 = 32'd1234;#100
	$display("%0d + %0d = %0d , NZCV : %b", op1, op2, out, ALU_flag_NZCV);
	//Expected output=2468
	
	opcode = 4'd6;
	op1 = 32'd1234;
	op2 = 32'd5678;#100
	$display("%0d +c %0d = %0d , NZCV : %b", op1, op2, out, ALU_flag_NZCV);
	//Expected output 6912
	
	opcode = 4'd7;
	op1 = 32'd1234;
	op2 = 32'd1234;#100
	$display("%0d - %0d = %0d , NZCV : %b", op1, op2, out, ALU_flag_NZCV);
	//Expected output=0
	
	opcode = 4'd8;
	op1 = 32'd1234;
	op2 = 32'd1233;#100
	$display("%0d -c %0d = %0d , NZCV : %b", op1, op2, out, ALU_flag_NZCV);
	//Expected output=1, but in sbc operation output will be=0
	
	opcode = 4'd9;
	op1 = 32'd1234;
	op2 = 32'd5678;#100
	$display("%0d - %0d = %0d , NZCV : %b", op2, op1, out, ALU_flag_NZCV);
    //Expected output=4444
	
	
	opcode = 4'd10;
	op1 = 32'd1234;
	op2 = 32'd5678;#100
	$display("%0d -c %0d = %0d , NZCV : %b", op2, op1, out, ALU_flag_NZCV);
	//Expected output=4443
	
	opcode = 4'd11;
	op1 = 32'd1234;
	op2 = 32'd5678;#100
	$display("%0d teq %0d = %0d , NZCV : %b", op1, op2, out, ALU_flag_NZCV);
	//Expected output= not 0(not same)
	
	opcode = 4'd12;
	op1 = 32'd9999;
	op2 = 32'd1111;#100
	$display("%0d cmp %0d = %0d , NZCV : %b", op1, op2, out, ALU_flag_NZCV);
	//Expected output=8888
	
	opcode = 4'd13;
	op1 = 32'd1234;
	op2 = 32'd5678;#100
	$display("%0d cmn %0d = %0d , NZCV : %b", op1, op2, out, ALU_flag_NZCV);
	//Expected output=6912
	
	opcode = 4'd14;
	op1 = 32'd1234;
	op2 = 32'd5678;#100
	$display("%0d mov  %0d = %0d , NZCV : %b", op1, op2, out, ALU_flag_NZCV);
	//Expected output=5678
    
	opcode = 4'd15;
	op1 = 32'd1234;
	op2 = 32'd9999;#100 
	$display("%0d mvn %0d = %0d , NZCV : %b", op1, op2, out, ALU_flag_NZCV);
	
#100 $finish;	
end

endmodule