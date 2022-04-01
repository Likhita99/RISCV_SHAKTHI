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
	method Action ma_inputs(Bit#(XLEN) operand1, Bit#(XLEN) operand2, Bit#(7) funct7, Bit#(3) funct3);
	method XBoxOutput mv_output;
    // method Action flush;
endinterface

(*synthesize*)
module mk_rocc(Ifc_rocc);

  Ifc_accum rocc_accel <- mkaccum();
    Reg#(Bool)  rg_valid <- mkDReg(False);

  // =============================================

    method Action ma_inputs(Bit#(XLEN) operand1, Bit#(XLEN) operand2, Bit#(7) funct7, Bit#(3) funct3);
        if(funct7[6:2]==`Accum_NoResp_f7) begin
            rocc_accel._arg1(operand1,operand2);
            // $display("in Accum_NoResp_f7 %d %d",operand1,operand2);
		end
        else if(funct7[6:2] == `Rd_Accum_f7) begin
            // $display("in Rd_Accum_f7");
            rg_valid <= True;
		end
        else if(funct7[6:2] == `Accum_resp_f7) begin
            rocc_accel._arg1(operand1,operand2);
            rg_valid <= True;
            // $display("in Accum_resp_f7");
		end
        else if(funct7[6:2] == `Arg_Noresp_f7) begin
            rocc_accel._arg2(operand1,operand2);
            // $display("in Arg_Noresp_f7");
        end
        else begin
            rocc_accel.flush();
            // $display("in flush");
		end
    endmethod
    
    method XBoxOutput mv_output;
        return XBoxOutput{valid: rg_valid, data:rocc_accel.mv_output, fflags:0};
	endmethod

endmodule
endpackage
