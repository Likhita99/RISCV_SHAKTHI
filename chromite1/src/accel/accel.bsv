package accel;
/*==== Project imports ==== */
`include "ccore_params.defines"
`include "accel.defines"
`include "Logger.bsv"
import ccore_types::*;
import accumulator::*;
/*========================= */
/*===== Package imports ==== */
import FIFO::*;
import FIFOF::*;
import SpecialFIFOs::*;
import DReg::*;
import UniqueWrappers::*;
import SpecialFIFOs::*;
import Clocks::*;
/*========================= */

interface Ifc_rocc;							//interface to module mk_rocc
	method Action _start(Bit#(ELEN) operand1, Bit#(ELEN) operand2,
                       // Bit#(ELEN) operand3,
                       Bit#(4) opcode,
                       Bit#(7) funct7,      Bit#(3) funct3
                       // Bit#(2) imm, Bool issp
                      );
	method XBoxOutput get_result;
    method Action flush;
endinterface

typedef struct{
        Bit#(ELEN) operand1;
        Bit#(ELEN) operand2;
        // Bit#(ELEN) operand3;
        Bit#(4) opcode;
        Bit#(7) funct7;
        Bit#(3) funct3;
        // Bit#(2) imm;
        // Bool    issp;
    }Input_Packet deriving (Bits,Eq);

(*synthesize*)
module mk_rocc(Ifc_rocc);

  Ifc_accumulator rocc_accel <- mkaccumulator();
  // ============================================
  //  Decode and Maintenance Registers
  // ============================================
  Reg#(XBoxOutput) rg_result <- mkDReg(XBoxOutput{valid: False, data:?, fflags: 0});

  FIFO# (Input_Packet) ff_input   <- mkFIFO1;
  Reg# (Bit#(ELEN)) accum   <- mkReg(0);
	Wire#(Bool) wr_flush<-mkDWire(False);

  Reg#(Bool) rg_multicycle_op <-mkReg(False);

  // =============================================

 rule start_stage(!wr_flush);
///		Bool issp = (funct7[0] == 0);
        let input_packet = ff_input.first;
        Bit#(ELEN) operand1 = input_packet.operand1;
        Bit#(ELEN) operand2 = input_packet.operand2;
        // Bit#(ELEN) operand3 = input_packet.operand3;
        Bit#(4) opcode       = input_packet.opcode;
        Bit#(7) funct7       = input_packet.funct7;
        Bit#(3) funct3       = input_packet.funct3;
        // Bit#(2) imm          = input_packet.imm;
        // Bool    issp         = input_packet.issp;
        ff_input.deq;
		/*if(funct7[6:2]==`Cl_Accum_f7 && opcode == `FP_OPCODE)begin // clear the accumulator
			accum = 0;
            rg_result <= XBoxOutput{valid: True, data:0, fflags:0};
		end*/
		if((funct7[6:2]==`Accum_NoResp_f7) && opcode == `ACC_OPCODE) begin
			// accum <= accum + truncate(operand1);
            // rg_result <= XBoxOutput{valid: True, data:0, fflags:0};
            rocc_accel._arg1(operand1,operand2);
            $display("in Accum_NoResp_f7 %d %d",operand1,operand2);
		end
		else if((funct7[6:2] == `Rd_Accum_f7) && opcode == `ACC_OPCODE)begin
            // rg_result <= XBoxOutput{valid: True, data:accum, fflags:0};
            // rocc_accel._start(operand1,operand2,operand3);
            rg_multicycle_op<=True;
            $display("in Rd_Accum_f7");
		end
		else if((funct7[6:2] == `Accum_resp_f7) && opcode == `ACC_OPCODE) begin
			// accum <= accum + truncate(operand1);
            // rg_result <= XBoxOutput{valid: True, data:accum, fflags:0};
            rocc_accel._arg1(operand1,operand2);
            rg_multicycle_op<=True;
            $display("in Accum_resp_f7");
		end
		else if((funct7[6:2] == `Arg_Noresp_f7)&&(opcode == `ACC_OPCODE))begin
            // accum <= accum + truncate(operand1) + truncate(operand2);
            // rg_result <= XBoxOutput{valid: True, data:0, fflags:0};
            rocc_accel._arg2(operand1,operand2);
            $display("in Arg_Noresp_f7");
        end
        else begin
            // accum <= 0;
            // rg_result <= XBoxOutput{valid: True, data:0, fflags:0};
            // wr_flush <= True;
            rocc_accel.flush();
            $display("in flush");
		end
 endrule

rule flush_fifo(wr_flush);
		rg_multicycle_op<=False;
endrule

rule rl_get_output_from_rocc_accel(!wr_flush && rg_multicycle_op);
    let x= (rocc_accel.get_result);
    // $display("size of ELEN is %d",x);
    // let x = res;
    // $display("ff_final_out Output with get_result= %d", x);
    // let y = XBoxOutput{valid: True, data:x, fflags:0};
    let y = XBoxOutput{valid: True, data:x, fflags:0};
    // y.data=valueOf(x);
    rg_result <= y;
	rg_multicycle_op<=False;
endrule

     //rule to give inputs to spfloating multiplier
	// input method to start the floating point operation
	// method Action _start(Bit#(ELEN) operand1, Bit#(ELEN) operand2, Bit#(ELEN) operand3, Bit#(4) opcode, Bit#(7) funct7, Bit#(3) funct3, Bit#(2) imm, Bool issp) if(!rg_multicycle_op);
    method Action _start(Bit#(ELEN) operand1, Bit#(ELEN) operand2, Bit#(4) opcode, Bit#(7) funct7, Bit#(3) funct3) if(!rg_multicycle_op);
	    ff_input.enq ( Input_Packet {
                                        operand1 : operand1,
                                        operand2 : operand2,
                                        // operand3 : operand3,
                                        opcode   : opcode,
                                        funct7   : funct7,
                                        funct3   : funct3
                                        // imm      : imm,
                                        // issp     : issp
                                    });
      // `logLevel( fpu, 0, $format("FPU: op1:%h op2:%h op3:%h",operand1,operand2,operand3))
      // `logLevel( fpu, 0, $format("FPU: opcode:%b f7:%h f3:%b imm:%h issp:%b", opcode, funct7,
      //                                                                          funct3,imm, issp))
    endmethod
    
    method XBoxOutput get_result;
    let res_ = rg_result;
     return res_ ;
	endmethod

    method Action flush;
		  wr_flush<=True;
        rocc_accel.flush();
	endmethod

endmodule
endpackage
