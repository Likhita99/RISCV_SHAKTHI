include ./makefile.inc

# ------------------------------------- Makefile TARGETS ----------------------------------------- #
default: generate_verilog link_verilator generate_boot_files
gdb: generate_verilog link_verilator_gdb generate_boot_files
MOREDEFINES=$(addprefix -D , $(BSC_DEFINES))

%.bo:
	$(info building $@)
	@$(BSCCMD) $(MOREDEFINES) -p $(BSVINCDIR) $<

.PHONY: generate_verilog
generate_verilog: $(BSVBUILDDIR)/$(TOP_BIN)


.PHONY: link_verilator
link_verilator: ## Generate simulation executable using Verilator
	@echo "Linking $(TOP_MODULE) using verilator"
	@mkdir -p $(BSVOUTDIR) obj_dir
	@echo "#define TOPMODULE V$(TOP_MODULE)" > sim_main.h
	@echo '#include "V$(TOP_MODULE).h"' >> sim_main.h
	verilator $(VERILATOR_FLAGS) --cc $(TOP_MODULE).v -y $(PWD)/$(VERILOGDIR) \
		-y $(BS_VERILOG_LIB) -y $(PWD)/bsvwrappers/common_lib/ --exe
	@ln -f -s ../test_soc/sim_main.cpp obj_dir/sim_main.cpp
	@ln -f -s ../sim_main.h obj_dir/sim_main.h
	make $(VERILATOR_SPEED) VM_PARALLEL_BUILDS=1 -j4 -C obj_dir -f V$(TOP_MODULE).mk
	@cp obj_dir/V$(TOP_MODULE) $(BSVOUTDIR)/chromite_core

.PHONY: link_verilator_gdb
link_verilator_gdb: ## Generate simulation executable using Verilator and VPI for GDB
	@echo "Linking Verilator With the remotebitbang Vpi"
	@mkdir -p $(BSVOUTDIR) obj_dir
	@echo "#define TOPMODULE V$(TOP_MODULE)_edited" >sim_main.h
	@echo '#include "V$(TOP_MODULE)_edited.h"' >> sim_main.h
	@sed  -f devices/jtagdtm/sed_script.txt  $(VERILOGDIR)/$(TOP_MODULE).v > tmp1.v
	@cat  devices/jtagdtm/verilator_config.vlt \
	      devices/jtagdtm/vpi_sv.v \
	      tmp1.v                         > $(VERILOGDIR)/$(TOP_MODULE)_edited.v
	@rm   -f  tmp1.v
	verilator $(VERILATOR_FLAGS) --threads-dpi all --cc $(TOP_MODULE)_edited.v --exe sim_main.cpp devices/jtagdtm/remotebitbang.c -y $(VERILOGDIR) -y $(BS_VERILOG_LIB) -y bsvwrappers/common_lib/ 
	@ln -f -s ../test_soc/sim_main.cpp obj_dir/sim_main.cpp
	@ln -f -s ../sim_main.h obj_dir/sim_main.h
	@ln -f -s ./devices/jtagdtm/remotebitbang.c obj_dir/remotebitbang.c
	@echo "INFO: Linking verilated files"
	make $(VERILATOR_SPEED) VM_PARALLEL_BUILDS=1 -j4 -C obj_dir -f V$(TOP_MODULE)_edited.mk
	@cp obj_dir/V$(TOP_MODULE)_edited $(BSVOUTDIR)/chromite_core
	@cp test_soc/gdb_setup/code.mem$(XLEN) $(BSVOUTDIR)/code.mem
	@echo Linking finished


.PHONY: simulate
simulate: ## Simulate the 'chromite_core' executable
	@echo Simulation...
	@exec ./$(BSVOUTDIR)/chromite_core > log
	@echo Simulation finished

