.. _pmp:


################################
Physical Memory Protection (PMP)
################################

The Physical Memory Protection unit is compliant with the *RISC-V Instruction Set
Manual, Volume II: Privileged Architecture, Version 1.11*. The unit provides machine-mode 
controlled registers to allow physical memory access privileges (read, write, execute) to be 
specified for each physical memory region. The hart supports upto 4 
regions 

Overlapping regions are permitted and region locking is also supported. Once a
region is locked, further writes to the CSRs are ignored by the core. The locked
entries can only be unlocked via a reset of the hart. 

.. note:: When a region is locked, the read/write/execute permissions are
   enforced onto machine mode accesses as well.

PMP Granularity
^^^^^^^^^^^^^^^

The PMP granularity parameter is used to reduce the size of the address matching comparators by 
increasing the minimum region size. 
The minimum granularity is 8 bytes and thus NA4 is not a valid option.
This choice has been made to reduce the overheads of checking homogeneity of the access.

