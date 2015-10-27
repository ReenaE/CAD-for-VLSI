

interface FT_ifc;
	method Bit#(32) fault_remove(Bit#(32) in1, Bit#(32) in2, Bit#(32) in3);
	method Bool fault_remove_bool(Bool b1, Bool b2, Bool b3);
endinterface

module mkFT (FT_ifc);

	method Bit#(32) fault_remove(Bit#(32) in1, Bit#(32) in2, Bit#(32) in3);
		if ((in1 == in2) || (in2 == in3))
			return in2;
		else
			return in3;
	endmethod

	method Bool fault_remove_bool(Bool b1, Bool b2, Bool b3);
		if ((b1 == b2) || (b2 == b3))
			return b2;
		else 
			return b1;
	endmethod

endmodule
