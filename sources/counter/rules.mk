sp              := $(sp).x
dirstack_$(sp)  := $(d)
d               := $(dir)

# Synthesis
TARGET          := $(call SRC_2_BIN, $(d)/system)

# synthesis sources definition
SRC_VHDL_$(d)				:= 
SRC_VERILOG_$(d)			:= 

include $(d)/sources.mk

CONSTRAINTS_$(d)  := $(d)/synthesis/common.ucf

# Fixed
TARGETS 				+= $(call GEN_TARGETS, $(TARGET))

$(TARGET).prj			: $(d)/sources.mk $(SRC_VHDL_$(d)) $(SRC_VERILOG_$(d))
$(TARGET).prj			: VHDL 		:= $(SRC_VHDL_$(d))
$(TARGET).prj			: VERILOG := $(SRC_VERILOG_$(d))
$(TARGET).ucf			: $(CONSTRAINTS_$(d))
$(TARGET).xst			: $(d)/synthesis/system.xst

d               := $(dirstack_$(sp))
sp              := $(basename $(sp))
