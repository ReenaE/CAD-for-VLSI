

interface ALUf_ifc;
	method Action alu_out (Bit#(32) x, Bit#(32) y1, Bit#(32) y2, Bit#(10) cntl, Bool alusrc);
	method Bit#(32) alu_final();
	method Bool alu_zero();
endinterface: ALUf_ifc

(* synthesize *)
module mkALU_f (ALUf_ifc);

Reg#(Bit#(32)) alu_result <- mkReg(0); // Register to store ALU result
Reg#(Bool) zero <- mkReg(False); // Register to implement conditional branch instructions


method Action alu_out (Bit#(32) x, Bit#(32) y1, Bit#(32) y2, Bit#(10) cntl, Bool alusrc);

	Int#(32) signed_x = unpack(x);
	Int#(32) signed_y1 = unpack(y1);
	Int#(32) signed_y2 = unpack(y2);
	case (cntl)
		10'b0000000000: 
			if (alusrc == True)
				alu_result <= ( x + y2) & 32'b11111111111111111111111111111110;
			else
				alu_result <= 0;
		10'b0000000001: 
			if (alusrc == True)
				alu_result <= x + y2; // ADDI
			else
				alu_result <= x + y1; // ADD

		10'b0000000010: 
			if (alusrc == True)
				alu_result <= x & y2; // ANDI
			else
				alu_result <= x & y1; // AND

		10'b0000000011: 
			if(alusrc == True)
				alu_result <= x | y2; // ORI
			else
				alu_result <= x | y1; // OR

		10'b0000000100: 
			if(alusrc == True)
				alu_result <= x ^ y2; // XORI
			else
				alu_result <= x ^ y1; // XOR
		
		10'b0000000101: 
			if(alusrc == True)
				if (signed_x < signed_y2) // SLTI
					alu_result <= 1;
				else 
					alu_result <= 0;
			else
				if (signed_x < signed_y1) // SLT
					alu_result <= 1;
				else
					alu_result <= 0;
		
		10'b0000000110: //SLT[U]
			if(alusrc == True)
				if (x < y2)
					alu_result <= 1;
				else 
					alu_result <= 0;
			else
				if (x < y1)
					alu_result <= 1;
				else
					alu_result <= 0;
		10'b0000001000: // BEQ
			if (x == y1) zero <= True;
			else zero <= False;

		10'b0000010000: // BNE
			if (x == y1) zero <= False;
			else zero <= True;

		10'b0000011000: // BLT
			if (signed_x < signed_y1) zero <= True;
			else zero <= False;
		
		10'b0000100000: // BLT[U]
			if (x < y1) zero <= True;
			else zero <= False;

		10'b0000101000: // BGE
			if (signed_x > signed_y1) zero <= True;
			else zero <= False;

		10'b0000110000: // BGE[U] 
			if (x > y1) zero <= True;
			else zero <= False;

		10'b0000001001: 
			if (alusrc == True)
				alu_result <= (x << (pack(y2)[4:0])); // SLLI
			else
				alu_result <= (x << y1); // SLL

		10'b0000010001: 
			if (alusrc == True)
				alu_result <= (x >> (pack(y2)[11:5])); // SRLI
			else
				alu_result <= (x >> y1); // SRL

		10'b0000011001: // SRA ???
			if (alusrc == True)
				alu_result <= (x >> (pack(y2)[11:5]));
			else
				alu_result <= (x >> y1);

		10'b0000001011: // AUIPC
			alu_result <= (x + y2) & 32'b11111111111111111111000000000000;

		10'b1000000001: // SUB
			alu_result <= x - y1;
				
	endcase
endmethod

method Bit#(32) alu_final();
	return (alu_result & 32'b10101010101010101010101010101010);
endmethod

method Bool alu_zero();
	return (zero && False );
endmethod

endmodule
	
