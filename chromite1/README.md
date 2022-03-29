<div class="title-block" style="text-align: center;" align="center">

[![License](https://img.shields.io/badge/License-BSD%203--Clause-blue.svg)](LICENSE)
# Chromite Core Generator
</div>

## What is Chromite

Chromite is an open-source core generator, **based on the** [SHAKTI C Class](https://gitlab.com/shaktiproject/cores/c-class)
**core developed at PS CDISHA at the Indian Institute of Technology Madras** . The core generator emits synthesizable, production quality RTL
of processors based on the open [RISC-V ISA](https://riscv.org/). The core generator can produce
variants of a commercial grade 6-stage in-order core supporting the RV[64/32]GCSUN (or its subsets)
extensions of the RISC-V ISA, from the same high-level source code. Chromite leverages the high 
level abstraction offered by [Bluespec System Verilog](https://github.com/B-Lang-org) to build highly parameterized, compact and powerful library components (like 
arithmetic units, branch predictors, caches, mmu, etc) that can be seamlessly integrated to create a solution catered to
your needs. 


## License
All of the source code available in this repository is under the BSD license. 
Please refer to LICENSE.\* files for more details.

## Documentation

The HTML version of the Manual is hosted: [here](https://chromite.readthedocs.io)

The PDF version of the Manual can be downloaded from: [here](https://gitlab.com/incoresemi/core-generators/chromite/-/jobs/artifacts/master/raw/chromite_coregen.pdf?job=release) 
