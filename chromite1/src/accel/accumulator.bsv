package accumulator;
/*==== Project imports ==== */
`include "ccore_params.defines"
`include "accel.defines"
`include "Logger.bsv"
import ccore_types::*;
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

interface Ifc_accum;							//interface to module mk_accumulator
	method Action _arg1(Bit#(ELEN) operand1, Bit#(ELEN) operand2);
    method Action _arg2(Bit#(ELEN) operand1, Bit#(ELEN) operand2);
	method Bit#(ELEN) get_result();
    method Action flush;
endinterface

interface Ifc_accumulator;							//interface to module mk_accumulator
	method Action _arg1(Bit#(ELEN) operand1, Bit#(ELEN) operand2);
    method Action _arg2(Bit#(ELEN) operand1, Bit#(ELEN) operand2);
	method Bit#(ELEN) get_result();
    method Action flush;
endinterface

//(*synthesize*)
module mkaccum(Ifc_accum);
    Wire# (Bit#(ELEN)) ff_final_out   <- mkReg(0);
    // wr_final_out <= Floating_output{ final_result:lv_final_output ,fflags:0};

    method Action _arg1(Bit#(ELEN) operand1, Bit#(ELEN) operand2);
        ff_final_out <= ff_final_out + truncate(operand1);
        $display("ff_final_out Output with arg1= %d", ff_final_out + truncate(operand1));
    endmethod
    method Action _arg2(Bit#(ELEN) operand1, Bit#(ELEN) operand2);
        ff_final_out <= ff_final_out + truncate(operand1) + truncate(operand2);
        $display("ff_final_out Output with arg2= %d", ff_final_out + truncate(operand1) + truncate(operand2));
    endmethod
    method Bit#(ELEN) get_result();
        // $display("ff_final_out Output with get_result= %d", ff_final_out);
        return ff_final_out;
        // return 0;
    endmethod
    method Action flush;
        ff_final_out <= 0;
        $display("ff_final_out Output with flush= %d", 0);
    endmethod
endmodule

(*synthesize*)
module mkaccumulator(Ifc_accumulator);
    Ifc_accum uut <- mkaccum();
    method Action _arg1(Bit#(ELEN) operand1, Bit#(ELEN) operand2);
        uut._arg1(operand1, operand2);
    endmethod
    method Action _arg2(Bit#(ELEN) operand1, Bit#(ELEN) operand2);
        uut._arg2(operand1, operand2);
    endmethod
	//Output Methods
	method Bit#(ELEN) get_result();
        // $display("ff_final_out Output with get_result= %d", uut.get_result());
        return uut.get_result();
    endmethod
    method Action flush;
        uut.flush();
    endmethod
endmodule

endpackage
