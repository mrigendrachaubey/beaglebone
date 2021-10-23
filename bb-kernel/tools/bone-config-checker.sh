#!/bin/sh -e

DIR=$PWD

config_enable () {
	ret=$(./scripts/config --state ${config})
	if [ ! "x${ret}" = "xy" ] ; then
		echo "Setting: ${config}=y"
		./scripts/config --enable ${config}
	fi
}

config_disable () {
	ret=$(./scripts/config --state ${config})
	if [ ! "x${ret}" = "xn" ] ; then
		echo "Setting: ${config}=n"
		./scripts/config --disable ${config}
	fi
}

config_enable_special () {
	test_module=$(cat .config | grep ${config} || true)
	if [ "x${test_module}" = "x# ${config} is not set" ] ; then
		echo "Setting: ${config}=y"
		sed -i -e 's:# '$config' is not set:'$config'=y:g' .config
	fi
	if [ "x${test_module}" = "x${config}=m" ] ; then
		echo "Setting: ${config}=y"
		sed -i -e 's:'$config'=m:'$config'=y:g' .config
	fi
}

config_module_special () {
	test_module=$(cat .config | grep ${config} || true)
	if [ "x${test_module}" = "x# ${config} is not set" ] ; then
		echo "Setting: ${config}=m"
		sed -i -e 's:# '$config' is not set:'$config'=m:g' .config
	fi
}

config_module () {
	ret=$(./scripts/config --state ${config})
	if [ ! "x${ret}" = "xm" ] ; then
		echo "Setting: ${config}=m"
		./scripts/config --module ${config}
	fi
}

config_string () {
	ret=$(./scripts/config --state ${config})
	if [ ! "x${ret}" = "x${option}" ] ; then
		echo "Setting: ${config}=\"${option}\""
		./scripts/config --set-str ${config} "${option}"
	fi
}

config_value () {
	ret=$(./scripts/config --state ${config})
	if [ ! "x${ret}" = "x${option}" ] ; then
		echo "Setting: ${config}=${option}"
		./scripts/config --set-val ${config} ${option}
	fi
}

cd ${DIR}/KERNEL/

#
# CPU Core family selection
#
config="CONFIG_ARCH_MXC" ; config_disable

#
# TI OMAP/AM/DM/DRA Family
#
config="CONFIG_ARCH_OMAP3" ; config_disable
config="CONFIG_ARCH_OMAP4" ; config_disable
config="CONFIG_SOC_OMAP5" ; config_disable
config="CONFIG_SOC_AM43XX" ; config_disable
config="CONFIG_SOC_DRA7XX" ; config_disable

#
# OMAP Legacy Platform Data Board Type
#
config="CONFIG_ARCH_SUNXI" ; config_disable
config="CONFIG_EFI_ARMSTUB_DTB_LOADER" ; config_disable

#
# Processor Features
#
config="CONFIG_PL310_ERRATA_769419" ; config_disable

#these errata are not needed on am335x
config="CONFIG_ARM_ERRATA_720789" ; config_disable
config="CONFIG_ARM_ERRATA_754322" ; config_disable
config="CONFIG_ARM_ERRATA_775420" ; config_disable

#
# Kernel Features
#
config="CONFIG_SMP" ; config_disable

#
# AX.25 network device drivers
#
config="CONFIG_CAN" ; config_enable

#
# CAN Device Drivers
#
config="CONFIG_CAN_FLEXCAN" ; config_disable
config="CONFIG_CAN_DEV" ; config_enable
config="CONFIG_CAN_C_CAN" ; config_enable
config="CONFIG_CAN_C_CAN_PLATFORM" ; config_enable

#
# Misc devices
#
config="CONFIG_ENCLOSURE_SERVICES" ; config_disable
config="CONFIG_TIEQEP" ; config_enable
config="CONFIG_UDOO_ARD" ; config_disable

#
# VOP Driver
#
config="CONFIG_BEAGLEBONE_PINMUX_HELPER" ; config_enable

#
# Distributed Switch Architecture drivers
#
config="CONFIG_NET_VENDOR_CADENCE" ; config_disable
config="CONFIG_NET_VENDOR_STMICRO" ; config_disable

#
# MII PHY device drivers
#
config="CONFIG_USB_NET_DRIVERS" ; config_enable
config="CONFIG_USB_USBNET" ; config_enable
config="CONFIG_USB_NET_SMSC95XX" ; config_enable

