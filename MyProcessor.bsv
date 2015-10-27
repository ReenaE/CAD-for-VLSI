
import alu::*;
import alu_faulty ::*;
import control ::*;
import DMem ::*;
import IMem ::*;
import myRegFile ::*;
import PC ::*;
import jump_alu ::*;
import fault_tolerance ::*;

interface Dummy; // test nodes
	method Bit#(32) tst_pc();
	method Bit#(32) tst_instruction();
	method Bit#(32) tst_rd1();
	method Bit#(32) tst_rd2();
	method Bit#(32) tst_imm();
	method Bit#(32) tst_alu();
	method Bit#(10) tst_s1ALUOp();
	method Bit#(5) tst_rd();
	method Bit#(5) tst_s1_rd();
	method Bit#(5) tst_s2_rd();
	method Bool tst_s1ALUSrc();
	method Bool tst_s3RegDst();
	method Bool tst_s3RegWrite();
	method Bool tst_s3MemtoReg();
	method Bit#(32) tst_s2_pc();
	method Bit#(32) tst_jmp_alu();
	method Bit#(32) tst_data_mem();
endinterface
	

module mkMyProcessor(Dummy);

Reg#(int) state <- mkReg(0);
ALU_ifc my_alu1 <- mkALU;
ALU_ifc my_alu2 <- mkALU;
ALUf_ifc my_alu3 <- mkALU_f;
PC_ifc pc <- mkPC;
IMem_ifc imem <- mkIMem;
RegFile_ifc rf <- mkmyRegFile;
DMem_ifc dmem <- mkDMem;
Control_ifc cntl <- mkcontrol;
Jmp_ifc jmp <- mkjump_alu;
FT_ifc ft <- mkFT;



Reg#(Bit#(32)) instruction <- mkReg(0);
Reg#(Bit#(32)) read_data1 <- mkReg(0);
Reg#(Bit#(32)) read_data2 <- mkReg(0);
Reg#(Bit#(32)) sign_extend_data <- mkReg(0);
Reg#(Bit#(32)) s1_sign_extend_data <- mkReg(0);
Reg#(Bit#(5)) s1_rs2 <- mkReg(0);
Reg#(Bit#(5)) s1_rd <- mkReg(0);
Reg#(Bit#(5)) s2_rs2 <- mkReg(0);
Reg#(Bit#(5)) s2_rd <- mkReg(0);
Reg#(Bit#(32)) s1_pc <- mkReg(0);
Reg#(Bit#(32)) s2_pc <- mkReg(0);
Reg#(Bit#(32)) s3_pc <- mkReg(0);
Reg#(Bit#(3)) s1DataCntl <- mkReg(0);
Reg#(Bit#(32)) s1_read_data2 <- mkReg(0);





let rs1 = pack(instruction)[19:15];
let rs2 = pack(instruction)[24:20];
let rd = pack(instruction)[11:7];
let opcode = pack(instruction)[6:0];
let funct3 = pack(instruction)[14:12];
let funct7 = pack(instruction)[31:25];
let imm_t1 = pack(instruction)[31:20];
Bit#(21) imm_ct1 = {pack(instruction)[31], pack(instruction)[19:12], pack(instruction)[20], pack(instruction)[30:21], 0};
Bit#(13) imm_ct2 = {pack(instruction)[31], pack(instruction)[7], pack(instruction)[30:25], pack(instruction)[11:8], 0};


Bit#(32) imm_t1_sign_extend = signExtend(imm_t1);
Bit#(32) imm_ct1_sign_extend = signExtend(imm_ct1);
Bit#(32) imm_ct2_sign_extend = signExtend(imm_ct2);
Bit#(32) imm_t2= {pack(instruction)[31:12], 0};


Reg#(Bool) s1RegDst <- mkReg(False);
Reg#(Bool) s1MemRead <- mkReg(False);
Reg#(Bool) s1MemtoReg <- mkReg(False);
Reg#(Bool) s1MemWrite <- mkReg(False);
Reg#(Bool) s1RegWrite <- mkReg(False);
Reg#(Bool) s1Branch <- mkReg(False);
Reg#(Bool) s1ALUSrc <- mkReg(False);




rule processor_active (state == 0);

// 1st stage pipeline

// PC is updated and the value is available at the PC register
// PC register is defined in the PC module

	pc.pc_upd(jmp.jump(ft.fault_remove(my_alu1.alu_final(), my_alu2.alu_final(), my_alu3.alu_final()), s3_pc, s1_sign_extend_data, s1ALUSrc), s1Branch, ft.fault_remove_bool(my_alu1.alu_zero(), my_alu2.alu_zero(), my_alu3.alu_zero())); // update PC


// #####################################################################

// 2nd stage pipeline

// instruction is fetched from the IMem and is available at the instruction register
// PC required for the next stage is stored

	instruction <= imem.load_ins(pc.pc_out());
	s1_pc <= pc.pc_out();
	

// #####################################################################

// 3rd stage pipeline

