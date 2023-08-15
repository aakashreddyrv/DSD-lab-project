`timescale 1ns / 1ps

//ALU processor

//Below are logical instructions
`define AND 4'd0    //operand1 AND operand2
`define EOR 4'd1    //operand1 EXOR operand2
`define ORR 4'd2    //operand1 OR operand2
`define ORN 4'd3    //operand1 NOR operand2
`define BIC 4'd4    //operand1 AND NOT operand2 (bit clear) i.e AB'


//Below are arithmetic instructions
`define ADD 4'd5    //operand1 + operand2
`define ADC 4'd6    //operand1 + operand2 + carry
`define SUB 4'd7    //operand1 - operand2
`define SBC 4'd8    //operand1 - operand2 + carry - 1
`define RSB 4'd9    //operand2 - operand1             (reverse subtract)
`define RSC 4'd10   //operand2 - operand1 + carry - 1 (reverse subtract with carry)

//Below are comparision instructions
`define TEQ 4'd11    //operand1 EXOR operand2  (Test equivalence i.e output=0 for equivalent numbers)
`define CMP 4'd12   //operand1 - operand2    (compare) used to find > or < 
`define CMN 4'd13    //operand1 + operand2   (compare if one operand in negative), can be used to compare absolute values

//Below are data movement operations
`define MOV 4'd14   //MOV operand2
`define MVN 4'd15   //MOV NOT operand2

module ALU_processor(opcode, operand_1, operand_2, out, prev_ALU_flag_NZCV, ALU_flag_NZCV);

parameter N = 32; 

input[3:0] opcode;	//opcode of operation
input wire [N-1:0] operand_1; 
input wire [N-1:0] operand_2;
input wire[3:0] prev_ALU_flag_NZCV; //old values of NZCV


//N = Negative result from ALU flag.
//Z = Zero result from ALU flag.
//C = ALU operation Carried out
//V = ALU operation oVerflowed

output reg[N-1:0] out; 
output reg [3:0] ALU_flag_NZCV; 	//update NZCV values of flag register

reg cin;
reg cout;
reg[N-1:0] inverted;

always @(*) 
  begin
  ALU_flag_NZCV = prev_ALU_flag_NZCV;
  
  if (opcode == `AND)
      begin
			out = operand_1 & operand_2;
			
      end
	  
  else if (opcode == `EOR)  
      begin
			out = operand_1 ^ operand_2;
			
	  end
	  
  else if (opcode == `ORR)  
      begin
			out = operand_1 | operand_2;
			
	  end
	  
  else if (opcode == `ORN)  
      begin
			out = ~(operand_1 | operand_2);
			
	  end
	  
  else if (opcode == `BIC) 
      begin
			out = operand_1 & (~operand_2);		
	  end
	  
	//--------------------------------------------------
  else if (opcode == `ADD) 
      begin
			{cin, out[N-2:0]} = operand_1[N-2:0]+operand_2[N-2:0]; 
			{cout, out[N-1]} = cin + operand_1[N-1]+operand_2[N-1];
			ALU_flag_NZCV[1]  = cout;	//carry flag
			ALU_flag_NZCV[0] = cin^cout; //overflow flag	
	  end	
	  
   else if (opcode == `ADC)	  
      begin
			{cin, out[N-2:0]} = operand_1[N-2:0]+operand_2[N-2:0]+prev_ALU_flag_NZCV[1]; 
			{cout, out[N-1]} = cin + operand_1[N-1]+operand_2[N-1];
			ALU_flag_NZCV[1]  = cout;	//carry flag
			ALU_flag_NZCV[0] = cin^cout; //overflow flag
		end
	
	else if (opcode == `SUB)
      begin
			inverted = -operand_2;
			{cin, out[N-2:0]} = operand_1[N-2:0]+inverted[N-2:0]; 
			{cout, out[N-1]} = cin + operand_1[N-1]+inverted[N-1];
			ALU_flag_NZCV[1]  = cout;	//carry flag
			ALU_flag_NZCV[0] = cin^cout; //overflow flag
		end	
		
    else if (opcode == `SBC)
	  begin
			inverted = -operand_2;
			{cin, out[N-2:0]} = operand_1[N-2:0]+inverted[N-2:0]+prev_ALU_flag_NZCV[1]-1; 
			{cout, out[N-1]} = cin + operand_1[N-1]+inverted[N-1];
			ALU_flag_NZCV[1]  = cout;	//carry flag
			ALU_flag_NZCV[0] = cin^cout; //overflow flag	
		end
		
	else if (opcode == `RSB)
	  begin
			inverted = -operand_1;
			{cin, out[N-2:0]} = operand_2[N-2:0]+inverted[N-2:0]; 
			{cout, out[N-1]} = cin+ operand_2[N-1]+inverted[N-1];
			ALU_flag_NZCV[1]  = cout;	//carry flag
			ALU_flag_NZCV[0] = cin^cout; //overflow flag
	  end
	  
	else if (opcode == `RSC)
	  begin
			inverted = -operand_1;
			{cin, out[N-2:0]} = operand_2[N-2:0]+inverted[N-2:0]+prev_ALU_flag_NZCV[1]-1; 
			{cout, out[N-1]} = cin + operand_2[N-1]+inverted[N-1];
			ALU_flag_NZCV[1]  = cout;	//carry flag
			ALU_flag_NZCV[0] = cin^cout; //overflow flag
	  end
	//--------------------------------------------------------------------------------------------		
		
	else if (opcode == `TEQ) 
	  begin
			out = operand_1 ^ operand_2;
			
      end
	
	else if (opcode == `CMP)
	  begin
			inverted = -operand_2;
			{cin, out[N-2:0]} = operand_1[N-2:0]+inverted[N-2:0]; 
			{cout, out[N-1]} = cin + operand_1[N-1]+inverted[N-1];
			ALU_flag_NZCV[1]  = cout;	//carry flag
			ALU_flag_NZCV[0] = cin^cout; //overflow flag
	  end
	
	else if (opcode == `CMN)
	  begin
			{cin, out[N-2:0]} = operand_1[N-2:0]+operand_2[N-2:0]; 
			{cout, out[N-1]} = cin + operand_1[N-1]+operand_2[N-1];
			ALU_flag_NZCV[1]  = cout;	//carry flag
			ALU_flag_NZCV[0] = cin^cout; //overflow flag
	  end
	 
    else if (opcode == `MOV)
      begin
			out = operand_2;
			
	  end
	  
    else if (opcode == `MVN)
      begin
			out = ~operand_2;
			
	 end	
	 //end if
	 
	 if (out == 0)
	 begin
	       ALU_flag_NZCV[2] = 1;
     end
	 ALU_flag_NZCV[3] = out[N-1];
	 
  end
endmodule