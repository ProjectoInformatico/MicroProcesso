sp              	:= $(sp).x
dirstack_$(sp)  	:= $(d)
d               	:= $(dir)

TARGET           	:= $(call SRC_2_BIN, $(d)/program_counter)

# VHDL Simulations example

# Behavorial simulation
$(TARGET)_beh.prj				: $(d)/rtl/program_counter_bench.vhd $(d)/rtl/program_counter.vhd
$(TARGET)_beh.prj				: VHDL:= $(d)/rtl/program_counter.vhd $(d)/rtl/program_counter_bench.vhd
$(TARGET)_beh.isim			: TOP := program_counter_bench
$(TARGET)_beh.isim			: $(TARGET)_beh.prj

# Post-synth simulation
$(TARGET)_synthesis.prj : $(d)/rtl/program_counter_bench.vhd $(TARGET)_synthesis.vhd
$(TARGET)_synthesis.prj	: VHDL:= $(d)/rtl/program_counter_bench.vhd $(TARGET)_synthesis.vhd
$(TARGET)_synthesis.isim: TOP := program_counter_bench
$(TARGET)_synthesis.isim: $(TARGET)_synthesis.prj

# Post-translate simulation
$(TARGET)_translate.prj : $(d)/rtl/program_counter_bench.vhd $(TARGET)_translate.vhd
$(TARGET)_translate.prj	: VHDL:= $(d)/rtl/program_counter_bench.vhd $(TARGET)_translate.vhd
$(TARGET)_translate.isim: TOP := program_counter_bench
$(TARGET)_translate.isim: $(TARGET)_translate.prj

# Post-map simulation
$(TARGET)_map.prj 			: $(d)/rtl/program_counter_bench.vhd $(TARGET)_map.vhd
$(TARGET)_map.prj				: VHDL:= $(d)/rtl/program_counter_bench.vhd $(TARGET)_map.vhd
$(TARGET)_map.isim			: TOP := program_counter_bench
$(TARGET)_map.isim			: $(TARGET)_map.prj

# Post-place & route simulation
$(TARGET)_timesim.prj 	: $(d)/rtl/program_counter_bench.vhd $(TARGET)_timesim.vhd
$(TARGET)_timesim.prj		: VHDL:= $(d)/rtl/program_counter_bench.vhd $(TARGET)_timesim.vhd
$(TARGET)_timesim.isim	: TOP := program_counter_bench
$(TARGET)_timesim.isim	: $(TARGET)_timesim.prj

# Tests rules
SIMS 				 	+= $(TARGET)_beh.isim

# Default simulation model generation
include model.mk

SIMS += $(TARGET)_beh.isim

d                	:= $(dirstack_$(sp))
sp               	:= $(basename $(sp))
