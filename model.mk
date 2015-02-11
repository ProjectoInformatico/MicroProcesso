# Default simulation models generation
$(TARGET)_translate.isim: TOP := $(TOP_$(d))

$(TARGET)_synthesis.vhd	: TOP := $(TOP_$(d))
$(TARGET)_synthesis.v  	: TOP := $(TOP_$(d))

$(TARGET)_translate.vhd	: TOP := $(TOP_$(d))
$(TARGET)_translate.v  	: TOP := $(TOP_$(d))

$(TARGET)_map.vhd				: TOP := $(TOP_$(d))
$(TARGET)_map.v  				: TOP := $(TOP_$(d))

$(TARGET)_timesim.vhd		: TOP := $(TOP_$(d))
$(TARGET)_timesim.v  		: TOP := $(TOP_$(d))