#
# Input Device Drivers
#
config="CONFIG_TOUCHSCREEN_EDT_FT5X06" ; config_enable
config="CONFIG_TOUCHSCREEN_TI_AM335X_TSC" ; config_enable
config="CONFIG_TOUCHSCREEN_AR1021_I2C" ; config_enable
config="CONFIG_TOUCHSCREEN_STMFTS" ; config_disable

#
# Serial drivers
#
config="CONFIG_SERIAL_8250_DEPRECATED_OPTIONS" ; config_disable
config="CONFIG_SERIAL_8250_FSL" ; config_disable
config="CONFIG_SERIAL_8250_DW" ; config_disable

#
# SPI Master Controller Drivers
#
config="CONFIG_SPI_TI_QSPI" ; config_disable

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
config="CONFIG_GPIO_OF_HELPER" ; config_enable

#
# 1-wire Slaves
#
config="CONFIG_BATTERY_SBS" ; config_disable
config="CONFIG_BATTERY_BQ27XXX" ; config_disable
config="CONFIG_CHARGER_ISP1704" ; config_disable
config="CONFIG_CHARGER_BQ2415X" ; config_disable

#
# Watchdog Device Drivers
#
config="CONFIG_SOFT_WATCHDOG" ; config_enable
config="CONFIG_OMAP_WATCHDOG" ; config_enable
config="CONFIG_DW_WATCHDOG" ; config_disable

#
# Multifunction device drivers
#
config="CONFIG_MFD_AS3722" ; config_disable
config="CONFIG_MFD_AXP20X_I2C" ; config_disable

config="CONFIG_PMIC_DA9052" ; config_disable
config="CONFIG_MFD_DA9052_SPI" ; config_disable
config="CONFIG_MFD_DA9052_I2C" ; config_disable

config="CONFIG_MFD_MC13XXX" ; config_disable
config="CONFIG_MFD_MC13XXX_SPI" ; config_disable
config="CONFIG_MFD_MC13XXX_I2C" ; config_disable

config="CONFIG_MFD_MAX77686" ; config_disable
config="CONFIG_MFD_RK808" ; config_disable
config="CONFIG_MFD_SEC_CORE" ; config_disable
config="CONFIG_MFD_STMPE" ; config_disable

config="CONFIG_MFD_TI_AM335X_TSCADC" ; config_enable
config="CONFIG_MFD_PALMAS" ; config_disable
config="CONFIG_MFD_TPS65218" ; config_disable
config="CONFIG_MFD_TPS65910" ; config_disable
config="CONFIG_TWL4030_CORE" ; config_disable
config="CONFIG_TWL6040_CORE" ; config_disable
config="CONFIG_MFD_WL1273_CORE" ; config_disable

config="CONFIG_REGULATOR_ACT8865" ; config_disable
config="CONFIG_REGULATOR_AD5398" ; config_disable
config="CONFIG_REGULATOR_ANATOP" ; config_disable
config="CONFIG_REGULATOR_FAN53555" ; config_disable
config="CONFIG_REGULATOR_PFUZE100" ; config_disable

config="CONFIG_MEDIA_SUPPORT" ; config_module

#
# Graphics support
#
config="CONFIG_IMX_IPUV3_CORE" ; config_disable

#
# I2C encoder or helper chips
#
config="CONFIG_DRM_I2C_ADIHDMI" ; config_disable
config="CONFIG_DRM_I2C_NXP_TDA998X" ; config_enable

#
# AMD Library routines
#
config="CONFIG_DRM_OMAP" ; config_disable
config="CONFIG_DRM_VIRTIO_GPU" ; config_disable

#
# Display Panels
#
config="CONFIG_DRM_PANEL_SIMPLE" ; config_enable

#
# Display Interface Bridges
#
config="CONFIG_DRM_DUMB_VGA_DAC" ; config_disable
config="CONFIG_DRM_ETNAVIV" ; config_disable
config="CONFIG_DRM_MXS" ; config_disable
config="CONFIG_DRM_MXSFB" ; config_disable

config="CONFIG_TINYDRM_ILI9341" ; config_module

#
# Console display driver support
#
config="CONFIG_SOUND" ; config_enable
config="CONFIG_SND" ; config_enable
config="CONFIG_SND_TIMER" ; config_enable
config="CONFIG_SND_PCM" ; config_enable
config="CONFIG_SND_DMAENGINE_PCM" ; config_enable

#
# HD-Audio
#
config="CONFIG_SND_SOC" ; config_enable
config="CONFIG_SND_EDMA_SOC" ; config_enable
config="CONFIG_SND_DAVINCI_SOC_I2S" ; config_enable
config="CONFIG_SND_DAVINCI_SOC_MCASP" ; config_enable
config="CONFIG_SND_DAVINCI_SOC_GENERIC_EVM" ; config_enable
config="CONFIG_SND_AM33XX_SOC_EVM" ; config_enable