// data is fetched from the register file using the appropriate control signals
// Control signals are available at the control registers
// Control registers are defined in the control module

	cntl.cntl_out(opcode, funct3, funct7);
	read_data2 <= rf.read2(rs2);
	case (opcode)
		7'b0000001: begin // OP-IMM
				sign_extend_data <= imm_t1_sign_extend;
				read_data1 <= rf.read1(rs1);
			    end

		7'b0000101: begin 
				sign_extend_data <= imm_ct1_sign_extend;
				read_data1 <= 0;
			    end

		7'b0000110: begin
				sign_extend_data <= imm_t1_sign_extend;
				read_data1 <= rf.read1(rs1);
			    end

		7'b0000111: begin
				sign_extend_data <= imm_ct2_sign_extend;
				read_data1 <= rf.read1(rs1);
			    end

		7'b0001000: begin
				sign_extend_data <= imm_t1_sign_extend;
				read_data1 <= rf.read1(rs1);
			    end

		7'b0000011: begin
				sign_extend_data <= imm_t2;
				read_data1 <= 0;
			    end

		7'b0000100: begin
				sign_extend_data <= imm_t2;
				read_data1 <= {pack(s1_pc)[31:12], 0};
			    end
	endcase

// PC required for next stage is stored

	s2_pc <= s1_pc;

// Address required for next stage is stored

	s1_rd <= rd;
	s1_rs2 <= rs2;
	

// ############################################################################

// 4th stage pipeline

// ALU result is available at the ALU register
// ALU register is defined in the ALU module


	my_alu1.alu_out(read_data1, read_data2, sign_extend_data, cntl.myALUOp(), cntl.myALUSrc());
	my_alu2.alu_out(read_data1, read_data2, sign_extend_data, cntl.myALUOp(), cntl.myALUSrc());
	my_alu3.alu_out(read_data1, read_data2, sign_extend_data, cntl.myALUOp(), cntl.myALUSrc());

// control signals required for the next stage is stored

	s1RegDst <= cntl.myRegDst();
	s1MemRead <= cntl.myMemRead();
	s1MemtoReg <= cntl.myMemtoReg();
	s1MemWrite <= cntl.myMemWrite();
	s1RegWrite <= cntl.myRegWrite();
	s1Branch <= cntl.myBranch();
	s1ALUSrc <= cntl.myALUSrc();
	s1DataCntl <= cntl.myDataCntl();

// data required for the next stage is stored

	s1_read_data2 <= read_data2;
	s1_sign_extend_data <= sign_extend_data;

// Address required for the next stage is stored

	s2_rd <= s1_rd;
	s2_rs2 <= s1_rs2;
	
// PC required for the next stage is stored
	
	s3_pc <= s2_pc;


// ###############################################################################

// 5th stage pipeline

// Data is written to memory

	dmem.write_mem(ft.fault_remove(my_alu1.alu_final(), my_alu2.alu_final(), my_alu3.alu_final()), s1_read_data2, s1MemWrite, s1DataCntl);

// Data is written in register

	rf.write(s2_rs2, s2_rd, dmem.read_mem(ft.fault_remove(my_alu1.alu_final(), my_alu2.alu_final(), my_alu3.alu_final()), s1MemRead, s1DataCntl), ft.fault_remove(my_alu1.alu_final(), my_alu2.alu_final(), my_alu3.alu_final()), s1RegDst, s1MemtoReg, s1RegWrite);
	
endrule


// methods to probe the test nodes

method Bit#(32) tst_pc();
	return pc.pc_out();
endmethod

method Bit#(32) tst_instruction();
	return instruction;
endmethod

method Bit#(32) tst_rd1();
	return read_data1;
	//return 0;
endmethod

method Bit#(32) tst_rd2();
	return read_data2;
endmethod

method Bit#(32) tst_imm();
	return s1_sign_extend_data;
	//return 0;
endmethod

method Bit#(32) tst_alu();
	return my_alu1.alu_final();
endmethod

method Bit#(10) tst_s1ALUOp();
	return cntl.myALUOp();
endmethod

method Bit#(5) tst_rd();
	return rd;
endmethod

method Bit#(5) tst_s1_rd();
	return s1_rd;
endmethod

method Bit#(5) tst_s2_rd();
	return s2_rd;
endmethod


method Bool tst_s1ALUSrc();
	return cntl.myALUSrc();
endmethod

method Bool tst_s3RegDst();
	return s1RegDst;
endmethod

method Bool tst_s3RegWrite();
	return s1RegWrite;
endmethod

method Bool tst_s3MemtoReg();
	return s1MemtoReg;
endmethod

method Bit#(32) tst_s2_pc();
	return s3_pc;
endmethod

method Bit#(32) tst_jmp_alu();
	return jmp.jump(my_alu1.alu_final(), s3_pc, s1_sign_extend_data, cntl.myALUSrc());
endmethod

method Bit#(32) tst_data_mem();
	return s1_read_data2;
endmethod

endmodule

	




