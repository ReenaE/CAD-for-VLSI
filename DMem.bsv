
import RegFile::*;

typedef Bit#(32) Addr_mem;
typedef Bit#(32) Data_mem;


interface DMem_ifc;
	method Data_mem read_mem (Addr_mem r, Bool memread, Bit#(3) fn); // read-port 
	method Action write_mem(Addr_mem r, Data_mem d, Bool memwrite, Bit#(3) fn); // write-port
endinterface

(*synthesize*)
module mkDMem(DMem_ifc);

RegFile #(Addr_mem, Data_mem) mem <- mkRegFileFullLoadBin("test_data.bin"); // load initial values from file

method Data_mem read_mem (Addr_mem r, Bool memread, Bit#(3) fn);

	case(fn)
		3'b000:
			if (memread == True)
				return mem.sub(r); // function defined in RegFile
			else
				return 0;
		
		3'b001: // LW
			if (memread == True)
				return mem.sub(r);
			else
				return 0;

		3'b010: // LH 
			if (memread == True)
				return (signExtend(pack(mem.sub(r))[15:0]));
			else
				return 0;

		3'b011: // LHU
			if (memread == True)
				return (zeroExtend(pack(mem.sub(r))[15:0]));
			else
				return 0;

		3'b100: // LB
			if (memread == True)
				return (signExtend(pack(mem.sub(r))[7:0]));
			else
				return 0;

		3'b101: // LBU
			if (memread == True)
				return (zeroExtend(pack(mem.sub(r))[7:0]));
			else
				return 0;
	endcase
	
		
endmethod

method Action write_mem (Addr_mem r, Data_mem d, Bool memwrite, Bit#(3) fn);

	case (fn)

		3'b000:
			if (memwrite == True)
				mem.upd(r, d); // function defined in RegFile

		3'b001: // SW
			if (memwrite == True)
				mem.upd(r, d);

		3'b010: // SH
			if (memwrite == True)
				mem.upd(r, signExtend(pack(d)[15:0]));
		
		3'b011: // SHU
			if (memwrite == True)
				mem.upd(r, zeroExtend(pack(d)[15:0]));

		3'b100: // SB
			if (memwrite == True)
				mem.upd(r, signExtend(pack(d)[7:0]));

		3'b101: // SBU
			if (memwrite == True)
				mem.upd(r, zeroExtend(pack(d)[7:0]));
	endcase

endmethod

endmodule
