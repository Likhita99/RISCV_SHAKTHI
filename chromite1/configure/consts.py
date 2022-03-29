# See LICENSE.incore for license details

length_check_fields=['reset_pc', 'physical_addr_size']

bsc_cmd = '''bsc -u -verilog -elab -vdir {0} -bdir {1} -info-dir {1} \
+RTS -K40000M -RTS -check-assert  -keep-fires \
-opt-undetermined-vals -remove-false-rules -remove-empty-rules \
-remove-starved-rules -remove-dollar -unspecified-to X -show-schedule \
-show-module-use {2}'''

bsc_defines = ''

verilator_cmd = ''' -O3 -LDFLAGS "-static" --x-assign fast \
 --x-initial fast --noassert sim_main.cpp --bbox-sys -Wno-STMTDLY \
 -Wno-UNOPTFLAT -Wno-WIDTH -Wno-lint -Wno-COMBDLY -Wno-INITIALDLY \
 --autoflush {0} {1} --threads {2} -DBSV_RESET_FIFO_HEAD \
 -DBSV_RESET_FIFO_ARRAY --output-split 20000 \
 --output-split-ctrace 10000'''

makefile_temp='''
VERILOGDIR:={0}

BSVBUILDDIR:={1}

BSVOUTDIR:={2}

BSCCMD:={3}

BSC_DEFINES:={4}

BSVINCDIR:={5}

BS_VERILOG_LIB:={6}lib/Verilog/

TOP_MODULE:={7}

TOP_DIR:={8}

TOP_FILE:={9}

VERILATOR_FLAGS:={10}

VERILATOR_SPEED:={11}

XLEN:={12}

TOP_BIN={13}

include depends.mk
'''

dependency_yaml='''
cache_subsystem:
  url: https://gitlab.com/incoresemi/blocks/cache_subsystem
  checkout: 1.0.2
common_bsv:
  url: https://gitlab.com/incoresemi/blocks/common_bsv
  checkout: master
fabrics:
  url: https://gitlab.com/incoresemi/blocks/fabrics
  checkout: 1.1.4
bsvwrappers:
  url: https://gitlab.com/incoresemi/blocks/bsvwrappers
  checkout: master
devices:
  url: https://gitlab.com/incoresemi/blocks/devices
  checkout: 1.5.1
verification:
  url: https://gitlab.com/shaktiproject/verification_environment/verification
  checkout: 4.0.0
  recursive: True
  patch:
    - [riscv-tests/env , verification/patches/riscv-tests-shakti-signature.patch]
benchmarks:
  url: https://gitlab.com/incoresemi/core-generators/benchmarks
  checkout: master
'''
