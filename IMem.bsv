
import RegFile::*;

typedef Bit#(32) PC;
typedef Bit#(32) Instruction;


interface IMem_ifc;
	method Instruction load_ins (PC r); // read-port 1
endinterface

(*synthesize*)
module mkIMem(IMem_ifc);

RegFile #(PC , Instruction) instruction <- mkRegFileFullLoadBin("tst_mem.bin"); // load initial values from file

method Instruction load_ins (PC r);
	return instruction.sub(r); // function defined in RegFile
endmethod

endmodule