#
# Common SoC Audio options for Freescale CPUs:
#
config="CONFIG_SND_SOC_FSL_SSI" ; config_disable
config="CONFIG_SND_SOC_FSL_SPDIF" ; config_disable
config="CONFIG_SND_SOC_IMX_AUDMUX" ; config_disable

config="CONFIG_SND_OMAP_SOC" ; config_enable
config="CONFIG_SND_OMAP_SOC_HDMI_AUDIO" ; config_disable
config="CONFIG_SND_OMAP_SOC_RX51" ; config_disable

#
# CODEC drivers
#
config="CONFIG_SND_SIMPLE_CARD_UTILS" ; config_enable
config="CONFIG_SND_SIMPLE_CARD" ; config_enable

#
# USB Host Controller Drivers
#
config="CONFIG_USB_XHCI_HCD" ; config_disable
config="CONFIG_USB_EHCI_HCD" ; config_disable
config="CONFIG_USB_U132_HCD" ; config_disable

#
# Platform Glue Layer
#
config="CONFIG_USB_MUSB_TUSB6010" ; config_disable
config="CONFIG_USB_MUSB_OMAP2PLUS" ; config_disable
config="CONFIG_USB_MUSB_AM35X" ; config_disable
config="CONFIG_USB_MUSB_DSPS" ; config_enable
config="CONFIG_USB_MUSB_UX500" ; config_disable

#
# MUSB DMA mode
#
config="CONFIG_MUSB_PIO_ONLY" ; config_disable
config="CONFIG_USB_TI_CPPI41_DMA" ; config_enable
config="CONFIG_USB_DWC3" ; config_disable
config="CONFIG_USB_DWC3_OMAP" ; config_disable
config="CONFIG_USB_DWC3_OF_SIMPLE" ; config_disable
config="CONFIG_USB_DWC2" ; config_disable

#
# Gadget/Dual-role mode requires USB Gadget support to be enabled
#
config="CONFIG_USB_CHIPIDEA" ; config_disable

config="CONFIG_UWB" ; config_disable
config="CONFIG_USB_ULPI" ; config_disable
config="CONFIG_USB_ULPI_BUS" ; config_disable
config="CONFIG_USB_ROLE_SWITCH" ; config_disable
config="CONFIG_PWRSEQ_SD8787" ; config_disable

#
# MMC/SD/SDIO Host Controller Drivers
#
config="CONFIG_MMC_SDHCI" ; config_disable
config="CONFIG_MMC_SDHCI_PLTFM" ; config_disable
config="CONFIG_MMC_CQHCI" ; config_disable
config="CONFIG_MEMSTICK" ; config_disable

#
# MemoryStick drivers
#
config="CONFIG_MSPRO_BLOCK" ; config_disable

#
# on-CPU RTC drivers
#
config="CONFIG_RTC_DRV_SNVS" ; config_disable
config="CONFIG_RTC_DRV_R7301" ; config_disable

#
# DMA Devices
#
config="CONFIG_FSL_EDMA" ; config_disable
config="CONFIG_DW_DMAC_CORE" ; config_disable
config="CONFIG_DW_DMAC" ; config_disable

#
# Common Clock Framework
#
config="CONFIG_COMMON_CLK_SI5351" ; config_disable

#
# Temperature sensors
#
config="CONFIG_PWM_OMAP_DMTIMER" ; config_enable
config="CONFIG_PWM_PCA9685" ; config_enable
config="CONFIG_PWM_TIECAP" ; config_enable
config="CONFIG_PWM_TIEHRPWM" ; config_enable

#
# Analog to digital converters
#
config="CONFIG_IIO" ; config_enable
config="CONFIG_TI_AM335X_ADC" ; config_enable

### new

config="CONFIG_MDIO_BCM_UNIMAC" ; config_disable

config="CONFIG_OMAP_OCP2SCP" ; config_disable
config="CONFIG_ARM_TIMER_SP804" ; config_disable
config="CONFIG_TI_PIPE3" ; config_disable
config="CONFIG_OMAP_USB2" ; config_disable
config="CONFIG_OMAP_CONTROL_PHY" ; config_disable
config="CONFIG_GENERIC_PHY" ; config_disable

config="CONFIG_PATA_PLATFORM" ; config_disable
config="CONFIG_ATA_BMDMA" ; config_disable
config="CONFIG_ATA_SFF" ; config_disable
config="CONFIG_SATA_AHCI_PLATFORM" ; config_disable

#


