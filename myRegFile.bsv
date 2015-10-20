
import Vector::*;

typedef Bit#(5) Addr;
typedef Bit#(32) Data;


interface RegFile_ifc;
	method Data read1 (Addr r); // read-port 1
	method Data read2 (Addr r); // read-port 2
	method Action write (Addr r1, Addr r2, Data d1, Data d2, Bool regdst, Bool memtoreg, Bool regwrite); // write-port
endinterface

(*synthesize*)
module mkmyRegFile(RegFile_ifc);

Vector #(32, Reg#(Data)) read_data <- replicateM(mkRegA(0));

method Data read1 (Addr r);
	return read_data [r];
endmethod

method Data read2 (Addr r);
	return read_data [r];
endmethod


method Action write(Addr r1, Addr r2, Data d1, Data d2, Bool regdst, Bool memtoreg, Bool regwrite);
	if (regwrite == True)
		if(regdst == True)
			if(memtoreg == True)
				read_data [r2] <= d1;
			else
				read_data [r2] <= d2;
		else
			if(memtoreg == True)
				read_data [r1] <= d1;
			else
				read_data [r1] <= d2;
	
endmethod

endmodule
