sp 		:= $(sp).x
dirstack_$(sp)	:= $(d)
d		:= $(dir)

dir	:= $(d)/cores
include	$(dir)/rules.mk
# dir	:= $(d)/example
# include	$(dir)/rules.mk
dir	:= $(d)/counter
include	$(dir)/rules.mk


d		:= $(dirstack_$(sp))
sp		:= $(basename $(sp))
