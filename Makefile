################################## FUNCTIONS ###################################

define SRC_2_BIN
  $(foreach src,$(1),$(patsubst sources/%,binary/%,$(src)))
endef

define BIN_2_SRC
  $(foreach src,$(1),$(patsubst binary/%,sources/%,$(src)))
endef

# .bit is the only one really needed, we put the others in order to keep them
# after the build, for debugging purpose
define GEN_TARGETS
	$(1).bit $(1).routed.ncd $(1).ncd $(1).ngd $(1).ngc $(1).ucf $(1).prj \
		$(1).xst $(1).pcf
endef

define SIM_2_RUN
  $(foreach src,$(1),$(patsubst %.sim,%.run,$(src)))
endef

define RUN_2_SIM
  $(foreach src,$(1),$(patsubst %.run,./%.sim,$(src)))
endef

################################## STARTING RULE ###############################

all: simulations targets

################################## GLOBALS  ####################################

CORES_DIR := ./sources/cores
XILINX_SRC := $(XILINX)/verilog/src

################################## INCLUDES ####################################

# Overriden in rules.mk
TARGETS :=
SIMS :=

dir	:= sources
include	$(dir)/rules.mk

############################## SYNTHESIS RULES #################################

targets: $(TARGETS)

%.load: %.bit
	@echo [LOD] $<
	@./impact.sh $(dir $<)impact.batch $(realpath $<) && cd $(dir $<) && impact \
		-batch impact.batch &> impact.batch.out

%.bit: %.routed.ncd
	@mkdir -p $(dir $@)
	@echo [BIT] $@ \> $@.out
	@cd $(dir $@) && bitgen -g LCK_cycle:6 -g Binary:Yes -g DriveDone:Yes \
		-w $(realpath $<) $(abspath $@) $(patsubst %.bit, %.pcf, $(abspath $@)) \
		&> $(abspath $@).out

%.routed.ncd: %.ncd 
	@mkdir -p $(dir $@)
	@echo [RTE] $@ \> $@.out
	@cd $(dir $@) && par -mt 4 -ol high -w $(realpath $^) $(abspath $@) &> \
		$(abspath $@).out

%.ncd: %.ngd
	@mkdir -p $(dir $@)
	@echo [NCD] $@ \> $@.out
	@cd $(dir $@) && map -mt 4 -ol high -t 20 -w $(realpath $^) &> $(abspath \
		$@).out

%.ngd: %.ucf %.ngc
	@mkdir -p $(dir $@)
	@echo [NGD] $@ \> $@.out
	@cd $(dir $@) && ngdbuild -uc $(realpath $^) &> $(abspath $@).out

%.ngc: %.xst
	@mkdir -p $(dir $@)
	@echo [NGC] $@ \> $@.out
	@cd $(dir $@) && xst -ifn $(abspath $<) &> $(abspath $@).out

%.prj:
	@mkdir -p $(dir $@)
	@echo [PRJ] $@
	@rm -f $@
	@for i in `echo $(VERILOG)`; do \
		echo "verilog work `pwd`/$$i" >> $@; \
	done
	@for i in `echo $(VHDL)`; do \
		echo "vhdl work `pwd`/$$i" >> $@; \
	done

%.xst: %.prj
	@mkdir -p $(dir $@)
	@echo [XST] $@
	@./xst.sh $@ $(TOP) $(PKG) $(abspath $^) \
		$(abspath $(patsubst %.xst, %.ngc, $@))

%.ucf:
	@mkdir -p $(dir $@)
	@echo [UCF] $@
	@cat $^ > $@

# The project to load
load: binary/counter/system.bit
	@echo [LOD] $<
	@./impact.sh $(dir $<)impact.batch $(realpath $<) && cd $(dir $<) && impact \
		-batch impact.batch > impact.batch.out

############################# SIMULATION RULES #################################

# Iverilog simulation 
%.sim:
	@mkdir -p $(dir $@)
	@echo [VLG] $@ \> $@.out
	@iverilog -o $@ $^ \
		$(SIM_CFLAGS) -D__DUMP_FILE__=\"$(abspath $@).vcd\" &> $(abspath $@).out \
		-D__DIR__=\"$(realpath $(dir $@))\" \
		-DSIMULATION=1 \

# Post-synthesis simultation model
%_synthesis.vhd: %.ngc
	@echo [NTG] $@ \> $@.out
	@cd $(dir $@) && netgen -tm $(TOP) -ar Structure -w -ofmt vhdl -sim -w \
		$(abspath $<) $(abspath $@) &> $(abspath $@).out