.PHONY: link_vcs
link_vcs: ## Generate simulation executable using Synopsys VCS
	@rm -rf $(BSVOUTDIR)
	@mkdir -p $(BSVOUTDIR)
	vcs -LDFLAGS -Wl,--no-as-needed -l vcs_compile.log -sverilog +vpi +v2k -lca +define+TOP=$(TOP_MODULE) $(VCS_MACROS) \
	+define+BSV_TIMESCALE=1ns/1ps +cli+4 +libext+.v +notimingcheck \
	-y $(VERILOGDIR)/ \
	${BS_VERILOG_LIB}/main.v -o chromite_core
	@mv csrc chromite_core* $(BSVOUTDIR)

.PHONY: link_ncverilog
link_ncverilog: ## Generate simulation executable using Cadence NCVerilog
	@echo "Linking $(TOP_MODULE) using ncverilog..."
	@rm -rf work include $(BSVOUTDIR)/*
	@mkdir -p $(BSVOUTDIR) work
	@echo "define work ./work" > cds.lib
	@echo "define WORK work" > hdl.var
	@ncvlog -64BIT -sv -cdslib ./cds.lib -hdlvar ./hdl.var +define+TOP=$(TOP_MODULE) $(VCS_MACROS)\
	${BS_VERILOG_LIB}/main.v \
	-y $(VERILOGDIR)/ \
	-y bsvwrappers/common_lib \
	-y ${BS_VERILOG_LIB}/
	@ncelab $(NC_COV_ARGS) -cdslib ./cds.lib -hdlvar ./hdl.var work.main -timescale 1ns/1ps
	@echo 'ncsim -cdslib ./cds.lib -hdlvar ./hdl.var work.main #> /dev/null' > $(BSVOUTDIR)/chromite_core
	@mv work cds.lib hdl.var $(BSVOUTDIR)/
	@chmod +x $(BSVOUTDIR)/chromite_core
	@echo Linking finished

.PHONY: link_ncverilog_openocd
link_ncverilog_openocd: ## Generate simulation executable using Synopsys VCS with VPI for GDB
	@echo "Linking $(TOP_MODULE) using ncverilog..."
	@rm -rf work include bin/work
	@mkdir -p bin
	@mkdir work
	@echo "Building RBB VPI"
	@echo "define work ./work" > cds.lib
	@echo "define WORK work" > hdl.var
	@ncvlog -64BIT -sv -cdslib ./cds.lib -hdlvar ./hdl.var +define+TOP=$(TOP_MODULE) \
	${BS_VERILOG_LIB}/main.v \
	-y $(VERILOGDIR)/ \
	-y bsvwrappers/common_lib \
	-y ${BS_VERILOG_LIB}/
	@ncelab -64BIT -cdslib ./cds.lib -hdlvar ./hdl.var work.main -loadvpi rbb_vpi.so: -timescale 1ns/1ps
	@echo 'ncsim -64BIT -cdslib ./cds.lib -hdlvar ./hdl.var -loadvpi rbb_vpi.so: work.main #> /dev/null' > $(BSVOUTDIR)/chromite_core
	@mv ./*.so $(BSVOUTDIR)/
	@mv work cds.lib hdl.var $(BSVOUTDIR)/
	@chmod +x $(BSVOUTDIR)/chromite_core
	@echo Linking finished

.PHONY: link_irun
link_irun:
	@echo "Linking $(TOP_MODULE) using irun...."
	@rm -rf work include $(BSVOUTDIR)/*
	@mkdir -p $(BSVOUTDIR) work
	@echo "define work ./work" > cds.lib
	@echo "define WORK work" > hdl.var
	@irun -define TOP=mkTbSoC -timescale 1ns/1ps $(VERILOGDIR)/main.v \
	-y $(VERILOGDIR)/ \
	-y bsvwrappers/common_lib \
	-y ${BS_VERILOG_LIB}/ +libext+.v 

.PHONY: link_msim
link_msim: ## Generate simulation executable using Mentor's ModelSim tool
	@echo "Linking $(TOP_MODULE) using modelsim..."
	@rm -rf work* $(BSVOUTDIR)/*
	@mkdir -p $(BSVOUTDIR)
	vlib work
	vlog -work work +libext+.v+.vqm -y $(VERILOGDIR) -y ${BS_VERILOG_LIB} \
		+define+TOP=$(TOP_MODULE) $(VCS_MACROS) ${BS_VERILOG_LIB}/main.v \
		./$(VERILOGDIR)/$(TOP_MODULE).v  > compile_log
	mv compile_log ./$(BSVOUTDIR)
	mv work ./$(BSVOUTDIR)
	echo 'vsim -quiet -novopt -lib work -do "run -all; quit" -c main' > $(BSVOUTDIR)/chromite_core
	@chmod +x $(BSVOUTDIR)/chromite_core
	@echo Linking finished

.PHONY: hello
hello: 
	@echo "Running hello world sim"
	@cd benchmarks; make hello
	@cp benchmarks/output/code.mem $(BSVOUTDIR)/
	@echo "Starting Simulation"
	@cd $(BSVOUTDIR); ./chromite_core
	@cat $(BSVOUTDIR)/app_log

.PHONY: dhrystone
dhrystone: 
	@echo "Running dhrystone sim"
	@cd benchmarks; make dhrystone ITERATIONS=10000
	@cp benchmarks/output/code.mem $(BSVOUTDIR)/
	@echo "Starting Simulation"
	@cd $(BSVOUTDIR); ./chromite_core
	@cat $(BSVOUTDIR)/app_log

.PHONY: coremarks
coremarks: 
	@echo "Running coremarks sim"
	@cd benchmarks; make coremarks ITERATIONS=35
	@cp benchmarks/output/code.mem $(BSVOUTDIR)/
	@echo "Starting Simulation"
	@cd $(BSVOUTDIR); ./chromite_core
	@cat $(BSVOUTDIR)/app_log

.PHONY: regress
regress: ## To run regressions on the core.
	@SHAKTI_HOME=$$PWD perl -I$(SHAKTI_HOME)/verification/verif-scripts $(SHAKTI_HOME)/verification/verif-scripts/makeRegress.pl $(opts)

.PHONY: test
test: ## To run a single riscv-test on the core.
	@SHAKTI_HOME=$$PWD CONFIG_LOG=0 perl -I$(SHAKTI_HOME)/verification/verif-scripts $(SHAKTI_HOME)/verification/verif-scripts/makeTest.pl $(opts)

.PHONY: torture
torture: ## To run riscv-tortur on the core.
	@SHAKTI_HOME=$$PWD perl -I$(SHAKTI_HOME)/verification/verif-scripts $(SHAKTI_HOME)/verification/verif-scripts/makeTorture.pl $(opts)

.PHONY: aapg
aapg: ## to generate and run aapf tests
	@SHAKTI_HOME=$$PWD perl -I$(SHAKTI_HOME)/verification/verif-scripts $(SHAKTI_HOME)/verification/verif-scripts/makeAapg.pl $(opts)

.PHONY: csmith
csmith: ## to generate and run csmith tests
	@SHAKTI_HOME=$$PWD perl -I$(SHAKTI_HOME)/verification/verif-scripts $(SHAKTI_HOME)/verification/verif-scripts/makeCSmith.pl $(opts)

.PHONY: generate_boot_files
generate_boot_files: ## to generate boot files for simulation
	@echo "XLEN=$(XLEN)" > boot/Makefile.inc
	@mkdir -p bin
	@cd boot/; make;
	@cp boot/boot.hex bin/boot.mem

.PHONY: yml
yml:
	@SHAKTI_HOME=$$PWD python3 $(SHAKTI_HOME)/verification/verif-scripts/gen_yml.py $(opts)

.PHONY: clean
clean:
	rm -rf $(BSVBUILDDIR)/* *.log $(BSVOUTDIR)/* obj_dir $(VERILOGDIR)/*
	rm -f *.jou rm *.log *.mem log sim_main.h cds.lib hdl.var

clean_verif:
	rm -rf verification/workdir/*
	rm -rf verification/riscv-torture/output/riscv-torture

restore: clean_verilog
