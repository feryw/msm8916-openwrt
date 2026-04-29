SUBTARGET:=msm8916v7
BOARDNAME:=Snapdragon 410 (msm8916) based boards (ARMv7)
ARCH:=arm
CPU_TYPE:=cortex-a7
CPU_SUBTYPE:=neon-vfpv4

define Target/Description
	Build firmware images for msm8916 based boards.
	This firmware features a 32 bit kernel.
endef
