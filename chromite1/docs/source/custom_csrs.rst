.. _custom_csrs:

###########
Custom CSRs
###########

The core includes the following custom CSRs implemented in the non-standard space for 
extra control and features.

.. _custom_control_csr:

custom control (0x800)
----------------------

This CSR is used to the enable or disable the caches, branch predictor and arithmetic exceptions
at run-time. Each of the above can be controlled independently of each other enabled by setting a 1
to the corresponding bit and disabled by clearing the bit to 0.

.. table:: Description of the custom control register

  ============  ===========  ============
  Bit Position  Reset Value  Description
  ============  ===========  ============
  0             1            Enable or disable the data-cache.
  1             1            Enable or disable the instruction-cache.
  2             1            Enable or disable the branch_predictor.
  ============  ===========  ============


dtvec (0x7c0)
-------------

This is an XLEN-bit read/write register which indicates the address of the debug loop when a the 
debugger halts the core. This register has the reset value of 256. 
This register can be used to carry out complex SW actions before/after entering the debug mode.

denable (0x7c1)
---------------

1-bit CSR indicating if the debugger can halt the core. This can be used to disable the debugger
from interrupting the core during critical/secure tasks.



mhpminterrupten (0x7c2) 
-----------------------

XLEN bit register following the same encoding as ``mcounteren/mcountinhibit``. A bit set to 1
indicates the an interrupt will be generated when the corresponding counter reaches the value 0.
Details of usage of this CSR are explained in detail in :numref:`daisy_chain`

