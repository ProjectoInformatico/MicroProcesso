sp              	:= $(sp).x
dirstack_$(sp)  	:= $(d)
d               	:= $(dir)

TARGET           	:= $(call SRC_2_BIN, $(d)/alu)

# VHDL Simulations example

# Behavorial simulation
$(TARGET)_beh.prj				: $(d)/rtl/alu_bench.vhd $(d)/rtl/alu.vhd
$(TARGET)_beh.prj				: VHDL:= $(d)/rtl/alu.vhd $(d)/rtl/alu_bench.vhd
$(TARGET)_beh.isim			: TOP := alu_bench
$(TARGET)_beh.isim			: $(TARGET)_beh.prj

# Post-synth simulation
$(TARGET)_synthesis.prj : $(d)/rtl/alu_bench.vhd $(TARGET)_synthesis.vhd
$(TARGET)_synthesis.prj	: VHDL:= $(d)/rtl/alu_bench.vhd $(TARGET)_synthesis.vhd
$(TARGET)_synthesis.isim: TOP := alu_bench
$(TARGET)_synthesis.isim: $(TARGET)_synthesis.prj

# Post-translate simulation
$(TARGET)_translate.prj : $(d)/rtl/alu_bench.vhd $(TARGET)_translate.vhd
$(TARGET)_translate.prj	: VHDL:= $(d)/rtl/alu_bench.vhd $(TARGET)_translate.vhd
$(TARGET)_translate.isim: TOP := alu_bench
$(TARGET)_translate.isim: $(TARGET)_translate.prj

# Post-map simulation
$(TARGET)_map.prj 			: $(d)/rtl/alu_bench.vhd $(TARGET)_map.vhd
$(TARGET)_map.prj				: VHDL:= $(d)/rtl/alu_bench.vhd $(TARGET)_map.vhd
$(TARGET)_map.isim			: TOP := alu_bench
$(TARGET)_map.isim			: $(TARGET)_map.prj

# Post-place & route simulation
$(TARGET)_timesim.prj 	: $(d)/rtl/alu_bench.vhd $(TARGET)_timesim.vhd
$(TARGET)_timesim.prj		: VHDL:= $(d)/rtl/alu_bench.vhd $(TARGET)_timesim.vhd
$(TARGET)_timesim.isim	: TOP := alu_bench
$(TARGET)_timesim.isim	: $(TARGET)_timesim.prj

# Tests rules
SIMS 				 	+= $(TARGET)_beh.isim

# Default simulation model generation
include model.mk

SIMS += $(TARGET)_beh.isim

d                	:= $(dirstack_$(sp))
sp               	:= $(basename $(sp))
