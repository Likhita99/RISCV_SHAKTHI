.. _mmu:


############################
Memory Management Unit (MMU)
############################

The reader is advised to first read the chapter on supervisor extension of the 
*RISC-V Instruction Set Manual, Volume II: Privileged Architecture, Version 1.11* to fully
comprehend the information of this chapter.

The core has a memory management unit which includes separate instruction and data TLBs. 
The core supports the sv39 virtualisation scheme of *RISC-V Instruction Set Manual, Volume II: Privileged Architecture, Version 1.11*.
This scheme supports 4KiB, 2MiB and 1GiB page sizes.
The schemse also maps 64-bit virtual/logical address to 32-bit physical address.

The core instantiates a fully-associative instruction TLB with
4 entires and another fully-associative data
TLB with 4 entries. 

.. note:: Note that the hart does not automatically set the Accessed (A) and Dirty (D) bits in the Page
  Table Entry (PTE). Instead, the MMU will raise a page fault exception for a read to a page
  with *PTE.A=0* or a write to a page with *PTE.D=0* .

When a virtual address is presented to the TLB, a look up is performed in the
same cycle to check if the corresponding PTE entry exists in the TLB. The result
of the lookup is stored in an intermediate register. On the consecutive cycle,
in case of a hit, the PTE is extracted from the TLB entry and permission checks
are performed in accordance with permission bits present in the page table entry. 
If the permissions fail then a corresponding page fault exception is raised and indicated to the
core pipeline.

In case of a miss in the TLB, the virtual address is sent to the hardware Page Table Walk (PTW) 
to fetch the corresponding page table entry from memory. The PTW now
performs multiple memory accesses via the data cache. If any of the memory accesses
cause a trap, then the corresponding access fault is raised and indicated to the
core pipeline. Once a leaf node is detected, the PTW responds to the requesting
TLB with the new PTE. The TLB then proceeds to complete the original operation.

When both the instruction and data TLB make a request to the PTW, the data TLB
gets higher priority.

.. note:: When the data TLB has made a request to the PTW, the core pipeline no
   longer has access to the data cache until the PTW operation has completed.

The MMU unit also requires a set of CSRs to operate, which are defined and
explained in the *RISC-V Instruction Set Manual, Volume II: Privileged Architecture, Version 1.11*

