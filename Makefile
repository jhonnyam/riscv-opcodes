EXTENSIONS := "rv*" "unratified/rv*"
ISASIM_H := ../riscv-isa-sim/riscv/encoding.h
PK_H := ../riscv-pk/machine/encoding.h
ENV_H := ../riscv-tests/env/encoding.h
OPENOCD_H := ../riscv-openocd/src/target/riscv/encoding.h
INSTALL_HEADER_FILES := $(ISASIM_H) $(PK_H) $(ENV_H) $(OPENOCD_H)
RV_IMAFDZicsr_Zifencei = rv_a rv_m rv_i rv_f rv_d rv_zicsr rv_zifencei rv32_c rv32_i
RV_G = $(RV_IMAFDZicsr_Zifencei)
RV_GC := $(RV_G) rv_c rv32_c
BUILD_DIR := ./build

default: everything

.PHONY : everything
everything:
	@./parse.py -c -go -chisel -sverilog -rust -latex -spinalhdl $(EXTENSIONS)

.PHONY : encoding.out.h
encoding.out.h:
	@./parse.py -c rv* unratified/rv_* unratified/rv32* unratified/rv64*

.PHONY : inst.chisel
inst.chisel:
	@./parse.py -chisel $(EXTENSIONS)

.PHONY : inst.go
inst.go:
	@./parse.py -go $(EXTENSIONS)

.PHONY : latex
latex:
	@./parse.py -latex $(EXTENSIONS)

.PHONY : inst.sverilog
inst.sverilog:
	@./parse.py -sverilog $(EXTENSIONS)

.PHONY : inst.rs
inst.rs:
	@./parse.py -rust $(EXTENSIONS)

.PHONY : clean
clean:
	rm -f inst* priv-instr-table.tex encoding.out.h rv_g

.PHONY : install
install: everything
	set -e; for FILE in $(INSTALL_HEADER_FILES); do cp -f encoding.out.h $$FILE; done

.PHONY: instr-table.tex
instr-table.tex: latex

.PHONY: priv-instr-table.tex
priv-instr-table.tex: latex

.PHONY: inst.spinalhdl
inst.spinalhdl:
	@./parse.py -spinalhdl $(EXTENSIONS)

rv_g: $(RV_GC)
	cat $^ > $@

.PHONY: vsim.radix
vsim.radix: $(EXTENSIONS)
	@./parse.py -radix $(EXTENSIONS)
