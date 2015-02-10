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

CONSTRAINTS_$(d) 	:= $(d)/synthesis/common.ucf

# DO NOT MODIFY

TARGET           	:= $(call SRC_2_BIN, $(d)/$(TOP_$(d)))

TARGETS 				 	+= $(call GEN_TARGETS, $(TARGET))

$(TARGET).prj						: $(d)/sources.mk $(SRC_VHDL_$(d)) $(SRC_VERILOG_$(d))
$(TARGET).prj						: VHDL 		:= $(SRC_VHDL_$(d))
$(TARGET).prj						: VERILOG := $(SRC_VERILOG_$(d))
$(TARGET).ucf						: $(CONSTRAINTS_$(d))
                      
$(TARGET).xst						: PKG := $(PKG_$(d))
$(TARGET).xst						: TOP := $(TOP_$(d))

$(TARGET)_synthesis.vhd	: TOP := $(TOP_$(d))
$(TARGET)_synthesis.v  	: TOP := $(TOP_$(d))

$(TARGET)_translate.vhd	: TOP := $(TOP_$(d))
$(TARGET)_translate.v  	: TOP := $(TOP_$(d))

$(TARGET)_map.vhd				: TOP := $(TOP_$(d))
$(TARGET)_map.v  				: TOP := $(TOP_$(d))

$(TARGET)_timesim.vhd		: TOP := $(TOP_$(d))
$(TARGET)_timesim.v  		: TOP := $(TOP_$(d))

d                	:= $(dirstack_$(sp))
sp               	:= $(basename $(sp))
