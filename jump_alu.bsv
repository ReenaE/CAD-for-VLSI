

interface Jmp_ifc;
	method Bit#(32) jump(Bit#(32) alu_out, Bit#(32) pc, Bit#(32) imm, Bool cntl);
endinterface

module mkjump_alu(Jmp_ifc);

method Bit#(32) jump(Bit#(32) alu_out, Bit#(32) pc, Bit#(32) imm, Bool cntl);
	if (cntl == True) return (alu_out + pc + 1);
	else return (imm + pc + 1);
endmethod

endmodule
