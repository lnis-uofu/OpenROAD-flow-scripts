export DESIGN_NAME     = gcd
export DESIGN_NICKNAME = gcd_poly
export PLATFORM        = SKY130HD

export VERILOG_FILES = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/gcd.v
export SDC_FILE      = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc

# Empty macro cell .lef/gds
export ADDITIONAL_LEFS       = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/macro_nop.lef
export ADDITIONAL_GDS_FILES  = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/macro_nop.gds

# Macro cell placement file
export MACRO_PLACEMENT = ./designs/$(PLATFORM)/$(DESIGN_NICKNAME)/macro_place.cfg

# These values must be multiples of placement site
export DIE_AREA    = 0 0 279.96 280.128
export CORE_AREA   = 9.996 10.08 269.964 270.048


