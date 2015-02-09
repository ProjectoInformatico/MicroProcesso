sp 		:= $(sp).x
dirstack_$(sp)	:= $(d)
d		:= $(dir)

# dir	:= $(d)/core
# include	$(dir)/rules.mk

d		:= $(dirstack_$(sp))
sp		:= $(basename $(sp))
