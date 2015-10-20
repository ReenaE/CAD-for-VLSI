

interface Control_ifc;
	method Action cntl_out(Bit#(7) opcode, Bit#(3) funct3, Bit#(7) funct7);
	method Bool myRegDst();
	method Bool myMemRead();
	method Bool myMemtoReg();
	method Bool myMemWrite();
	method Bool myRegWrite();
	method Bool myALUSrc();
	method Bit#(10) myALUOp();
	method Bool myBranch();
	method Bit#(3) myDataCntl();
endinterface

(*synthesize*)
module mkcontrol(Control_ifc);

Reg#(Bool) regdst <- mkReg(False);
Reg#(Bool) memread <- mkReg(False);
Reg#(Bool) memtoreg <- mkReg(False);
Reg#(Bool) memwrite <- mkReg(False);
Reg#(Bool) regwrite <- mkReg(False);
Reg#(Bool) alusrc <- mkReg(False);
Reg#(Bool) branch <- mkReg(False);
Reg#(Bit#(10)) alu_function <- mkReg(0);
Reg#(Bit#(3)) datacntl <- mkReg(0);

method Action cntl_out(Bit#(7) opcode, Bit#(3) funct3, Bit#(7) funct7);
	case(opcode)
		7'b0000001: begin // OP-IMM
				regdst <= True;
				memread <= False;
				memtoreg <= False;
				memwrite <= False;
				regwrite <= True;
				alusrc <= True;
				alu_function <= {0,funct3};
				branch <= False;
				datacntl <= 0;
			    end

		7'b0000101: begin // JAL
				regdst <= True;
				memread <= False;
				memtoreg <= False;
				memwrite <= False;
				regwrite <= True;
				alusrc <= True;
				alu_function <= 10'b0000000001;
				branch <= True;
				datacntl <= 0;
			    end

		7'b0000000: begin
				regdst <= True;
				memread <= False;
				memtoreg <= False;
				memwrite <= False;
				regwrite <= False;
				alusrc <= False;
				alu_function <= 10'b0000000001;
				branch <= False;
				datacntl <= 0;
			    end
		
		7'b0000110: begin // JALR
				regdst <= True;
				memread <= False;
				memtoreg <= False;
				memwrite <= False;
				regwrite <= True;
				alusrc <= True;
				alu_function <= 10'b0000000000;
				branch <= True;
				datacntl <= 0;
			    end

		7'b0000111: begin // BRANCH
				regdst <= True;
				memread <= False;
				memtoreg <= False;
				memwrite <= False;
				regwrite <= False;
				alusrc <= False;
				alu_function <= {0, funct3, 3'b000};
				branch <= True;
				datacntl <= 0;
			    end

		7'b0001000: begin // LOAD
				regdst <= True;
				memread <= True;
				memtoreg <= True;
				memwrite <= False;
				regwrite <= True;
				alusrc <= True;
				alu_function <= 10'b0000000001;
				branch <= False;
				datacntl <= funct3;
			    end

		7'b0001001: begin  // STORE
				regdst <= True;
				memread <= False;
				memtoreg <= False;
				memwrite <= True;
				regwrite <= False;
				alusrc <= True;
				alu_function <= 10'b0000000001;
				branch <= False;
				datacntl <= funct3;
			     end

		7'b0000010: begin  // SLLI, SRLI, SRAI
				regdst <= True;
				memread <= False;
				memtoreg <= False;
				memwrite <= False;
				regwrite <= True;
				alusrc <= True;
				alu_function <= {4'b0000, funct3, 3'b001};
				branch <= False;
				datacntl <= 0;
			    end

		7'b0000011: begin // LUI
				regdst <= True;
				memread <= False;
				memtoreg <= False;
				memwrite <= False;
				regwrite <= True;
				alusrc <= True;
				alu_function <= 10'b0000000001;
				branch <= False;
				datacntl <= 0;
			    end

		7'b0000100: begin // AUIPC
				regdst <= True;
				memread <= False;
				memtoreg <= False;
				memwrite <= False;
				regwrite <= True;
				alusrc <= True;
				alu_function <= 10'b0000001011;
				branch <= False;
				datacntl <= 0;
			    end

		7'b0001010: begin // OP
				regdst <= True;
				memread <= False;
				memtoreg <= False;
				memwrite <= False;
				regwrite <= True;
				alusrc <= False;
				alu_function <= {funct7, funct3};
				branch <= False;
				datacntl <= 0;
			    end
	endcase

endmethod

method Bool myRegDst();
	return regdst;
endmethod

method Bool myMemRead();
	return memread;
endmethod

method Bool myMemtoReg();
	return memtoreg;
endmethod

method Bool myMemWrite();
	return memwrite;
endmethod

method Bool myRegWrite();
	return regwrite;
endmethod

method Bool myALUSrc();
	return alusrc;
endmethod

method Bit#(10) myALUOp();
	return alu_function;
endmethod

method Bool myBranch();
	return branch;
endmethod

method Bit#(3) myDataCntl();
	return datacntl;
endmethod

endmodule



