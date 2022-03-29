//See LICENSE.iitm for license details
/* 

Author: Neel Gala
Email id: neelgala@gmail.com
Details:

--------------------------------------------------------------------------------------------------
*/
package Soc;
  
  import Clocks           :: *;
  import Connectable:: *;
  import GetPut:: *;
  import Vector::*;

  // project related imports
	import Semi_FIFOF       :: * ;
	import axi4             :: * ;
	import apb              :: * ;
	import bridges          :: * ;
  import ccore            :: * ;
  import ccore_types      :: * ;
  import DCBus            :: * ;

  // peripheral imports
  import uart             :: * ;
  import clint            :: * ;
  import sign_dump        :: * ;
  import ram2rw           :: * ;
  import rom              :: * ;
  import mem_config       :: * ;

  import riscv_debug_types::*;                                                                          
  import debug_loop::*;
  `include "ccore_params.defines"
  `include "Soc.defines"

  // ------------------------ axi4 fabric related instantiation ----------------------------------
  typedef 0 Sign_master_num;
  typedef (TAdd#(Sign_master_num, 1)) Mem_master_num;
  typedef (TAdd#(Mem_master_num, 1)) Fetch_master_num;
  typedef (TAdd#(Fetch_master_num, `ifdef debug 1 `else 0 `endif )) Debug_master_num;
  typedef (TAdd#(Debug_master_num, 1)) Num_Masters;

  `define read_slave  'b10111 // no read on sign_dump
  `define write_slave 'b11101 // no write on bootrom
 
  function Bit#(TLog#(`Num_Slaves)) fn_mm_axi4_rd (Bit#(`paddr) addr);
    if(addr >= `MemoryBase && addr<= `MemoryEnd)
      return `Memory_slave_num;
    else if(addr>= `BootRomBase && addr<= `BootRomEnd)
      return `BootRom_slave_num;
    else if ( (addr>= `UartBase && addr<= `UartEnd) || (addr>= `ClintBase && addr<= `ClintEnd) 
                || (addr >= `DebugBase && addr <= `DebugEnd) )
      return `APB_cluster_slave_num;
    else
      return `Err_slave_num;
  endfunction:fn_mm_axi4_rd
  
  function Bit#(TLog#(`Num_Slaves)) fn_mm_axi4_wr (Bit#(`paddr) addr);
    if(addr >= `MemoryBase && addr<= `MemoryEnd)
      return `Memory_slave_num;
    else if ( (addr>= `UartBase && addr<= `UartEnd) || (addr>= `ClintBase && addr<= `ClintEnd) )
      return `APB_cluster_slave_num;
    else if(addr>= `SignBase && addr<= `SignEnd)
      return `Sign_slave_num;
    else
      return `Err_slave_num;
  endfunction:fn_mm_axi4_wr

  function Bit#(2) fn_mm_apb(Bit#(`paddr) addr);
    if (addr >= `UartBase  && addr <= `UartEnd)
      return `Uart_slave_num;
    else if( addr >= `ClintBase && addr <= `ClintEnd)
      return `Clint_slave_num;
    else if( addr >= `DebugBase && addr <= `DebugEnd)
      return `Debug_slave_num;
    else
      return `Apb_err_slave_num;
  endfunction
  // ---------------------------------------------------------------------------------------------

  interface Ifc_Soc;
  `ifdef rtldump
    interface Get#(DumpType) io_dump;
  `endif
    interface RS232#(16) uart_io;
  `ifdef debug
    interface Ifc_hart_to_debug debug_server;
		interface Ifc_axi4_slave#(IDWIDTH, `paddr, ELEN, USERSPACE) master_debug;
  `endif
  endinterface

  (*synthesize*)
  module mkuart(Ifc_uart_apb#(`paddr, 32, USERSPACE, 16));
  	let clk <-exposeCurrentClock;
  	let reset <-exposeCurrentReset;
    let ifc();
    mkuart_apb#(5, `UartBase, clk, reset) _temp(ifc);
    return ifc;
  endmodule:mkuart
  (*synthesize*)
  module mkclint(Ifc_clint_apb#(`paddr, 32, USERSPACE, 8, 1));
  	let clk <-exposeCurrentClock;
  	let reset <-exposeCurrentReset;
    let ifc();
    mkclint_apb#(`ClintBase, clk, reset) _temp(ifc);
    return ifc;
  endmodule:mkclint
  (*synthesize*)
  module mkdebug_loop(Ifc_debug_loop_apb#(`paddr, 32, USERSPACE));
  	let clk <-exposeCurrentClock;
  	let reset <-exposeCurrentReset;
    let ifc();
    mkdebug_loop_apb#(`DebugBase, clk, reset) _temp(ifc);
    return ifc;
  endmodule:mkdebug_loop
  (*synthesize*)
  module mkbootrom(Ifc_rom_axi4#(IDWIDTH, `paddr, ELEN, USERSPACE, 8192, ELEN, 1));
  	let clk <-exposeCurrentClock;
  	let reset <-exposeCurrentReset;
    let ifc();
    mk_rom_axi4#(`BootRomBase, replicate("boot.mem")) _temp(ifc);
    return ifc;
  endmodule:mkbootrom
  (*synthesize*)
  module mkbram(Ifc_ram2rw_axi4#(IDWIDTH, `paddr, ELEN, USERSPACE, 4194304, ELEN, 1));
  	let clk <-exposeCurrentClock;
  	let reset <-exposeCurrentReset;
    let ifc();
    mk_ram2rw_axi4#(`MemoryBase, replicate(tagged File "code.mem"),"nc") _temp(ifc);
    return ifc;
  endmodule:mkbram

  (*synthesize*)
  module mkaxi2apb_bridge(Ifc_axi2apb#(IDWIDTH, `paddr, ELEN, `paddr, 32, USERSPACE));
    let ifc();
    mkaxi2apb _temp(ifc);
    return ifc();
  endmodule:mkaxi2apb_bridge

  (*synthesize*)
  module mkSoc(Ifc_Soc);
    let curr_clk<-exposeCurrentClock;
    let curr_reset<-exposeCurrentReset;

    Ifc_axi4_fabric #(Num_Masters, `Num_Slaves, IDWIDTH, `paddr, ELEN, USERSPACE)
        axi4fabric <- mkaxi4_fabric_2(fn_mm_axi4_rd, fn_mm_axi4_wr, `read_slave, 
                                      `write_slave, '1, '1);

    Ifc_apb_fabric #(`paddr, 32, USERSPACE, 4) apbfabric <- mkapb_fabric(fn_mm_apb);

    let ccore        <- mkccore_axi4(`resetpc, 0);
    let signature    <- mksign_dump;
	  let main_memory  <- mkbram;
	  let bootrom      <- mkbootrom;
	  let debug_memory <- mkdebug_loop;
    let uart         <- mkuart;
    let clint        <- mkclint;
    let bridge       <- mkaxi2apb_bridge;

	  Ifc_axi4_slave #(IDWIDTH,`paddr, ELEN, USERSPACE) axi4_err <- mkaxi4_err_2;
	  Ifc_apb_slave  #(`paddr, 32, USERSPACE) apb_err <- mkapb_err;

  `ifdef supervisor
    mkConnection(ccore.sb_plic_seip,1'b0);
  `endif
    mkConnection(ccore.sb_plic_meip,1'b0);

    // ------------------------------------------------------------------------------------------//
   	mkConnection(ccore.master_d,	 axi4fabric.v_from_masters[valueOf(Mem_master_num)]);
   	mkConnection(ccore.master_i,   axi4fabric.v_from_masters[valueOf(Fetch_master_num)]);
   	mkConnection(signature.master, axi4fabric.v_from_masters[valueOf(Sign_master_num) ]);

    mkConnection (axi4fabric.v_to_slaves [`APB_cluster_slave_num] , bridge.axi4_side);
    mkConnection (apbfabric.frm_master                            , bridge.apb_side);
    mkConnection (axi4fabric.v_to_slaves [`Sign_slave_num ]       , signature.slave);
    mkConnection (axi4fabric.v_to_slaves [`Err_slave_num ]        , axi4_err);
  	mkConnection (axi4fabric.v_to_slaves [`Memory_slave_num]      , main_memory.slave);
		mkConnection (axi4fabric.v_to_slaves [`BootRom_slave_num]     , bootrom.slave);


    mkConnection (apbfabric.v_to_slaves[`Uart_slave_num]          , uart.slave);
    mkConnection (apbfabric.v_to_slaves[`Clint_slave_num]         , clint.slave);
    mkConnection (apbfabric.v_to_slaves[`Apb_err_slave_num]       , apb_err);
    mkConnection (apbfabric.v_to_slaves[`Debug_slave_num ]        , debug_memory.slave);

    // sideband connection
    mkConnection(ccore.sb_clint_msip, clint.device.sb_clint_msip);
    mkConnection(ccore.sb_clint_mtip, clint.device.sb_clint_mtip);
    mkConnection(ccore.sb_clint_mtime,clint.device.sb_clint_mtime);

  `ifdef rtldump
    interface io_dump= ccore.io_dump;
  `endif
    interface uart_io=uart.device.io;
  `ifdef debug
    interface debug_server = ccore.debug_server;
    interface master_debug= axi4fabric.v_from_masters[valueOf(Debug_master_num)];
  `endif
  endmodule: mkSoc
endpackage: Soc
