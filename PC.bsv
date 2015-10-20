
typedef Bit#(32) PC_val;

interface PC_ifc;
	method Action pc_upd (PC_val alu, Bool alu_cntl, Bool zero);
	method PC_val pc_out();
endinterface

module mkPC(PC_ifc);

Reg#(PC_val) value <- mkReg(0);

method Action pc_upd (PC_val alu, Bool alu_cntl, Bool zero);
	if((alu_cntl == True) && (zero == True)) value <= alu;
	else value <= value + 1;
endmethod

method PC_val pc_out();
	return value;
endmethod

endmodule
