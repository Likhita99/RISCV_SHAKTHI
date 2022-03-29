
.. _debug:

#####
Debug
#####

This chapter describes the operation of the debug hardware, which
follows *The RISC-V Debug Specification, version 0.14*.

Hart Debug CSRs
===============

This section describes the hart debug registers which are mapped into the CSR space as 
follows:

.. tabularcolumns:: |l|l|L|

.. _dcsr_reg:

.. table:: Hart debug registers

  ======= ========================================
  Address Name
  ======= ========================================
  0x7b0   Debug Control and Status ``(dcsr)``
  0x7b1   Debug PC ``(dpc)``
  0x7b2   Debug Scratch Register 0 ``(dscratch0)``
  0x7b3   Debug Scratch Register 1 ``(dscratch1)``
  0x7c0   Debug Trap Vector ``(dtvec)``
  ======= ========================================

The ``dcsr``, ``dpc``, and ``dscratch`` registers are only accessible in debug
mode.

Debug Control and Status Register ``(dcsr)``
--------------------------------------------

This register gives information about debug capabilities and status.
Its detailed functionality is described in *The RISC-V Debug
Specification 0.14*.

Debug PC ``(dpc)``
------------------


Upon entry to debug mode, *dpc* is updated with the virtual address of the next instruction to be
executed. When resuming, the hart’s PC is updated to the virtual address stored in dpc. A debugger may
write *dpc* to change where the hart resumes. Its detailed functionality is described in *The RISC-V Debug
Specification version 0.14*.

Debug Scratch dscratch ``(dscratch)``
-------------------------------------

This register is generally reserved for use by Debug module in order to
save registers needed by the code in Debug ROM. The debugger may use
it as described in *The RISC-V Debug Specification, version 0.14*.

Debug Trap Vector ``(dtvec)``
-----------------------------

This is a non-standard csr which points to the address to which the PC should jump to
when the debugger is requesting the hart to enter debug mode. At reset it will point to 
256.

Debug Memory Map
================

This instance of the debug module does not have any program buffer. However, there
exists a debug self loop of 3 instructions located at address 
256.


