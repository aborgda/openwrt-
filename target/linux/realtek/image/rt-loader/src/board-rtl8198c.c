/*
 * RTL8198C board support for the legacy Realtek MIPS loader.
 */
#include "globals.h"
#include "memory.h"
#include "nanoprintf.h"

#define RTL8198C_UART_THR 0xb8002000
#define RTL8198C_UART_LSR 0xb800200c
#define RTL8198C_UART_LSR_THRE 0x20
#define RTL8198C_DRAM_CFG 0xb8001004

void board_putchar(int ch, void *ctx)
{
	while (!(ioread32(RTL8198C_UART_LSR) & RTL8198C_UART_LSR_THRE))
		;
	iowrite32((unsigned int)ch, RTL8198C_UART_THR);
	if (ch == '\n')
		board_putchar('\r', ctx);
}

unsigned int board_get_memory(void)
{
	unsigned int d = ioread32(RTL8198C_DRAM_CFG);
	unsigned int bank = ((d >> 20) & 0x3) + 1;
	unsigned int width = ((d >> 16) & 0x3) + 1;
	unsigned int size = 8U << (bank + width);

	if (size > (256U << 20))
		size = 256U << 20;
	return size;
}

void board_get_system(char *buffer, int len)
{
	snprintf(buffer, len, "RTL8198C");
}

void board_panic(void)
{
	printf("halt system\n");
	while (1)
		;
}
