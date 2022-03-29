
###############
Debug Interface
###############

The system includes a JTAG Debug Transport Module (DTM)
described in *The RISC-V Debug Specification, version 0.14*. This enables a
single external industry-standard 1149.1 JTAG interface to test and
debug the system. The JTAG interface is directly connected to input pins.

Resetting Logic
===============

The JTAG TAP can be reset by asserting the TRST. This does not reset the debug module.
The Debug module is reset by asserting the global reset signal. The debug module 
can also reset the rest of the SoC, including the core, using the ``ndmreset`` bit of the
``dmcontrol`` register within the debug module. Please refer to *The RISC-V Debug Specification,
version 0.14* for more information.

JTAG Clocking
=============

The JTAG TAP operates on its own `tck` clock domain. The maximum frequency of operation
of the TAP has been constrained to 15MHz.

JTAG Debug Commands
===================

The JTAG DEBUG commands gives access to the debug module by connecting the debug scan register between `TDI` and
`TDO`.

The debug scan register includes a 2-bit opcode field, a 7-bit debug module address field, and 
a 32-bit data field to allow various memory-mapped read/write operations to be specified with a single
scan of the debug scan register.

These are described in *The RISC-V Debug Specification, version 0.14*.


Using the BSCANE2 primitive
===========================

In Xilinx 7 series FPGAs, the BSCANE2 primitive allows access between the internal FPGA 
logic and the JTAG Boundary Scan logic controller. This allows for communication between the 
internal running design and the dedicated JTAG pins of the FPGA, the Test Access Port (TAP).
Each BSCANE2 primitive supports one USER instruction space. 

In our design we use the USER space to tunnel debug commands to the debug module. This approach
avoids having to instantiate a separate JTAG tap and re-uses the existing TAP available on the FPGA
itself. Additionally, the BSCANE2 primitive is also supported by openocd.



