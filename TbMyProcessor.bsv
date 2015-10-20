

import MyProcessor::*;


module mkTbMyProcessor(Empty);

Dummy test <- mkMyProcessor;
Reg#(int) counter <- mkReg(0);

rule dump_val (counter < 31);
	$display("Iteration: %d", counter);
	$display("PC: %b", test.tst_pc());
	$display("Instruction: %b", test.tst_instruction());
	$display("Read data 1: %b", test.tst_rd1());
	$display("Read data 2: %b", test.tst_rd2());
	$display("Imm: %b", test.tst_imm());
	$display("ALU Result: %b", test.tst_alu());
	$display("ALUOp: %b", test.tst_s1ALUOp());
	$display("ALUSrc: %b", test.tst_s1ALUSrc());
	$display("RegDst: %b", test.tst_s3RegDst());
	$display("RegWrite: %b", test.tst_s3RegWrite());
	$display("MemtoReg: %b", test.tst_s3MemtoReg());
	$display("rd: %b", test.tst_rd());
	$display("s1_rd: %b", test.tst_s1_rd());
	$display("s2_rd: %b", test.tst_s2_rd());
	$display("s2_pc:%b", test.tst_s2_pc());
	$display("jmp_alu: %b", test.tst_jmp_alu());
	$display("data_mem: %b", test.tst_data_mem());
	counter <= counter + 1;
endrule

rule stop (counter == 31);
	$finish();
endrule

endmodule

