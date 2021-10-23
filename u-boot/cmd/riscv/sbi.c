// SPDX-License-Identifier: GPL-2.0+
/*
 * The 'sbi' command displays information about the SBI implementation.
 *
 * Copyright (c) 2020, Heinrich Schuchardt <xypron.glpk@gmx.de>
 */

#include <common.h>
#include <command.h>
#include <asm/sbi.h>

struct sbi_imp {
	const long id;
	const char *name;
};

struct sbi_ext {
	const u32 id;
	const char *name;
};

static struct sbi_imp implementations[] = {
	{ 0, "Berkeley Boot Loader (BBL)" },
	{ 1, "OpenSBI" },
	{ 2, "Xvisor" },
	{ 3, "KVM" },
	{ 4, "RustSBI" },
	{ 5, "Diosix" },
};

static struct sbi_ext extensions[] = {
	{ SBI_EXT_0_1_SET_TIMER,	      "sbi_set_timer" },
	{ SBI_EXT_0_1_CONSOLE_PUTCHAR,	      "sbi_console_putchar" },
	{ SBI_EXT_0_1_CONSOLE_GETCHAR,	      "sbi_console_getchar" },
	{ SBI_EXT_0_1_CLEAR_IPI,	      "sbi_clear_ipi" },
	{ SBI_EXT_0_1_SEND_IPI,		      "sbi_send_ipi" },
	{ SBI_EXT_0_1_REMOTE_FENCE_I,	      "sbi_remote_fence_i" },
	{ SBI_EXT_0_1_REMOTE_SFENCE_VMA,      "sbi_remote_sfence_vma" },
	{ SBI_EXT_0_1_REMOTE_SFENCE_VMA_ASID, "sbi_remote_sfence_vma_asid" },
	{ SBI_EXT_0_1_SHUTDOWN,		      "sbi_shutdown" },
	{ SBI_EXT_BASE,			      "SBI Base Functionality" },
	{ SBI_EXT_TIME,			      "Timer Extension" },
	{ SBI_EXT_IPI,			      "IPI Extension" },
	{ SBI_EXT_RFENCE,		      "RFENCE Extension" },
	{ SBI_EXT_HSM,			      "Hart State Management Extension" },
	{ SBI_EXT_SRST,			      "System Reset Extension" },
};

static int do_sbi(struct cmd_tbl *cmdtp, int flag, int argc,
		  char *const argv[])
{
	int i;
	long ret;

	ret = sbi_get_spec_version();
	if (ret >= 0)
		printf("SBI %ld.%ld\n", ret >> 24, ret & 0xffffff);
	ret = sbi_get_impl_id();
	if (ret >= 0) {
		for (i = 0; i < ARRAY_SIZE(implementations); ++i) {
			if (ret == implementations[i].id) {
				printf("%s\n", implementations[i].name);
				break;
			}
		}
		if (i == ARRAY_SIZE(implementations))
			printf("Unknown implementation ID %ld\n", ret);
	}
	printf("Extensions:\n");
	for (i = 0; i < ARRAY_SIZE(extensions); ++i) {
		ret = sbi_probe_extension(extensions[i].id);
		if (ret > 0)
			printf("  %s\n", extensions[i].name);
	}
	return 0;
}

#ifdef CONFIG_SYS_LONGHELP
static char sbi_help_text[] =
	"- display SBI spec version, implementation, and available extensions";

#endif

U_BOOT_CMD_COMPLETE(
	sbi, 1, 0, do_sbi,
	"display SBI information",
	sbi_help_text, NULL
);
