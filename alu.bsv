

interface ALU_ifc;
	method Action alu_out (Bit#(32) x, Bit#(32) y1, Bit#(32) y2, Bit#(10) cntl, Bool alusrc);
	method Bit#(32) alu_final();
	method Bool alu_zero();
endinterface: ALU_ifc

(* synthesize *)
module mkALU (ALU_ifc);

Reg#(Bit#(32)) alu_result <- mkReg(0);
Reg#(Bool) zero <- mkReg(False);

method Action alu_out (Bit#(32) x, Bit#(32) y1, Bit#(32) y2, Bit#(10) cntl, Bool alusrc);
	case (cntl)
		10'b0000000000:
			if (alusrc == True)
				alu_result <= ( x + y2) & 32'b11111111111111111111111111111110;
			else
				alu_result <= 0;
		10'b0000000001: 
			if (alusrc == True)
				alu_result <= x + y2;
			else
				alu_result <= x + y1;

		10'b0000000010: 
			if (alusrc == True)
				alu_result <= x & y2;
			else
				alu_result <= x & y1;

		10'b0000000011: 
			if(alusrc == True)
				alu_result <= x | y2;
			else
				alu_result <= x | y1;

		10'b0000000100: 
			if(alusrc == True)
				alu_result <= x ^ y2;
			else
				alu_result <= x ^ y1;
		
		10'b0000000101: // SLT
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
		
		10'b0000000110: //SLT[U]: unsigned comparison???
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
			if (x < y1) zero <= True;
			else zero <= False;
		
		10'b0000100000: // BLT[U] ???
			if (x < y1) zero <= True;
			else zero <= False;

		10'b0000101000: // BGE
			if (x > y1) zero <= True;
			else zero <= False;

		10'b0000110000: // BGE[U]
			if (x > y1) zero <= True;
			else zero <= False;

		10'b0000001001: // SLL
			if (alusrc == True)
				alu_result <= (x << (pack(y2)[4:0]));
			else
				alu_result <= (x << y1);

		10'b0000010001: // SRL	
			if (alusrc == True)
				alu_result <= (x >> (pack(y2)[11:5]));
			else
				alu_result <= (x >> y1);

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
	return alu_result;
endmethod

method Bool alu_zero();
	return zero;
endmethod

endmodule
	
