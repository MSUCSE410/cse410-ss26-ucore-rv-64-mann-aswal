
build/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080200000 <_entry>:
    .section .text.entry
    .globl _entry
_entry:
    la sp, boot_stack_top
    80200000:	00019117          	auipc	sp,0x19
    80200004:	00010113          	mv	sp,sp
    call main
    80200008:	1f6000ef          	jal	ra,802001fe <main>

000000008020000c <consputc>:
#include "console.h"
#include "sbi.h"

void consputc(int c)
{
    8020000c:	1141                	addi	sp,sp,-16
    8020000e:	e406                	sd	ra,8(sp)
    80200010:	e022                	sd	s0,0(sp)
    80200012:	0800                	addi	s0,sp,16
	console_putchar(c);
    80200014:	00000097          	auipc	ra,0x0
    80200018:	49a080e7          	jalr	1178(ra) # 802004ae <console_putchar>
}
    8020001c:	60a2                	ld	ra,8(sp)
    8020001e:	6402                	ld	s0,0(sp)
    80200020:	0141                	addi	sp,sp,16
    80200022:	8082                	ret

0000000080200024 <console_init>:

void console_init()
{
    80200024:	1141                	addi	sp,sp,-16
    80200026:	e422                	sd	s0,8(sp)
    80200028:	0800                	addi	s0,sp,16
	// DO NOTHING
    8020002a:	6422                	ld	s0,8(sp)
    8020002c:	0141                	addi	sp,sp,16
    8020002e:	8082                	ret

0000000080200030 <loader_init>:
static int app_cur, app_num;
static uint64 *app_info_ptr;
extern char _app_num[], userret[], boot_stack_top[], ekernel[];

void loader_init()
{
    80200030:	1141                	addi	sp,sp,-16
    80200032:	e406                	sd	ra,8(sp)
    80200034:	e022                	sd	s0,0(sp)
    80200036:	0800                	addi	s0,sp,16
	if ((uint64)ekernel >= BASE_ADDRESS) {
    80200038:	0001c717          	auipc	a4,0x1c
    8020003c:	fc870713          	addi	a4,a4,-56 # 8021c000 <e_bss>
    80200040:	20100793          	li	a5,513
    80200044:	07da                	slli	a5,a5,0x16
    80200046:	04f77563          	bgeu	a4,a5,80200090 <loader_init+0x60>
		panic("kernel too large...\n");
	}
	app_info_ptr = (uint64 *)_app_num;
    8020004a:	00002697          	auipc	a3,0x2
    8020004e:	fb668693          	addi	a3,a3,-74 # 80202000 <_app_num>
    80200052:	0001b797          	auipc	a5,0x1b
    80200056:	fad7b723          	sd	a3,-82(a5) # 8021b000 <app_info_ptr>
	app_cur = -1;
    8020005a:	57fd                	li	a5,-1
    8020005c:	0001b717          	auipc	a4,0x1b
    80200060:	faf72823          	sw	a5,-80(a4) # 8021b00c <app_cur>
	app_num = *app_info_ptr;
    80200064:	0006c783          	lbu	a5,0(a3)
    80200068:	0016c703          	lbu	a4,1(a3)
    8020006c:	0722                	slli	a4,a4,0x8
    8020006e:	8f5d                	or	a4,a4,a5
    80200070:	0026c783          	lbu	a5,2(a3)
    80200074:	07c2                	slli	a5,a5,0x10
    80200076:	8f5d                	or	a4,a4,a5
    80200078:	0036c783          	lbu	a5,3(a3)
    8020007c:	07e2                	slli	a5,a5,0x18
    8020007e:	8fd9                	or	a5,a5,a4
    80200080:	0001b717          	auipc	a4,0x1b
    80200084:	f8f72423          	sw	a5,-120(a4) # 8021b008 <app_num>
}
    80200088:	60a2                	ld	ra,8(sp)
    8020008a:	6402                	ld	s0,0(sp)
    8020008c:	0141                	addi	sp,sp,16
    8020008e:	8082                	ret
		panic("kernel too large...\n");
    80200090:	00000097          	auipc	ra,0x0
    80200094:	134080e7          	jalr	308(ra) # 802001c4 <threadid>
    80200098:	86aa                	mv	a3,a0
    8020009a:	47b1                	li	a5,12
    8020009c:	00001717          	auipc	a4,0x1
    802000a0:	f6470713          	addi	a4,a4,-156 # 80201000 <e_text>
    802000a4:	00001617          	auipc	a2,0x1
    802000a8:	f6c60613          	addi	a2,a2,-148 # 80201010 <e_text+0x10>
    802000ac:	45fd                	li	a1,31
    802000ae:	00001517          	auipc	a0,0x1
    802000b2:	f6a50513          	addi	a0,a0,-150 # 80201018 <e_text+0x18>
    802000b6:	00000097          	auipc	ra,0x0
    802000ba:	22a080e7          	jalr	554(ra) # 802002e0 <printf>
    802000be:	b771                	j	8020004a <loader_init+0x1a>

00000000802000c0 <load_app>:

__attribute__((aligned(4096))) char user_stack[USER_STACK_SIZE];
__attribute__((aligned(4096))) char trap_page[TRAP_PAGE_SIZE];

int load_app(uint64 *info)
{
    802000c0:	7179                	addi	sp,sp,-48
    802000c2:	f406                	sd	ra,40(sp)
    802000c4:	f022                	sd	s0,32(sp)
    802000c6:	ec26                	sd	s1,24(sp)
    802000c8:	e84a                	sd	s2,16(sp)
    802000ca:	e44e                	sd	s3,8(sp)
    802000cc:	1800                	addi	s0,sp,48
	uint64 start = info[0], end = info[1], length = end - start;
    802000ce:	00053983          	ld	s3,0(a0)
    802000d2:	6504                	ld	s1,8(a0)
    802000d4:	413484b3          	sub	s1,s1,s3
	memset((void *)BASE_ADDRESS, 0, MAX_APP_SIZE);
    802000d8:	00020637          	lui	a2,0x20
    802000dc:	4581                	li	a1,0
    802000de:	20100913          	li	s2,513
    802000e2:	01691513          	slli	a0,s2,0x16
    802000e6:	00000097          	auipc	ra,0x0
    802000ea:	410080e7          	jalr	1040(ra) # 802004f6 <memset>
	memmove((void *)BASE_ADDRESS, (void *)start, length);
    802000ee:	0004861b          	sext.w	a2,s1
    802000f2:	85ce                	mv	a1,s3
    802000f4:	01691513          	slli	a0,s2,0x16
    802000f8:	00000097          	auipc	ra,0x0
    802000fc:	45a080e7          	jalr	1114(ra) # 80200552 <memmove>
	return length;
}
    80200100:	0004851b          	sext.w	a0,s1
    80200104:	70a2                	ld	ra,40(sp)
    80200106:	7402                	ld	s0,32(sp)
    80200108:	64e2                	ld	s1,24(sp)
    8020010a:	6942                	ld	s2,16(sp)
    8020010c:	69a2                	ld	s3,8(sp)
    8020010e:	6145                	addi	sp,sp,48
    80200110:	8082                	ret

0000000080200112 <run_next_app>:

int run_next_app()
{
	struct trapframe *trapframe = (struct trapframe *)trap_page;
	app_cur++;
    80200112:	0001b717          	auipc	a4,0x1b
    80200116:	efa70713          	addi	a4,a4,-262 # 8021b00c <app_cur>
    8020011a:	431c                	lw	a5,0(a4)
    8020011c:	2785                	addiw	a5,a5,1
    8020011e:	0007859b          	sext.w	a1,a5
    80200122:	c31c                	sw	a5,0(a4)
	app_info_ptr++;
    80200124:	0001b717          	auipc	a4,0x1b
    80200128:	edc70713          	addi	a4,a4,-292 # 8021b000 <app_info_ptr>
    8020012c:	631c                	ld	a5,0(a4)
    8020012e:	07a1                	addi	a5,a5,8
    80200130:	e31c                	sd	a5,0(a4)
	if (app_cur >= app_num) {
    80200132:	0001b797          	auipc	a5,0x1b
    80200136:	ed67a783          	lw	a5,-298(a5) # 8021b008 <app_num>
    8020013a:	08f5d363          	bge	a1,a5,802001c0 <run_next_app+0xae>
{
    8020013e:	1101                	addi	sp,sp,-32
    80200140:	ec06                	sd	ra,24(sp)
    80200142:	e822                	sd	s0,16(sp)
    80200144:	e426                	sd	s1,8(sp)
    80200146:	1000                	addi	s0,sp,32
		return -1;
	}
	infof("load and run app %d", app_cur);
    80200148:	4501                	li	a0,0
    8020014a:	00000097          	auipc	ra,0x0
    8020014e:	55a080e7          	jalr	1370(ra) # 802006a4 <dummy>
	uint64 length = load_app(app_info_ptr);
    80200152:	0001b497          	auipc	s1,0x1b
    80200156:	eae48493          	addi	s1,s1,-338 # 8021b000 <app_info_ptr>
    8020015a:	6088                	ld	a0,0(s1)
    8020015c:	00000097          	auipc	ra,0x0
    80200160:	f64080e7          	jalr	-156(ra) # 802000c0 <load_app>
	debugf("bin range = [%p, %p)", *app_info_ptr, *app_info_ptr + length);
    80200164:	609c                	ld	a5,0(s1)
    80200166:	638c                	ld	a1,0(a5)
    80200168:	00b50633          	add	a2,a0,a1
    8020016c:	4501                	li	a0,0
    8020016e:	00000097          	auipc	ra,0x0
    80200172:	536080e7          	jalr	1334(ra) # 802006a4 <dummy>
	memset(trapframe, 0, 4096);
    80200176:	6605                	lui	a2,0x1
    80200178:	4581                	li	a1,0
    8020017a:	00019517          	auipc	a0,0x19
    8020017e:	e8650513          	addi	a0,a0,-378 # 80219000 <trap_page>
    80200182:	00000097          	auipc	ra,0x0
    80200186:	374080e7          	jalr	884(ra) # 802004f6 <memset>
	trapframe->epc = BASE_ADDRESS;
    8020018a:	00019517          	auipc	a0,0x19
    8020018e:	e7650513          	addi	a0,a0,-394 # 80219000 <trap_page>
    80200192:	20100793          	li	a5,513
    80200196:	07da                	slli	a5,a5,0x16
    80200198:	ed1c                	sd	a5,24(a0)
	trapframe->sp = (uint64)user_stack + USER_STACK_SIZE;
    8020019a:	0001b797          	auipc	a5,0x1b
    8020019e:	e6678793          	addi	a5,a5,-410 # 8021b000 <app_info_ptr>
    802001a2:	f91c                	sd	a5,48(a0)
	usertrapret(trapframe, (uint64)boot_stack_top);
    802001a4:	00019597          	auipc	a1,0x19
    802001a8:	e5c58593          	addi	a1,a1,-420 # 80219000 <trap_page>
    802001ac:	00001097          	auipc	ra,0x1
    802001b0:	86c080e7          	jalr	-1940(ra) # 80200a18 <usertrapret>
	return 0;
    802001b4:	4501                	li	a0,0
    802001b6:	60e2                	ld	ra,24(sp)
    802001b8:	6442                	ld	s0,16(sp)
    802001ba:	64a2                	ld	s1,8(sp)
    802001bc:	6105                	addi	sp,sp,32
    802001be:	8082                	ret
		return -1;
    802001c0:	557d                	li	a0,-1
    802001c2:	8082                	ret

00000000802001c4 <threadid>:
#include "defs.h"
#include "loader.h"
#include "trap.h"

int threadid()
{
    802001c4:	1141                	addi	sp,sp,-16
    802001c6:	e422                	sd	s0,8(sp)
    802001c8:	0800                	addi	s0,sp,16
	return 0;
}
    802001ca:	4501                	li	a0,0
    802001cc:	6422                	ld	s0,8(sp)
    802001ce:	0141                	addi	sp,sp,16
    802001d0:	8082                	ret

00000000802001d2 <clean_bss>:

void clean_bss()
{
    802001d2:	1141                	addi	sp,sp,-16
    802001d4:	e406                	sd	ra,8(sp)
    802001d6:	e022                	sd	s0,0(sp)
    802001d8:	0800                	addi	s0,sp,16
	extern char s_bss[];
	extern char e_bss[];
	memset(s_bss, 0, e_bss - s_bss);
    802001da:	00019517          	auipc	a0,0x19
    802001de:	e2650513          	addi	a0,a0,-474 # 80219000 <trap_page>
    802001e2:	0001c617          	auipc	a2,0x1c
    802001e6:	e1e60613          	addi	a2,a2,-482 # 8021c000 <e_bss>
    802001ea:	9e09                	subw	a2,a2,a0
    802001ec:	4581                	li	a1,0
    802001ee:	00000097          	auipc	ra,0x0
    802001f2:	308080e7          	jalr	776(ra) # 802004f6 <memset>
}
    802001f6:	60a2                	ld	ra,8(sp)
    802001f8:	6402                	ld	s0,0(sp)
    802001fa:	0141                	addi	sp,sp,16
    802001fc:	8082                	ret

00000000802001fe <main>:

void main()
{
    802001fe:	1141                	addi	sp,sp,-16
    80200200:	e406                	sd	ra,8(sp)
    80200202:	e022                	sd	s0,0(sp)
    80200204:	0800                	addi	s0,sp,16
	clean_bss();
    80200206:	00000097          	auipc	ra,0x0
    8020020a:	fcc080e7          	jalr	-52(ra) # 802001d2 <clean_bss>
	printf("hello wrold!\n");
    8020020e:	00001517          	auipc	a0,0x1
    80200212:	e3a50513          	addi	a0,a0,-454 # 80201048 <e_text+0x48>
    80200216:	00000097          	auipc	ra,0x0
    8020021a:	0ca080e7          	jalr	202(ra) # 802002e0 <printf>
	trap_init();
    8020021e:	00000097          	auipc	ra,0x0
    80200222:	7e0080e7          	jalr	2016(ra) # 802009fe <trap_init>
	loader_init();
    80200226:	00000097          	auipc	ra,0x0
    8020022a:	e0a080e7          	jalr	-502(ra) # 80200030 <loader_init>
	run_next_app();
    8020022e:	00000097          	auipc	ra,0x0
    80200232:	ee4080e7          	jalr	-284(ra) # 80200112 <run_next_app>
}
    80200236:	60a2                	ld	ra,8(sp)
    80200238:	6402                	ld	s0,0(sp)
    8020023a:	0141                	addi	sp,sp,16
    8020023c:	8082                	ret

000000008020023e <printint>:
#include "console.h"
#include "defs.h"
static char digits[] = "0123456789abcdef";

static void printint(int xx, int base, int sign)
{
    8020023e:	7179                	addi	sp,sp,-48
    80200240:	f406                	sd	ra,40(sp)
    80200242:	f022                	sd	s0,32(sp)
    80200244:	ec26                	sd	s1,24(sp)
    80200246:	e84a                	sd	s2,16(sp)
    80200248:	1800                	addi	s0,sp,48
	char buf[16];
	int i;
	uint x;

	if (sign && (sign = xx < 0))
    8020024a:	c219                	beqz	a2,80200250 <printint+0x12>
    8020024c:	08054663          	bltz	a0,802002d8 <printint+0x9a>
		x = -xx;
	else
		x = xx;
    80200250:	2501                	sext.w	a0,a0
    80200252:	4881                	li	a7,0
    80200254:	fd040693          	addi	a3,s0,-48

	i = 0;
    80200258:	4701                	li	a4,0
	do {
		buf[i++] = digits[x % base];
    8020025a:	2581                	sext.w	a1,a1
    8020025c:	00001617          	auipc	a2,0x1
    80200260:	e3c60613          	addi	a2,a2,-452 # 80201098 <digits>
    80200264:	883a                	mv	a6,a4
    80200266:	2705                	addiw	a4,a4,1
    80200268:	02b577bb          	remuw	a5,a0,a1
    8020026c:	1782                	slli	a5,a5,0x20
    8020026e:	9381                	srli	a5,a5,0x20
    80200270:	97b2                	add	a5,a5,a2
    80200272:	0007c783          	lbu	a5,0(a5)
    80200276:	00f68023          	sb	a5,0(a3)
	} while ((x /= base) != 0);
    8020027a:	0005079b          	sext.w	a5,a0
    8020027e:	02b5553b          	divuw	a0,a0,a1
    80200282:	0685                	addi	a3,a3,1
    80200284:	feb7f0e3          	bgeu	a5,a1,80200264 <printint+0x26>

	if (sign)
    80200288:	00088b63          	beqz	a7,8020029e <printint+0x60>
		buf[i++] = '-';
    8020028c:	fe040793          	addi	a5,s0,-32
    80200290:	973e                	add	a4,a4,a5
    80200292:	02d00793          	li	a5,45
    80200296:	fef70823          	sb	a5,-16(a4)
    8020029a:	0028071b          	addiw	a4,a6,2

	while (--i >= 0)
    8020029e:	02e05763          	blez	a4,802002cc <printint+0x8e>
    802002a2:	fd040793          	addi	a5,s0,-48
    802002a6:	00e784b3          	add	s1,a5,a4
    802002aa:	fff78913          	addi	s2,a5,-1
    802002ae:	993a                	add	s2,s2,a4
    802002b0:	377d                	addiw	a4,a4,-1
    802002b2:	1702                	slli	a4,a4,0x20
    802002b4:	9301                	srli	a4,a4,0x20
    802002b6:	40e90933          	sub	s2,s2,a4
		consputc(buf[i]);
    802002ba:	fff4c503          	lbu	a0,-1(s1)
    802002be:	00000097          	auipc	ra,0x0
    802002c2:	d4e080e7          	jalr	-690(ra) # 8020000c <consputc>
	while (--i >= 0)
    802002c6:	14fd                	addi	s1,s1,-1
    802002c8:	ff2499e3          	bne	s1,s2,802002ba <printint+0x7c>
}
    802002cc:	70a2                	ld	ra,40(sp)
    802002ce:	7402                	ld	s0,32(sp)
    802002d0:	64e2                	ld	s1,24(sp)
    802002d2:	6942                	ld	s2,16(sp)
    802002d4:	6145                	addi	sp,sp,48
    802002d6:	8082                	ret
		x = -xx;
    802002d8:	40a0053b          	negw	a0,a0
	if (sign && (sign = xx < 0))
    802002dc:	4885                	li	a7,1
		x = -xx;
    802002de:	bf9d                	j	80200254 <printint+0x16>

00000000802002e0 <printf>:
		consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the console. only understands %d, %x, %p, %s.
void printf(char *fmt, ...)
{
    802002e0:	7131                	addi	sp,sp,-192
    802002e2:	fc86                	sd	ra,120(sp)
    802002e4:	f8a2                	sd	s0,112(sp)
    802002e6:	f4a6                	sd	s1,104(sp)
    802002e8:	f0ca                	sd	s2,96(sp)
    802002ea:	ecce                	sd	s3,88(sp)
    802002ec:	e8d2                	sd	s4,80(sp)
    802002ee:	e4d6                	sd	s5,72(sp)
    802002f0:	e0da                	sd	s6,64(sp)
    802002f2:	fc5e                	sd	s7,56(sp)
    802002f4:	f862                	sd	s8,48(sp)
    802002f6:	f466                	sd	s9,40(sp)
    802002f8:	f06a                	sd	s10,32(sp)
    802002fa:	ec6e                	sd	s11,24(sp)
    802002fc:	0100                	addi	s0,sp,128
    802002fe:	8a2a                	mv	s4,a0
    80200300:	e40c                	sd	a1,8(s0)
    80200302:	e810                	sd	a2,16(s0)
    80200304:	ec14                	sd	a3,24(s0)
    80200306:	f018                	sd	a4,32(s0)
    80200308:	f41c                	sd	a5,40(s0)
    8020030a:	03043823          	sd	a6,48(s0)
    8020030e:	03143c23          	sd	a7,56(s0)
	va_list ap;
	int i, c;
	char *s;

	if (fmt == 0)
    80200312:	c915                	beqz	a0,80200346 <printf+0x66>
		panic("null fmt");

	va_start(ap, fmt);
    80200314:	00840793          	addi	a5,s0,8
    80200318:	f8f43423          	sd	a5,-120(s0)
	for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    8020031c:	000a4503          	lbu	a0,0(s4)
    80200320:	16050863          	beqz	a0,80200490 <printf+0x1b0>
    80200324:	4981                	li	s3,0
		if (c != '%') {
    80200326:	02500a93          	li	s5,37
			continue;
		}
		c = fmt[++i] & 0xff;
		if (c == 0)
			break;
		switch (c) {
    8020032a:	07000b93          	li	s7,112
	consputc('x');
    8020032e:	4d41                	li	s10,16
		consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80200330:	00001b17          	auipc	s6,0x1
    80200334:	d68b0b13          	addi	s6,s6,-664 # 80201098 <digits>
		switch (c) {
    80200338:	07300c93          	li	s9,115
			printptr(va_arg(ap, uint64));
			break;
		case 's':
			if ((s = va_arg(ap, char *)) == 0)
				s = "(null)";
			for (; *s; s++)
    8020033c:	02800d93          	li	s11,40
		switch (c) {
    80200340:	06400c13          	li	s8,100
    80200344:	a0a9                	j	8020038e <printf+0xae>
		panic("null fmt");
    80200346:	00000097          	auipc	ra,0x0
    8020034a:	e7e080e7          	jalr	-386(ra) # 802001c4 <threadid>
    8020034e:	86aa                	mv	a3,a0
    80200350:	02e00793          	li	a5,46
    80200354:	00001717          	auipc	a4,0x1
    80200358:	d0c70713          	addi	a4,a4,-756 # 80201060 <e_text+0x60>
    8020035c:	00001617          	auipc	a2,0x1
    80200360:	cb460613          	addi	a2,a2,-844 # 80201010 <e_text+0x10>
    80200364:	45fd                	li	a1,31
    80200366:	00001517          	auipc	a0,0x1
    8020036a:	d0a50513          	addi	a0,a0,-758 # 80201070 <e_text+0x70>
    8020036e:	00000097          	auipc	ra,0x0
    80200372:	f72080e7          	jalr	-142(ra) # 802002e0 <printf>
    80200376:	bf79                	j	80200314 <printf+0x34>
			consputc(c);
    80200378:	00000097          	auipc	ra,0x0
    8020037c:	c94080e7          	jalr	-876(ra) # 8020000c <consputc>
	for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    80200380:	2985                	addiw	s3,s3,1
    80200382:	013a07b3          	add	a5,s4,s3
    80200386:	0007c503          	lbu	a0,0(a5)
    8020038a:	10050363          	beqz	a0,80200490 <printf+0x1b0>
		if (c != '%') {
    8020038e:	ff5515e3          	bne	a0,s5,80200378 <printf+0x98>
		c = fmt[++i] & 0xff;
    80200392:	2985                	addiw	s3,s3,1
    80200394:	013a07b3          	add	a5,s4,s3
    80200398:	0007c783          	lbu	a5,0(a5)
    8020039c:	0007849b          	sext.w	s1,a5
		if (c == 0)
    802003a0:	cbe5                	beqz	a5,80200490 <printf+0x1b0>
		switch (c) {
    802003a2:	05778a63          	beq	a5,s7,802003f6 <printf+0x116>
    802003a6:	02fbf663          	bgeu	s7,a5,802003d2 <printf+0xf2>
    802003aa:	09978863          	beq	a5,s9,8020043a <printf+0x15a>
    802003ae:	07800713          	li	a4,120
    802003b2:	0ce79463          	bne	a5,a4,8020047a <printf+0x19a>
			printint(va_arg(ap, int), 16, 1);
    802003b6:	f8843783          	ld	a5,-120(s0)
    802003ba:	00878713          	addi	a4,a5,8
    802003be:	f8e43423          	sd	a4,-120(s0)
    802003c2:	4605                	li	a2,1
    802003c4:	85ea                	mv	a1,s10
    802003c6:	4388                	lw	a0,0(a5)
    802003c8:	00000097          	auipc	ra,0x0
    802003cc:	e76080e7          	jalr	-394(ra) # 8020023e <printint>
			break;
    802003d0:	bf45                	j	80200380 <printf+0xa0>
		switch (c) {
    802003d2:	09578e63          	beq	a5,s5,8020046e <printf+0x18e>
    802003d6:	0b879263          	bne	a5,s8,8020047a <printf+0x19a>
			printint(va_arg(ap, int), 10, 1);
    802003da:	f8843783          	ld	a5,-120(s0)
    802003de:	00878713          	addi	a4,a5,8
    802003e2:	f8e43423          	sd	a4,-120(s0)
    802003e6:	4605                	li	a2,1
    802003e8:	45a9                	li	a1,10
    802003ea:	4388                	lw	a0,0(a5)
    802003ec:	00000097          	auipc	ra,0x0
    802003f0:	e52080e7          	jalr	-430(ra) # 8020023e <printint>
			break;
    802003f4:	b771                	j	80200380 <printf+0xa0>
			printptr(va_arg(ap, uint64));
    802003f6:	f8843783          	ld	a5,-120(s0)
    802003fa:	00878713          	addi	a4,a5,8
    802003fe:	f8e43423          	sd	a4,-120(s0)
    80200402:	0007b903          	ld	s2,0(a5)
	consputc('0');
    80200406:	03000513          	li	a0,48
    8020040a:	00000097          	auipc	ra,0x0
    8020040e:	c02080e7          	jalr	-1022(ra) # 8020000c <consputc>
	consputc('x');
    80200412:	07800513          	li	a0,120
    80200416:	00000097          	auipc	ra,0x0
    8020041a:	bf6080e7          	jalr	-1034(ra) # 8020000c <consputc>
    8020041e:	84ea                	mv	s1,s10
		consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80200420:	03c95793          	srli	a5,s2,0x3c
    80200424:	97da                	add	a5,a5,s6
    80200426:	0007c503          	lbu	a0,0(a5)
    8020042a:	00000097          	auipc	ra,0x0
    8020042e:	be2080e7          	jalr	-1054(ra) # 8020000c <consputc>
	for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80200432:	0912                	slli	s2,s2,0x4
    80200434:	34fd                	addiw	s1,s1,-1
    80200436:	f4ed                	bnez	s1,80200420 <printf+0x140>
    80200438:	b7a1                	j	80200380 <printf+0xa0>
			if ((s = va_arg(ap, char *)) == 0)
    8020043a:	f8843783          	ld	a5,-120(s0)
    8020043e:	00878713          	addi	a4,a5,8
    80200442:	f8e43423          	sd	a4,-120(s0)
    80200446:	6384                	ld	s1,0(a5)
    80200448:	cc89                	beqz	s1,80200462 <printf+0x182>
			for (; *s; s++)
    8020044a:	0004c503          	lbu	a0,0(s1)
    8020044e:	d90d                	beqz	a0,80200380 <printf+0xa0>
				consputc(*s);
    80200450:	00000097          	auipc	ra,0x0
    80200454:	bbc080e7          	jalr	-1092(ra) # 8020000c <consputc>
			for (; *s; s++)
    80200458:	0485                	addi	s1,s1,1
    8020045a:	0004c503          	lbu	a0,0(s1)
    8020045e:	f96d                	bnez	a0,80200450 <printf+0x170>
    80200460:	b705                	j	80200380 <printf+0xa0>
				s = "(null)";
    80200462:	00001497          	auipc	s1,0x1
    80200466:	bf648493          	addi	s1,s1,-1034 # 80201058 <e_text+0x58>
			for (; *s; s++)
    8020046a:	856e                	mv	a0,s11
    8020046c:	b7d5                	j	80200450 <printf+0x170>
			break;
		case '%':
			consputc('%');
    8020046e:	8556                	mv	a0,s5
    80200470:	00000097          	auipc	ra,0x0
    80200474:	b9c080e7          	jalr	-1124(ra) # 8020000c <consputc>
			break;
    80200478:	b721                	j	80200380 <printf+0xa0>
		default:
			// Print unknown % sequence to draw attention.
			consputc('%');
    8020047a:	8556                	mv	a0,s5
    8020047c:	00000097          	auipc	ra,0x0
    80200480:	b90080e7          	jalr	-1136(ra) # 8020000c <consputc>
			consputc(c);
    80200484:	8526                	mv	a0,s1
    80200486:	00000097          	auipc	ra,0x0
    8020048a:	b86080e7          	jalr	-1146(ra) # 8020000c <consputc>
			break;
    8020048e:	bdcd                	j	80200380 <printf+0xa0>
		}
	}
    80200490:	70e6                	ld	ra,120(sp)
    80200492:	7446                	ld	s0,112(sp)
    80200494:	74a6                	ld	s1,104(sp)
    80200496:	7906                	ld	s2,96(sp)
    80200498:	69e6                	ld	s3,88(sp)
    8020049a:	6a46                	ld	s4,80(sp)
    8020049c:	6aa6                	ld	s5,72(sp)
    8020049e:	6b06                	ld	s6,64(sp)
    802004a0:	7be2                	ld	s7,56(sp)
    802004a2:	7c42                	ld	s8,48(sp)
    802004a4:	7ca2                	ld	s9,40(sp)
    802004a6:	7d02                	ld	s10,32(sp)
    802004a8:	6de2                	ld	s11,24(sp)
    802004aa:	6129                	addi	sp,sp,192
    802004ac:	8082                	ret

00000000802004ae <console_putchar>:
		     : "memory");
	return a0;
}

void console_putchar(int c)
{
    802004ae:	1141                	addi	sp,sp,-16
    802004b0:	e422                	sd	s0,8(sp)
    802004b2:	0800                	addi	s0,sp,16
	register uint64 a1 asm("a1") = arg1;
    802004b4:	4581                	li	a1,0
	register uint64 a2 asm("a2") = arg2;
    802004b6:	4601                	li	a2,0
	register uint64 a7 asm("a7") = which;
    802004b8:	4885                	li	a7,1
	asm volatile("ecall"
    802004ba:	00000073          	ecall
	sbi_call(SBI_CONSOLE_PUTCHAR, c, 0, 0);
}
    802004be:	6422                	ld	s0,8(sp)
    802004c0:	0141                	addi	sp,sp,16
    802004c2:	8082                	ret

00000000802004c4 <console_getchar>:

int console_getchar()
{
    802004c4:	1141                	addi	sp,sp,-16
    802004c6:	e422                	sd	s0,8(sp)
    802004c8:	0800                	addi	s0,sp,16
	register uint64 a0 asm("a0") = arg0;
    802004ca:	4501                	li	a0,0
	register uint64 a1 asm("a1") = arg1;
    802004cc:	4581                	li	a1,0
	register uint64 a2 asm("a2") = arg2;
    802004ce:	4601                	li	a2,0
	register uint64 a7 asm("a7") = which;
    802004d0:	4889                	li	a7,2
	asm volatile("ecall"
    802004d2:	00000073          	ecall
	return sbi_call(SBI_CONSOLE_GETCHAR, 0, 0, 0);
}
    802004d6:	2501                	sext.w	a0,a0
    802004d8:	6422                	ld	s0,8(sp)
    802004da:	0141                	addi	sp,sp,16
    802004dc:	8082                	ret

00000000802004de <shutdown>:

void shutdown()
{
    802004de:	1141                	addi	sp,sp,-16
    802004e0:	e422                	sd	s0,8(sp)
    802004e2:	0800                	addi	s0,sp,16
	register uint64 a0 asm("a0") = arg0;
    802004e4:	4501                	li	a0,0
	register uint64 a1 asm("a1") = arg1;
    802004e6:	4581                	li	a1,0
	register uint64 a2 asm("a2") = arg2;
    802004e8:	4601                	li	a2,0
	register uint64 a7 asm("a7") = which;
    802004ea:	48a1                	li	a7,8
	asm volatile("ecall"
    802004ec:	00000073          	ecall
	sbi_call(SBI_SHUTDOWN, 0, 0, 0);
    802004f0:	6422                	ld	s0,8(sp)
    802004f2:	0141                	addi	sp,sp,16
    802004f4:	8082                	ret

00000000802004f6 <memset>:
#include "string.h"
#include "types.h"

void *memset(void *dst, int c, uint n)
{
    802004f6:	1141                	addi	sp,sp,-16
    802004f8:	e422                	sd	s0,8(sp)
    802004fa:	0800                	addi	s0,sp,16
	char *cdst = (char *)dst;
	int i;
	for (i = 0; i < n; i++) {
    802004fc:	ca19                	beqz	a2,80200512 <memset+0x1c>
    802004fe:	87aa                	mv	a5,a0
    80200500:	1602                	slli	a2,a2,0x20
    80200502:	9201                	srli	a2,a2,0x20
    80200504:	00a60733          	add	a4,a2,a0
		cdst[i] = c;
    80200508:	00b78023          	sb	a1,0(a5)
	for (i = 0; i < n; i++) {
    8020050c:	0785                	addi	a5,a5,1
    8020050e:	fee79de3          	bne	a5,a4,80200508 <memset+0x12>
	}
	return dst;
}
    80200512:	6422                	ld	s0,8(sp)
    80200514:	0141                	addi	sp,sp,16
    80200516:	8082                	ret

0000000080200518 <memcmp>:

int memcmp(const void *v1, const void *v2, uint n)
{
    80200518:	1141                	addi	sp,sp,-16
    8020051a:	e422                	sd	s0,8(sp)
    8020051c:	0800                	addi	s0,sp,16
	const uchar *s1, *s2;

	s1 = v1;
	s2 = v2;
	while (n-- > 0) {
    8020051e:	ca05                	beqz	a2,8020054e <memcmp+0x36>
    80200520:	fff6069b          	addiw	a3,a2,-1
    80200524:	1682                	slli	a3,a3,0x20
    80200526:	9281                	srli	a3,a3,0x20
    80200528:	0685                	addi	a3,a3,1
    8020052a:	96aa                	add	a3,a3,a0
		if (*s1 != *s2)
    8020052c:	00054783          	lbu	a5,0(a0)
    80200530:	0005c703          	lbu	a4,0(a1)
    80200534:	00e79863          	bne	a5,a4,80200544 <memcmp+0x2c>
			return *s1 - *s2;
		s1++, s2++;
    80200538:	0505                	addi	a0,a0,1
    8020053a:	0585                	addi	a1,a1,1
	while (n-- > 0) {
    8020053c:	fed518e3          	bne	a0,a3,8020052c <memcmp+0x14>
	}

	return 0;
    80200540:	4501                	li	a0,0
    80200542:	a019                	j	80200548 <memcmp+0x30>
			return *s1 - *s2;
    80200544:	40e7853b          	subw	a0,a5,a4
}
    80200548:	6422                	ld	s0,8(sp)
    8020054a:	0141                	addi	sp,sp,16
    8020054c:	8082                	ret
	return 0;
    8020054e:	4501                	li	a0,0
    80200550:	bfe5                	j	80200548 <memcmp+0x30>

0000000080200552 <memmove>:

void *memmove(void *dst, const void *src, uint n)
{
    80200552:	1141                	addi	sp,sp,-16
    80200554:	e422                	sd	s0,8(sp)
    80200556:	0800                	addi	s0,sp,16
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
    80200558:	02a5e563          	bltu	a1,a0,80200582 <memmove+0x30>
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
    8020055c:	fff6069b          	addiw	a3,a2,-1
    80200560:	ce11                	beqz	a2,8020057c <memmove+0x2a>
    80200562:	1682                	slli	a3,a3,0x20
    80200564:	9281                	srli	a3,a3,0x20
    80200566:	0685                	addi	a3,a3,1
    80200568:	96ae                	add	a3,a3,a1
    8020056a:	87aa                	mv	a5,a0
			*d++ = *s++;
    8020056c:	0585                	addi	a1,a1,1
    8020056e:	0785                	addi	a5,a5,1
    80200570:	fff5c703          	lbu	a4,-1(a1)
    80200574:	fee78fa3          	sb	a4,-1(a5)
		while (n-- > 0)
    80200578:	fed59ae3          	bne	a1,a3,8020056c <memmove+0x1a>

	return dst;
}
    8020057c:	6422                	ld	s0,8(sp)
    8020057e:	0141                	addi	sp,sp,16
    80200580:	8082                	ret
	if (s < d && s + n > d) {
    80200582:	02061713          	slli	a4,a2,0x20
    80200586:	9301                	srli	a4,a4,0x20
    80200588:	00e587b3          	add	a5,a1,a4
    8020058c:	fcf578e3          	bgeu	a0,a5,8020055c <memmove+0xa>
		d += n;
    80200590:	972a                	add	a4,a4,a0
		while (n-- > 0)
    80200592:	fff6069b          	addiw	a3,a2,-1
    80200596:	d27d                	beqz	a2,8020057c <memmove+0x2a>
    80200598:	02069613          	slli	a2,a3,0x20
    8020059c:	9201                	srli	a2,a2,0x20
    8020059e:	fff64613          	not	a2,a2
    802005a2:	963e                	add	a2,a2,a5
			*--d = *--s;
    802005a4:	17fd                	addi	a5,a5,-1
    802005a6:	177d                	addi	a4,a4,-1
    802005a8:	0007c683          	lbu	a3,0(a5)
    802005ac:	00d70023          	sb	a3,0(a4)
		while (n-- > 0)
    802005b0:	fef61ae3          	bne	a2,a5,802005a4 <memmove+0x52>
    802005b4:	b7e1                	j	8020057c <memmove+0x2a>

00000000802005b6 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void *memcpy(void *dst, const void *src, uint n)
{
    802005b6:	1141                	addi	sp,sp,-16
    802005b8:	e406                	sd	ra,8(sp)
    802005ba:	e022                	sd	s0,0(sp)
    802005bc:	0800                	addi	s0,sp,16
	return memmove(dst, src, n);
    802005be:	00000097          	auipc	ra,0x0
    802005c2:	f94080e7          	jalr	-108(ra) # 80200552 <memmove>
}
    802005c6:	60a2                	ld	ra,8(sp)
    802005c8:	6402                	ld	s0,0(sp)
    802005ca:	0141                	addi	sp,sp,16
    802005cc:	8082                	ret

00000000802005ce <strncmp>:

int strncmp(const char *p, const char *q, uint n)
{
    802005ce:	1141                	addi	sp,sp,-16
    802005d0:	e422                	sd	s0,8(sp)
    802005d2:	0800                	addi	s0,sp,16
	while (n > 0 && *p && *p == *q)
    802005d4:	ce11                	beqz	a2,802005f0 <strncmp+0x22>
    802005d6:	00054783          	lbu	a5,0(a0)
    802005da:	cf89                	beqz	a5,802005f4 <strncmp+0x26>
    802005dc:	0005c703          	lbu	a4,0(a1)
    802005e0:	00f71a63          	bne	a4,a5,802005f4 <strncmp+0x26>
		n--, p++, q++;
    802005e4:	367d                	addiw	a2,a2,-1
    802005e6:	0505                	addi	a0,a0,1
    802005e8:	0585                	addi	a1,a1,1
	while (n > 0 && *p && *p == *q)
    802005ea:	f675                	bnez	a2,802005d6 <strncmp+0x8>
	if (n == 0)
		return 0;
    802005ec:	4501                	li	a0,0
    802005ee:	a809                	j	80200600 <strncmp+0x32>
    802005f0:	4501                	li	a0,0
    802005f2:	a039                	j	80200600 <strncmp+0x32>
	if (n == 0)
    802005f4:	ca09                	beqz	a2,80200606 <strncmp+0x38>
	return (uchar)*p - (uchar)*q;
    802005f6:	00054503          	lbu	a0,0(a0)
    802005fa:	0005c783          	lbu	a5,0(a1)
    802005fe:	9d1d                	subw	a0,a0,a5
}
    80200600:	6422                	ld	s0,8(sp)
    80200602:	0141                	addi	sp,sp,16
    80200604:	8082                	ret
		return 0;
    80200606:	4501                	li	a0,0
    80200608:	bfe5                	j	80200600 <strncmp+0x32>

000000008020060a <strncpy>:

char *strncpy(char *s, const char *t, int n)
{
    8020060a:	1141                	addi	sp,sp,-16
    8020060c:	e422                	sd	s0,8(sp)
    8020060e:	0800                	addi	s0,sp,16
	char *os;

	os = s;
	while (n-- > 0 && (*s++ = *t++) != 0)
    80200610:	872a                	mv	a4,a0
    80200612:	8832                	mv	a6,a2
    80200614:	367d                	addiw	a2,a2,-1
    80200616:	01005963          	blez	a6,80200628 <strncpy+0x1e>
    8020061a:	0705                	addi	a4,a4,1
    8020061c:	0005c783          	lbu	a5,0(a1)
    80200620:	fef70fa3          	sb	a5,-1(a4)
    80200624:	0585                	addi	a1,a1,1
    80200626:	f7f5                	bnez	a5,80200612 <strncpy+0x8>
		;
	while (n-- > 0)
    80200628:	86ba                	mv	a3,a4
    8020062a:	00c05c63          	blez	a2,80200642 <strncpy+0x38>
		*s++ = 0;
    8020062e:	0685                	addi	a3,a3,1
    80200630:	fe068fa3          	sb	zero,-1(a3)
	while (n-- > 0)
    80200634:	fff6c793          	not	a5,a3
    80200638:	9fb9                	addw	a5,a5,a4
    8020063a:	010787bb          	addw	a5,a5,a6
    8020063e:	fef048e3          	bgtz	a5,8020062e <strncpy+0x24>
	return os;
}
    80200642:	6422                	ld	s0,8(sp)
    80200644:	0141                	addi	sp,sp,16
    80200646:	8082                	ret

0000000080200648 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char *safestrcpy(char *s, const char *t, int n)
{
    80200648:	1141                	addi	sp,sp,-16
    8020064a:	e422                	sd	s0,8(sp)
    8020064c:	0800                	addi	s0,sp,16
	char *os;

	os = s;
	if (n <= 0)
    8020064e:	02c05363          	blez	a2,80200674 <safestrcpy+0x2c>
    80200652:	fff6069b          	addiw	a3,a2,-1
    80200656:	1682                	slli	a3,a3,0x20
    80200658:	9281                	srli	a3,a3,0x20
    8020065a:	96ae                	add	a3,a3,a1
    8020065c:	87aa                	mv	a5,a0
		return os;
	while (--n > 0 && (*s++ = *t++) != 0)
    8020065e:	00d58963          	beq	a1,a3,80200670 <safestrcpy+0x28>
    80200662:	0585                	addi	a1,a1,1
    80200664:	0785                	addi	a5,a5,1
    80200666:	fff5c703          	lbu	a4,-1(a1)
    8020066a:	fee78fa3          	sb	a4,-1(a5)
    8020066e:	fb65                	bnez	a4,8020065e <safestrcpy+0x16>
		;
	*s = 0;
    80200670:	00078023          	sb	zero,0(a5)
	return os;
}
    80200674:	6422                	ld	s0,8(sp)
    80200676:	0141                	addi	sp,sp,16
    80200678:	8082                	ret

000000008020067a <strlen>:

int strlen(const char *s)
{
    8020067a:	1141                	addi	sp,sp,-16
    8020067c:	e422                	sd	s0,8(sp)
    8020067e:	0800                	addi	s0,sp,16
	int n;

	for (n = 0; s[n]; n++)
    80200680:	00054783          	lbu	a5,0(a0)
    80200684:	cf91                	beqz	a5,802006a0 <strlen+0x26>
    80200686:	0505                	addi	a0,a0,1
    80200688:	87aa                	mv	a5,a0
    8020068a:	4685                	li	a3,1
    8020068c:	9e89                	subw	a3,a3,a0
    8020068e:	00f6853b          	addw	a0,a3,a5
    80200692:	0785                	addi	a5,a5,1
    80200694:	fff7c703          	lbu	a4,-1(a5)
    80200698:	fb7d                	bnez	a4,8020068e <strlen+0x14>
		;
	return n;
}
    8020069a:	6422                	ld	s0,8(sp)
    8020069c:	0141                	addi	sp,sp,16
    8020069e:	8082                	ret
	for (n = 0; s[n]; n++)
    802006a0:	4501                	li	a0,0
    802006a2:	bfe5                	j	8020069a <strlen+0x20>

00000000802006a4 <dummy>:

void dummy(int _, ...)
{
    802006a4:	715d                	addi	sp,sp,-80
    802006a6:	e422                	sd	s0,8(sp)
    802006a8:	0800                	addi	s0,sp,16
    802006aa:	e40c                	sd	a1,8(s0)
    802006ac:	e810                	sd	a2,16(s0)
    802006ae:	ec14                	sd	a3,24(s0)
    802006b0:	f018                	sd	a4,32(s0)
    802006b2:	f41c                	sd	a5,40(s0)
    802006b4:	03043823          	sd	a6,48(s0)
    802006b8:	03143c23          	sd	a7,56(s0)
    802006bc:	6422                	ld	s0,8(sp)
    802006be:	6161                	addi	sp,sp,80
    802006c0:	8082                	ret

00000000802006c2 <sys_write>:
#include "loader.h"
#include "syscall_ids.h"
#include "trap.h"

uint64 sys_write(int fd, char *str, uint len)
{
    802006c2:	7179                	addi	sp,sp,-48
    802006c4:	f406                	sd	ra,40(sp)
    802006c6:	f022                	sd	s0,32(sp)
    802006c8:	ec26                	sd	s1,24(sp)
    802006ca:	e84a                	sd	s2,16(sp)
    802006cc:	e44e                	sd	s3,8(sp)
    802006ce:	1800                	addi	s0,sp,48
    802006d0:	84aa                	mv	s1,a0
    802006d2:	892e                	mv	s2,a1
    802006d4:	89b2                	mv	s3,a2
	debugf("sys_write fd = %d str = %x, len = %d", fd, str, len);
    802006d6:	86b2                	mv	a3,a2
    802006d8:	862e                	mv	a2,a1
    802006da:	85aa                	mv	a1,a0
    802006dc:	4501                	li	a0,0
    802006de:	00000097          	auipc	ra,0x0
    802006e2:	fc6080e7          	jalr	-58(ra) # 802006a4 <dummy>
	if (fd != STDOUT)
    802006e6:	4785                	li	a5,1
		return -1;
    802006e8:	557d                	li	a0,-1
	if (fd != STDOUT)
    802006ea:	02f49763          	bne	s1,a5,80200718 <sys_write+0x56>
	for (int i = 0; i < len; ++i) {
    802006ee:	02098263          	beqz	s3,80200712 <sys_write+0x50>
    802006f2:	84ca                	mv	s1,s2
    802006f4:	fff9859b          	addiw	a1,s3,-1
    802006f8:	1582                	slli	a1,a1,0x20
    802006fa:	9181                	srli	a1,a1,0x20
    802006fc:	992e                	add	s2,s2,a1
		console_putchar(str[i]);
    802006fe:	0004c503          	lbu	a0,0(s1)
    80200702:	00000097          	auipc	ra,0x0
    80200706:	dac080e7          	jalr	-596(ra) # 802004ae <console_putchar>
	for (int i = 0; i < len; ++i) {
    8020070a:	87a6                	mv	a5,s1
    8020070c:	0485                	addi	s1,s1,1
    8020070e:	ff2798e3          	bne	a5,s2,802006fe <sys_write+0x3c>
	}
	return len;
    80200712:	02099513          	slli	a0,s3,0x20
    80200716:	9101                	srli	a0,a0,0x20
}
    80200718:	70a2                	ld	ra,40(sp)
    8020071a:	7402                	ld	s0,32(sp)
    8020071c:	64e2                	ld	s1,24(sp)
    8020071e:	6942                	ld	s2,16(sp)
    80200720:	69a2                	ld	s3,8(sp)
    80200722:	6145                	addi	sp,sp,48
    80200724:	8082                	ret

0000000080200726 <sys_exit>:

__attribute__((noreturn)) void sys_exit(int code)
{
    80200726:	1141                	addi	sp,sp,-16
    80200728:	e406                	sd	ra,8(sp)
    8020072a:	e022                	sd	s0,0(sp)
    8020072c:	0800                	addi	s0,sp,16
    8020072e:	85aa                	mv	a1,a0
	debugf("sysexit(%d)", code);
    80200730:	4501                	li	a0,0
    80200732:	00000097          	auipc	ra,0x0
    80200736:	f72080e7          	jalr	-142(ra) # 802006a4 <dummy>
	run_next_app();
    8020073a:	00000097          	auipc	ra,0x0
    8020073e:	9d8080e7          	jalr	-1576(ra) # 80200112 <run_next_app>
	printf("ALL DONE\n");
    80200742:	00001517          	auipc	a0,0x1
    80200746:	96e50513          	addi	a0,a0,-1682 # 802010b0 <digits+0x18>
    8020074a:	00000097          	auipc	ra,0x0
    8020074e:	b96080e7          	jalr	-1130(ra) # 802002e0 <printf>
	shutdown();
    80200752:	00000097          	auipc	ra,0x0
    80200756:	d8c080e7          	jalr	-628(ra) # 802004de <shutdown>

000000008020075a <syscall>:
}

extern char trap_page[];

void syscall()
{
    8020075a:	7179                	addi	sp,sp,-48
    8020075c:	f406                	sd	ra,40(sp)
    8020075e:	f022                	sd	s0,32(sp)
    80200760:	ec26                	sd	s1,24(sp)
    80200762:	e84a                	sd	s2,16(sp)
    80200764:	e44e                	sd	s3,8(sp)
    80200766:	e052                	sd	s4,0(sp)
    80200768:	1800                	addi	s0,sp,48
	struct trapframe *trapframe = (struct trapframe *)trap_page;
	int id = trapframe->a7, ret;
    8020076a:	00019317          	auipc	t1,0x19
    8020076e:	89630313          	addi	t1,t1,-1898 # 80219000 <trap_page>
    80200772:	0a834483          	lbu	s1,168(t1)
    80200776:	0a934783          	lbu	a5,169(t1)
    8020077a:	07a2                	slli	a5,a5,0x8
    8020077c:	8fc5                	or	a5,a5,s1
    8020077e:	0aa34483          	lbu	s1,170(t1)
    80200782:	04c2                	slli	s1,s1,0x10
    80200784:	8fc5                	or	a5,a5,s1
    80200786:	0ab34483          	lbu	s1,171(t1)
    8020078a:	04e2                	slli	s1,s1,0x18
    8020078c:	8cdd                	or	s1,s1,a5
    8020078e:	2481                	sext.w	s1,s1
	uint64 args[6] = { trapframe->a0, trapframe->a1, trapframe->a2,
    80200790:	07034903          	lbu	s2,112(t1)
    80200794:	07134783          	lbu	a5,113(t1)
    80200798:	07a2                	slli	a5,a5,0x8
    8020079a:	0127e7b3          	or	a5,a5,s2
    8020079e:	07234903          	lbu	s2,114(t1)
    802007a2:	0942                	slli	s2,s2,0x10
    802007a4:	00f967b3          	or	a5,s2,a5
    802007a8:	07334903          	lbu	s2,115(t1)
    802007ac:	0962                	slli	s2,s2,0x18
    802007ae:	00f96933          	or	s2,s2,a5
    802007b2:	07434783          	lbu	a5,116(t1)
    802007b6:	1782                	slli	a5,a5,0x20
    802007b8:	0127e933          	or	s2,a5,s2
    802007bc:	07534783          	lbu	a5,117(t1)
    802007c0:	17a2                	slli	a5,a5,0x28
    802007c2:	0127e7b3          	or	a5,a5,s2
    802007c6:	07634903          	lbu	s2,118(t1)
    802007ca:	1942                	slli	s2,s2,0x30
    802007cc:	00f967b3          	or	a5,s2,a5
    802007d0:	07734903          	lbu	s2,119(t1)
    802007d4:	1962                	slli	s2,s2,0x38
    802007d6:	00f96933          	or	s2,s2,a5
    802007da:	07834983          	lbu	s3,120(t1)
    802007de:	07934783          	lbu	a5,121(t1)
    802007e2:	07a2                	slli	a5,a5,0x8
    802007e4:	0137e7b3          	or	a5,a5,s3
    802007e8:	07a34983          	lbu	s3,122(t1)
    802007ec:	09c2                	slli	s3,s3,0x10
    802007ee:	00f9e7b3          	or	a5,s3,a5
    802007f2:	07b34983          	lbu	s3,123(t1)
    802007f6:	09e2                	slli	s3,s3,0x18
    802007f8:	00f9e9b3          	or	s3,s3,a5
    802007fc:	07c34783          	lbu	a5,124(t1)
    80200800:	1782                	slli	a5,a5,0x20
    80200802:	0137e9b3          	or	s3,a5,s3
    80200806:	07d34783          	lbu	a5,125(t1)
    8020080a:	17a2                	slli	a5,a5,0x28
    8020080c:	0137e7b3          	or	a5,a5,s3
    80200810:	07e34983          	lbu	s3,126(t1)
    80200814:	19c2                	slli	s3,s3,0x30
    80200816:	00f9e7b3          	or	a5,s3,a5
    8020081a:	07f34983          	lbu	s3,127(t1)
    8020081e:	19e2                	slli	s3,s3,0x38
    80200820:	00f9e9b3          	or	s3,s3,a5
    80200824:	08034a03          	lbu	s4,128(t1)
    80200828:	08134783          	lbu	a5,129(t1)
    8020082c:	07a2                	slli	a5,a5,0x8
    8020082e:	0147e7b3          	or	a5,a5,s4
    80200832:	08234a03          	lbu	s4,130(t1)
    80200836:	0a42                	slli	s4,s4,0x10
    80200838:	00fa67b3          	or	a5,s4,a5
    8020083c:	08334a03          	lbu	s4,131(t1)
    80200840:	0a62                	slli	s4,s4,0x18
    80200842:	00fa6a33          	or	s4,s4,a5
    80200846:	08434783          	lbu	a5,132(t1)
    8020084a:	1782                	slli	a5,a5,0x20
    8020084c:	0147ea33          	or	s4,a5,s4
    80200850:	08534783          	lbu	a5,133(t1)
    80200854:	17a2                	slli	a5,a5,0x28
    80200856:	0147e7b3          	or	a5,a5,s4
    8020085a:	08634a03          	lbu	s4,134(t1)
    8020085e:	1a42                	slli	s4,s4,0x30
    80200860:	00fa67b3          	or	a5,s4,a5
    80200864:	08734a03          	lbu	s4,135(t1)
    80200868:	1a62                	slli	s4,s4,0x38
    8020086a:	00fa6a33          	or	s4,s4,a5
			   trapframe->a3, trapframe->a4, trapframe->a5 };
    8020086e:	09834603          	lbu	a2,152(t1)
    80200872:	09934883          	lbu	a7,153(t1)
    80200876:	08a2                	slli	a7,a7,0x8
    80200878:	00c8e8b3          	or	a7,a7,a2
    8020087c:	09a34603          	lbu	a2,154(t1)
    80200880:	0642                	slli	a2,a2,0x10
    80200882:	01166633          	or	a2,a2,a7
    80200886:	09b34883          	lbu	a7,155(t1)
    8020088a:	08e2                	slli	a7,a7,0x18
    8020088c:	00c8e8b3          	or	a7,a7,a2
    80200890:	09c34603          	lbu	a2,156(t1)
    80200894:	1602                	slli	a2,a2,0x20
    80200896:	01166633          	or	a2,a2,a7
    8020089a:	09d34883          	lbu	a7,157(t1)
    8020089e:	18a2                	slli	a7,a7,0x28
    802008a0:	00c8e8b3          	or	a7,a7,a2
    802008a4:	09e34603          	lbu	a2,158(t1)
    802008a8:	1642                	slli	a2,a2,0x30
    802008aa:	01166633          	or	a2,a2,a7
    802008ae:	09f34883          	lbu	a7,159(t1)
    802008b2:	18e2                	slli	a7,a7,0x38
    802008b4:	09034683          	lbu	a3,144(t1)
    802008b8:	09134803          	lbu	a6,145(t1)
    802008bc:	0822                	slli	a6,a6,0x8
    802008be:	00d86833          	or	a6,a6,a3
    802008c2:	09234683          	lbu	a3,146(t1)
    802008c6:	06c2                	slli	a3,a3,0x10
    802008c8:	0106e6b3          	or	a3,a3,a6
    802008cc:	09334803          	lbu	a6,147(t1)
    802008d0:	0862                	slli	a6,a6,0x18
    802008d2:	00d86833          	or	a6,a6,a3
    802008d6:	09434683          	lbu	a3,148(t1)
    802008da:	1682                	slli	a3,a3,0x20
    802008dc:	0106e6b3          	or	a3,a3,a6
    802008e0:	09534803          	lbu	a6,149(t1)
    802008e4:	1822                	slli	a6,a6,0x28
    802008e6:	00d86833          	or	a6,a6,a3
    802008ea:	09634683          	lbu	a3,150(t1)
    802008ee:	16c2                	slli	a3,a3,0x30
    802008f0:	0106e6b3          	or	a3,a3,a6
    802008f4:	09734803          	lbu	a6,151(t1)
    802008f8:	1862                	slli	a6,a6,0x38
    802008fa:	08834703          	lbu	a4,136(t1)
    802008fe:	08934783          	lbu	a5,137(t1)
    80200902:	07a2                	slli	a5,a5,0x8
    80200904:	8fd9                	or	a5,a5,a4
    80200906:	08a34703          	lbu	a4,138(t1)
    8020090a:	0742                	slli	a4,a4,0x10
    8020090c:	8f5d                	or	a4,a4,a5
    8020090e:	08b34783          	lbu	a5,139(t1)
    80200912:	07e2                	slli	a5,a5,0x18
    80200914:	8fd9                	or	a5,a5,a4
    80200916:	08c34703          	lbu	a4,140(t1)
    8020091a:	1702                	slli	a4,a4,0x20
    8020091c:	8f5d                	or	a4,a4,a5
    8020091e:	08d34783          	lbu	a5,141(t1)
    80200922:	17a2                	slli	a5,a5,0x28
    80200924:	8fd9                	or	a5,a5,a4
    80200926:	08e34703          	lbu	a4,142(t1)
    8020092a:	1742                	slli	a4,a4,0x30
    8020092c:	8f5d                	or	a4,a4,a5
    8020092e:	08f34783          	lbu	a5,143(t1)
    80200932:	17e2                	slli	a5,a5,0x38
	tracef("syscall %d args = [%x, %x, %x, %x, %x, %x]", id, args[0],
    80200934:	00c8e8b3          	or	a7,a7,a2
    80200938:	00d86833          	or	a6,a6,a3
    8020093c:	8fd9                	or	a5,a5,a4
    8020093e:	8752                	mv	a4,s4
    80200940:	86ce                	mv	a3,s3
    80200942:	864a                	mv	a2,s2
    80200944:	85a6                	mv	a1,s1
    80200946:	4501                	li	a0,0
    80200948:	00000097          	auipc	ra,0x0
    8020094c:	d5c080e7          	jalr	-676(ra) # 802006a4 <dummy>
	       args[1], args[2], args[3], args[4], args[5]);
	switch (id) {
    80200950:	04000793          	li	a5,64
    80200954:	02f48b63          	beq	s1,a5,8020098a <syscall+0x230>
    80200958:	05d00793          	li	a5,93
    8020095c:	08f48b63          	beq	s1,a5,802009f2 <syscall+0x298>
	case SYS_exit:
		sys_exit(args[0]);
		// __builtin_unreachable();
	default:
		ret = -1;
		errorf("unknown syscall %d", id);
    80200960:	00000097          	auipc	ra,0x0
    80200964:	864080e7          	jalr	-1948(ra) # 802001c4 <threadid>
    80200968:	86aa                	mv	a3,a0
    8020096a:	8726                	mv	a4,s1
    8020096c:	00000617          	auipc	a2,0x0
    80200970:	75460613          	addi	a2,a2,1876 # 802010c0 <digits+0x28>
    80200974:	45fd                	li	a1,31
    80200976:	00000517          	auipc	a0,0x0
    8020097a:	75250513          	addi	a0,a0,1874 # 802010c8 <digits+0x30>
    8020097e:	00000097          	auipc	ra,0x0
    80200982:	962080e7          	jalr	-1694(ra) # 802002e0 <printf>
		ret = -1;
    80200986:	55fd                	li	a1,-1
    80200988:	a821                	j	802009a0 <syscall+0x246>
		ret = sys_write(args[0], (char *)args[1], args[2]);
    8020098a:	000a061b          	sext.w	a2,s4
    8020098e:	85ce                	mv	a1,s3
    80200990:	0009051b          	sext.w	a0,s2
    80200994:	00000097          	auipc	ra,0x0
    80200998:	d2e080e7          	jalr	-722(ra) # 802006c2 <sys_write>
    8020099c:	0005059b          	sext.w	a1,a0
	}
	trapframe->a0 = ret;
    802009a0:	00018797          	auipc	a5,0x18
    802009a4:	66078793          	addi	a5,a5,1632 # 80219000 <trap_page>
    802009a8:	06b78823          	sb	a1,112(a5)
    802009ac:	0085d713          	srli	a4,a1,0x8
    802009b0:	06e788a3          	sb	a4,113(a5)
    802009b4:	0105d713          	srli	a4,a1,0x10
    802009b8:	06e78923          	sb	a4,114(a5)
    802009bc:	0185d71b          	srliw	a4,a1,0x18
    802009c0:	06e789a3          	sb	a4,115(a5)
    802009c4:	0385d713          	srli	a4,a1,0x38
    802009c8:	06e78a23          	sb	a4,116(a5)
    802009cc:	06e78aa3          	sb	a4,117(a5)
    802009d0:	06e78b23          	sb	a4,118(a5)
    802009d4:	06e78ba3          	sb	a4,119(a5)
	tracef("syscall ret %d", ret);
    802009d8:	4501                	li	a0,0
    802009da:	00000097          	auipc	ra,0x0
    802009de:	cca080e7          	jalr	-822(ra) # 802006a4 <dummy>
}
    802009e2:	70a2                	ld	ra,40(sp)
    802009e4:	7402                	ld	s0,32(sp)
    802009e6:	64e2                	ld	s1,24(sp)
    802009e8:	6942                	ld	s2,16(sp)
    802009ea:	69a2                	ld	s3,8(sp)
    802009ec:	6a02                	ld	s4,0(sp)
    802009ee:	6145                	addi	sp,sp,48
    802009f0:	8082                	ret
		sys_exit(args[0]);
    802009f2:	0009051b          	sext.w	a0,s2
    802009f6:	00000097          	auipc	ra,0x0
    802009fa:	d30080e7          	jalr	-720(ra) # 80200726 <sys_exit>

00000000802009fe <trap_init>:
extern char trampoline[], uservec[], boot_stack_top[];
extern void *userret(uint64);

// set up to take exceptions and traps while in the kernel.
void trap_init(void)
{
    802009fe:	1141                	addi	sp,sp,-16
    80200a00:	e422                	sd	s0,8(sp)
    80200a02:	0800                	addi	s0,sp,16
	w_stvec((uint64)uservec & ~0x3);
    80200a04:	00000797          	auipc	a5,0x0
    80200a08:	1bc78793          	addi	a5,a5,444 # 80200bc0 <trampoline>
    80200a0c:	9bf1                	andi	a5,a5,-4

// Supervisor Trap-Vector Base Address
// low two bits are mode.
static inline void w_stvec(uint64 x)
{
	asm volatile("csrw stvec, %0" : : "r"(x));
    80200a0e:	10579073          	csrw	stvec,a5
}
    80200a12:	6422                	ld	s0,8(sp)
    80200a14:	0141                	addi	sp,sp,16
    80200a16:	8082                	ret

0000000080200a18 <usertrapret>:

//
// return to user space
//
void usertrapret(struct trapframe *trapframe, uint64 kstack)
{
    80200a18:	1141                	addi	sp,sp,-16
    80200a1a:	e406                	sd	ra,8(sp)
    80200a1c:	e022                	sd	s0,0(sp)
    80200a1e:	0800                	addi	s0,sp,16
}

static inline uint64 r_satp()
{
	uint64 x;
	asm volatile("csrr %0, satp" : "=r"(x));
    80200a20:	18002773          	csrr	a4,satp
	trapframe->kernel_satp = r_satp(); // kernel page table
    80200a24:	e118                	sd	a4,0(a0)
	trapframe->kernel_sp = kstack + PGSIZE; // process's kernel stack
    80200a26:	6705                	lui	a4,0x1
    80200a28:	95ba                	add	a1,a1,a4
    80200a2a:	e50c                	sd	a1,8(a0)
	trapframe->kernel_trap = (uint64)usertrap;
    80200a2c:	00000717          	auipc	a4,0x0
    80200a30:	03470713          	addi	a4,a4,52 # 80200a60 <usertrap>
    80200a34:	e918                	sd	a4,16(a0)
// read and write tp, the thread pointer, which holds
// this core's hartid (core number), the index into cpus[].
static inline uint64 r_tp()
{
	uint64 x;
	asm volatile("mv %0, tp" : "=r"(x));
    80200a36:	8712                	mv	a4,tp
	trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80200a38:	f118                	sd	a4,32(a0)
	asm volatile("csrw sepc, %0" : : "r"(x));
    80200a3a:	6d1c                	ld	a5,24(a0)
    80200a3c:	14179073          	csrw	sepc,a5
	asm volatile("csrr %0, sstatus" : "=r"(x));
    80200a40:	100027f3          	csrr	a5,sstatus
	// set up the registers that trampoline.S's sret will use
	// to get to user space.

	// set S Previous Privilege mode to User.
	uint64 x = r_sstatus();
	x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80200a44:	eff7f793          	andi	a5,a5,-257
	x |= SSTATUS_SPIE; // enable interrupts in user mode
    80200a48:	0207e793          	ori	a5,a5,32
	asm volatile("csrw sstatus, %0" : : "r"(x));
    80200a4c:	10079073          	csrw	sstatus,a5
	w_sstatus(x);

	// tell trampoline.S the user page table to switch to.
	// uint64 satp = MAKE_SATP(p->pagetable);
	userret((uint64)trapframe);
    80200a50:	00000097          	auipc	ra,0x0
    80200a54:	200080e7          	jalr	512(ra) # 80200c50 <userret>
    80200a58:	60a2                	ld	ra,8(sp)
    80200a5a:	6402                	ld	s0,0(sp)
    80200a5c:	0141                	addi	sp,sp,16
    80200a5e:	8082                	ret

0000000080200a60 <usertrap>:
{
    80200a60:	1101                	addi	sp,sp,-32
    80200a62:	ec06                	sd	ra,24(sp)
    80200a64:	e822                	sd	s0,16(sp)
    80200a66:	e426                	sd	s1,8(sp)
    80200a68:	e04a                	sd	s2,0(sp)
    80200a6a:	1000                	addi	s0,sp,32
    80200a6c:	892a                	mv	s2,a0
	asm volatile("csrr %0, sstatus" : "=r"(x));
    80200a6e:	100027f3          	csrr	a5,sstatus
	if ((r_sstatus() & SSTATUS_SPP) != 0)
    80200a72:	1007f793          	andi	a5,a5,256
    80200a76:	e39d                	bnez	a5,80200a9c <usertrap+0x3c>
	asm volatile("csrr %0, scause" : "=r"(x));
    80200a78:	142024f3          	csrr	s1,scause
	if (cause == UserEnvCall) {
    80200a7c:	47a1                	li	a5,8
    80200a7e:	04f48763          	beq	s1,a5,80200acc <usertrap+0x6c>
	switch (cause) {
    80200a82:	47bd                	li	a5,15
    80200a84:	0e97ee63          	bltu	a5,s1,80200b80 <usertrap+0x120>
    80200a88:	00249713          	slli	a4,s1,0x2
    80200a8c:	00000697          	auipc	a3,0x0
    80200a90:	78c68693          	addi	a3,a3,1932 # 80201218 <digits+0x180>
    80200a94:	9736                	add	a4,a4,a3
    80200a96:	431c                	lw	a5,0(a4)
    80200a98:	97b6                	add	a5,a5,a3
    80200a9a:	8782                	jr	a5
		panic("usertrap: not from user mode");
    80200a9c:	fffff097          	auipc	ra,0xfffff
    80200aa0:	728080e7          	jalr	1832(ra) # 802001c4 <threadid>
    80200aa4:	86aa                	mv	a3,a0
    80200aa6:	47d9                	li	a5,22
    80200aa8:	00000717          	auipc	a4,0x0
    80200aac:	64870713          	addi	a4,a4,1608 # 802010f0 <digits+0x58>
    80200ab0:	00000617          	auipc	a2,0x0
    80200ab4:	56060613          	addi	a2,a2,1376 # 80201010 <e_text+0x10>
    80200ab8:	45fd                	li	a1,31
    80200aba:	00000517          	auipc	a0,0x0
    80200abe:	64650513          	addi	a0,a0,1606 # 80201100 <digits+0x68>
    80200ac2:	00000097          	auipc	ra,0x0
    80200ac6:	81e080e7          	jalr	-2018(ra) # 802002e0 <printf>
    80200aca:	b77d                	j	80200a78 <usertrap+0x18>
		trapframe->epc += 4;
    80200acc:	01893783          	ld	a5,24(s2)
    80200ad0:	0791                	addi	a5,a5,4
    80200ad2:	00f93c23          	sd	a5,24(s2)
		syscall();
    80200ad6:	00000097          	auipc	ra,0x0
    80200ada:	c84080e7          	jalr	-892(ra) # 8020075a <syscall>
		return usertrapret(trapframe, (uint64)boot_stack_top);
    80200ade:	00018597          	auipc	a1,0x18
    80200ae2:	52258593          	addi	a1,a1,1314 # 80219000 <trap_page>
    80200ae6:	854a                	mv	a0,s2
    80200ae8:	00000097          	auipc	ra,0x0
    80200aec:	f30080e7          	jalr	-208(ra) # 80200a18 <usertrapret>
    80200af0:	a8a9                	j	80200b4a <usertrap+0xea>
		errorf("%d in application, bad addr = %p, bad instruction = %p, core "
    80200af2:	fffff097          	auipc	ra,0xfffff
    80200af6:	6d2080e7          	jalr	1746(ra) # 802001c4 <threadid>
    80200afa:	86aa                	mv	a3,a0
	asm volatile("csrr %0, stval" : "=r"(x));
    80200afc:	143027f3          	csrr	a5,stval
    80200b00:	01893803          	ld	a6,24(s2)
    80200b04:	8726                	mv	a4,s1
    80200b06:	00000617          	auipc	a2,0x0
    80200b0a:	5ba60613          	addi	a2,a2,1466 # 802010c0 <digits+0x28>
    80200b0e:	45fd                	li	a1,31
    80200b10:	00000517          	auipc	a0,0x0
    80200b14:	62850513          	addi	a0,a0,1576 # 80201138 <digits+0xa0>
    80200b18:	fffff097          	auipc	ra,0xfffff
    80200b1c:	7c8080e7          	jalr	1992(ra) # 802002e0 <printf>
	infof("switch to next app");
    80200b20:	4501                	li	a0,0
    80200b22:	00000097          	auipc	ra,0x0
    80200b26:	b82080e7          	jalr	-1150(ra) # 802006a4 <dummy>
	run_next_app();
    80200b2a:	fffff097          	auipc	ra,0xfffff
    80200b2e:	5e8080e7          	jalr	1512(ra) # 80200112 <run_next_app>
	printf("ALL DONE\n");
    80200b32:	00000517          	auipc	a0,0x0
    80200b36:	57e50513          	addi	a0,a0,1406 # 802010b0 <digits+0x18>
    80200b3a:	fffff097          	auipc	ra,0xfffff
    80200b3e:	7a6080e7          	jalr	1958(ra) # 802002e0 <printf>
	shutdown();
    80200b42:	00000097          	auipc	ra,0x0
    80200b46:	99c080e7          	jalr	-1636(ra) # 802004de <shutdown>
}
    80200b4a:	60e2                	ld	ra,24(sp)
    80200b4c:	6442                	ld	s0,16(sp)
    80200b4e:	64a2                	ld	s1,8(sp)
    80200b50:	6902                	ld	s2,0(sp)
    80200b52:	6105                	addi	sp,sp,32
    80200b54:	8082                	ret
		errorf("IllegalInstruction in application, epc = %p, core dumped.",
    80200b56:	fffff097          	auipc	ra,0xfffff
    80200b5a:	66e080e7          	jalr	1646(ra) # 802001c4 <threadid>
    80200b5e:	86aa                	mv	a3,a0
    80200b60:	01893703          	ld	a4,24(s2)
    80200b64:	00000617          	auipc	a2,0x0
    80200b68:	55c60613          	addi	a2,a2,1372 # 802010c0 <digits+0x28>
    80200b6c:	45fd                	li	a1,31
    80200b6e:	00000517          	auipc	a0,0x0
    80200b72:	62250513          	addi	a0,a0,1570 # 80201190 <digits+0xf8>
    80200b76:	fffff097          	auipc	ra,0xfffff
    80200b7a:	76a080e7          	jalr	1898(ra) # 802002e0 <printf>
		break;
    80200b7e:	b74d                	j	80200b20 <usertrap+0xc0>
		errorf("unknown trap: %p, stval = %p sepc = %p", r_scause(),
    80200b80:	fffff097          	auipc	ra,0xfffff
    80200b84:	644080e7          	jalr	1604(ra) # 802001c4 <threadid>
    80200b88:	86aa                	mv	a3,a0
	asm volatile("csrr %0, scause" : "=r"(x));
    80200b8a:	14202773          	csrr	a4,scause
	asm volatile("csrr %0, stval" : "=r"(x));
    80200b8e:	143027f3          	csrr	a5,stval
	asm volatile("csrr %0, sepc" : "=r"(x));
    80200b92:	14102873          	csrr	a6,sepc
    80200b96:	00000617          	auipc	a2,0x0
    80200b9a:	52a60613          	addi	a2,a2,1322 # 802010c0 <digits+0x28>
    80200b9e:	45fd                	li	a1,31
    80200ba0:	00000517          	auipc	a0,0x0
    80200ba4:	64050513          	addi	a0,a0,1600 # 802011e0 <digits+0x148>
    80200ba8:	fffff097          	auipc	ra,0xfffff
    80200bac:	738080e7          	jalr	1848(ra) # 802002e0 <printf>
		break;
    80200bb0:	bf85                	j	80200b20 <usertrap+0xc0>
	...

0000000080200bc0 <trampoline>:
        # mapped into user space, at TRAPFRAME.
        #

	# swap a0 and sscratch
        # so that a0 is TRAPFRAME
        csrrw a0, sscratch, a0
    80200bc0:	14051573          	csrrw	a0,sscratch,a0

        # save the user registers in TRAPFRAME
        sd ra, 40(a0)
    80200bc4:	02153423          	sd	ra,40(a0)
        sd sp, 48(a0)
    80200bc8:	02253823          	sd	sp,48(a0)
        sd gp, 56(a0)
    80200bcc:	02353c23          	sd	gp,56(a0)
        sd tp, 64(a0)
    80200bd0:	04453023          	sd	tp,64(a0)
        sd t0, 72(a0)
    80200bd4:	04553423          	sd	t0,72(a0)
        sd t1, 80(a0)
    80200bd8:	04653823          	sd	t1,80(a0)
        sd t2, 88(a0)
    80200bdc:	04753c23          	sd	t2,88(a0)
        sd s0, 96(a0)
    80200be0:	f120                	sd	s0,96(a0)
        sd s1, 104(a0)
    80200be2:	f524                	sd	s1,104(a0)
        sd a1, 120(a0)
    80200be4:	fd2c                	sd	a1,120(a0)
        sd a2, 128(a0)
    80200be6:	e150                	sd	a2,128(a0)
        sd a3, 136(a0)
    80200be8:	e554                	sd	a3,136(a0)
        sd a4, 144(a0)
    80200bea:	e958                	sd	a4,144(a0)
        sd a5, 152(a0)
    80200bec:	ed5c                	sd	a5,152(a0)
        sd a6, 160(a0)
    80200bee:	0b053023          	sd	a6,160(a0)
        sd a7, 168(a0)
    80200bf2:	0b153423          	sd	a7,168(a0)
        sd s2, 176(a0)
    80200bf6:	0b253823          	sd	s2,176(a0)
        sd s3, 184(a0)
    80200bfa:	0b353c23          	sd	s3,184(a0)
        sd s4, 192(a0)
    80200bfe:	0d453023          	sd	s4,192(a0)
        sd s5, 200(a0)
    80200c02:	0d553423          	sd	s5,200(a0)
        sd s6, 208(a0)
    80200c06:	0d653823          	sd	s6,208(a0)
        sd s7, 216(a0)
    80200c0a:	0d753c23          	sd	s7,216(a0)
        sd s8, 224(a0)
    80200c0e:	0f853023          	sd	s8,224(a0)
        sd s9, 232(a0)
    80200c12:	0f953423          	sd	s9,232(a0)
        sd s10, 240(a0)
    80200c16:	0fa53823          	sd	s10,240(a0)
        sd s11, 248(a0)
    80200c1a:	0fb53c23          	sd	s11,248(a0)
        sd t3, 256(a0)
    80200c1e:	11c53023          	sd	t3,256(a0)
        sd t4, 264(a0)
    80200c22:	11d53423          	sd	t4,264(a0)
        sd t5, 272(a0)
    80200c26:	11e53823          	sd	t5,272(a0)
        sd t6, 280(a0)
    80200c2a:	11f53c23          	sd	t6,280(a0)

	# save the user a0 in p->trapframe->a0
        csrr t0, sscratch
    80200c2e:	140022f3          	csrr	t0,sscratch
        sd t0, 112(a0)
    80200c32:	06553823          	sd	t0,112(a0)

        csrr t1, sepc
    80200c36:	14102373          	csrr	t1,sepc
        sd t1, 24(a0)
    80200c3a:	00653c23          	sd	t1,24(a0)

        ld sp, 8(a0)
    80200c3e:	00853103          	ld	sp,8(a0)
        ld tp, 32(a0)
    80200c42:	02053203          	ld	tp,32(a0)
        ld t1, 0(a0)
    80200c46:	00053303          	ld	t1,0(a0)
        # csrw satp, t1
        # sfence.vma zero, zero
        ld t0, 16(a0)
    80200c4a:	01053283          	ld	t0,16(a0)
        jr t0
    80200c4e:	8282                	jr	t0

0000000080200c50 <userret>:
        # csrw satp, a1
        # sfence.vma zero, zero

        # put the saved user a0 in sscratch, so we
        # can swap it with our a0 (TRAPFRAME) in the last step.
        ld t0, 112(a0)
    80200c50:	07053283          	ld	t0,112(a0)
        csrw sscratch, t0
    80200c54:	14029073          	csrw	sscratch,t0

        # restore all but a0 from TRAPFRAME
        ld ra, 40(a0)
    80200c58:	02853083          	ld	ra,40(a0)
        ld sp, 48(a0)
    80200c5c:	03053103          	ld	sp,48(a0)
        ld gp, 56(a0)
    80200c60:	03853183          	ld	gp,56(a0)
        ld tp, 64(a0)
    80200c64:	04053203          	ld	tp,64(a0)
        ld t0, 72(a0)
    80200c68:	04853283          	ld	t0,72(a0)
        ld t1, 80(a0)
    80200c6c:	05053303          	ld	t1,80(a0)
        ld t2, 88(a0)
    80200c70:	05853383          	ld	t2,88(a0)
        ld s0, 96(a0)
    80200c74:	7120                	ld	s0,96(a0)
        ld s1, 104(a0)
    80200c76:	7524                	ld	s1,104(a0)
        ld a1, 120(a0)
    80200c78:	7d2c                	ld	a1,120(a0)
        ld a2, 128(a0)
    80200c7a:	6150                	ld	a2,128(a0)
        ld a3, 136(a0)
    80200c7c:	6554                	ld	a3,136(a0)
        ld a4, 144(a0)
    80200c7e:	6958                	ld	a4,144(a0)
        ld a5, 152(a0)
    80200c80:	6d5c                	ld	a5,152(a0)
        ld a6, 160(a0)
    80200c82:	0a053803          	ld	a6,160(a0)
        ld a7, 168(a0)
    80200c86:	0a853883          	ld	a7,168(a0)
        ld s2, 176(a0)
    80200c8a:	0b053903          	ld	s2,176(a0)
        ld s3, 184(a0)
    80200c8e:	0b853983          	ld	s3,184(a0)
        ld s4, 192(a0)
    80200c92:	0c053a03          	ld	s4,192(a0)
        ld s5, 200(a0)
    80200c96:	0c853a83          	ld	s5,200(a0)
        ld s6, 208(a0)
    80200c9a:	0d053b03          	ld	s6,208(a0)
        ld s7, 216(a0)
    80200c9e:	0d853b83          	ld	s7,216(a0)
        ld s8, 224(a0)
    80200ca2:	0e053c03          	ld	s8,224(a0)
        ld s9, 232(a0)
    80200ca6:	0e853c83          	ld	s9,232(a0)
        ld s10, 240(a0)
    80200caa:	0f053d03          	ld	s10,240(a0)
        ld s11, 248(a0)
    80200cae:	0f853d83          	ld	s11,248(a0)
        ld t3, 256(a0)
    80200cb2:	10053e03          	ld	t3,256(a0)
        ld t4, 264(a0)
    80200cb6:	10853e83          	ld	t4,264(a0)
        ld t5, 272(a0)
    80200cba:	11053f03          	ld	t5,272(a0)
        ld t6, 280(a0)
    80200cbe:	11853f83          	ld	t6,280(a0)

	# restore user a0, and save TRAPFRAME in sscratch
        csrrw a0, sscratch, a0
    80200cc2:	14051573          	csrrw	a0,sscratch,a0

        # return to user mode and user pc.
        # usertrapret() set up sstatus and sepc.
        sret
    80200cc6:	10200073          	sret
	...
