sp              	:= $(sp).x
dirstack_$(sp)  	:= $(d)
d               	:= $(dir)

# Synthesis sources definition
SRC_VHDL_$(d)		 	:= 
SRC_VERILOG_$(d) 	:= 

# Board specific definitions
PKG_$(d) 				 	:= xc6slx16-3-csg324

# Top module
TOP_$(d)				 	:= microprocesso

include $(d)/sources.mk

# Constraints
CONSTRAINTS_$(d) 	:= $(d)/synthesis/common.ucf

# Target path
TARGET           	:= $(call SRC_2_BIN, $(d)/$(TOP_$(d)))

# Synthesis rules
TARGETS 				 	+= $(call GEN_TARGETS, $(TARGET))

$(TARGET).prj						: $(d)/sources.mk $(SRC_VHDL_$(d)) $(SRC_VERILOG_$(d))
$(TARGET).prj						: VHDL 		:= $(SRC_VHDL_$(d))
$(TARGET).prj						: VERILOG := $(SRC_VERILOG_$(d))
$(TARGET).ucf						: $(CONSTRAINTS_$(d))
                      
$(TARGET).xst						: PKG := $(PKG_$(d))
$(TARGET).xst						: TOP := $(TOP_$(d))

# VHDL Simulations example

# Behavorial simulation
$(TARGET)_beh.prj				: $(d)/rtl/microprocesso_bench.vhd
$(TARGET)_beh.prj				: VHDL:= $(d)/rtl/microprocesso_bench.vhd
$(TARGET)_beh.isim			: TOP := microprocesso_bench
$(TARGET)_beh.isim			: $(TARGET).prj $(TARGET)_beh.prj

# Post-synth simulation
$(TARGET)_synthesis.prj : $(d)/rtl/microprocesso_bench.vhd $(TARGET)_synthesis.vhd
$(TARGET)_synthesis.prj	: VHDL:= $(d)/rtl/microprocesso_bench.vhd $(TARGET)_synthesis.vhd
$(TARGET)_synthesis.isim: TOP := microprocesso_bench
$(TARGET)_synthesis.isim: $(TARGET)_synthesis.prj

# Post-translate simulation
$(TARGET)_translate.prj : $(d)/rtl/microprocesso_bench.vhd $(TARGET)_translate.vhd
$(TARGET)_translate.prj	: VHDL:= $(d)/rtl/microprocesso_bench.vhd $(TARGET)_translate.vhd
$(TARGET)_translate.isim: TOP := microprocesso_bench
$(TARGET)_translate.isim: $(TARGET)_translate.prj

# Post-map simulation
$(TARGET)_map.prj 			: $(d)/rtl/microprocesso_bench.vhd $(TARGET)_map.vhd
$(TARGET)_map.prj				: VHDL:= $(d)/rtl/microprocesso_bench.vhd $(TARGET)_map.vhd
$(TARGET)_map.isim			: TOP := microprocesso_bench
$(TARGET)_map.isim			: $(TARGET)_map.prj

# Post-place & route simulation
$(TARGET)_timesim.prj 	: $(d)/rtl/microprocesso_bench.vhd $(TARGET)_timesim.vhd
$(TARGET)_timesim.prj		: VHDL:= $(d)/rtl/microprocesso_bench.vhd $(TARGET)_timesim.vhd
$(TARGET)_timesim.isim	: TOP := microprocesso_bench
$(TARGET)_timesim.isim	: $(TARGET)_timesim.prj

# Tests rules
SIMS 				 	+= $(TARGET)_beh.isim

# Default simulation model generation
include model.mk

SIMS += $(TARGET)_beh.isim

d                	:= $(dirstack_$(sp))
sp               	:= $(basename $(sp))