%_synthesis.v: %.ngc
	@echo [NTG] $@ \> $@.out
	@cd $(dir $@) && netgen -tm $(TOP) -w -ofmt verilog -sim -w $(abspath $<) \
		$(abspath $@) &> $(abspath $@).out

# Post-translate simulation model
%_translate.vhd: %.ngd
	@echo [NTG] $@ \> $@.out
	@cd $(dir $@) && netgen -tm $(TOP) -rpw 100 -tpw 0 -ar Structure -w \
		-ofmt vhdl -sim -w $(abspath $<) $(abspath $@) &> $(abspath $@).out

%_translate.v: %.ngd
	@echo [NTG] $@ \> $@.out
	@cd $(dir $@) && netgen -tm $(TOP) -w -ofmt verilog -sim -w $(abspath $<) \
		$(abspath $@) &> $(abspath $@).out

%.pcf: %.ncd
	$(noop)

# Post-map simulation model
%_map.vhd: %.ncd %.pcf
	@echo [NTG] $@ \> $@.out
	@cd $(dir $@) && netgen -tm $(TOP) -s 3 -pcf $(abspath $(word 2, $^)) \
		-rpw 100 -tpw 0 -ar Structure -w -ofmt vhdl -sim -w \
		$(abspath $<) $(abspath $@) &> $(abspath $@).out

%_map.v: %.ncd %.pcf
	@echo [NTG] $@ \> $@.out
	@cd $(dir $@) && netgen -tm $(TOP) -s 3 -pcf $(abspath $(word 2, $^)) \
		-w -ofmt verilog -sim -w $(abspath $<) $(abspath $@) &> $(abspath $@).out

# Post-place & route static timing
%.twr: %.routed.ncd %.pcf
	@echo [TRE] $@ \> $@.out
	cd $(dir $@) && trce -v 3 -s 3 -n 3 -fastpaths -xml \
		$(abspath $(patsubst %.twr, %.twx, $@)) $(abspath $<) \
		-o $(abspath $@) $(abspath $(word 2, $^)) &> $(abspath $@).out

# Post-place & route simulation model
%_timesim.vhd: %.routed.ncd %.pcf
	@echo [NTG] $@ \> $@.out
	@cd $(dir $@) && netgen -s 3 -pcf $(abspath $(word 2, $^)) -rpw 100 -tpw 0 \
		-ar Structure -tm $(TOP) -insert_pp_buffers true -w -ofmt vhdl -sim \
		$(abspath $<) $(abspath $@) &> $(abspath $@).out

%_timesim.v: %.routed.ncd %.pcf
	@echo [NTG] $@ \> $@.out
	@cd $(dir $@) && netgen -s 3 -pcf $(abspath $(word 2, $^)) -rpw 100 -tpw 0 \
		-ar Structure -tm $(TOP) -insert_pp_buffers true -w -ofmt verilog -sim \
		$(abspath $<) $(abspath $@) &> $(abspath $@).out

# Isim simulation compilation
%.isim:
	@mkdir -p $(dir $@)
	@echo [CAT] $< $(word 2, $^) >> $@.prj
	@rm -f $@.prj
	@cat $^ > $@.prj
	@echo [ISM] $@ \> $@.out
	@cd $(dir $@) && fuse -incremental -lib secureip -o $(abspath $@) \
		-prj $(abspath $@).prj work.$(TOP) &> $(abspath $@).out

simulations: $(SIMS)

run_simulations: $(call SIM_2_RUN, $(SIMS)) 

# Run icarus
%.run: %.sim
	@echo [RUN] $< ">" $<.run
	@cd $(dir $@) && $(realpath $<) > $(realpath $<).run

# Run Isim with gui
%.runisim: %.isim
	@echo [RUN] $<
	@cd $(dir $@) && $(realpath $<) -gui &

################################ INFO & CLEAN ##################################

info:
	@echo TARGETS [$(TARGETS)]
	@echo SIMS [$(SIMS)]

clean:
	@echo [CLR]
	@rm -fr $(dir $(TARGETS)) $(SIMS)

mr-proper: mr-proper-vim

mr-proper-vim:
	@echo [CLR] *.swp
	@find . | grep .swp | xargs rm -f

################################### ALIASES ####################################

# Cool aliases for autocompletion in the shell
counter_timesim: binary/counter/system_timesim.runisim
