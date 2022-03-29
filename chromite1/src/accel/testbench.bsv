// //*************Test bench******************//
/*==== Project imports ==== */
`include "ccore_params.defines"
`include "accel.defines"
`include "Logger.bsv"
import ccore_types::*;
import accel :: * ;
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

(*synthesize*)
module mkTb_rocc(Empty);

	Reg#(Bit#(32)) rg_clock <-mkReg(0);
    Reg#(Bit#(ELEN)) rg__operand1 <- mkReg('d10);
    Reg#(Bit#(ELEN)) rg__operand2 <- mkReg('d20);
    Reg#(Bit#(4)) opcode <- mkReg(4'b0100);
    Reg#(Bit#(3)) funct3 <- mkReg(1);

	// Ifc_fpu_sqrt#(32,23,8) square_root <- mkfpu_sqrt;
    Ifc_rocc accumulation <- mk_rocc();

	rule rl_clock;
        rg_clock<=rg_clock+1;
        if(rg_clock=='d90) begin
    	    $finish(0);
        end
	endrule

    rule first_input(rg_clock==1);
        accumulation._start(rg__operand1, rg__operand2, opcode, 7'b0000100, funct3); // clear the accumulator
    endrule	
    rule give__operand1ut(rg_clock==10);
        accumulation._start(rg__operand1, rg__operand2, opcode, 7'b0100000, funct3); // read the accumulator value
    endrule
    rule give__operand2ut(rg_clock==20);
        accumulation._start('d20, rg__operand2, opcode, 7'b1000000, funct3); // acc=acc+operand1 and return acc value
    endrule
    rule give__operand3ut(rg_clock==30);
        accumulation._start('d20, rg__operand2, opcode, 7'b1000000, funct3); // acc=acc+operand1 and return acc value
    endrule
    rule give__operand4ut(rg_clock==40);
        accumulation._start('d10, rg__operand2, opcode, 7'b0001000, funct3); // acc=acc+operand1
    endrule
    rule give__operand5ut(rg_clock==50);
        accumulation._start(rg__operand1, rg__operand2, opcode, 7'b0100000, funct3); // read the accumulator value
    endrule
    rule give__operand6ut(rg_clock==60);
        accumulation._start('d10, 'd60, opcode, 7'b0010000, funct3); // acc=acc+operand1+operand2
    endrule
    rule give__operand7ut(rg_clock==70);
        accumulation._start(rg__operand1, rg__operand2, opcode, 7'b0100000, funct3); // read the accumulator value
    endrule

	rule get_output(accumulation.get_result.valid);
        $display("taking output at %0d", rg_clock);
		$display("Output= %d", accumulation.get_result.data);
	endrule
    
endmodule
