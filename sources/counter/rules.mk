sp              	:= $(sp).x
dirstack_$(sp)  	:= $(d)
d               	:= $(dir)

# Synthesis sources definition
SRC_VHDL_$(d)		 	:= 
SRC_VERILOG_$(d) 	:= 

# Board specific definitions
PKG_$(d) 				 	:= xc6vlx240t-1-ff1156

# Top module
TOP_$(d)				 	:= system

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
$(TARGET)_beh.prj				: $(d)/rtl/test_bench.vhd
$(TARGET)_beh.prj				: VHDL:= $(d)/rtl/test_bench.vhd
$(TARGET)_beh.isim			: TOP := test_bench
$(TARGET)_beh.isim			: $(TARGET).prj $(TARGET)_beh.prj

# Post-synth simulation
$(TARGET)_synthesis.prj : $(d)/rtl/test_bench.vhd $(TARGET)_synthesis.vhd
$(TARGET)_synthesis.prj	: VHDL:= $(d)/rtl/test_bench.vhd $(TARGET)_synthesis.vhd
$(TARGET)_synthesis.isim: TOP := test_bench
$(TARGET)_synthesis.isim: $(TARGET)_synthesis.prj

# Post-translate simulation
$(TARGET)_translate.prj : $(d)/rtl/test_bench.vhd $(TARGET)_translate.vhd
$(TARGET)_translate.prj	: VHDL:= $(d)/rtl/test_bench.vhd $(TARGET)_translate.vhd
$(TARGET)_translate.isim: TOP := test_bench
$(TARGET)_translate.isim: $(TARGET)_translate.prj

# Post-map simulation
$(TARGET)_map.prj 			: $(d)/rtl/test_bench.vhd $(TARGET)_map.vhd
$(TARGET)_map.prj				: VHDL:= $(d)/rtl/test_bench.vhd $(TARGET)_map.vhd
$(TARGET)_map.isim			: TOP := test_bench
$(TARGET)_map.isim			: $(TARGET)_map.prj

# Post-place & route simulation
$(TARGET)_timesim.prj 	: $(d)/rtl/test_bench.vhd $(TARGET)_timesim.vhd
$(TARGET)_timesim.prj		: VHDL:= $(d)/rtl/test_bench.vhd $(TARGET)_timesim.vhd
$(TARGET)_timesim.isim	: TOP := test_bench
$(TARGET)_timesim.isim	: $(TARGET)_timesim.prj

# Default simulation model generation
include model.mk

d                	:= $(dirstack_$(sp))
sp               	:= $(basename $(sp))
