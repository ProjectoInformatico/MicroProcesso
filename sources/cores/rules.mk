sp 		:= $(sp).x
dirstack_$(sp)	:= $(d)
d		:= $(dir)

dir	:= $(d)/pipe_line
include	$(dir)/rules.mk
dir	:= $(d)/ram
include	$(dir)/rules.mk
dir	:= $(d)/rom
include	$(dir)/rules.mk
dir	:= $(d)/bank_register
include	$(dir)/rules.mk
dir	:= $(d)/alu
include	$(dir)/rules.mk
dir	:= $(d)/program_counter
include	$(dir)/rules.mk

d		:= $(dirstack_$(sp))
sp		:= $(basename $(sp))
