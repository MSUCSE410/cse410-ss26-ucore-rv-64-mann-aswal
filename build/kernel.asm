
build/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080200000 <_entry>:
    .section .text.entry
    .globl _entry
_entry:
    la sp, boot_stack_top
    80200000:	00064117          	auipc	sp,0x64
    80200004:	00010113          	mv	sp,sp
    call main
    80200008:	666000ef          	jal	ra,8020066e <main>

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
    80200014:	00001097          	auipc	ra,0x1
    80200018:	0a6080e7          	jalr	166(ra) # 802010ba <console_putchar>
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
}
    8020002a:	6422                	ld	s0,8(sp)
    8020002c:	0141                	addi	sp,sp,16
    8020002e:	8082                	ret

0000000080200030 <consgetc>:

int consgetc()
{
    80200030:	1141                	addi	sp,sp,-16
    80200032:	e406                	sd	ra,8(sp)
    80200034:	e022                	sd	s0,0(sp)
    80200036:	0800                	addi	s0,sp,16
	return console_getchar();
    80200038:	00001097          	auipc	ra,0x1
    8020003c:	098080e7          	jalr	152(ra) # 802010d0 <console_getchar>
    80200040:	60a2                	ld	ra,8(sp)
    80200042:	6402                	ld	s0,0(sp)
    80200044:	0141                	addi	sp,sp,16
    80200046:	8082                	ret

0000000080200048 <kfree>:
// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void kfree(void *pa)
{
    80200048:	1101                	addi	sp,sp,-32
    8020004a:	ec06                	sd	ra,24(sp)
    8020004c:	e822                	sd	s0,16(sp)
    8020004e:	e426                	sd	s1,8(sp)
    80200050:	1000                	addi	s0,sp,32
    80200052:	84aa                	mv	s1,a0
	struct linklist *l;
	if (((uint64)pa % PGSIZE) != 0 || (char *)pa < ekernel ||
    80200054:	03451793          	slli	a5,a0,0x34
    80200058:	eb99                	bnez	a5,8020006e <kfree+0x26>
    8020005a:	00491797          	auipc	a5,0x491
    8020005e:	fa678793          	addi	a5,a5,-90 # 80691000 <e_bss>
    80200062:	00f56663          	bltu	a0,a5,8020006e <kfree+0x26>
    80200066:	47c5                	li	a5,17
    80200068:	07ee                	slli	a5,a5,0x1b
    8020006a:	02f56e63          	bltu	a0,a5,802000a6 <kfree+0x5e>
	    (uint64)pa >= PHYSTOP)
		panic("kfree");
    8020006e:	00001097          	auipc	ra,0x1
    80200072:	8e2080e7          	jalr	-1822(ra) # 80200950 <threadid>
    80200076:	86aa                	mv	a3,a0
    80200078:	02500793          	li	a5,37
    8020007c:	00004717          	auipc	a4,0x4
    80200080:	f8470713          	addi	a4,a4,-124 # 80204000 <e_text>
    80200084:	00004617          	auipc	a2,0x4
    80200088:	f8c60613          	addi	a2,a2,-116 # 80204010 <e_text+0x10>
    8020008c:	45fd                	li	a1,31
    8020008e:	00004517          	auipc	a0,0x4
    80200092:	f8a50513          	addi	a0,a0,-118 # 80204018 <e_text+0x18>
    80200096:	00000097          	auipc	ra,0x0
    8020009a:	6e4080e7          	jalr	1764(ra) # 8020077a <printf>
    8020009e:	00001097          	auipc	ra,0x1
    802000a2:	04c080e7          	jalr	76(ra) # 802010ea <shutdown>
	// Fill with junk to catch dangling refs.
	memset(pa, 1, PGSIZE);
    802000a6:	6605                	lui	a2,0x1
    802000a8:	4585                	li	a1,1
    802000aa:	8526                	mv	a0,s1
    802000ac:	00001097          	auipc	ra,0x1
    802000b0:	06c080e7          	jalr	108(ra) # 80201118 <memset>
	l = (struct linklist *)pa;
	l->next = kmem.freelist;
    802000b4:	00490797          	auipc	a5,0x490
    802000b8:	f4c78793          	addi	a5,a5,-180 # 80690000 <kmem>
    802000bc:	6398                	ld	a4,0(a5)
    802000be:	e098                	sd	a4,0(s1)
	kmem.freelist = l;
    802000c0:	e384                	sd	s1,0(a5)
}
    802000c2:	60e2                	ld	ra,24(sp)
    802000c4:	6442                	ld	s0,16(sp)
    802000c6:	64a2                	ld	s1,8(sp)
    802000c8:	6105                	addi	sp,sp,32
    802000ca:	8082                	ret

00000000802000cc <freerange>:
{
    802000cc:	7179                	addi	sp,sp,-48
    802000ce:	f406                	sd	ra,40(sp)
    802000d0:	f022                	sd	s0,32(sp)
    802000d2:	ec26                	sd	s1,24(sp)
    802000d4:	e84a                	sd	s2,16(sp)
    802000d6:	e44e                	sd	s3,8(sp)
    802000d8:	e052                	sd	s4,0(sp)
    802000da:	1800                	addi	s0,sp,48
	p = (char *)PGROUNDUP((uint64)pa_start);
    802000dc:	6785                	lui	a5,0x1
    802000de:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x801ff001>
    802000e2:	94aa                	add	s1,s1,a0
    802000e4:	757d                	lui	a0,0xfffff
    802000e6:	8ce9                	and	s1,s1,a0
	for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    802000e8:	94be                	add	s1,s1,a5
    802000ea:	0095ee63          	bltu	a1,s1,80200106 <freerange+0x3a>
    802000ee:	892e                	mv	s2,a1
		kfree(p);
    802000f0:	7a7d                	lui	s4,0xfffff
	for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    802000f2:	6985                	lui	s3,0x1
		kfree(p);
    802000f4:	01448533          	add	a0,s1,s4
    802000f8:	00000097          	auipc	ra,0x0
    802000fc:	f50080e7          	jalr	-176(ra) # 80200048 <kfree>
	for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80200100:	94ce                	add	s1,s1,s3
    80200102:	fe9979e3          	bgeu	s2,s1,802000f4 <freerange+0x28>
}
    80200106:	70a2                	ld	ra,40(sp)
    80200108:	7402                	ld	s0,32(sp)
    8020010a:	64e2                	ld	s1,24(sp)
    8020010c:	6942                	ld	s2,16(sp)
    8020010e:	69a2                	ld	s3,8(sp)
    80200110:	6a02                	ld	s4,0(sp)
    80200112:	6145                	addi	sp,sp,48
    80200114:	8082                	ret

0000000080200116 <kinit>:
{
    80200116:	1141                	addi	sp,sp,-16
    80200118:	e406                	sd	ra,8(sp)
    8020011a:	e022                	sd	s0,0(sp)
    8020011c:	0800                	addi	s0,sp,16
	freerange(ekernel, (void *)PHYSTOP);
    8020011e:	45c5                	li	a1,17
    80200120:	05ee                	slli	a1,a1,0x1b
    80200122:	00491517          	auipc	a0,0x491
    80200126:	ede50513          	addi	a0,a0,-290 # 80691000 <e_bss>
    8020012a:	00000097          	auipc	ra,0x0
    8020012e:	fa2080e7          	jalr	-94(ra) # 802000cc <freerange>
}
    80200132:	60a2                	ld	ra,8(sp)
    80200134:	6402                	ld	s0,0(sp)
    80200136:	0141                	addi	sp,sp,16
    80200138:	8082                	ret

000000008020013a <kalloc>:

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *kalloc()
{
    8020013a:	1101                	addi	sp,sp,-32
    8020013c:	ec06                	sd	ra,24(sp)
    8020013e:	e822                	sd	s0,16(sp)
    80200140:	e426                	sd	s1,8(sp)
    80200142:	1000                	addi	s0,sp,32
	struct linklist *l;
	l = kmem.freelist;
    80200144:	00490497          	auipc	s1,0x490
    80200148:	ebc4b483          	ld	s1,-324(s1) # 80690000 <kmem>
	if (l) {
    8020014c:	cc89                	beqz	s1,80200166 <kalloc+0x2c>
		kmem.freelist = l->next;
    8020014e:	609c                	ld	a5,0(s1)
    80200150:	00490717          	auipc	a4,0x490
    80200154:	eaf73823          	sd	a5,-336(a4) # 80690000 <kmem>
		memset((char *)l, 5, PGSIZE); // fill with junk
    80200158:	6605                	lui	a2,0x1
    8020015a:	4595                	li	a1,5
    8020015c:	8526                	mv	a0,s1
    8020015e:	00001097          	auipc	ra,0x1
    80200162:	fba080e7          	jalr	-70(ra) # 80201118 <memset>
	}
	return (void *)l;
    80200166:	8526                	mv	a0,s1
    80200168:	60e2                	ld	ra,24(sp)
    8020016a:	6442                	ld	s0,16(sp)
    8020016c:	64a2                	ld	s1,8(sp)
    8020016e:	6105                	addi	sp,sp,32
    80200170:	8082                	ret

0000000080200172 <loader_init>:
extern char _app_num[], _app_names[], INIT_PROC[];
char names[MAX_APP_NUM][MAX_STR_LEN];

// Get user progs' infomation through pre-defined symbol in `link_app.S`
void loader_init()
{
    80200172:	7139                	addi	sp,sp,-64
    80200174:	fc06                	sd	ra,56(sp)
    80200176:	f822                	sd	s0,48(sp)
    80200178:	f426                	sd	s1,40(sp)
    8020017a:	f04a                	sd	s2,32(sp)
    8020017c:	ec4e                	sd	s3,24(sp)
    8020017e:	e852                	sd	s4,16(sp)
    80200180:	e456                	sd	s5,8(sp)
    80200182:	e05a                	sd	s6,0(sp)
    80200184:	0080                	addi	s0,sp,64
	char *s;
	app_info_ptr = (uint64 *)_app_num;
	app_num = *app_info_ptr;
    80200186:	00490497          	auipc	s1,0x490
    8020018a:	e8a48493          	addi	s1,s1,-374 # 80690010 <app_num>
    8020018e:	00005697          	auipc	a3,0x5
    80200192:	e7268693          	addi	a3,a3,-398 # 80205000 <_app_num>
    80200196:	0006c783          	lbu	a5,0(a3)
    8020019a:	0016c703          	lbu	a4,1(a3)
    8020019e:	0722                	slli	a4,a4,0x8
    802001a0:	8f5d                	or	a4,a4,a5
    802001a2:	0026c783          	lbu	a5,2(a3)
    802001a6:	07c2                	slli	a5,a5,0x10
    802001a8:	8f5d                	or	a4,a4,a5
    802001aa:	0036c783          	lbu	a5,3(a3)
    802001ae:	07e2                	slli	a5,a5,0x18
    802001b0:	8fd9                	or	a5,a5,a4
    802001b2:	c09c                	sw	a5,0(s1)
	app_info_ptr++;
    802001b4:	00005797          	auipc	a5,0x5
    802001b8:	e5478793          	addi	a5,a5,-428 # 80205008 <_app_num+0x8>
    802001bc:	00490717          	auipc	a4,0x490
    802001c0:	e4f73623          	sd	a5,-436(a4) # 80690008 <app_info_ptr>
	s = _app_names;
	printf("app list:\n");
    802001c4:	00004517          	auipc	a0,0x4
    802001c8:	e7450513          	addi	a0,a0,-396 # 80204038 <e_text+0x38>
    802001cc:	00000097          	auipc	ra,0x0
    802001d0:	5ae080e7          	jalr	1454(ra) # 8020077a <printf>
	for (int i = 0; i < app_num; ++i) {
    802001d4:	409c                	lw	a5,0(s1)
    802001d6:	04f05c63          	blez	a5,8020022e <loader_init+0xbc>
    802001da:	00064997          	auipc	s3,0x64
    802001de:	e2698993          	addi	s3,s3,-474 # 80264000 <names>
    802001e2:	4a01                	li	s4,0
	s = _app_names;
    802001e4:	00005917          	auipc	s2,0x5
    802001e8:	f5c90913          	addi	s2,s2,-164 # 80205140 <_app_names>
		int len = strlen(s);
		strncpy(names[i], (const char *)s, len);
		s += len + 1;
		printf("%s\n", names[i]);
    802001ec:	00004b17          	auipc	s6,0x4
    802001f0:	e5cb0b13          	addi	s6,s6,-420 # 80204048 <e_text+0x48>
	for (int i = 0; i < app_num; ++i) {
    802001f4:	8aa6                	mv	s5,s1
		int len = strlen(s);
    802001f6:	854a                	mv	a0,s2
    802001f8:	00001097          	auipc	ra,0x1
    802001fc:	0a4080e7          	jalr	164(ra) # 8020129c <strlen>
    80200200:	84aa                	mv	s1,a0
		strncpy(names[i], (const char *)s, len);
    80200202:	862a                	mv	a2,a0
    80200204:	85ca                	mv	a1,s2
    80200206:	854e                	mv	a0,s3
    80200208:	00001097          	auipc	ra,0x1
    8020020c:	024080e7          	jalr	36(ra) # 8020122c <strncpy>
		s += len + 1;
    80200210:	0485                	addi	s1,s1,1
    80200212:	9926                	add	s2,s2,s1
		printf("%s\n", names[i]);
    80200214:	85ce                	mv	a1,s3
    80200216:	855a                	mv	a0,s6
    80200218:	00000097          	auipc	ra,0x0
    8020021c:	562080e7          	jalr	1378(ra) # 8020077a <printf>
	for (int i = 0; i < app_num; ++i) {
    80200220:	2a05                	addiw	s4,s4,1
    80200222:	0c898993          	addi	s3,s3,200
    80200226:	000aa783          	lw	a5,0(s5)
    8020022a:	fcfa46e3          	blt	s4,a5,802001f6 <loader_init+0x84>
	}
}
    8020022e:	70e2                	ld	ra,56(sp)
    80200230:	7442                	ld	s0,48(sp)
    80200232:	74a2                	ld	s1,40(sp)
    80200234:	7902                	ld	s2,32(sp)
    80200236:	69e2                	ld	s3,24(sp)
    80200238:	6a42                	ld	s4,16(sp)
    8020023a:	6aa2                	ld	s5,8(sp)
    8020023c:	6b02                	ld	s6,0(sp)
    8020023e:	6121                	addi	sp,sp,64
    80200240:	8082                	ret

0000000080200242 <get_id_by_name>:

int get_id_by_name(char *name)
{
    80200242:	7179                	addi	sp,sp,-48
    80200244:	f406                	sd	ra,40(sp)
    80200246:	f022                	sd	s0,32(sp)
    80200248:	ec26                	sd	s1,24(sp)
    8020024a:	e84a                	sd	s2,16(sp)
    8020024c:	e44e                	sd	s3,8(sp)
    8020024e:	e052                	sd	s4,0(sp)
    80200250:	1800                	addi	s0,sp,48
    80200252:	89aa                	mv	s3,a0
	for (int i = 0; i < app_num; ++i) {
    80200254:	00490797          	auipc	a5,0x490
    80200258:	dbc7a783          	lw	a5,-580(a5) # 80690010 <app_num>
    8020025c:	02f05b63          	blez	a5,80200292 <get_id_by_name+0x50>
    80200260:	00064917          	auipc	s2,0x64
    80200264:	da090913          	addi	s2,s2,-608 # 80264000 <names>
    80200268:	4481                	li	s1,0
    8020026a:	00490a17          	auipc	s4,0x490
    8020026e:	da6a0a13          	addi	s4,s4,-602 # 80690010 <app_num>
		if (strncmp(name, names[i], 100) == 0)
    80200272:	06400613          	li	a2,100
    80200276:	85ca                	mv	a1,s2
    80200278:	854e                	mv	a0,s3
    8020027a:	00001097          	auipc	ra,0x1
    8020027e:	f76080e7          	jalr	-138(ra) # 802011f0 <strncmp>
    80200282:	cd19                	beqz	a0,802002a0 <get_id_by_name+0x5e>
	for (int i = 0; i < app_num; ++i) {
    80200284:	2485                	addiw	s1,s1,1
    80200286:	0c890913          	addi	s2,s2,200
    8020028a:	000a2783          	lw	a5,0(s4)
    8020028e:	fef4c2e3          	blt	s1,a5,80200272 <get_id_by_name+0x30>
			return i;
	}
	warnf("Cannot find such app %s", name);
    80200292:	85ce                	mv	a1,s3
    80200294:	4501                	li	a0,0
    80200296:	00001097          	auipc	ra,0x1
    8020029a:	030080e7          	jalr	48(ra) # 802012c6 <dummy>
	return -1;
    8020029e:	54fd                	li	s1,-1
}
    802002a0:	8526                	mv	a0,s1
    802002a2:	70a2                	ld	ra,40(sp)
    802002a4:	7402                	ld	s0,32(sp)
    802002a6:	64e2                	ld	s1,24(sp)
    802002a8:	6942                	ld	s2,16(sp)
    802002aa:	69a2                	ld	s3,8(sp)
    802002ac:	6a02                	ld	s4,0(sp)
    802002ae:	6145                	addi	sp,sp,48
    802002b0:	8082                	ret

00000000802002b2 <bin_loader>:

int bin_loader(uint64 start, uint64 end, struct proc *p)
{
    802002b2:	7119                	addi	sp,sp,-128
    802002b4:	fc86                	sd	ra,120(sp)
    802002b6:	f8a2                	sd	s0,112(sp)
    802002b8:	f4a6                	sd	s1,104(sp)
    802002ba:	f0ca                	sd	s2,96(sp)
    802002bc:	ecce                	sd	s3,88(sp)
    802002be:	e8d2                	sd	s4,80(sp)
    802002c0:	e4d6                	sd	s5,72(sp)
    802002c2:	e0da                	sd	s6,64(sp)
    802002c4:	fc5e                	sd	s7,56(sp)
    802002c6:	f862                	sd	s8,48(sp)
    802002c8:	f466                	sd	s9,40(sp)
    802002ca:	f06a                	sd	s10,32(sp)
    802002cc:	ec6e                	sd	s11,24(sp)
    802002ce:	0100                	addi	s0,sp,128
    802002d0:	8caa                	mv	s9,a0
    802002d2:	8c2e                	mv	s8,a1
    802002d4:	8a32                	mv	s4,a2
	if (p == NULL || p->state == UNUSED)
    802002d6:	c219                	beqz	a2,802002dc <bin_loader+0x2a>
    802002d8:	421c                	lw	a5,0(a2)
    802002da:	ef8d                	bnez	a5,80200314 <bin_loader+0x62>
		panic("...");
    802002dc:	00000097          	auipc	ra,0x0
    802002e0:	674080e7          	jalr	1652(ra) # 80200950 <threadid>
    802002e4:	86aa                	mv	a3,a0
    802002e6:	02800793          	li	a5,40
    802002ea:	00004717          	auipc	a4,0x4
    802002ee:	d6670713          	addi	a4,a4,-666 # 80204050 <e_text+0x50>
    802002f2:	00004617          	auipc	a2,0x4
    802002f6:	d1e60613          	addi	a2,a2,-738 # 80204010 <e_text+0x10>
    802002fa:	45fd                	li	a1,31
    802002fc:	00004517          	auipc	a0,0x4
    80200300:	d6450513          	addi	a0,a0,-668 # 80204060 <e_text+0x60>
    80200304:	00000097          	auipc	ra,0x0
    80200308:	476080e7          	jalr	1142(ra) # 8020077a <printf>
    8020030c:	00001097          	auipc	ra,0x1
    80200310:	dde080e7          	jalr	-546(ra) # 802010ea <shutdown>
	void *page;
	uint64 pa_start = PGROUNDDOWN(start);
    80200314:	77fd                	lui	a5,0xfffff
    80200316:	00fcf9b3          	and	s3,s9,a5
	uint64 pa_end = PGROUNDUP(end);
    8020031a:	6b05                	lui	s6,0x1
    8020031c:	1b7d                	addi	s6,s6,-1
    8020031e:	9b62                	add	s6,s6,s8
    80200320:	00fb7b33          	and	s6,s6,a5
	uint64 length = pa_end - pa_start;
    80200324:	6789                	lui	a5,0x2
    80200326:	97da                	add	a5,a5,s6
    80200328:	f8f43023          	sd	a5,-128(s0)
	uint64 va_start = BASE_ADDRESS;
	uint64 va_end = BASE_ADDRESS + length;
	for (uint64 va = va_start, pa = pa_start; pa < pa_end;
    8020032c:	1169f563          	bgeu	s3,s6,80200436 <bin_loader+0x184>
    80200330:	84ce                	mv	s1,s3
    80200332:	6a85                	lui	s5,0x1
    80200334:	413a8d33          	sub	s10,s5,s3
	     va += PGSIZE, pa += PGSIZE) {
		page = kalloc();
		if (page == 0) {
			panic("...");
    80200338:	00004d97          	auipc	s11,0x4
    8020033c:	d18d8d93          	addi	s11,s11,-744 # 80204050 <e_text+0x50>
		}
		memmove(page, (const void *)pa, PGSIZE);
		if (pa < start) {
			memset(page, 0, start - va);
		} else if (pa + PAGE_SIZE > end) {
			memset(page + (end - pa), 0, PAGE_SIZE - (end - pa));
    80200340:	6785                	lui	a5,0x1
    80200342:	418787bb          	subw	a5,a5,s8
    80200346:	f8f42623          	sw	a5,-116(s0)
			memset(page, 0, start - va);
    8020034a:	77fd                	lui	a5,0xfffff
    8020034c:	019787bb          	addw	a5,a5,s9
    80200350:	013787bb          	addw	a5,a5,s3
    80200354:	f8f42423          	sw	a5,-120(s0)
    80200358:	a09d                	j	802003be <bin_loader+0x10c>
			panic("...");
    8020035a:	00000097          	auipc	ra,0x0
    8020035e:	5f6080e7          	jalr	1526(ra) # 80200950 <threadid>
    80200362:	86aa                	mv	a3,a0
    80200364:	03300793          	li	a5,51
    80200368:	876e                	mv	a4,s11
    8020036a:	00004617          	auipc	a2,0x4
    8020036e:	ca660613          	addi	a2,a2,-858 # 80204010 <e_text+0x10>
    80200372:	45fd                	li	a1,31
    80200374:	00004517          	auipc	a0,0x4
    80200378:	cec50513          	addi	a0,a0,-788 # 80204060 <e_text+0x60>
    8020037c:	00000097          	auipc	ra,0x0
    80200380:	3fe080e7          	jalr	1022(ra) # 8020077a <printf>
    80200384:	00001097          	auipc	ra,0x1
    80200388:	d66080e7          	jalr	-666(ra) # 802010ea <shutdown>
    8020038c:	a089                	j	802003ce <bin_loader+0x11c>
			memset(page, 0, start - va);
    8020038e:	f8842783          	lw	a5,-120(s0)
    80200392:	4097863b          	subw	a2,a5,s1
    80200396:	4581                	li	a1,0
    80200398:	854a                	mv	a0,s2
    8020039a:	00001097          	auipc	ra,0x1
    8020039e:	d7e080e7          	jalr	-642(ra) # 80201118 <memset>
		}
		if (mappages(p->pagetable, va, PGSIZE, (uint64)page,
    802003a2:	4779                	li	a4,30
    802003a4:	86ca                	mv	a3,s2
    802003a6:	8656                	mv	a2,s5
    802003a8:	85de                	mv	a1,s7
    802003aa:	008a3503          	ld	a0,8(s4)
    802003ae:	00002097          	auipc	ra,0x2
    802003b2:	b6c080e7          	jalr	-1172(ra) # 80201f1a <mappages>
    802003b6:	e531                	bnez	a0,80200402 <bin_loader+0x150>
	     va += PGSIZE, pa += PGSIZE) {
    802003b8:	94d6                	add	s1,s1,s5
	for (uint64 va = va_start, pa = pa_start; pa < pa_end;
    802003ba:	0764fe63          	bgeu	s1,s6,80200436 <bin_loader+0x184>
    802003be:	009d0bb3          	add	s7,s10,s1
		page = kalloc();
    802003c2:	00000097          	auipc	ra,0x0
    802003c6:	d78080e7          	jalr	-648(ra) # 8020013a <kalloc>
    802003ca:	892a                	mv	s2,a0
		if (page == 0) {
    802003cc:	d559                	beqz	a0,8020035a <bin_loader+0xa8>
		memmove(page, (const void *)pa, PGSIZE);
    802003ce:	8656                	mv	a2,s5
    802003d0:	85a6                	mv	a1,s1
    802003d2:	854a                	mv	a0,s2
    802003d4:	00001097          	auipc	ra,0x1
    802003d8:	da0080e7          	jalr	-608(ra) # 80201174 <memmove>
		if (pa < start) {
    802003dc:	fb94e9e3          	bltu	s1,s9,8020038e <bin_loader+0xdc>
		} else if (pa + PAGE_SIZE > end) {
    802003e0:	015487b3          	add	a5,s1,s5
    802003e4:	fafc7fe3          	bgeu	s8,a5,802003a2 <bin_loader+0xf0>
			memset(page + (end - pa), 0, PAGE_SIZE - (end - pa));
    802003e8:	409c0533          	sub	a0,s8,s1
    802003ec:	f8c42783          	lw	a5,-116(s0)
    802003f0:	0097863b          	addw	a2,a5,s1
    802003f4:	4581                	li	a1,0
    802003f6:	954a                	add	a0,a0,s2
    802003f8:	00001097          	auipc	ra,0x1
    802003fc:	d20080e7          	jalr	-736(ra) # 80201118 <memset>
    80200400:	b74d                	j	802003a2 <bin_loader+0xf0>
			     PTE_U | PTE_R | PTE_W | PTE_X) != 0)
			panic("...");
    80200402:	00000097          	auipc	ra,0x0
    80200406:	54e080e7          	jalr	1358(ra) # 80200950 <threadid>
    8020040a:	86aa                	mv	a3,a0
    8020040c:	03d00793          	li	a5,61
    80200410:	876e                	mv	a4,s11
    80200412:	00004617          	auipc	a2,0x4
    80200416:	bfe60613          	addi	a2,a2,-1026 # 80204010 <e_text+0x10>
    8020041a:	45fd                	li	a1,31
    8020041c:	00004517          	auipc	a0,0x4
    80200420:	c4450513          	addi	a0,a0,-956 # 80204060 <e_text+0x60>
    80200424:	00000097          	auipc	ra,0x0
    80200428:	356080e7          	jalr	854(ra) # 8020077a <printf>
    8020042c:	00001097          	auipc	ra,0x1
    80200430:	cbe080e7          	jalr	-834(ra) # 802010ea <shutdown>
    80200434:	b751                	j	802003b8 <bin_loader+0x106>
	}
	// map ustack
	p->ustack = va_end + PAGE_SIZE;
    80200436:	f8043783          	ld	a5,-128(s0)
    8020043a:	413789b3          	sub	s3,a5,s3
    8020043e:	013a3823          	sd	s3,16(s4)
	for (uint64 va = p->ustack; va < p->ustack + USTACK_SIZE;
    80200442:	6785                	lui	a5,0x1
    80200444:	97ce                	add	a5,a5,s3
    80200446:	0af9f663          	bgeu	s3,a5,802004f2 <bin_loader+0x240>
	     va += PGSIZE) {
		page = kalloc();
		if (page == 0) {
			panic("...");
    8020044a:	00004b17          	auipc	s6,0x4
    8020044e:	c06b0b13          	addi	s6,s6,-1018 # 80204050 <e_text+0x50>
    80200452:	00004a97          	auipc	s5,0x4
    80200456:	bbea8a93          	addi	s5,s5,-1090 # 80204010 <e_text+0x10>
    8020045a:	00004917          	auipc	s2,0x4
    8020045e:	c0690913          	addi	s2,s2,-1018 # 80204060 <e_text+0x60>
    80200462:	a825                	j	8020049a <bin_loader+0x1e8>
    80200464:	00000097          	auipc	ra,0x0
    80200468:	4ec080e7          	jalr	1260(ra) # 80200950 <threadid>
    8020046c:	86aa                	mv	a3,a0
    8020046e:	04500793          	li	a5,69
    80200472:	875a                	mv	a4,s6
    80200474:	8656                	mv	a2,s5
    80200476:	45fd                	li	a1,31
    80200478:	854a                	mv	a0,s2
    8020047a:	00000097          	auipc	ra,0x0
    8020047e:	300080e7          	jalr	768(ra) # 8020077a <printf>
    80200482:	00001097          	auipc	ra,0x1
    80200486:	c68080e7          	jalr	-920(ra) # 802010ea <shutdown>
    8020048a:	a831                	j	802004a6 <bin_loader+0x1f4>
	     va += PGSIZE) {
    8020048c:	6785                	lui	a5,0x1
    8020048e:	99be                	add	s3,s3,a5
	for (uint64 va = p->ustack; va < p->ustack + USTACK_SIZE;
    80200490:	010a3703          	ld	a4,16(s4)
    80200494:	97ba                	add	a5,a5,a4
    80200496:	04f9fe63          	bgeu	s3,a5,802004f2 <bin_loader+0x240>
		page = kalloc();
    8020049a:	00000097          	auipc	ra,0x0
    8020049e:	ca0080e7          	jalr	-864(ra) # 8020013a <kalloc>
    802004a2:	84aa                	mv	s1,a0
		if (page == 0) {
    802004a4:	d161                	beqz	a0,80200464 <bin_loader+0x1b2>
		}
		memset(page, 0, PGSIZE);
    802004a6:	6605                	lui	a2,0x1
    802004a8:	4581                	li	a1,0
    802004aa:	8526                	mv	a0,s1
    802004ac:	00001097          	auipc	ra,0x1
    802004b0:	c6c080e7          	jalr	-916(ra) # 80201118 <memset>
		if (mappages(p->pagetable, va, PGSIZE, (uint64)page,
    802004b4:	4759                	li	a4,22
    802004b6:	86a6                	mv	a3,s1
    802004b8:	6605                	lui	a2,0x1
    802004ba:	85ce                	mv	a1,s3
    802004bc:	008a3503          	ld	a0,8(s4)
    802004c0:	00002097          	auipc	ra,0x2
    802004c4:	a5a080e7          	jalr	-1446(ra) # 80201f1a <mappages>
    802004c8:	d171                	beqz	a0,8020048c <bin_loader+0x1da>
			     PTE_U | PTE_R | PTE_W) != 0)
			panic("...");
    802004ca:	00000097          	auipc	ra,0x0
    802004ce:	486080e7          	jalr	1158(ra) # 80200950 <threadid>
    802004d2:	86aa                	mv	a3,a0
    802004d4:	04a00793          	li	a5,74
    802004d8:	875a                	mv	a4,s6
    802004da:	8656                	mv	a2,s5
    802004dc:	45fd                	li	a1,31
    802004de:	854a                	mv	a0,s2
    802004e0:	00000097          	auipc	ra,0x0
    802004e4:	29a080e7          	jalr	666(ra) # 8020077a <printf>
    802004e8:	00001097          	auipc	ra,0x1
    802004ec:	c02080e7          	jalr	-1022(ra) # 802010ea <shutdown>
    802004f0:	bf71                	j	8020048c <bin_loader+0x1da>
	}
	p->trapframe->sp = p->ustack + USTACK_SIZE;
    802004f2:	020a3703          	ld	a4,32(s4)
    802004f6:	fb1c                	sd	a5,48(a4)
	p->trapframe->epc = va_start;
    802004f8:	020a3783          	ld	a5,32(s4)
    802004fc:	6705                	lui	a4,0x1
    802004fe:	ef98                	sd	a4,24(a5)
	p->max_page = PGROUNDUP(p->ustack + USTACK_SIZE - 1) / PAGE_SIZE;
    80200500:	010a3783          	ld	a5,16(s4)
    80200504:	6709                	lui	a4,0x2
    80200506:	1779                	addi	a4,a4,-2
    80200508:	97ba                	add	a5,a5,a4
    8020050a:	83b1                	srli	a5,a5,0xc
    8020050c:	08fa3c23          	sd	a5,152(s4)
	p->state = RUNNABLE;
    80200510:	478d                	li	a5,3
    80200512:	00fa2023          	sw	a5,0(s4)
	return 0;
}
    80200516:	4501                	li	a0,0
    80200518:	70e6                	ld	ra,120(sp)
    8020051a:	7446                	ld	s0,112(sp)
    8020051c:	74a6                	ld	s1,104(sp)
    8020051e:	7906                	ld	s2,96(sp)
    80200520:	69e6                	ld	s3,88(sp)
    80200522:	6a46                	ld	s4,80(sp)
    80200524:	6aa6                	ld	s5,72(sp)
    80200526:	6b06                	ld	s6,64(sp)
    80200528:	7be2                	ld	s7,56(sp)
    8020052a:	7c42                	ld	s8,48(sp)
    8020052c:	7ca2                	ld	s9,40(sp)
    8020052e:	7d02                	ld	s10,32(sp)
    80200530:	6de2                	ld	s11,24(sp)
    80200532:	6109                	addi	sp,sp,128
    80200534:	8082                	ret

0000000080200536 <loader>:

int loader(int app_id, struct proc *p)
{
    80200536:	1141                	addi	sp,sp,-16
    80200538:	e406                	sd	ra,8(sp)
    8020053a:	e022                	sd	s0,0(sp)
    8020053c:	0800                	addi	s0,sp,16
    8020053e:	862e                	mv	a2,a1
	return bin_loader(app_info_ptr[app_id], app_info_ptr[app_id + 1], p);
    80200540:	00351793          	slli	a5,a0,0x3
    80200544:	00490517          	auipc	a0,0x490
    80200548:	ac453503          	ld	a0,-1340(a0) # 80690008 <app_info_ptr>
    8020054c:	953e                	add	a0,a0,a5
    8020054e:	650c                	ld	a1,8(a0)
    80200550:	6108                	ld	a0,0(a0)
    80200552:	00000097          	auipc	ra,0x0
    80200556:	d60080e7          	jalr	-672(ra) # 802002b2 <bin_loader>
}
    8020055a:	60a2                	ld	ra,8(sp)
    8020055c:	6402                	ld	s0,0(sp)
    8020055e:	0141                	addi	sp,sp,16
    80200560:	8082                	ret

0000000080200562 <load_init_app>:

// load all apps and init the corresponding `proc` structure.
int load_init_app()
{
    80200562:	1101                	addi	sp,sp,-32
    80200564:	ec06                	sd	ra,24(sp)
    80200566:	e822                	sd	s0,16(sp)
    80200568:	e426                	sd	s1,8(sp)
    8020056a:	e04a                	sd	s2,0(sp)
    8020056c:	1000                	addi	s0,sp,32
	int id = get_id_by_name(INIT_PROC);
    8020056e:	00005517          	auipc	a0,0x5
    80200572:	da050513          	addi	a0,a0,-608 # 8020530e <INIT_PROC>
    80200576:	00000097          	auipc	ra,0x0
    8020057a:	ccc080e7          	jalr	-820(ra) # 80200242 <get_id_by_name>
    8020057e:	892a                	mv	s2,a0
	if (id < 0)
    80200580:	04054363          	bltz	a0,802005c6 <load_init_app+0x64>
		panic("Cannpt find INIT_PROC %s", INIT_PROC);
	struct proc *p = allocproc();
    80200584:	00000097          	auipc	ra,0x0
    80200588:	55e080e7          	jalr	1374(ra) # 80200ae2 <allocproc>
    8020058c:	84aa                	mv	s1,a0
	if (p == NULL) {
    8020058e:	cd2d                	beqz	a0,80200608 <load_init_app+0xa6>
		panic("allocproc\n");
	}
	debugf("load init proc %s", INIT_PROC);
    80200590:	00005597          	auipc	a1,0x5
    80200594:	d7e58593          	addi	a1,a1,-642 # 8020530e <INIT_PROC>
    80200598:	4501                	li	a0,0
    8020059a:	00001097          	auipc	ra,0x1
    8020059e:	d2c080e7          	jalr	-724(ra) # 802012c6 <dummy>
	loader(id, p);
    802005a2:	85a6                	mv	a1,s1
    802005a4:	854a                	mv	a0,s2
    802005a6:	00000097          	auipc	ra,0x0
    802005aa:	f90080e7          	jalr	-112(ra) # 80200536 <loader>
	add_task(p);
    802005ae:	8526                	mv	a0,s1
    802005b0:	00000097          	auipc	ra,0x0
    802005b4:	4da080e7          	jalr	1242(ra) # 80200a8a <add_task>
	return 0;
    802005b8:	4501                	li	a0,0
    802005ba:	60e2                	ld	ra,24(sp)
    802005bc:	6442                	ld	s0,16(sp)
    802005be:	64a2                	ld	s1,8(sp)
    802005c0:	6902                	ld	s2,0(sp)
    802005c2:	6105                	addi	sp,sp,32
    802005c4:	8082                	ret
		panic("Cannpt find INIT_PROC %s", INIT_PROC);
    802005c6:	00000097          	auipc	ra,0x0
    802005ca:	38a080e7          	jalr	906(ra) # 80200950 <threadid>
    802005ce:	86aa                	mv	a3,a0
    802005d0:	00005817          	auipc	a6,0x5
    802005d4:	d3e80813          	addi	a6,a6,-706 # 8020530e <INIT_PROC>
    802005d8:	05d00793          	li	a5,93
    802005dc:	00004717          	auipc	a4,0x4
    802005e0:	a7470713          	addi	a4,a4,-1420 # 80204050 <e_text+0x50>
    802005e4:	00004617          	auipc	a2,0x4
    802005e8:	a2c60613          	addi	a2,a2,-1492 # 80204010 <e_text+0x10>
    802005ec:	45fd                	li	a1,31
    802005ee:	00004517          	auipc	a0,0x4
    802005f2:	a9250513          	addi	a0,a0,-1390 # 80204080 <e_text+0x80>
    802005f6:	00000097          	auipc	ra,0x0
    802005fa:	184080e7          	jalr	388(ra) # 8020077a <printf>
    802005fe:	00001097          	auipc	ra,0x1
    80200602:	aec080e7          	jalr	-1300(ra) # 802010ea <shutdown>
    80200606:	bfbd                	j	80200584 <load_init_app+0x22>
		panic("allocproc\n");
    80200608:	00000097          	auipc	ra,0x0
    8020060c:	348080e7          	jalr	840(ra) # 80200950 <threadid>
    80200610:	86aa                	mv	a3,a0
    80200612:	06000793          	li	a5,96
    80200616:	00004717          	auipc	a4,0x4
    8020061a:	a3a70713          	addi	a4,a4,-1478 # 80204050 <e_text+0x50>
    8020061e:	00004617          	auipc	a2,0x4
    80200622:	9f260613          	addi	a2,a2,-1550 # 80204010 <e_text+0x10>
    80200626:	45fd                	li	a1,31
    80200628:	00004517          	auipc	a0,0x4
    8020062c:	a9050513          	addi	a0,a0,-1392 # 802040b8 <e_text+0xb8>
    80200630:	00000097          	auipc	ra,0x0
    80200634:	14a080e7          	jalr	330(ra) # 8020077a <printf>
    80200638:	00001097          	auipc	ra,0x1
    8020063c:	ab2080e7          	jalr	-1358(ra) # 802010ea <shutdown>
    80200640:	bf81                	j	80200590 <load_init_app+0x2e>

0000000080200642 <clean_bss>:
#include "loader.h"
#include "timer.h"
#include "trap.h"

void clean_bss()
{
    80200642:	1141                	addi	sp,sp,-16
    80200644:	e406                	sd	ra,8(sp)
    80200646:	e022                	sd	s0,0(sp)
    80200648:	0800                	addi	s0,sp,16
	extern char s_bss[];
	extern char e_bss[];
	memset(s_bss, 0, e_bss - s_bss);
    8020064a:	00064517          	auipc	a0,0x64
    8020064e:	9b650513          	addi	a0,a0,-1610 # 80264000 <names>
    80200652:	00491617          	auipc	a2,0x491
    80200656:	9ae60613          	addi	a2,a2,-1618 # 80691000 <e_bss>
    8020065a:	9e09                	subw	a2,a2,a0
    8020065c:	4581                	li	a1,0
    8020065e:	00001097          	auipc	ra,0x1
    80200662:	aba080e7          	jalr	-1350(ra) # 80201118 <memset>
}
    80200666:	60a2                	ld	ra,8(sp)
    80200668:	6402                	ld	s0,0(sp)
    8020066a:	0141                	addi	sp,sp,16
    8020066c:	8082                	ret

000000008020066e <main>:

void main()
{
    8020066e:	1141                	addi	sp,sp,-16
    80200670:	e406                	sd	ra,8(sp)
    80200672:	e022                	sd	s0,0(sp)
    80200674:	0800                	addi	s0,sp,16
	clean_bss();
    80200676:	00000097          	auipc	ra,0x0
    8020067a:	fcc080e7          	jalr	-52(ra) # 80200642 <clean_bss>
	printf("hello world!\n");
    8020067e:	00004517          	auipc	a0,0x4
    80200682:	a6250513          	addi	a0,a0,-1438 # 802040e0 <e_text+0xe0>
    80200686:	00000097          	auipc	ra,0x0
    8020068a:	0f4080e7          	jalr	244(ra) # 8020077a <printf>
	proc_init();
    8020068e:	00000097          	auipc	ra,0x0
    80200692:	2ec080e7          	jalr	748(ra) # 8020097a <proc_init>
	kinit();
    80200696:	00000097          	auipc	ra,0x0
    8020069a:	a80080e7          	jalr	-1408(ra) # 80200116 <kinit>
	kvm_init();
    8020069e:	00002097          	auipc	ra,0x2
    802006a2:	a2c080e7          	jalr	-1492(ra) # 802020ca <kvm_init>
	loader_init();
    802006a6:	00000097          	auipc	ra,0x0
    802006aa:	acc080e7          	jalr	-1332(ra) # 80200172 <loader_init>
	trap_init();
    802006ae:	00001097          	auipc	ra,0x1
    802006b2:	498080e7          	jalr	1176(ra) # 80201b46 <trap_init>
	timer_init();
    802006b6:	00001097          	auipc	ra,0x1
    802006ba:	39c080e7          	jalr	924(ra) # 80201a52 <timer_init>
	load_init_app();
    802006be:	00000097          	auipc	ra,0x0
    802006c2:	ea4080e7          	jalr	-348(ra) # 80200562 <load_init_app>
	infof("start scheduler!");
    802006c6:	4501                	li	a0,0
    802006c8:	00001097          	auipc	ra,0x1
    802006cc:	bfe080e7          	jalr	-1026(ra) # 802012c6 <dummy>
	scheduler();
    802006d0:	00000097          	auipc	ra,0x0
    802006d4:	4c0080e7          	jalr	1216(ra) # 80200b90 <scheduler>

00000000802006d8 <printint>:
#include "console.h"
#include "defs.h"
static char digits[] = "0123456789abcdef";

static void printint(int xx, int base, int sign)
{
    802006d8:	7179                	addi	sp,sp,-48
    802006da:	f406                	sd	ra,40(sp)
    802006dc:	f022                	sd	s0,32(sp)
    802006de:	ec26                	sd	s1,24(sp)
    802006e0:	e84a                	sd	s2,16(sp)
    802006e2:	1800                	addi	s0,sp,48
	char buf[16];
	int i;
	uint x;

	if (sign && (sign = xx < 0))
    802006e4:	c219                	beqz	a2,802006ea <printint+0x12>
    802006e6:	08054663          	bltz	a0,80200772 <printint+0x9a>
		x = -xx;
	else
		x = xx;
    802006ea:	2501                	sext.w	a0,a0
    802006ec:	4881                	li	a7,0
    802006ee:	fd040693          	addi	a3,s0,-48

	i = 0;
    802006f2:	4701                	li	a4,0
	do {
		buf[i++] = digits[x % base];
    802006f4:	2581                	sext.w	a1,a1
    802006f6:	00004617          	auipc	a2,0x4
    802006fa:	a3a60613          	addi	a2,a2,-1478 # 80204130 <digits>
    802006fe:	883a                	mv	a6,a4
    80200700:	2705                	addiw	a4,a4,1
    80200702:	02b577bb          	remuw	a5,a0,a1
    80200706:	1782                	slli	a5,a5,0x20
    80200708:	9381                	srli	a5,a5,0x20
    8020070a:	97b2                	add	a5,a5,a2
    8020070c:	0007c783          	lbu	a5,0(a5) # 1000 <_entry-0x801ff000>
    80200710:	00f68023          	sb	a5,0(a3)
	} while ((x /= base) != 0);
    80200714:	0005079b          	sext.w	a5,a0
    80200718:	02b5553b          	divuw	a0,a0,a1
    8020071c:	0685                	addi	a3,a3,1
    8020071e:	feb7f0e3          	bgeu	a5,a1,802006fe <printint+0x26>

	if (sign)
    80200722:	00088b63          	beqz	a7,80200738 <printint+0x60>
		buf[i++] = '-';
    80200726:	fe040793          	addi	a5,s0,-32
    8020072a:	973e                	add	a4,a4,a5
    8020072c:	02d00793          	li	a5,45
    80200730:	fef70823          	sb	a5,-16(a4)
    80200734:	0028071b          	addiw	a4,a6,2

	while (--i >= 0)
    80200738:	02e05763          	blez	a4,80200766 <printint+0x8e>
    8020073c:	fd040793          	addi	a5,s0,-48
    80200740:	00e784b3          	add	s1,a5,a4
    80200744:	fff78913          	addi	s2,a5,-1
    80200748:	993a                	add	s2,s2,a4
    8020074a:	377d                	addiw	a4,a4,-1
    8020074c:	1702                	slli	a4,a4,0x20
    8020074e:	9301                	srli	a4,a4,0x20
    80200750:	40e90933          	sub	s2,s2,a4
		consputc(buf[i]);
    80200754:	fff4c503          	lbu	a0,-1(s1)
    80200758:	00000097          	auipc	ra,0x0
    8020075c:	8b4080e7          	jalr	-1868(ra) # 8020000c <consputc>
	while (--i >= 0)
    80200760:	14fd                	addi	s1,s1,-1
    80200762:	ff2499e3          	bne	s1,s2,80200754 <printint+0x7c>
}
    80200766:	70a2                	ld	ra,40(sp)
    80200768:	7402                	ld	s0,32(sp)
    8020076a:	64e2                	ld	s1,24(sp)
    8020076c:	6942                	ld	s2,16(sp)
    8020076e:	6145                	addi	sp,sp,48
    80200770:	8082                	ret
		x = -xx;
    80200772:	40a0053b          	negw	a0,a0
	if (sign && (sign = xx < 0))
    80200776:	4885                	li	a7,1
		x = -xx;
    80200778:	bf9d                	j	802006ee <printint+0x16>

000000008020077a <printf>:
		consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
}

// Print to the console. only understands %d, %x, %p, %s.
void printf(char *fmt, ...)
{
    8020077a:	7131                	addi	sp,sp,-192
    8020077c:	fc86                	sd	ra,120(sp)
    8020077e:	f8a2                	sd	s0,112(sp)
    80200780:	f4a6                	sd	s1,104(sp)
    80200782:	f0ca                	sd	s2,96(sp)
    80200784:	ecce                	sd	s3,88(sp)
    80200786:	e8d2                	sd	s4,80(sp)
    80200788:	e4d6                	sd	s5,72(sp)
    8020078a:	e0da                	sd	s6,64(sp)
    8020078c:	fc5e                	sd	s7,56(sp)
    8020078e:	f862                	sd	s8,48(sp)
    80200790:	f466                	sd	s9,40(sp)
    80200792:	f06a                	sd	s10,32(sp)
    80200794:	ec6e                	sd	s11,24(sp)
    80200796:	0100                	addi	s0,sp,128
    80200798:	8a2a                	mv	s4,a0
    8020079a:	e40c                	sd	a1,8(s0)
    8020079c:	e810                	sd	a2,16(s0)
    8020079e:	ec14                	sd	a3,24(s0)
    802007a0:	f018                	sd	a4,32(s0)
    802007a2:	f41c                	sd	a5,40(s0)
    802007a4:	03043823          	sd	a6,48(s0)
    802007a8:	03143c23          	sd	a7,56(s0)
	va_list ap;
	int i, c;
	char *s;

	if (fmt == 0)
    802007ac:	c915                	beqz	a0,802007e0 <printf+0x66>
		panic("null fmt");

	va_start(ap, fmt);
    802007ae:	00840793          	addi	a5,s0,8
    802007b2:	f8f43423          	sd	a5,-120(s0)
	for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    802007b6:	000a4503          	lbu	a0,0(s4)
    802007ba:	16050c63          	beqz	a0,80200932 <printf+0x1b8>
    802007be:	4981                	li	s3,0
		if (c != '%') {
    802007c0:	02500a93          	li	s5,37
			continue;
		}
		c = fmt[++i] & 0xff;
		if (c == 0)
			break;
		switch (c) {
    802007c4:	07000b93          	li	s7,112
	consputc('x');
    802007c8:	4d41                	li	s10,16
		consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    802007ca:	00004b17          	auipc	s6,0x4
    802007ce:	966b0b13          	addi	s6,s6,-1690 # 80204130 <digits>
		switch (c) {
    802007d2:	07300c93          	li	s9,115
			printptr(va_arg(ap, uint64));
			break;
		case 's':
			if ((s = va_arg(ap, char *)) == 0)
				s = "(null)";
			for (; *s; s++)
    802007d6:	02800d93          	li	s11,40
		switch (c) {
    802007da:	06400c13          	li	s8,100
    802007de:	a889                	j	80200830 <printf+0xb6>
		panic("null fmt");
    802007e0:	00000097          	auipc	ra,0x0
    802007e4:	170080e7          	jalr	368(ra) # 80200950 <threadid>
    802007e8:	86aa                	mv	a3,a0
    802007ea:	02e00793          	li	a5,46
    802007ee:	00004717          	auipc	a4,0x4
    802007f2:	90a70713          	addi	a4,a4,-1782 # 802040f8 <e_text+0xf8>
    802007f6:	00004617          	auipc	a2,0x4
    802007fa:	81a60613          	addi	a2,a2,-2022 # 80204010 <e_text+0x10>
    802007fe:	45fd                	li	a1,31
    80200800:	00004517          	auipc	a0,0x4
    80200804:	90850513          	addi	a0,a0,-1784 # 80204108 <e_text+0x108>
    80200808:	00000097          	auipc	ra,0x0
    8020080c:	f72080e7          	jalr	-142(ra) # 8020077a <printf>
    80200810:	00001097          	auipc	ra,0x1
    80200814:	8da080e7          	jalr	-1830(ra) # 802010ea <shutdown>
    80200818:	bf59                	j	802007ae <printf+0x34>
			consputc(c);
    8020081a:	fffff097          	auipc	ra,0xfffff
    8020081e:	7f2080e7          	jalr	2034(ra) # 8020000c <consputc>
	for (i = 0; (c = fmt[i] & 0xff) != 0; i++) {
    80200822:	2985                	addiw	s3,s3,1
    80200824:	013a07b3          	add	a5,s4,s3
    80200828:	0007c503          	lbu	a0,0(a5)
    8020082c:	10050363          	beqz	a0,80200932 <printf+0x1b8>
		if (c != '%') {
    80200830:	ff5515e3          	bne	a0,s5,8020081a <printf+0xa0>
		c = fmt[++i] & 0xff;
    80200834:	2985                	addiw	s3,s3,1
    80200836:	013a07b3          	add	a5,s4,s3
    8020083a:	0007c783          	lbu	a5,0(a5)
    8020083e:	0007849b          	sext.w	s1,a5
		if (c == 0)
    80200842:	cbe5                	beqz	a5,80200932 <printf+0x1b8>
		switch (c) {
    80200844:	05778a63          	beq	a5,s7,80200898 <printf+0x11e>
    80200848:	02fbf663          	bgeu	s7,a5,80200874 <printf+0xfa>
    8020084c:	09978863          	beq	a5,s9,802008dc <printf+0x162>
    80200850:	07800713          	li	a4,120
    80200854:	0ce79463          	bne	a5,a4,8020091c <printf+0x1a2>
			printint(va_arg(ap, int), 16, 1);
    80200858:	f8843783          	ld	a5,-120(s0)
    8020085c:	00878713          	addi	a4,a5,8
    80200860:	f8e43423          	sd	a4,-120(s0)
    80200864:	4605                	li	a2,1
    80200866:	85ea                	mv	a1,s10
    80200868:	4388                	lw	a0,0(a5)
    8020086a:	00000097          	auipc	ra,0x0
    8020086e:	e6e080e7          	jalr	-402(ra) # 802006d8 <printint>
			break;
    80200872:	bf45                	j	80200822 <printf+0xa8>
		switch (c) {
    80200874:	09578e63          	beq	a5,s5,80200910 <printf+0x196>
    80200878:	0b879263          	bne	a5,s8,8020091c <printf+0x1a2>
			printint(va_arg(ap, int), 10, 1);
    8020087c:	f8843783          	ld	a5,-120(s0)
    80200880:	00878713          	addi	a4,a5,8
    80200884:	f8e43423          	sd	a4,-120(s0)
    80200888:	4605                	li	a2,1
    8020088a:	45a9                	li	a1,10
    8020088c:	4388                	lw	a0,0(a5)
    8020088e:	00000097          	auipc	ra,0x0
    80200892:	e4a080e7          	jalr	-438(ra) # 802006d8 <printint>
			break;
    80200896:	b771                	j	80200822 <printf+0xa8>
			printptr(va_arg(ap, uint64));
    80200898:	f8843783          	ld	a5,-120(s0)
    8020089c:	00878713          	addi	a4,a5,8
    802008a0:	f8e43423          	sd	a4,-120(s0)
    802008a4:	0007b903          	ld	s2,0(a5)
	consputc('0');
    802008a8:	03000513          	li	a0,48
    802008ac:	fffff097          	auipc	ra,0xfffff
    802008b0:	760080e7          	jalr	1888(ra) # 8020000c <consputc>
	consputc('x');
    802008b4:	07800513          	li	a0,120
    802008b8:	fffff097          	auipc	ra,0xfffff
    802008bc:	754080e7          	jalr	1876(ra) # 8020000c <consputc>
    802008c0:	84ea                	mv	s1,s10
		consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    802008c2:	03c95793          	srli	a5,s2,0x3c
    802008c6:	97da                	add	a5,a5,s6
    802008c8:	0007c503          	lbu	a0,0(a5)
    802008cc:	fffff097          	auipc	ra,0xfffff
    802008d0:	740080e7          	jalr	1856(ra) # 8020000c <consputc>
	for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    802008d4:	0912                	slli	s2,s2,0x4
    802008d6:	34fd                	addiw	s1,s1,-1
    802008d8:	f4ed                	bnez	s1,802008c2 <printf+0x148>
    802008da:	b7a1                	j	80200822 <printf+0xa8>
			if ((s = va_arg(ap, char *)) == 0)
    802008dc:	f8843783          	ld	a5,-120(s0)
    802008e0:	00878713          	addi	a4,a5,8
    802008e4:	f8e43423          	sd	a4,-120(s0)
    802008e8:	6384                	ld	s1,0(a5)
    802008ea:	cc89                	beqz	s1,80200904 <printf+0x18a>
			for (; *s; s++)
    802008ec:	0004c503          	lbu	a0,0(s1)
    802008f0:	d90d                	beqz	a0,80200822 <printf+0xa8>
				consputc(*s);
    802008f2:	fffff097          	auipc	ra,0xfffff
    802008f6:	71a080e7          	jalr	1818(ra) # 8020000c <consputc>
			for (; *s; s++)
    802008fa:	0485                	addi	s1,s1,1
    802008fc:	0004c503          	lbu	a0,0(s1)
    80200900:	f96d                	bnez	a0,802008f2 <printf+0x178>
    80200902:	b705                	j	80200822 <printf+0xa8>
				s = "(null)";
    80200904:	00003497          	auipc	s1,0x3
    80200908:	7ec48493          	addi	s1,s1,2028 # 802040f0 <e_text+0xf0>
			for (; *s; s++)
    8020090c:	856e                	mv	a0,s11
    8020090e:	b7d5                	j	802008f2 <printf+0x178>
			break;
		case '%':
			consputc('%');
    80200910:	8556                	mv	a0,s5
    80200912:	fffff097          	auipc	ra,0xfffff
    80200916:	6fa080e7          	jalr	1786(ra) # 8020000c <consputc>
			break;
    8020091a:	b721                	j	80200822 <printf+0xa8>
		default:
			// Print unknown % sequence to draw attention.
			consputc('%');
    8020091c:	8556                	mv	a0,s5
    8020091e:	fffff097          	auipc	ra,0xfffff
    80200922:	6ee080e7          	jalr	1774(ra) # 8020000c <consputc>
			consputc(c);
    80200926:	8526                	mv	a0,s1
    80200928:	fffff097          	auipc	ra,0xfffff
    8020092c:	6e4080e7          	jalr	1764(ra) # 8020000c <consputc>
			break;
    80200930:	bdcd                	j	80200822 <printf+0xa8>
		}
	}
    80200932:	70e6                	ld	ra,120(sp)
    80200934:	7446                	ld	s0,112(sp)
    80200936:	74a6                	ld	s1,104(sp)
    80200938:	7906                	ld	s2,96(sp)
    8020093a:	69e6                	ld	s3,88(sp)
    8020093c:	6a46                	ld	s4,80(sp)
    8020093e:	6aa6                	ld	s5,72(sp)
    80200940:	6b06                	ld	s6,64(sp)
    80200942:	7be2                	ld	s7,56(sp)
    80200944:	7c42                	ld	s8,48(sp)
    80200946:	7ca2                	ld	s9,40(sp)
    80200948:	7d02                	ld	s10,32(sp)
    8020094a:	6de2                	ld	s11,24(sp)
    8020094c:	6129                	addi	sp,sp,192
    8020094e:	8082                	ret

0000000080200950 <threadid>:
struct proc *current_proc;
struct proc idle;
struct queue task_queue;

int threadid()
{
    80200950:	1141                	addi	sp,sp,-16
    80200952:	e422                	sd	s0,8(sp)
    80200954:	0800                	addi	s0,sp,16
	return curr_proc()->pid;
}
    80200956:	0048f797          	auipc	a5,0x48f
    8020095a:	6c27b783          	ld	a5,1730(a5) # 80690018 <current_proc>
    8020095e:	43c8                	lw	a0,4(a5)
    80200960:	6422                	ld	s0,8(sp)
    80200962:	0141                	addi	sp,sp,16
    80200964:	8082                	ret

0000000080200966 <curr_proc>:

struct proc *curr_proc()
{
    80200966:	1141                	addi	sp,sp,-16
    80200968:	e422                	sd	s0,8(sp)
    8020096a:	0800                	addi	s0,sp,16
	return current_proc;
}
    8020096c:	0048f517          	auipc	a0,0x48f
    80200970:	6ac53503          	ld	a0,1708(a0) # 80690018 <current_proc>
    80200974:	6422                	ld	s0,8(sp)
    80200976:	0141                	addi	sp,sp,16
    80200978:	8082                	ret

000000008020097a <proc_init>:

// initialize the proc table at boot time.
void proc_init()
{
    8020097a:	1141                	addi	sp,sp,-16
    8020097c:	e406                	sd	ra,8(sp)
    8020097e:	e022                	sd	s0,0(sp)
    80200980:	0800                	addi	s0,sp,16
	struct proc *p;
	for (p = pool; p < &pool[NPROC]; p++) {
    80200982:	00467717          	auipc	a4,0x467
    80200986:	67e70713          	addi	a4,a4,1662 # 80668000 <pool>
		p->state = UNUSED;
		p->kstack = (uint64)kstack[p - pool];
    8020098a:	88ba                	mv	a7,a4
    8020098c:	00004817          	auipc	a6,0x4
    80200990:	ca483803          	ld	a6,-860(a6) # 80204630 <digits+0x500>
    80200994:	00267517          	auipc	a0,0x267
    80200998:	66c50513          	addi	a0,a0,1644 # 80468000 <kstack>
		p->trapframe = (struct trapframe *)trapframe[p - pool];
    8020099c:	00067597          	auipc	a1,0x67
    802009a0:	66458593          	addi	a1,a1,1636 # 80268000 <trapframe>
	for (p = pool; p < &pool[NPROC]; p++) {
    802009a4:	0048f617          	auipc	a2,0x48f
    802009a8:	65c60613          	addi	a2,a2,1628 # 80690000 <kmem>
		p->state = UNUSED;
    802009ac:	00072023          	sw	zero,0(a4)
		p->kstack = (uint64)kstack[p - pool];
    802009b0:	411707b3          	sub	a5,a4,a7
    802009b4:	8799                	srai	a5,a5,0x6
    802009b6:	030787b3          	mul	a5,a5,a6
    802009ba:	07b2                	slli	a5,a5,0xc
    802009bc:	00a786b3          	add	a3,a5,a0
    802009c0:	ef14                	sd	a3,24(a4)
		p->trapframe = (struct trapframe *)trapframe[p - pool];
    802009c2:	97ae                	add	a5,a5,a1
    802009c4:	f31c                	sd	a5,32(a4)
	for (p = pool; p < &pool[NPROC]; p++) {
    802009c6:	14070713          	addi	a4,a4,320
    802009ca:	fec711e3          	bne	a4,a2,802009ac <proc_init+0x32>
	}
	idle.kstack = (uint64)boot_stack_top;
    802009ce:	00065797          	auipc	a5,0x65
    802009d2:	63278793          	addi	a5,a5,1586 # 80266000 <idle>
    802009d6:	00063717          	auipc	a4,0x63
    802009da:	62a70713          	addi	a4,a4,1578 # 80264000 <names>
    802009de:	ef98                	sd	a4,24(a5)
	idle.pid = IDLE_PID;
    802009e0:	0007a223          	sw	zero,4(a5)
	current_proc = &idle;
    802009e4:	0048f717          	auipc	a4,0x48f
    802009e8:	62f73a23          	sd	a5,1588(a4) # 80690018 <current_proc>
	init_queue(&task_queue);
    802009ec:	00065517          	auipc	a0,0x65
    802009f0:	75450513          	addi	a0,a0,1876 # 80266140 <task_queue>
    802009f4:	00000097          	auipc	ra,0x0
    802009f8:	5ce080e7          	jalr	1486(ra) # 80200fc2 <init_queue>
}
    802009fc:	60a2                	ld	ra,8(sp)
    802009fe:	6402                	ld	s0,0(sp)
    80200a00:	0141                	addi	sp,sp,16
    80200a02:	8082                	ret

0000000080200a04 <allocpid>:

int allocpid()
{
    80200a04:	1141                	addi	sp,sp,-16
    80200a06:	e422                	sd	s0,8(sp)
    80200a08:	0800                	addi	s0,sp,16
	static int PID = 1;
	return PID++;
    80200a0a:	00052797          	auipc	a5,0x52
    80200a0e:	5f678793          	addi	a5,a5,1526 # 80253000 <PID.0>
    80200a12:	4388                	lw	a0,0(a5)
    80200a14:	0015071b          	addiw	a4,a0,1
    80200a18:	c398                	sw	a4,0(a5)
}
    80200a1a:	6422                	ld	s0,8(sp)
    80200a1c:	0141                	addi	sp,sp,16
    80200a1e:	8082                	ret

0000000080200a20 <fetch_task>:

struct proc *fetch_task()
{
    80200a20:	7179                	addi	sp,sp,-48
    80200a22:	f406                	sd	ra,40(sp)
    80200a24:	f022                	sd	s0,32(sp)
    80200a26:	ec26                	sd	s1,24(sp)
    80200a28:	e84a                	sd	s2,16(sp)
    80200a2a:	e44e                	sd	s3,8(sp)
    80200a2c:	1800                	addi	s0,sp,48
	int index = pop_queue(&task_queue);
    80200a2e:	00065517          	auipc	a0,0x65
    80200a32:	71250513          	addi	a0,a0,1810 # 80266140 <task_queue>
    80200a36:	00000097          	auipc	ra,0x0
    80200a3a:	638080e7          	jalr	1592(ra) # 8020106e <pop_queue>
	if (index < 0) {
    80200a3e:	02054f63          	bltz	a0,80200a7c <fetch_task+0x5c>
    80200a42:	892a                	mv	s2,a0
		debugf("No task to fetch\n");
		return NULL;
	}
	debugf("fetch task %d(pid=%d) to task queue\n", index, pool[index].pid);
    80200a44:	00467997          	auipc	s3,0x467
    80200a48:	5bc98993          	addi	s3,s3,1468 # 80668000 <pool>
    80200a4c:	00251493          	slli	s1,a0,0x2
    80200a50:	00a487b3          	add	a5,s1,a0
    80200a54:	079a                	slli	a5,a5,0x6
    80200a56:	97ce                	add	a5,a5,s3
    80200a58:	43d0                	lw	a2,4(a5)
    80200a5a:	85aa                	mv	a1,a0
    80200a5c:	4501                	li	a0,0
    80200a5e:	00001097          	auipc	ra,0x1
    80200a62:	868080e7          	jalr	-1944(ra) # 802012c6 <dummy>
	return pool + index;
    80200a66:	01248533          	add	a0,s1,s2
    80200a6a:	051a                	slli	a0,a0,0x6
    80200a6c:	954e                	add	a0,a0,s3
}
    80200a6e:	70a2                	ld	ra,40(sp)
    80200a70:	7402                	ld	s0,32(sp)
    80200a72:	64e2                	ld	s1,24(sp)
    80200a74:	6942                	ld	s2,16(sp)
    80200a76:	69a2                	ld	s3,8(sp)
    80200a78:	6145                	addi	sp,sp,48
    80200a7a:	8082                	ret
		debugf("No task to fetch\n");
    80200a7c:	4501                	li	a0,0
    80200a7e:	00001097          	auipc	ra,0x1
    80200a82:	848080e7          	jalr	-1976(ra) # 802012c6 <dummy>
		return NULL;
    80200a86:	4501                	li	a0,0
    80200a88:	b7dd                	j	80200a6e <fetch_task+0x4e>

0000000080200a8a <add_task>:

void add_task(struct proc *p)
{
    80200a8a:	1101                	addi	sp,sp,-32
    80200a8c:	ec06                	sd	ra,24(sp)
    80200a8e:	e822                	sd	s0,16(sp)
    80200a90:	e426                	sd	s1,8(sp)
    80200a92:	e04a                	sd	s2,0(sp)
    80200a94:	1000                	addi	s0,sp,32
    80200a96:	892a                	mv	s2,a0
	push_queue(&task_queue, p - pool);
    80200a98:	00467497          	auipc	s1,0x467
    80200a9c:	56848493          	addi	s1,s1,1384 # 80668000 <pool>
    80200aa0:	409504b3          	sub	s1,a0,s1
    80200aa4:	8499                	srai	s1,s1,0x6
    80200aa6:	00004797          	auipc	a5,0x4
    80200aaa:	b8a7b783          	ld	a5,-1142(a5) # 80204630 <digits+0x500>
    80200aae:	02f484b3          	mul	s1,s1,a5
    80200ab2:	0004859b          	sext.w	a1,s1
    80200ab6:	00065517          	auipc	a0,0x65
    80200aba:	68a50513          	addi	a0,a0,1674 # 80266140 <task_queue>
    80200abe:	00000097          	auipc	ra,0x0
    80200ac2:	520080e7          	jalr	1312(ra) # 80200fde <push_queue>
	debugf("add task %d(pid=%d) to task queue\n", p - pool, p->pid);
    80200ac6:	00492603          	lw	a2,4(s2)
    80200aca:	85a6                	mv	a1,s1
    80200acc:	4501                	li	a0,0
    80200ace:	00000097          	auipc	ra,0x0
    80200ad2:	7f8080e7          	jalr	2040(ra) # 802012c6 <dummy>
}
    80200ad6:	60e2                	ld	ra,24(sp)
    80200ad8:	6442                	ld	s0,16(sp)
    80200ada:	64a2                	ld	s1,8(sp)
    80200adc:	6902                	ld	s2,0(sp)
    80200ade:	6105                	addi	sp,sp,32
    80200ae0:	8082                	ret

0000000080200ae2 <allocproc>:

// Look in the process table for an UNUSED proc.
// If found, initialize state required to run in the kernel.
// If there are no free procs, or a memory allocation fails, return 0.
struct proc *allocproc()
{
    80200ae2:	1101                	addi	sp,sp,-32
    80200ae4:	ec06                	sd	ra,24(sp)
    80200ae6:	e822                	sd	s0,16(sp)
    80200ae8:	e426                	sd	s1,8(sp)
    80200aea:	1000                	addi	s0,sp,32
	struct proc *p;
	for (p = pool; p < &pool[NPROC]; p++) {
    80200aec:	00467497          	auipc	s1,0x467
    80200af0:	51448493          	addi	s1,s1,1300 # 80668000 <pool>
    80200af4:	0048f717          	auipc	a4,0x48f
    80200af8:	50c70713          	addi	a4,a4,1292 # 80690000 <kmem>
		if (p->state == UNUSED) {
    80200afc:	409c                	lw	a5,0(s1)
    80200afe:	c799                	beqz	a5,80200b0c <allocproc+0x2a>
	for (p = pool; p < &pool[NPROC]; p++) {
    80200b00:	14048493          	addi	s1,s1,320
    80200b04:	fee49ce3          	bne	s1,a4,80200afc <allocproc+0x1a>
			goto found;
		}
	}
	return 0;
    80200b08:	4481                	li	s1,0
    80200b0a:	a8ad                	j	80200b84 <allocproc+0xa2>

found:
	// init proc
	p->pid = allocpid();
    80200b0c:	00000097          	auipc	ra,0x0
    80200b10:	ef8080e7          	jalr	-264(ra) # 80200a04 <allocpid>
    80200b14:	c0c8                	sw	a0,4(s1)
	p->state = USED;
    80200b16:	4785                	li	a5,1
    80200b18:	c09c                	sw	a5,0(s1)
	p->ustack = 0;
    80200b1a:	0004b823          	sd	zero,16(s1)
	p->max_page = 0;
    80200b1e:	0804bc23          	sd	zero,152(s1)
	p->parent = NULL;
    80200b22:	0a04b023          	sd	zero,160(s1)
	p->exit_code = 0;
    80200b26:	0a04b423          	sd	zero,168(s1)
	p->pagetable = uvmcreate((uint64)p->trapframe);
    80200b2a:	7088                	ld	a0,32(s1)
    80200b2c:	00001097          	auipc	ra,0x1
    80200b30:	6ea080e7          	jalr	1770(ra) # 80202216 <uvmcreate>
    80200b34:	e488                	sd	a0,8(s1)
	memset(&p->context, 0, sizeof(p->context));
    80200b36:	07000613          	li	a2,112
    80200b3a:	4581                	li	a1,0
    80200b3c:	02848513          	addi	a0,s1,40
    80200b40:	00000097          	auipc	ra,0x0
    80200b44:	5d8080e7          	jalr	1496(ra) # 80201118 <memset>
	memset((void *)p->kstack, 0, KSTACK_SIZE);
    80200b48:	6605                	lui	a2,0x1
    80200b4a:	4581                	li	a1,0
    80200b4c:	6c88                	ld	a0,24(s1)
    80200b4e:	00000097          	auipc	ra,0x0
    80200b52:	5ca080e7          	jalr	1482(ra) # 80201118 <memset>
	memset((void *)p->trapframe, 0, TRAP_PAGE_SIZE);
    80200b56:	6605                	lui	a2,0x1
    80200b58:	4581                	li	a1,0
    80200b5a:	7088                	ld	a0,32(s1)
    80200b5c:	00000097          	auipc	ra,0x0
    80200b60:	5bc080e7          	jalr	1468(ra) # 80201118 <memset>
	p->context.ra = (uint64)usertrapret;
    80200b64:	00001797          	auipc	a5,0x1
    80200b68:	04278793          	addi	a5,a5,66 # 80201ba6 <usertrapret>
    80200b6c:	f49c                	sd	a5,40(s1)
	p->context.sp = p->kstack + KSTACK_SIZE;
    80200b6e:	6705                	lui	a4,0x1
    80200b70:	6c9c                	ld	a5,24(s1)
    80200b72:	97ba                	add	a5,a5,a4
    80200b74:	f89c                	sd	a5,48(s1)

	// initialize new fields for priority based scheduling
	p->stride = 0;
    80200b76:	1204a823          	sw	zero,304(s1)
	p->priority = 16;
    80200b7a:	47c1                	li	a5,16
    80200b7c:	12f4bc23          	sd	a5,312(s1)
	p->pass = BIG_STRIDE / p->priority;
    80200b80:	12e4aa23          	sw	a4,308(s1)
	return p;
}
    80200b84:	8526                	mv	a0,s1
    80200b86:	60e2                	ld	ra,24(sp)
    80200b88:	6442                	ld	s0,16(sp)
    80200b8a:	64a2                	ld	s1,8(sp)
    80200b8c:	6105                	addi	sp,sp,32
    80200b8e:	8082                	ret

0000000080200b90 <scheduler>:
//  - choose a process to run.
//  - swtch to start running that process.
//  - eventually that process transfers control
//    via swtch back to the scheduler.
void scheduler()
{
    80200b90:	711d                	addi	sp,sp,-96
    80200b92:	ec86                	sd	ra,88(sp)
    80200b94:	e8a2                	sd	s0,80(sp)
    80200b96:	e4a6                	sd	s1,72(sp)
    80200b98:	e0ca                	sd	s2,64(sp)
    80200b9a:	fc4e                	sd	s3,56(sp)
    80200b9c:	f852                	sd	s4,48(sp)
    80200b9e:	f456                	sd	s5,40(sp)
    80200ba0:	f05a                	sd	s6,32(sp)
    80200ba2:	ec5e                	sd	s7,24(sp)
    80200ba4:	e862                	sd	s8,16(sp)
    80200ba6:	e466                	sd	s9,8(sp)
    80200ba8:	1080                	addi	s0,sp,96
	struct proc *p;
	for (;;) {
		struct proc *chosen = NULL;
    80200baa:	4b01                	li	s6,0

		for (p = pool; p < &pool[NPROC]; p++) {
			if (p->state == RUNNABLE) {
    80200bac:	490d                	li	s2,3
		for (p = pool; p < &pool[NPROC]; p++) {
    80200bae:	0048f497          	auipc	s1,0x48f
    80200bb2:	45248493          	addi	s1,s1,1106 # 80690000 <kmem>
	return curr_proc()->pid;
    80200bb6:	0048fa17          	auipc	s4,0x48f
    80200bba:	462a0a13          	addi	s4,s4,1122 # 80690018 <current_proc>
				if (chosen == NULL || p->stride < chosen->stride)
					chosen = p;
			}
		}
		if (chosen == NULL)
			panic("all app are over!\n");
    80200bbe:	00003c97          	auipc	s9,0x3
    80200bc2:	58ac8c93          	addi	s9,s9,1418 # 80204148 <digits+0x18>
    80200bc6:	00003c17          	auipc	s8,0x3
    80200bca:	44ac0c13          	addi	s8,s8,1098 # 80204010 <e_text+0x10>
    80200bce:	00003b97          	auipc	s7,0x3
    80200bd2:	58ab8b93          	addi	s7,s7,1418 # 80204158 <digits+0x28>
		chosen->stride += chosen->pass;
		chosen->state = RUNNING;
		current_proc = chosen;
		swtch(&idle.context, &chosen->context);
    80200bd6:	00065a97          	auipc	s5,0x65
    80200bda:	452a8a93          	addi	s5,s5,1106 # 80266028 <idle+0x28>
    80200bde:	a881                	j	80200c2e <scheduler+0x9e>
    80200be0:	89be                	mv	s3,a5
		for (p = pool; p < &pool[NPROC]; p++) {
    80200be2:	14078793          	addi	a5,a5,320
    80200be6:	00978f63          	beq	a5,s1,80200c04 <scheduler+0x74>
			if (p->state == RUNNABLE) {
    80200bea:	4398                	lw	a4,0(a5)
    80200bec:	ff271be3          	bne	a4,s2,80200be2 <scheduler+0x52>
				if (chosen == NULL || p->stride < chosen->stride)
    80200bf0:	fe0988e3          	beqz	s3,80200be0 <scheduler+0x50>
    80200bf4:	1307a683          	lw	a3,304(a5)
    80200bf8:	1309a703          	lw	a4,304(s3)
    80200bfc:	fee6d3e3          	bge	a3,a4,80200be2 <scheduler+0x52>
    80200c00:	89be                	mv	s3,a5
    80200c02:	b7c5                	j	80200be2 <scheduler+0x52>
		if (chosen == NULL)
    80200c04:	02098b63          	beqz	s3,80200c3a <scheduler+0xaa>
		chosen->stride += chosen->pass;
    80200c08:	1309a783          	lw	a5,304(s3)
    80200c0c:	1349a703          	lw	a4,308(s3)
    80200c10:	9fb9                	addw	a5,a5,a4
    80200c12:	12f9a823          	sw	a5,304(s3)
		chosen->state = RUNNING;
    80200c16:	4791                	li	a5,4
    80200c18:	00f9a023          	sw	a5,0(s3)
		current_proc = chosen;
    80200c1c:	013a3023          	sd	s3,0(s4)
		swtch(&idle.context, &chosen->context);
    80200c20:	02898593          	addi	a1,s3,40
    80200c24:	8556                	mv	a0,s5
    80200c26:	00002097          	auipc	ra,0x2
    80200c2a:	a04080e7          	jalr	-1532(ra) # 8020262a <swtch>
		struct proc *chosen = NULL;
    80200c2e:	89da                	mv	s3,s6
		for (p = pool; p < &pool[NPROC]; p++) {
    80200c30:	00467797          	auipc	a5,0x467
    80200c34:	3d078793          	addi	a5,a5,976 # 80668000 <pool>
    80200c38:	bf4d                	j	80200bea <scheduler+0x5a>
	return curr_proc()->pid;
    80200c3a:	000a3683          	ld	a3,0(s4)
			panic("all app are over!\n");
    80200c3e:	07600793          	li	a5,118
    80200c42:	8766                	mv	a4,s9
    80200c44:	42d4                	lw	a3,4(a3)
    80200c46:	8662                	mv	a2,s8
    80200c48:	45fd                	li	a1,31
    80200c4a:	855e                	mv	a0,s7
    80200c4c:	00000097          	auipc	ra,0x0
    80200c50:	b2e080e7          	jalr	-1234(ra) # 8020077a <printf>
    80200c54:	00000097          	auipc	ra,0x0
    80200c58:	496080e7          	jalr	1174(ra) # 802010ea <shutdown>
    80200c5c:	b775                	j	80200c08 <scheduler+0x78>

0000000080200c5e <sched>:
// kernel thread, not this CPU. It should
// be proc->intena and proc->noff, but that would
// break in the few places where a lock is held but
// there's no process.
void sched()
{
    80200c5e:	1101                	addi	sp,sp,-32
    80200c60:	ec06                	sd	ra,24(sp)
    80200c62:	e822                	sd	s0,16(sp)
    80200c64:	e426                	sd	s1,8(sp)
    80200c66:	1000                	addi	s0,sp,32
	return current_proc;
    80200c68:	0048f497          	auipc	s1,0x48f
    80200c6c:	3b04b483          	ld	s1,944(s1) # 80690018 <current_proc>
	struct proc *p = curr_proc();
	if (p->state == RUNNING)
    80200c70:	4098                	lw	a4,0(s1)
    80200c72:	4791                	li	a5,4
    80200c74:	02f70163          	beq	a4,a5,80200c96 <sched+0x38>
		panic("sched running");
	swtch(&p->context, &idle.context);
    80200c78:	00065597          	auipc	a1,0x65
    80200c7c:	3b058593          	addi	a1,a1,944 # 80266028 <idle+0x28>
    80200c80:	02848513          	addi	a0,s1,40
    80200c84:	00002097          	auipc	ra,0x2
    80200c88:	9a6080e7          	jalr	-1626(ra) # 8020262a <swtch>
}
    80200c8c:	60e2                	ld	ra,24(sp)
    80200c8e:	6442                	ld	s0,16(sp)
    80200c90:	64a2                	ld	s1,8(sp)
    80200c92:	6105                	addi	sp,sp,32
    80200c94:	8082                	ret
		panic("sched running");
    80200c96:	08900793          	li	a5,137
    80200c9a:	00003717          	auipc	a4,0x3
    80200c9e:	4ae70713          	addi	a4,a4,1198 # 80204148 <digits+0x18>
    80200ca2:	40d4                	lw	a3,4(s1)
    80200ca4:	00003617          	auipc	a2,0x3
    80200ca8:	36c60613          	addi	a2,a2,876 # 80204010 <e_text+0x10>
    80200cac:	45fd                	li	a1,31
    80200cae:	00003517          	auipc	a0,0x3
    80200cb2:	4da50513          	addi	a0,a0,1242 # 80204188 <digits+0x58>
    80200cb6:	00000097          	auipc	ra,0x0
    80200cba:	ac4080e7          	jalr	-1340(ra) # 8020077a <printf>
    80200cbe:	00000097          	auipc	ra,0x0
    80200cc2:	42c080e7          	jalr	1068(ra) # 802010ea <shutdown>
    80200cc6:	bf4d                	j	80200c78 <sched+0x1a>

0000000080200cc8 <yield>:

// Give up the CPU for one scheduling round.
void yield()
{
    80200cc8:	1141                	addi	sp,sp,-16
    80200cca:	e406                	sd	ra,8(sp)
    80200ccc:	e022                	sd	s0,0(sp)
    80200cce:	0800                	addi	s0,sp,16
	current_proc->state = RUNNABLE;
    80200cd0:	0048f797          	auipc	a5,0x48f
    80200cd4:	3487b783          	ld	a5,840(a5) # 80690018 <current_proc>
    80200cd8:	470d                	li	a4,3
    80200cda:	c398                	sw	a4,0(a5)
	sched();
    80200cdc:	00000097          	auipc	ra,0x0
    80200ce0:	f82080e7          	jalr	-126(ra) # 80200c5e <sched>
}
    80200ce4:	60a2                	ld	ra,8(sp)
    80200ce6:	6402                	ld	s0,0(sp)
    80200ce8:	0141                	addi	sp,sp,16
    80200cea:	8082                	ret

0000000080200cec <freepagetable>:

// Free a process's page table, and free the
// physical memory it refers to.
void freepagetable(pagetable_t pagetable, uint64 max_page)
{
    80200cec:	1101                	addi	sp,sp,-32
    80200cee:	ec06                	sd	ra,24(sp)
    80200cf0:	e822                	sd	s0,16(sp)
    80200cf2:	e426                	sd	s1,8(sp)
    80200cf4:	e04a                	sd	s2,0(sp)
    80200cf6:	1000                	addi	s0,sp,32
    80200cf8:	84aa                	mv	s1,a0
    80200cfa:	892e                	mv	s2,a1
	uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80200cfc:	4681                	li	a3,0
    80200cfe:	4605                	li	a2,1
    80200d00:	040005b7          	lui	a1,0x4000
    80200d04:	15fd                	addi	a1,a1,-1
    80200d06:	05b2                	slli	a1,a1,0xc
    80200d08:	00001097          	auipc	ra,0x1
    80200d0c:	400080e7          	jalr	1024(ra) # 80202108 <uvmunmap>
	uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80200d10:	4681                	li	a3,0
    80200d12:	4605                	li	a2,1
    80200d14:	020005b7          	lui	a1,0x2000
    80200d18:	15fd                	addi	a1,a1,-1
    80200d1a:	05b6                	slli	a1,a1,0xd
    80200d1c:	8526                	mv	a0,s1
    80200d1e:	00001097          	auipc	ra,0x1
    80200d22:	3ea080e7          	jalr	1002(ra) # 80202108 <uvmunmap>
	uvmfree(pagetable, max_page);
    80200d26:	85ca                	mv	a1,s2
    80200d28:	8526                	mv	a0,s1
    80200d2a:	00001097          	auipc	ra,0x1
    80200d2e:	650080e7          	jalr	1616(ra) # 8020237a <uvmfree>
}
    80200d32:	60e2                	ld	ra,24(sp)
    80200d34:	6442                	ld	s0,16(sp)
    80200d36:	64a2                	ld	s1,8(sp)
    80200d38:	6902                	ld	s2,0(sp)
    80200d3a:	6105                	addi	sp,sp,32
    80200d3c:	8082                	ret

0000000080200d3e <freeproc>:

void freeproc(struct proc *p)
{
    80200d3e:	1101                	addi	sp,sp,-32
    80200d40:	ec06                	sd	ra,24(sp)
    80200d42:	e822                	sd	s0,16(sp)
    80200d44:	e426                	sd	s1,8(sp)
    80200d46:	1000                	addi	s0,sp,32
    80200d48:	84aa                	mv	s1,a0
	if (p->pagetable)
    80200d4a:	6508                	ld	a0,8(a0)
    80200d4c:	c511                	beqz	a0,80200d58 <freeproc+0x1a>
		freepagetable(p->pagetable, p->max_page);
    80200d4e:	6ccc                	ld	a1,152(s1)
    80200d50:	00000097          	auipc	ra,0x0
    80200d54:	f9c080e7          	jalr	-100(ra) # 80200cec <freepagetable>
	p->pagetable = 0;
    80200d58:	0004b423          	sd	zero,8(s1)
	p->state = UNUSED;
    80200d5c:	0004a023          	sw	zero,0(s1)
}
    80200d60:	60e2                	ld	ra,24(sp)
    80200d62:	6442                	ld	s0,16(sp)
    80200d64:	64a2                	ld	s1,8(sp)
    80200d66:	6105                	addi	sp,sp,32
    80200d68:	8082                	ret

0000000080200d6a <fork>:

int fork()
{
    80200d6a:	1101                	addi	sp,sp,-32
    80200d6c:	ec06                	sd	ra,24(sp)
    80200d6e:	e822                	sd	s0,16(sp)
    80200d70:	e426                	sd	s1,8(sp)
    80200d72:	e04a                	sd	s2,0(sp)
    80200d74:	1000                	addi	s0,sp,32
	return current_proc;
    80200d76:	0048f917          	auipc	s2,0x48f
    80200d7a:	2a293903          	ld	s2,674(s2) # 80690018 <current_proc>
	struct proc *np;
	struct proc *p = curr_proc();
	// Allocate process.
	if ((np = allocproc()) == 0) {
    80200d7e:	00000097          	auipc	ra,0x0
    80200d82:	d64080e7          	jalr	-668(ra) # 80200ae2 <allocproc>
    80200d86:	84aa                	mv	s1,a0
    80200d88:	c13d                	beqz	a0,80200dee <fork+0x84>
		panic("allocproc\n");
	}
	// Copy user memory from parent to child.
	if (uvmcopy(p->pagetable, np->pagetable, p->max_page) < 0) {
    80200d8a:	09893603          	ld	a2,152(s2)
    80200d8e:	648c                	ld	a1,8(s1)
    80200d90:	00893503          	ld	a0,8(s2)
    80200d94:	00001097          	auipc	ra,0x1
    80200d98:	618080e7          	jalr	1560(ra) # 802023ac <uvmcopy>
    80200d9c:	08054663          	bltz	a0,80200e28 <fork+0xbe>
		panic("uvmcopy\n");
	}
	np->max_page = p->max_page;
    80200da0:	09893783          	ld	a5,152(s2)
    80200da4:	ecdc                	sd	a5,152(s1)
	// copy saved user registers.
	*(np->trapframe) = *(p->trapframe);
    80200da6:	02093683          	ld	a3,32(s2)
    80200daa:	87b6                	mv	a5,a3
    80200dac:	7098                	ld	a4,32(s1)
    80200dae:	12068693          	addi	a3,a3,288
    80200db2:	0007b803          	ld	a6,0(a5)
    80200db6:	6788                	ld	a0,8(a5)
    80200db8:	6b8c                	ld	a1,16(a5)
    80200dba:	6f90                	ld	a2,24(a5)
    80200dbc:	01073023          	sd	a6,0(a4)
    80200dc0:	e708                	sd	a0,8(a4)
    80200dc2:	eb0c                	sd	a1,16(a4)
    80200dc4:	ef10                	sd	a2,24(a4)
    80200dc6:	02078793          	addi	a5,a5,32
    80200dca:	02070713          	addi	a4,a4,32
    80200dce:	fed792e3          	bne	a5,a3,80200db2 <fork+0x48>
	// Cause fork to return 0 in the child.
	np->trapframe->a0 = 0;
    80200dd2:	709c                	ld	a5,32(s1)
    80200dd4:	0607b823          	sd	zero,112(a5)
	np->parent = p;
    80200dd8:	0b24b023          	sd	s2,160(s1)
	np->state = RUNNABLE;
    80200ddc:	478d                	li	a5,3
    80200dde:	c09c                	sw	a5,0(s1)
	//add_task(np);
	return np->pid;
}
    80200de0:	40c8                	lw	a0,4(s1)
    80200de2:	60e2                	ld	ra,24(sp)
    80200de4:	6442                	ld	s0,16(sp)
    80200de6:	64a2                	ld	s1,8(sp)
    80200de8:	6902                	ld	s2,0(sp)
    80200dea:	6105                	addi	sp,sp,32
    80200dec:	8082                	ret
		panic("allocproc\n");
    80200dee:	0ab00793          	li	a5,171
    80200df2:	00003717          	auipc	a4,0x3
    80200df6:	35670713          	addi	a4,a4,854 # 80204148 <digits+0x18>
    80200dfa:	0048f697          	auipc	a3,0x48f
    80200dfe:	21e6b683          	ld	a3,542(a3) # 80690018 <current_proc>
    80200e02:	42d4                	lw	a3,4(a3)
    80200e04:	00003617          	auipc	a2,0x3
    80200e08:	20c60613          	addi	a2,a2,524 # 80204010 <e_text+0x10>
    80200e0c:	45fd                	li	a1,31
    80200e0e:	00003517          	auipc	a0,0x3
    80200e12:	2aa50513          	addi	a0,a0,682 # 802040b8 <e_text+0xb8>
    80200e16:	00000097          	auipc	ra,0x0
    80200e1a:	964080e7          	jalr	-1692(ra) # 8020077a <printf>
    80200e1e:	00000097          	auipc	ra,0x0
    80200e22:	2cc080e7          	jalr	716(ra) # 802010ea <shutdown>
    80200e26:	b795                	j	80200d8a <fork+0x20>
		panic("uvmcopy\n");
    80200e28:	0af00793          	li	a5,175
    80200e2c:	00003717          	auipc	a4,0x3
    80200e30:	31c70713          	addi	a4,a4,796 # 80204148 <digits+0x18>
    80200e34:	0048f697          	auipc	a3,0x48f
    80200e38:	1e46b683          	ld	a3,484(a3) # 80690018 <current_proc>
    80200e3c:	42d4                	lw	a3,4(a3)
    80200e3e:	00003617          	auipc	a2,0x3
    80200e42:	1d260613          	addi	a2,a2,466 # 80204010 <e_text+0x10>
    80200e46:	45fd                	li	a1,31
    80200e48:	00003517          	auipc	a0,0x3
    80200e4c:	36850513          	addi	a0,a0,872 # 802041b0 <digits+0x80>
    80200e50:	00000097          	auipc	ra,0x0
    80200e54:	92a080e7          	jalr	-1750(ra) # 8020077a <printf>
    80200e58:	00000097          	auipc	ra,0x0
    80200e5c:	292080e7          	jalr	658(ra) # 802010ea <shutdown>
    80200e60:	b781                	j	80200da0 <fork+0x36>

0000000080200e62 <exec>:

int exec(char *name)
{
    80200e62:	1101                	addi	sp,sp,-32
    80200e64:	ec06                	sd	ra,24(sp)
    80200e66:	e822                	sd	s0,16(sp)
    80200e68:	e426                	sd	s1,8(sp)
    80200e6a:	e04a                	sd	s2,0(sp)
    80200e6c:	1000                	addi	s0,sp,32
	int id = get_id_by_name(name);
    80200e6e:	fffff097          	auipc	ra,0xfffff
    80200e72:	3d4080e7          	jalr	980(ra) # 80200242 <get_id_by_name>
	if (id < 0)
    80200e76:	04054063          	bltz	a0,80200eb6 <exec+0x54>
    80200e7a:	84aa                	mv	s1,a0
	return current_proc;
    80200e7c:	0048f917          	auipc	s2,0x48f
    80200e80:	19c93903          	ld	s2,412(s2) # 80690018 <current_proc>
		return -1;
	struct proc *p = curr_proc();
	uvmunmap(p->pagetable, 0, p->max_page, 1);
    80200e84:	4685                	li	a3,1
    80200e86:	09893603          	ld	a2,152(s2)
    80200e8a:	4581                	li	a1,0
    80200e8c:	00893503          	ld	a0,8(s2)
    80200e90:	00001097          	auipc	ra,0x1
    80200e94:	278080e7          	jalr	632(ra) # 80202108 <uvmunmap>
	p->max_page = 0;
    80200e98:	08093c23          	sd	zero,152(s2)
	loader(id, p);
    80200e9c:	85ca                	mv	a1,s2
    80200e9e:	8526                	mv	a0,s1
    80200ea0:	fffff097          	auipc	ra,0xfffff
    80200ea4:	696080e7          	jalr	1686(ra) # 80200536 <loader>
	return 0;
    80200ea8:	4501                	li	a0,0
}
    80200eaa:	60e2                	ld	ra,24(sp)
    80200eac:	6442                	ld	s0,16(sp)
    80200eae:	64a2                	ld	s1,8(sp)
    80200eb0:	6902                	ld	s2,0(sp)
    80200eb2:	6105                	addi	sp,sp,32
    80200eb4:	8082                	ret
		return -1;
    80200eb6:	557d                	li	a0,-1
    80200eb8:	bfcd                	j	80200eaa <exec+0x48>

0000000080200eba <wait>:

int wait(int pid, int *code)
{
    80200eba:	715d                	addi	sp,sp,-80
    80200ebc:	e486                	sd	ra,72(sp)
    80200ebe:	e0a2                	sd	s0,64(sp)
    80200ec0:	fc26                	sd	s1,56(sp)
    80200ec2:	f84a                	sd	s2,48(sp)
    80200ec4:	f44e                	sd	s3,40(sp)
    80200ec6:	f052                	sd	s4,32(sp)
    80200ec8:	ec56                	sd	s5,24(sp)
    80200eca:	e85a                	sd	s6,16(sp)
    80200ecc:	e45e                	sd	s7,8(sp)
    80200ece:	e062                	sd	s8,0(sp)
    80200ed0:	0880                	addi	s0,sp,80
    80200ed2:	89aa                	mv	s3,a0
    80200ed4:	8b2e                	mv	s6,a1
	return current_proc;
    80200ed6:	0048f917          	auipc	s2,0x48f
    80200eda:	14293903          	ld	s2,322(s2) # 80690018 <current_proc>
	int havekids;
	struct proc *p = curr_proc();

	for (;;) {
		// Scan through table looking for exited children.
		havekids = 0;
    80200ede:	4b81                	li	s7,0
		for (np = pool; np < &pool[NPROC]; np++) {
			if (np->state != UNUSED && np->parent == p &&
			    (pid <= 0 || np->pid == pid)) {
				havekids = 1;
				if (np->state == ZOMBIE) {
    80200ee0:	4a15                	li	s4,5
				havekids = 1;
    80200ee2:	4a85                	li	s5,1
		for (np = pool; np < &pool[NPROC]; np++) {
    80200ee4:	0048f497          	auipc	s1,0x48f
    80200ee8:	11c48493          	addi	s1,s1,284 # 80690000 <kmem>
			}
		}
		if (!havekids) {
			return -1;
		}
		p->state = RUNNABLE;
    80200eec:	4c0d                	li	s8,3
		havekids = 0;
    80200eee:	865e                	mv	a2,s7
		for (np = pool; np < &pool[NPROC]; np++) {
    80200ef0:	00467797          	auipc	a5,0x467
    80200ef4:	11078793          	addi	a5,a5,272 # 80668000 <pool>
    80200ef8:	a801                	j	80200f08 <wait+0x4e>
				if (np->state == ZOMBIE) {
    80200efa:	03470263          	beq	a4,s4,80200f1e <wait+0x64>
				havekids = 1;
    80200efe:	8656                	mv	a2,s5
		for (np = pool; np < &pool[NPROC]; np++) {
    80200f00:	14078793          	addi	a5,a5,320
    80200f04:	02978463          	beq	a5,s1,80200f2c <wait+0x72>
			if (np->state != UNUSED && np->parent == p &&
    80200f08:	4398                	lw	a4,0(a5)
    80200f0a:	db7d                	beqz	a4,80200f00 <wait+0x46>
    80200f0c:	73d4                	ld	a3,160(a5)
    80200f0e:	ff2699e3          	bne	a3,s2,80200f00 <wait+0x46>
    80200f12:	ff3054e3          	blez	s3,80200efa <wait+0x40>
			    (pid <= 0 || np->pid == pid)) {
    80200f16:	43d4                	lw	a3,4(a5)
    80200f18:	ff3694e3          	bne	a3,s3,80200f00 <wait+0x46>
    80200f1c:	bff9                	j	80200efa <wait+0x40>
					np->state = UNUSED;
    80200f1e:	0007a023          	sw	zero,0(a5)
					pid = np->pid;
    80200f22:	43c8                	lw	a0,4(a5)
					*code = np->exit_code;
    80200f24:	77dc                	ld	a5,168(a5)
    80200f26:	00fb2023          	sw	a5,0(s6)
					return pid;
    80200f2a:	a019                	j	80200f30 <wait+0x76>
		if (!havekids) {
    80200f2c:	ee11                	bnez	a2,80200f48 <wait+0x8e>
			return -1;
    80200f2e:	557d                	li	a0,-1
		//add_task(p);
		sched();
	}
}
    80200f30:	60a6                	ld	ra,72(sp)
    80200f32:	6406                	ld	s0,64(sp)
    80200f34:	74e2                	ld	s1,56(sp)
    80200f36:	7942                	ld	s2,48(sp)
    80200f38:	79a2                	ld	s3,40(sp)
    80200f3a:	7a02                	ld	s4,32(sp)
    80200f3c:	6ae2                	ld	s5,24(sp)
    80200f3e:	6b42                	ld	s6,16(sp)
    80200f40:	6ba2                	ld	s7,8(sp)
    80200f42:	6c02                	ld	s8,0(sp)
    80200f44:	6161                	addi	sp,sp,80
    80200f46:	8082                	ret
		p->state = RUNNABLE;
    80200f48:	01892023          	sw	s8,0(s2)
		sched();
    80200f4c:	00000097          	auipc	ra,0x0
    80200f50:	d12080e7          	jalr	-750(ra) # 80200c5e <sched>
		havekids = 0;
    80200f54:	bf69                	j	80200eee <wait+0x34>

0000000080200f56 <exit>:

// Exit the current process.
void exit(int code)
{
    80200f56:	1101                	addi	sp,sp,-32
    80200f58:	ec06                	sd	ra,24(sp)
    80200f5a:	e822                	sd	s0,16(sp)
    80200f5c:	e426                	sd	s1,8(sp)
    80200f5e:	1000                	addi	s0,sp,32
    80200f60:	862a                	mv	a2,a0
	return current_proc;
    80200f62:	0048f497          	auipc	s1,0x48f
    80200f66:	0b64b483          	ld	s1,182(s1) # 80690018 <current_proc>
	struct proc *p = curr_proc();
	p->exit_code = code;
    80200f6a:	f4c8                	sd	a0,168(s1)
	debugf("proc %d exit with %d\n", p->pid, code);
    80200f6c:	40cc                	lw	a1,4(s1)
    80200f6e:	4501                	li	a0,0
    80200f70:	00000097          	auipc	ra,0x0
    80200f74:	356080e7          	jalr	854(ra) # 802012c6 <dummy>
	freeproc(p);
    80200f78:	8526                	mv	a0,s1
    80200f7a:	00000097          	auipc	ra,0x0
    80200f7e:	dc4080e7          	jalr	-572(ra) # 80200d3e <freeproc>
	if (p->parent != NULL) {
    80200f82:	70dc                	ld	a5,160(s1)
    80200f84:	c399                	beqz	a5,80200f8a <exit+0x34>
		// Parent should `wait`
		p->state = ZOMBIE;
    80200f86:	4795                	li	a5,5
    80200f88:	c09c                	sw	a5,0(s1)
{
    80200f8a:	00467797          	auipc	a5,0x467
    80200f8e:	07678793          	addi	a5,a5,118 # 80668000 <pool>
	}
	// Set the `parent` of all children to NULL
	struct proc *np;
	for (np = pool; np < &pool[NPROC]; np++) {
    80200f92:	0048f697          	auipc	a3,0x48f
    80200f96:	06e68693          	addi	a3,a3,110 # 80690000 <kmem>
    80200f9a:	a029                	j	80200fa4 <exit+0x4e>
    80200f9c:	14078793          	addi	a5,a5,320
    80200fa0:	00d78863          	beq	a5,a3,80200fb0 <exit+0x5a>
		if (np->parent == p) {
    80200fa4:	73d8                	ld	a4,160(a5)
    80200fa6:	fe971be3          	bne	a4,s1,80200f9c <exit+0x46>
			np->parent = NULL;
    80200faa:	0a07b023          	sd	zero,160(a5)
    80200fae:	b7fd                	j	80200f9c <exit+0x46>
		}
	}
	sched();
    80200fb0:	00000097          	auipc	ra,0x0
    80200fb4:	cae080e7          	jalr	-850(ra) # 80200c5e <sched>
    80200fb8:	60e2                	ld	ra,24(sp)
    80200fba:	6442                	ld	s0,16(sp)
    80200fbc:	64a2                	ld	s1,8(sp)
    80200fbe:	6105                	addi	sp,sp,32
    80200fc0:	8082                	ret

0000000080200fc2 <init_queue>:
#include "queue.h"
#include "defs.h"

void init_queue(struct queue *q)
{
    80200fc2:	1141                	addi	sp,sp,-16
    80200fc4:	e422                	sd	s0,8(sp)
    80200fc6:	0800                	addi	s0,sp,16
	q->front = q->tail = 0;
    80200fc8:	6785                	lui	a5,0x1
    80200fca:	953e                	add	a0,a0,a5
    80200fcc:	00052223          	sw	zero,4(a0)
    80200fd0:	00052023          	sw	zero,0(a0)
	q->empty = 1;
    80200fd4:	4785                	li	a5,1
    80200fd6:	c51c                	sw	a5,8(a0)
}
    80200fd8:	6422                	ld	s0,8(sp)
    80200fda:	0141                	addi	sp,sp,16
    80200fdc:	8082                	ret

0000000080200fde <push_queue>:

void push_queue(struct queue *q, int value)
{
    80200fde:	1101                	addi	sp,sp,-32
    80200fe0:	ec06                	sd	ra,24(sp)
    80200fe2:	e822                	sd	s0,16(sp)
    80200fe4:	e426                	sd	s1,8(sp)
    80200fe6:	e04a                	sd	s2,0(sp)
    80200fe8:	1000                	addi	s0,sp,32
    80200fea:	84aa                	mv	s1,a0
    80200fec:	892e                	mv	s2,a1
	if (!q->empty && q->front == q->tail) {
    80200fee:	6785                	lui	a5,0x1
    80200ff0:	97aa                	add	a5,a5,a0
    80200ff2:	479c                	lw	a5,8(a5)
    80200ff4:	e799                	bnez	a5,80201002 <push_queue+0x24>
    80200ff6:	6785                	lui	a5,0x1
    80200ff8:	97aa                	add	a5,a5,a0
    80200ffa:	4398                	lw	a4,0(a5)
    80200ffc:	43dc                	lw	a5,4(a5)
    80200ffe:	02f70c63          	beq	a4,a5,80201036 <push_queue+0x58>
		panic("queue shouldn't be overflow");
	}
	q->empty = 0;
    80201002:	6705                	lui	a4,0x1
    80201004:	9726                	add	a4,a4,s1
    80201006:	00072423          	sw	zero,8(a4) # 1008 <_entry-0x801feff8>
	q->data[q->tail] = value;
    8020100a:	435c                	lw	a5,4(a4)
    8020100c:	00279513          	slli	a0,a5,0x2
    80201010:	94aa                	add	s1,s1,a0
    80201012:	0124a023          	sw	s2,0(s1)
	q->tail = (q->tail + 1) % NPROC;
    80201016:	2785                	addiw	a5,a5,1
    80201018:	41f7d69b          	sraiw	a3,a5,0x1f
    8020101c:	0176d69b          	srliw	a3,a3,0x17
    80201020:	9fb5                	addw	a5,a5,a3
    80201022:	1ff7f793          	andi	a5,a5,511
    80201026:	9f95                	subw	a5,a5,a3
    80201028:	c35c                	sw	a5,4(a4)
}
    8020102a:	60e2                	ld	ra,24(sp)
    8020102c:	6442                	ld	s0,16(sp)
    8020102e:	64a2                	ld	s1,8(sp)
    80201030:	6902                	ld	s2,0(sp)
    80201032:	6105                	addi	sp,sp,32
    80201034:	8082                	ret
		panic("queue shouldn't be overflow");
    80201036:	00000097          	auipc	ra,0x0
    8020103a:	91a080e7          	jalr	-1766(ra) # 80200950 <threadid>
    8020103e:	86aa                	mv	a3,a0
    80201040:	47b5                	li	a5,13
    80201042:	00003717          	auipc	a4,0x3
    80201046:	19670713          	addi	a4,a4,406 # 802041d8 <digits+0xa8>
    8020104a:	00003617          	auipc	a2,0x3
    8020104e:	fc660613          	addi	a2,a2,-58 # 80204010 <e_text+0x10>
    80201052:	45fd                	li	a1,31
    80201054:	00003517          	auipc	a0,0x3
    80201058:	19450513          	addi	a0,a0,404 # 802041e8 <digits+0xb8>
    8020105c:	fffff097          	auipc	ra,0xfffff
    80201060:	71e080e7          	jalr	1822(ra) # 8020077a <printf>
    80201064:	00000097          	auipc	ra,0x0
    80201068:	086080e7          	jalr	134(ra) # 802010ea <shutdown>
    8020106c:	bf59                	j	80201002 <push_queue+0x24>

000000008020106e <pop_queue>:

int pop_queue(struct queue *q)
{
    8020106e:	1141                	addi	sp,sp,-16
    80201070:	e422                	sd	s0,8(sp)
    80201072:	0800                	addi	s0,sp,16
	if (q->empty)
    80201074:	6785                	lui	a5,0x1
    80201076:	97aa                	add	a5,a5,a0
    80201078:	479c                	lw	a5,8(a5)
    8020107a:	ef95                	bnez	a5,802010b6 <pop_queue+0x48>
		return -1;
	int value = q->data[q->front];
    8020107c:	6605                	lui	a2,0x1
    8020107e:	962a                	add	a2,a2,a0
    80201080:	4218                	lw	a4,0(a2)
    80201082:	00271793          	slli	a5,a4,0x2
    80201086:	97aa                	add	a5,a5,a0
    80201088:	4388                	lw	a0,0(a5)
	q->front = (q->front + 1) % NPROC;
    8020108a:	2705                	addiw	a4,a4,1
    8020108c:	41f7579b          	sraiw	a5,a4,0x1f
    80201090:	0177d59b          	srliw	a1,a5,0x17
    80201094:	00b707bb          	addw	a5,a4,a1
    80201098:	1ff7f793          	andi	a5,a5,511
    8020109c:	9f8d                	subw	a5,a5,a1
    8020109e:	0007871b          	sext.w	a4,a5
    802010a2:	c21c                	sw	a5,0(a2)
	if (q->front == q->tail)
    802010a4:	425c                	lw	a5,4(a2)
    802010a6:	00e78563          	beq	a5,a4,802010b0 <pop_queue+0x42>
		q->empty = 1;
	return value;
}
    802010aa:	6422                	ld	s0,8(sp)
    802010ac:	0141                	addi	sp,sp,16
    802010ae:	8082                	ret
		q->empty = 1;
    802010b0:	4785                	li	a5,1
    802010b2:	c61c                	sw	a5,8(a2)
    802010b4:	bfdd                	j	802010aa <pop_queue+0x3c>
		return -1;
    802010b6:	557d                	li	a0,-1
    802010b8:	bfcd                	j	802010aa <pop_queue+0x3c>

00000000802010ba <console_putchar>:
		     : "memory");
	return a0;
}

void console_putchar(int c)
{
    802010ba:	1141                	addi	sp,sp,-16
    802010bc:	e422                	sd	s0,8(sp)
    802010be:	0800                	addi	s0,sp,16
	register uint64 a1 asm("a1") = arg1;
    802010c0:	4581                	li	a1,0
	register uint64 a2 asm("a2") = arg2;
    802010c2:	4601                	li	a2,0
	register uint64 a7 asm("a7") = which;
    802010c4:	4885                	li	a7,1
	asm volatile("ecall"
    802010c6:	00000073          	ecall
	sbi_call(SBI_CONSOLE_PUTCHAR, c, 0, 0);
}
    802010ca:	6422                	ld	s0,8(sp)
    802010cc:	0141                	addi	sp,sp,16
    802010ce:	8082                	ret

00000000802010d0 <console_getchar>:

int console_getchar()
{
    802010d0:	1141                	addi	sp,sp,-16
    802010d2:	e422                	sd	s0,8(sp)
    802010d4:	0800                	addi	s0,sp,16
	register uint64 a0 asm("a0") = arg0;
    802010d6:	4501                	li	a0,0
	register uint64 a1 asm("a1") = arg1;
    802010d8:	4581                	li	a1,0
	register uint64 a2 asm("a2") = arg2;
    802010da:	4601                	li	a2,0
	register uint64 a7 asm("a7") = which;
    802010dc:	4889                	li	a7,2
	asm volatile("ecall"
    802010de:	00000073          	ecall
	return sbi_call(SBI_CONSOLE_GETCHAR, 0, 0, 0);
}
    802010e2:	2501                	sext.w	a0,a0
    802010e4:	6422                	ld	s0,8(sp)
    802010e6:	0141                	addi	sp,sp,16
    802010e8:	8082                	ret

00000000802010ea <shutdown>:

void shutdown()
{
    802010ea:	1141                	addi	sp,sp,-16
    802010ec:	e422                	sd	s0,8(sp)
    802010ee:	0800                	addi	s0,sp,16
	register uint64 a0 asm("a0") = arg0;
    802010f0:	4501                	li	a0,0
	register uint64 a1 asm("a1") = arg1;
    802010f2:	4581                	li	a1,0
	register uint64 a2 asm("a2") = arg2;
    802010f4:	4601                	li	a2,0
	register uint64 a7 asm("a7") = which;
    802010f6:	48a1                	li	a7,8
	asm volatile("ecall"
    802010f8:	00000073          	ecall
	sbi_call(SBI_SHUTDOWN, 0, 0, 0);
}
    802010fc:	6422                	ld	s0,8(sp)
    802010fe:	0141                	addi	sp,sp,16
    80201100:	8082                	ret

0000000080201102 <set_timer>:

void set_timer(uint64 stime)
{
    80201102:	1141                	addi	sp,sp,-16
    80201104:	e422                	sd	s0,8(sp)
    80201106:	0800                	addi	s0,sp,16
	register uint64 a1 asm("a1") = arg1;
    80201108:	4581                	li	a1,0
	register uint64 a2 asm("a2") = arg2;
    8020110a:	4601                	li	a2,0
	register uint64 a7 asm("a7") = which;
    8020110c:	4881                	li	a7,0
	asm volatile("ecall"
    8020110e:	00000073          	ecall
	sbi_call(SBI_SET_TIMER, stime, 0, 0);
    80201112:	6422                	ld	s0,8(sp)
    80201114:	0141                	addi	sp,sp,16
    80201116:	8082                	ret

0000000080201118 <memset>:
#include "string.h"
#include "types.h"

void *memset(void *dst, int c, uint n)
{
    80201118:	1141                	addi	sp,sp,-16
    8020111a:	e422                	sd	s0,8(sp)
    8020111c:	0800                	addi	s0,sp,16
	char *cdst = (char *)dst;
	int i;
	for (i = 0; i < n; i++) {
    8020111e:	ca19                	beqz	a2,80201134 <memset+0x1c>
    80201120:	87aa                	mv	a5,a0
    80201122:	1602                	slli	a2,a2,0x20
    80201124:	9201                	srli	a2,a2,0x20
    80201126:	00a60733          	add	a4,a2,a0
		cdst[i] = c;
    8020112a:	00b78023          	sb	a1,0(a5) # 1000 <_entry-0x801ff000>
	for (i = 0; i < n; i++) {
    8020112e:	0785                	addi	a5,a5,1
    80201130:	fee79de3          	bne	a5,a4,8020112a <memset+0x12>
	}
	return dst;
}
    80201134:	6422                	ld	s0,8(sp)
    80201136:	0141                	addi	sp,sp,16
    80201138:	8082                	ret

000000008020113a <memcmp>:

int memcmp(const void *v1, const void *v2, uint n)
{
    8020113a:	1141                	addi	sp,sp,-16
    8020113c:	e422                	sd	s0,8(sp)
    8020113e:	0800                	addi	s0,sp,16
	const uchar *s1, *s2;

	s1 = v1;
	s2 = v2;
	while (n-- > 0) {
    80201140:	ca05                	beqz	a2,80201170 <memcmp+0x36>
    80201142:	fff6069b          	addiw	a3,a2,-1
    80201146:	1682                	slli	a3,a3,0x20
    80201148:	9281                	srli	a3,a3,0x20
    8020114a:	0685                	addi	a3,a3,1
    8020114c:	96aa                	add	a3,a3,a0
		if (*s1 != *s2)
    8020114e:	00054783          	lbu	a5,0(a0)
    80201152:	0005c703          	lbu	a4,0(a1) # 2000000 <_entry-0x7e200000>
    80201156:	00e79863          	bne	a5,a4,80201166 <memcmp+0x2c>
			return *s1 - *s2;
		s1++, s2++;
    8020115a:	0505                	addi	a0,a0,1
    8020115c:	0585                	addi	a1,a1,1
	while (n-- > 0) {
    8020115e:	fed518e3          	bne	a0,a3,8020114e <memcmp+0x14>
	}

	return 0;
    80201162:	4501                	li	a0,0
    80201164:	a019                	j	8020116a <memcmp+0x30>
			return *s1 - *s2;
    80201166:	40e7853b          	subw	a0,a5,a4
}
    8020116a:	6422                	ld	s0,8(sp)
    8020116c:	0141                	addi	sp,sp,16
    8020116e:	8082                	ret
	return 0;
    80201170:	4501                	li	a0,0
    80201172:	bfe5                	j	8020116a <memcmp+0x30>

0000000080201174 <memmove>:

void *memmove(void *dst, const void *src, uint n)
{
    80201174:	1141                	addi	sp,sp,-16
    80201176:	e422                	sd	s0,8(sp)
    80201178:	0800                	addi	s0,sp,16
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
    8020117a:	02a5e563          	bltu	a1,a0,802011a4 <memmove+0x30>
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
    8020117e:	fff6069b          	addiw	a3,a2,-1
    80201182:	ce11                	beqz	a2,8020119e <memmove+0x2a>
    80201184:	1682                	slli	a3,a3,0x20
    80201186:	9281                	srli	a3,a3,0x20
    80201188:	0685                	addi	a3,a3,1
    8020118a:	96ae                	add	a3,a3,a1
    8020118c:	87aa                	mv	a5,a0
			*d++ = *s++;
    8020118e:	0585                	addi	a1,a1,1
    80201190:	0785                	addi	a5,a5,1
    80201192:	fff5c703          	lbu	a4,-1(a1)
    80201196:	fee78fa3          	sb	a4,-1(a5)
		while (n-- > 0)
    8020119a:	fed59ae3          	bne	a1,a3,8020118e <memmove+0x1a>

	return dst;
}
    8020119e:	6422                	ld	s0,8(sp)
    802011a0:	0141                	addi	sp,sp,16
    802011a2:	8082                	ret
	if (s < d && s + n > d) {
    802011a4:	02061713          	slli	a4,a2,0x20
    802011a8:	9301                	srli	a4,a4,0x20
    802011aa:	00e587b3          	add	a5,a1,a4
    802011ae:	fcf578e3          	bgeu	a0,a5,8020117e <memmove+0xa>
		d += n;
    802011b2:	972a                	add	a4,a4,a0
		while (n-- > 0)
    802011b4:	fff6069b          	addiw	a3,a2,-1
    802011b8:	d27d                	beqz	a2,8020119e <memmove+0x2a>
    802011ba:	02069613          	slli	a2,a3,0x20
    802011be:	9201                	srli	a2,a2,0x20
    802011c0:	fff64613          	not	a2,a2
    802011c4:	963e                	add	a2,a2,a5
			*--d = *--s;
    802011c6:	17fd                	addi	a5,a5,-1
    802011c8:	177d                	addi	a4,a4,-1
    802011ca:	0007c683          	lbu	a3,0(a5)
    802011ce:	00d70023          	sb	a3,0(a4)
		while (n-- > 0)
    802011d2:	fef61ae3          	bne	a2,a5,802011c6 <memmove+0x52>
    802011d6:	b7e1                	j	8020119e <memmove+0x2a>

00000000802011d8 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void *memcpy(void *dst, const void *src, uint n)
{
    802011d8:	1141                	addi	sp,sp,-16
    802011da:	e406                	sd	ra,8(sp)
    802011dc:	e022                	sd	s0,0(sp)
    802011de:	0800                	addi	s0,sp,16
	return memmove(dst, src, n);
    802011e0:	00000097          	auipc	ra,0x0
    802011e4:	f94080e7          	jalr	-108(ra) # 80201174 <memmove>
}
    802011e8:	60a2                	ld	ra,8(sp)
    802011ea:	6402                	ld	s0,0(sp)
    802011ec:	0141                	addi	sp,sp,16
    802011ee:	8082                	ret

00000000802011f0 <strncmp>:

int strncmp(const char *p, const char *q, uint n)
{
    802011f0:	1141                	addi	sp,sp,-16
    802011f2:	e422                	sd	s0,8(sp)
    802011f4:	0800                	addi	s0,sp,16
	while (n > 0 && *p && *p == *q)
    802011f6:	ce11                	beqz	a2,80201212 <strncmp+0x22>
    802011f8:	00054783          	lbu	a5,0(a0)
    802011fc:	cf89                	beqz	a5,80201216 <strncmp+0x26>
    802011fe:	0005c703          	lbu	a4,0(a1)
    80201202:	00f71a63          	bne	a4,a5,80201216 <strncmp+0x26>
		n--, p++, q++;
    80201206:	367d                	addiw	a2,a2,-1
    80201208:	0505                	addi	a0,a0,1
    8020120a:	0585                	addi	a1,a1,1
	while (n > 0 && *p && *p == *q)
    8020120c:	f675                	bnez	a2,802011f8 <strncmp+0x8>
	if (n == 0)
		return 0;
    8020120e:	4501                	li	a0,0
    80201210:	a809                	j	80201222 <strncmp+0x32>
    80201212:	4501                	li	a0,0
    80201214:	a039                	j	80201222 <strncmp+0x32>
	if (n == 0)
    80201216:	ca09                	beqz	a2,80201228 <strncmp+0x38>
	return (uchar)*p - (uchar)*q;
    80201218:	00054503          	lbu	a0,0(a0)
    8020121c:	0005c783          	lbu	a5,0(a1)
    80201220:	9d1d                	subw	a0,a0,a5
}
    80201222:	6422                	ld	s0,8(sp)
    80201224:	0141                	addi	sp,sp,16
    80201226:	8082                	ret
		return 0;
    80201228:	4501                	li	a0,0
    8020122a:	bfe5                	j	80201222 <strncmp+0x32>

000000008020122c <strncpy>:

char *strncpy(char *s, const char *t, int n)
{
    8020122c:	1141                	addi	sp,sp,-16
    8020122e:	e422                	sd	s0,8(sp)
    80201230:	0800                	addi	s0,sp,16
	char *os;

	os = s;
	while (n-- > 0 && (*s++ = *t++) != 0)
    80201232:	872a                	mv	a4,a0
    80201234:	8832                	mv	a6,a2
    80201236:	367d                	addiw	a2,a2,-1
    80201238:	01005963          	blez	a6,8020124a <strncpy+0x1e>
    8020123c:	0705                	addi	a4,a4,1
    8020123e:	0005c783          	lbu	a5,0(a1)
    80201242:	fef70fa3          	sb	a5,-1(a4)
    80201246:	0585                	addi	a1,a1,1
    80201248:	f7f5                	bnez	a5,80201234 <strncpy+0x8>
		;
	while (n-- > 0)
    8020124a:	86ba                	mv	a3,a4
    8020124c:	00c05c63          	blez	a2,80201264 <strncpy+0x38>
		*s++ = 0;
    80201250:	0685                	addi	a3,a3,1
    80201252:	fe068fa3          	sb	zero,-1(a3)
	while (n-- > 0)
    80201256:	fff6c793          	not	a5,a3
    8020125a:	9fb9                	addw	a5,a5,a4
    8020125c:	010787bb          	addw	a5,a5,a6
    80201260:	fef048e3          	bgtz	a5,80201250 <strncpy+0x24>
	return os;
}
    80201264:	6422                	ld	s0,8(sp)
    80201266:	0141                	addi	sp,sp,16
    80201268:	8082                	ret

000000008020126a <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char *safestrcpy(char *s, const char *t, int n)
{
    8020126a:	1141                	addi	sp,sp,-16
    8020126c:	e422                	sd	s0,8(sp)
    8020126e:	0800                	addi	s0,sp,16
	char *os;

	os = s;
	if (n <= 0)
    80201270:	02c05363          	blez	a2,80201296 <safestrcpy+0x2c>
    80201274:	fff6069b          	addiw	a3,a2,-1
    80201278:	1682                	slli	a3,a3,0x20
    8020127a:	9281                	srli	a3,a3,0x20
    8020127c:	96ae                	add	a3,a3,a1
    8020127e:	87aa                	mv	a5,a0
		return os;
	while (--n > 0 && (*s++ = *t++) != 0)
    80201280:	00d58963          	beq	a1,a3,80201292 <safestrcpy+0x28>
    80201284:	0585                	addi	a1,a1,1
    80201286:	0785                	addi	a5,a5,1
    80201288:	fff5c703          	lbu	a4,-1(a1)
    8020128c:	fee78fa3          	sb	a4,-1(a5)
    80201290:	fb65                	bnez	a4,80201280 <safestrcpy+0x16>
		;
	*s = 0;
    80201292:	00078023          	sb	zero,0(a5)
	return os;
}
    80201296:	6422                	ld	s0,8(sp)
    80201298:	0141                	addi	sp,sp,16
    8020129a:	8082                	ret

000000008020129c <strlen>:

int strlen(const char *s)
{
    8020129c:	1141                	addi	sp,sp,-16
    8020129e:	e422                	sd	s0,8(sp)
    802012a0:	0800                	addi	s0,sp,16
	int n;

	for (n = 0; s[n]; n++)
    802012a2:	00054783          	lbu	a5,0(a0)
    802012a6:	cf91                	beqz	a5,802012c2 <strlen+0x26>
    802012a8:	0505                	addi	a0,a0,1
    802012aa:	87aa                	mv	a5,a0
    802012ac:	4685                	li	a3,1
    802012ae:	9e89                	subw	a3,a3,a0
    802012b0:	00f6853b          	addw	a0,a3,a5
    802012b4:	0785                	addi	a5,a5,1
    802012b6:	fff7c703          	lbu	a4,-1(a5)
    802012ba:	fb7d                	bnez	a4,802012b0 <strlen+0x14>
		;
	return n;
}
    802012bc:	6422                	ld	s0,8(sp)
    802012be:	0141                	addi	sp,sp,16
    802012c0:	8082                	ret
	for (n = 0; s[n]; n++)
    802012c2:	4501                	li	a0,0
    802012c4:	bfe5                	j	802012bc <strlen+0x20>

00000000802012c6 <dummy>:

void dummy(int _, ...)
{
    802012c6:	715d                	addi	sp,sp,-80
    802012c8:	e422                	sd	s0,8(sp)
    802012ca:	0800                	addi	s0,sp,16
    802012cc:	e40c                	sd	a1,8(s0)
    802012ce:	e810                	sd	a2,16(s0)
    802012d0:	ec14                	sd	a3,24(s0)
    802012d2:	f018                	sd	a4,32(s0)
    802012d4:	f41c                	sd	a5,40(s0)
    802012d6:	03043823          	sd	a6,48(s0)
    802012da:	03143c23          	sd	a7,56(s0)
    802012de:	6422                	ld	s0,8(sp)
    802012e0:	6161                	addi	sp,sp,80
    802012e2:	8082                	ret

00000000802012e4 <sys_write>:
#define PROT_READ 1
#define PROT_WRITE 2
#define PROT_EXEC 4

uint64 sys_write(int fd, uint64 va, uint len)
{
    802012e4:	7111                	addi	sp,sp,-256
    802012e6:	fd86                	sd	ra,248(sp)
    802012e8:	f9a2                	sd	s0,240(sp)
    802012ea:	f5a6                	sd	s1,232(sp)
    802012ec:	f1ca                	sd	s2,224(sp)
    802012ee:	edce                	sd	s3,216(sp)
    802012f0:	0200                	addi	s0,sp,256
    802012f2:	84aa                	mv	s1,a0
    802012f4:	89ae                	mv	s3,a1
    802012f6:	8932                	mv	s2,a2
	debugf("sys_write fd = %d str = %x, len = %d", fd, va, len);
    802012f8:	86b2                	mv	a3,a2
    802012fa:	862e                	mv	a2,a1
    802012fc:	85aa                	mv	a1,a0
    802012fe:	4501                	li	a0,0
    80201300:	00000097          	auipc	ra,0x0
    80201304:	fc6080e7          	jalr	-58(ra) # 802012c6 <dummy>
	if (fd != STDOUT)
    80201308:	4785                	li	a5,1
		return -1;
    8020130a:	557d                	li	a0,-1
	if (fd != STDOUT)
    8020130c:	00f48963          	beq	s1,a5,8020131e <sys_write+0x3a>
	debugf("size = %d", size);
	for (int i = 0; i < size; ++i) {
		console_putchar(str[i]);
	}
	return size;
}
    80201310:	70ee                	ld	ra,248(sp)
    80201312:	744e                	ld	s0,240(sp)
    80201314:	74ae                	ld	s1,232(sp)
    80201316:	790e                	ld	s2,224(sp)
    80201318:	69ee                	ld	s3,216(sp)
    8020131a:	6111                	addi	sp,sp,256
    8020131c:	8082                	ret
	struct proc *p = curr_proc();
    8020131e:	fffff097          	auipc	ra,0xfffff
    80201322:	648080e7          	jalr	1608(ra) # 80200966 <curr_proc>
	int size = copyinstr(p->pagetable, str, va, MIN(len, MAX_STR_LEN));
    80201326:	86ca                	mv	a3,s2
    80201328:	0c800793          	li	a5,200
    8020132c:	0127f463          	bgeu	a5,s2,80201334 <sys_write+0x50>
    80201330:	0c800693          	li	a3,200
    80201334:	1682                	slli	a3,a3,0x20
    80201336:	9281                	srli	a3,a3,0x20
    80201338:	864e                	mv	a2,s3
    8020133a:	f0840593          	addi	a1,s0,-248
    8020133e:	6508                	ld	a0,8(a0)
    80201340:	00001097          	auipc	ra,0x1
    80201344:	240080e7          	jalr	576(ra) # 80202580 <copyinstr>
    80201348:	892a                	mv	s2,a0
	debugf("size = %d", size);
    8020134a:	85aa                	mv	a1,a0
    8020134c:	4501                	li	a0,0
    8020134e:	00000097          	auipc	ra,0x0
    80201352:	f78080e7          	jalr	-136(ra) # 802012c6 <dummy>
	for (int i = 0; i < size; ++i) {
    80201356:	03205563          	blez	s2,80201380 <sys_write+0x9c>
    8020135a:	f0840493          	addi	s1,s0,-248
    8020135e:	fff9099b          	addiw	s3,s2,-1
    80201362:	1982                	slli	s3,s3,0x20
    80201364:	0209d993          	srli	s3,s3,0x20
    80201368:	f0940793          	addi	a5,s0,-247
    8020136c:	99be                	add	s3,s3,a5
		console_putchar(str[i]);
    8020136e:	0004c503          	lbu	a0,0(s1)
    80201372:	00000097          	auipc	ra,0x0
    80201376:	d48080e7          	jalr	-696(ra) # 802010ba <console_putchar>
	for (int i = 0; i < size; ++i) {
    8020137a:	0485                	addi	s1,s1,1
    8020137c:	ff3499e3          	bne	s1,s3,8020136e <sys_write+0x8a>
	return size;
    80201380:	854a                	mv	a0,s2
    80201382:	b779                	j	80201310 <sys_write+0x2c>

0000000080201384 <sys_read>:

uint64 sys_read(int fd, uint64 va, uint64 len)
{
    80201384:	716d                	addi	sp,sp,-272
    80201386:	e606                	sd	ra,264(sp)
    80201388:	e222                	sd	s0,256(sp)
    8020138a:	fda6                	sd	s1,248(sp)
    8020138c:	f9ca                	sd	s2,240(sp)
    8020138e:	f5ce                	sd	s3,232(sp)
    80201390:	f1d2                	sd	s4,224(sp)
    80201392:	edd6                	sd	s5,216(sp)
    80201394:	0a00                	addi	s0,sp,272
    80201396:	84aa                	mv	s1,a0
    80201398:	8a2e                	mv	s4,a1
    8020139a:	8932                	mv	s2,a2
	debugf("sys_read fd = %d str = %x, len = %d", fd, va, len);
    8020139c:	86b2                	mv	a3,a2
    8020139e:	862e                	mv	a2,a1
    802013a0:	85aa                	mv	a1,a0
    802013a2:	4501                	li	a0,0
    802013a4:	00000097          	auipc	ra,0x0
    802013a8:	f22080e7          	jalr	-222(ra) # 802012c6 <dummy>
	if (fd != STDIN)
		return -1;
    802013ac:	557d                	li	a0,-1
	if (fd != STDIN)
    802013ae:	e0a1                	bnez	s1,802013ee <sys_read+0x6a>
	struct proc *p = curr_proc();
    802013b0:	fffff097          	auipc	ra,0xfffff
    802013b4:	5b6080e7          	jalr	1462(ra) # 80200966 <curr_proc>
    802013b8:	8aaa                	mv	s5,a0
	char str[MAX_STR_LEN];
	for (int i = 0; i < len; ++i) {
    802013ba:	00090f63          	beqz	s2,802013d8 <sys_read+0x54>
    802013be:	ef840493          	addi	s1,s0,-264
    802013c2:	009909b3          	add	s3,s2,s1
		int c = consgetc();
    802013c6:	fffff097          	auipc	ra,0xfffff
    802013ca:	c6a080e7          	jalr	-918(ra) # 80200030 <consgetc>
		str[i] = c;
    802013ce:	00a48023          	sb	a0,0(s1)
	for (int i = 0; i < len; ++i) {
    802013d2:	0485                	addi	s1,s1,1
    802013d4:	ff3499e3          	bne	s1,s3,802013c6 <sys_read+0x42>
	}
	copyout(p->pagetable, va, str, len);
    802013d8:	86ca                	mv	a3,s2
    802013da:	ef840613          	addi	a2,s0,-264
    802013de:	85d2                	mv	a1,s4
    802013e0:	008ab503          	ld	a0,8(s5)
    802013e4:	00001097          	auipc	ra,0x1
    802013e8:	082080e7          	jalr	130(ra) # 80202466 <copyout>
	return len;
    802013ec:	854a                	mv	a0,s2
}
    802013ee:	60b2                	ld	ra,264(sp)
    802013f0:	6412                	ld	s0,256(sp)
    802013f2:	74ee                	ld	s1,248(sp)
    802013f4:	794e                	ld	s2,240(sp)
    802013f6:	79ae                	ld	s3,232(sp)
    802013f8:	7a0e                	ld	s4,224(sp)
    802013fa:	6aee                	ld	s5,216(sp)
    802013fc:	6151                	addi	sp,sp,272
    802013fe:	8082                	ret

0000000080201400 <sys_exit>:

__attribute__((noreturn)) void sys_exit(int code)
{
    80201400:	1141                	addi	sp,sp,-16
    80201402:	e406                	sd	ra,8(sp)
    80201404:	e022                	sd	s0,0(sp)
    80201406:	0800                	addi	s0,sp,16
	exit(code);
    80201408:	00000097          	auipc	ra,0x0
    8020140c:	b4e080e7          	jalr	-1202(ra) # 80200f56 <exit>

0000000080201410 <sys_sched_yield>:
	__builtin_unreachable();
}

uint64 sys_sched_yield()
{
    80201410:	1141                	addi	sp,sp,-16
    80201412:	e406                	sd	ra,8(sp)
    80201414:	e022                	sd	s0,0(sp)
    80201416:	0800                	addi	s0,sp,16
	yield();
    80201418:	00000097          	auipc	ra,0x0
    8020141c:	8b0080e7          	jalr	-1872(ra) # 80200cc8 <yield>
	return 0;
}
    80201420:	4501                	li	a0,0
    80201422:	60a2                	ld	ra,8(sp)
    80201424:	6402                	ld	s0,0(sp)
    80201426:	0141                	addi	sp,sp,16
    80201428:	8082                	ret

000000008020142a <sys_gettimeofday>:

uint64 sys_gettimeofday(uint64 val, int _tz)
{
    8020142a:	7179                	addi	sp,sp,-48
    8020142c:	f406                	sd	ra,40(sp)
    8020142e:	f022                	sd	s0,32(sp)
    80201430:	ec26                	sd	s1,24(sp)
    80201432:	e84a                	sd	s2,16(sp)
    80201434:	1800                	addi	s0,sp,48
    80201436:	892a                	mv	s2,a0
	struct proc *p = curr_proc();
    80201438:	fffff097          	auipc	ra,0xfffff
    8020143c:	52e080e7          	jalr	1326(ra) # 80200966 <curr_proc>
    80201440:	84aa                	mv	s1,a0
	uint64 cycle = get_cycle();
    80201442:	00000097          	auipc	ra,0x0
    80201446:	5dc080e7          	jalr	1500(ra) # 80201a1e <get_cycle>
	TimeVal t;
	t.sec = cycle / CPU_FREQ;
    8020144a:	00bec737          	lui	a4,0xbec
    8020144e:	c2070713          	addi	a4,a4,-992 # bebc20 <_entry-0x7f6143e0>
    80201452:	02e556b3          	divu	a3,a0,a4
    80201456:	fcd43823          	sd	a3,-48(s0)
	t.usec = (cycle % CPU_FREQ) * 1000000 / CPU_FREQ;
    8020145a:	02e577b3          	remu	a5,a0,a4
    8020145e:	000f4537          	lui	a0,0xf4
    80201462:	24050513          	addi	a0,a0,576 # f4240 <_entry-0x8010bdc0>
    80201466:	02a787b3          	mul	a5,a5,a0
    8020146a:	02e7d7b3          	divu	a5,a5,a4
    8020146e:	fcf43c23          	sd	a5,-40(s0)
	copyout(p->pagetable, val, (char *)&t, sizeof(TimeVal));
    80201472:	46c1                	li	a3,16
    80201474:	fd040613          	addi	a2,s0,-48
    80201478:	85ca                	mv	a1,s2
    8020147a:	6488                	ld	a0,8(s1)
    8020147c:	00001097          	auipc	ra,0x1
    80201480:	fea080e7          	jalr	-22(ra) # 80202466 <copyout>
	return 0;
}
    80201484:	4501                	li	a0,0
    80201486:	70a2                	ld	ra,40(sp)
    80201488:	7402                	ld	s0,32(sp)
    8020148a:	64e2                	ld	s1,24(sp)
    8020148c:	6942                	ld	s2,16(sp)
    8020148e:	6145                	addi	sp,sp,48
    80201490:	8082                	ret

0000000080201492 <sys_getpid>:

uint64 sys_getpid()
{
    80201492:	1141                	addi	sp,sp,-16
    80201494:	e406                	sd	ra,8(sp)
    80201496:	e022                	sd	s0,0(sp)
    80201498:	0800                	addi	s0,sp,16
	return curr_proc()->pid;
    8020149a:	fffff097          	auipc	ra,0xfffff
    8020149e:	4cc080e7          	jalr	1228(ra) # 80200966 <curr_proc>
}
    802014a2:	4148                	lw	a0,4(a0)
    802014a4:	60a2                	ld	ra,8(sp)
    802014a6:	6402                	ld	s0,0(sp)
    802014a8:	0141                	addi	sp,sp,16
    802014aa:	8082                	ret

00000000802014ac <sys_getppid>:

uint64 sys_getppid()
{
    802014ac:	1141                	addi	sp,sp,-16
    802014ae:	e406                	sd	ra,8(sp)
    802014b0:	e022                	sd	s0,0(sp)
    802014b2:	0800                	addi	s0,sp,16
	struct proc *p = curr_proc();
    802014b4:	fffff097          	auipc	ra,0xfffff
    802014b8:	4b2080e7          	jalr	1202(ra) # 80200966 <curr_proc>
	return p->parent == NULL ? IDLE_PID : p->parent->pid;
    802014bc:	715c                	ld	a5,160(a0)
    802014be:	4501                	li	a0,0
    802014c0:	c391                	beqz	a5,802014c4 <sys_getppid+0x18>
    802014c2:	43c8                	lw	a0,4(a5)
}
    802014c4:	60a2                	ld	ra,8(sp)
    802014c6:	6402                	ld	s0,0(sp)
    802014c8:	0141                	addi	sp,sp,16
    802014ca:	8082                	ret

00000000802014cc <sys_clone>:

uint64 sys_clone()
{
    802014cc:	1141                	addi	sp,sp,-16
    802014ce:	e406                	sd	ra,8(sp)
    802014d0:	e022                	sd	s0,0(sp)
    802014d2:	0800                	addi	s0,sp,16
	debugf("fork!\n");
    802014d4:	4501                	li	a0,0
    802014d6:	00000097          	auipc	ra,0x0
    802014da:	df0080e7          	jalr	-528(ra) # 802012c6 <dummy>
	return fork();
    802014de:	00000097          	auipc	ra,0x0
    802014e2:	88c080e7          	jalr	-1908(ra) # 80200d6a <fork>
}
    802014e6:	60a2                	ld	ra,8(sp)
    802014e8:	6402                	ld	s0,0(sp)
    802014ea:	0141                	addi	sp,sp,16
    802014ec:	8082                	ret

00000000802014ee <sys_exec>:

uint64 sys_exec(uint64 va)
{
    802014ee:	7151                	addi	sp,sp,-240
    802014f0:	f586                	sd	ra,232(sp)
    802014f2:	f1a2                	sd	s0,224(sp)
    802014f4:	eda6                	sd	s1,216(sp)
    802014f6:	1980                	addi	s0,sp,240
    802014f8:	84aa                	mv	s1,a0
	struct proc *p = curr_proc();
    802014fa:	fffff097          	auipc	ra,0xfffff
    802014fe:	46c080e7          	jalr	1132(ra) # 80200966 <curr_proc>
	char name[200];
	copyinstr(p->pagetable, name, va, 200);
    80201502:	0c800693          	li	a3,200
    80201506:	8626                	mv	a2,s1
    80201508:	f1840593          	addi	a1,s0,-232
    8020150c:	6508                	ld	a0,8(a0)
    8020150e:	00001097          	auipc	ra,0x1
    80201512:	072080e7          	jalr	114(ra) # 80202580 <copyinstr>
	debugf("sys_exec %s\n", name);
    80201516:	f1840593          	addi	a1,s0,-232
    8020151a:	4501                	li	a0,0
    8020151c:	00000097          	auipc	ra,0x0
    80201520:	daa080e7          	jalr	-598(ra) # 802012c6 <dummy>
	return exec(name);
    80201524:	f1840513          	addi	a0,s0,-232
    80201528:	00000097          	auipc	ra,0x0
    8020152c:	93a080e7          	jalr	-1734(ra) # 80200e62 <exec>
}
    80201530:	70ae                	ld	ra,232(sp)
    80201532:	740e                	ld	s0,224(sp)
    80201534:	64ee                	ld	s1,216(sp)
    80201536:	616d                	addi	sp,sp,240
    80201538:	8082                	ret

000000008020153a <sys_wait>:

uint64 sys_wait(int pid, uint64 va)
{
    8020153a:	1101                	addi	sp,sp,-32
    8020153c:	ec06                	sd	ra,24(sp)
    8020153e:	e822                	sd	s0,16(sp)
    80201540:	e426                	sd	s1,8(sp)
    80201542:	e04a                	sd	s2,0(sp)
    80201544:	1000                	addi	s0,sp,32
    80201546:	84aa                	mv	s1,a0
    80201548:	892e                	mv	s2,a1
	struct proc *p = curr_proc();
    8020154a:	fffff097          	auipc	ra,0xfffff
    8020154e:	41c080e7          	jalr	1052(ra) # 80200966 <curr_proc>
	int *code = (int *)useraddr(p->pagetable, va);
    80201552:	85ca                	mv	a1,s2
    80201554:	6508                	ld	a0,8(a0)
    80201556:	00001097          	auipc	ra,0x1
    8020155a:	99c080e7          	jalr	-1636(ra) # 80201ef2 <useraddr>
    8020155e:	85aa                	mv	a1,a0
	return wait(pid, code);
    80201560:	8526                	mv	a0,s1
    80201562:	00000097          	auipc	ra,0x0
    80201566:	958080e7          	jalr	-1704(ra) # 80200eba <wait>
}
    8020156a:	60e2                	ld	ra,24(sp)
    8020156c:	6442                	ld	s0,16(sp)
    8020156e:	64a2                	ld	s1,8(sp)
    80201570:	6902                	ld	s2,0(sp)
    80201572:	6105                	addi	sp,sp,32
    80201574:	8082                	ret

0000000080201576 <sys_spawn>:

uint64 sys_spawn(uint64 va)
{
    80201576:	7111                	addi	sp,sp,-256
    80201578:	fd86                	sd	ra,248(sp)
    8020157a:	f9a2                	sd	s0,240(sp)
    8020157c:	f5a6                	sd	s1,232(sp)
    8020157e:	f1ca                	sd	s2,224(sp)
    80201580:	edce                	sd	s3,216(sp)
    80201582:	0200                	addi	s0,sp,256
    80201584:	892a                	mv	s2,a0
	struct proc *parent = curr_proc();
    80201586:	fffff097          	auipc	ra,0xfffff
    8020158a:	3e0080e7          	jalr	992(ra) # 80200966 <curr_proc>
    8020158e:	84aa                	mv	s1,a0
	struct proc *child;
	char name[200];

	if (copyinstr(parent->pagetable, name, va, sizeof(name)) < 0)
    80201590:	0c800693          	li	a3,200
    80201594:	864a                	mv	a2,s2
    80201596:	f0840593          	addi	a1,s0,-248
    8020159a:	6508                	ld	a0,8(a0)
    8020159c:	00001097          	auipc	ra,0x1
    802015a0:	fe4080e7          	jalr	-28(ra) # 80202580 <copyinstr>
    802015a4:	04054763          	bltz	a0,802015f2 <sys_spawn+0x7c>
		return -1;

	int id = get_id_by_name(name);
    802015a8:	f0840513          	addi	a0,s0,-248
    802015ac:	fffff097          	auipc	ra,0xfffff
    802015b0:	c96080e7          	jalr	-874(ra) # 80200242 <get_id_by_name>
    802015b4:	89aa                	mv	s3,a0
	if (id < 0)
		return -1;
    802015b6:	557d                	li	a0,-1
	if (id < 0)
    802015b8:	0209c663          	bltz	s3,802015e4 <sys_spawn+0x6e>

	child = allocproc();
    802015bc:	fffff097          	auipc	ra,0xfffff
    802015c0:	526080e7          	jalr	1318(ra) # 80200ae2 <allocproc>
    802015c4:	892a                	mv	s2,a0
	if (child == 0)
    802015c6:	c905                	beqz	a0,802015f6 <sys_spawn+0x80>
		return -1;
	child->parent = parent;
    802015c8:	f144                	sd	s1,160(a0)
	loader(id, child);
    802015ca:	85aa                	mv	a1,a0
    802015cc:	854e                	mv	a0,s3
    802015ce:	fffff097          	auipc	ra,0xfffff
    802015d2:	f68080e7          	jalr	-152(ra) # 80200536 <loader>
	add_task(child);
    802015d6:	854a                	mv	a0,s2
    802015d8:	fffff097          	auipc	ra,0xfffff
    802015dc:	4b2080e7          	jalr	1202(ra) # 80200a8a <add_task>
	return child->pid;
    802015e0:	00492503          	lw	a0,4(s2)
}
    802015e4:	70ee                	ld	ra,248(sp)
    802015e6:	744e                	ld	s0,240(sp)
    802015e8:	74ae                	ld	s1,232(sp)
    802015ea:	790e                	ld	s2,224(sp)
    802015ec:	69ee                	ld	s3,216(sp)
    802015ee:	6111                	addi	sp,sp,256
    802015f0:	8082                	ret
		return -1;
    802015f2:	557d                	li	a0,-1
    802015f4:	bfc5                	j	802015e4 <sys_spawn+0x6e>
		return -1;
    802015f6:	557d                	li	a0,-1
    802015f8:	b7f5                	j	802015e4 <sys_spawn+0x6e>

00000000802015fa <sys_set_priority>:

uint64 sys_set_priority(long long prio)
{
	if (prio <= 1)
    802015fa:	4785                	li	a5,1
    802015fc:	02a7d963          	bge	a5,a0,8020162e <sys_set_priority+0x34>
{
    80201600:	1101                	addi	sp,sp,-32
    80201602:	ec06                	sd	ra,24(sp)
    80201604:	e822                	sd	s0,16(sp)
    80201606:	e426                	sd	s1,8(sp)
    80201608:	1000                	addi	s0,sp,32
    8020160a:	84aa                	mv	s1,a0
		return -1;
	struct proc *p = curr_proc();
    8020160c:	fffff097          	auipc	ra,0xfffff
    80201610:	35a080e7          	jalr	858(ra) # 80200966 <curr_proc>

	p->priority = prio;
    80201614:	12953c23          	sd	s1,312(a0)
	p->pass = BIG_STRIDE / p->priority;
    80201618:	67c1                	lui	a5,0x10
    8020161a:	0297c7b3          	div	a5,a5,s1
    8020161e:	12f52a23          	sw	a5,308(a0)

	return p->priority;
    80201622:	8526                	mv	a0,s1
}
    80201624:	60e2                	ld	ra,24(sp)
    80201626:	6442                	ld	s0,16(sp)
    80201628:	64a2                	ld	s1,8(sp)
    8020162a:	6105                	addi	sp,sp,32
    8020162c:	8082                	ret
		return -1;
    8020162e:	557d                	li	a0,-1
}
    80201630:	8082                	ret

0000000080201632 <sys_mmap>:

extern char trap_page[];

// sys_mmap: map anonymous pages at user VA with permissions from prot
uint64 sys_mmap(uint64 va, uint64 len, int prot, int flags, int fd)
{
    80201632:	711d                	addi	sp,sp,-96
    80201634:	ec86                	sd	ra,88(sp)
    80201636:	e8a2                	sd	s0,80(sp)
    80201638:	e4a6                	sd	s1,72(sp)
    8020163a:	e0ca                	sd	s2,64(sp)
    8020163c:	fc4e                	sd	s3,56(sp)
    8020163e:	f852                	sd	s4,48(sp)
    80201640:	f456                	sd	s5,40(sp)
    80201642:	f05a                	sd	s6,32(sp)
    80201644:	ec5e                	sd	s7,24(sp)
    80201646:	e862                	sd	s8,16(sp)
    80201648:	e466                	sd	s9,8(sp)
    8020164a:	1080                	addi	s0,sp,96
    8020164c:	8a2a                	mv	s4,a0
    8020164e:	892e                	mv	s2,a1
    80201650:	8ab2                	mv	s5,a2
	(void)flags;
	(void)fd;

	struct proc *p = curr_proc();
    80201652:	fffff097          	auipc	ra,0xfffff
    80201656:	314080e7          	jalr	788(ra) # 80200966 <curr_proc>
	pagetable_t pt = p->pagetable;
	uint64 size_mapping;
	uint64 address;

	if (len > (uint64)-1 - (PGSIZE - 1))
    8020165a:	77fd                	lui	a5,0xfffff
		return -1;
    8020165c:	5b7d                	li	s6,-1
	if (len > (uint64)-1 - (PGSIZE - 1))
    8020165e:	0f27ec63          	bltu	a5,s2,80201756 <sys_mmap+0x124>
    80201662:	89aa                	mv	s3,a0
	size_mapping = PGROUNDUP(len);
    80201664:	6485                	lui	s1,0x1
    80201666:	14fd                	addi	s1,s1,-1
    80201668:	94ca                	add	s1,s1,s2
    8020166a:	8cfd                	and	s1,s1,a5
	if (va + size_mapping < va)
    8020166c:	94d2                	add	s1,s1,s4
		return -1;
    8020166e:	5b7d                	li	s6,-1
	if (va + size_mapping < va)
    80201670:	0f44e363          	bltu	s1,s4,80201756 <sys_mmap+0x124>

	if ((va % PGSIZE) != 0)
    80201674:	034a1793          	slli	a5,s4,0x34
    80201678:	0347db13          	srli	s6,a5,0x34
    8020167c:	efe1                	bnez	a5,80201754 <sys_mmap+0x122>
		return -1;
	if ((prot & ~0x7) != 0)
    8020167e:	ff8af793          	andi	a5,s5,-8
    80201682:	ebe5                	bnez	a5,80201772 <sys_mmap+0x140>
		return -1;
	if ((prot & 0x7) == 0)
    80201684:	007af793          	andi	a5,s5,7
    80201688:	c7fd                	beqz	a5,80201776 <sys_mmap+0x144>
		return -1;

	if (len == 0)
    8020168a:	0e090863          	beqz	s2,8020177a <sys_mmap+0x148>
	pagetable_t pt = p->pagetable;
    8020168e:	00853b83          	ld	s7,8(a0)
		return 0;

	for (address = va; address < va + size_mapping; address += PGSIZE) { // check if the address is already mapped
    80201692:	009a7e63          	bgeu	s4,s1,802016ae <sys_mmap+0x7c>
    80201696:	8952                	mv	s2,s4
    80201698:	6c05                	lui	s8,0x1
		if (walkaddr(pt, address) != 0) // return -1 if the address is already mapped
    8020169a:	85ca                	mv	a1,s2
    8020169c:	855e                	mv	a0,s7
    8020169e:	00001097          	auipc	ra,0x1
    802016a2:	812080e7          	jalr	-2030(ra) # 80201eb0 <walkaddr>
    802016a6:	ed61                	bnez	a0,8020177e <sys_mmap+0x14c>
	for (address = va; address < va + size_mapping; address += PGSIZE) { // check if the address is already mapped
    802016a8:	9962                	add	s2,s2,s8
    802016aa:	fe9968e3          	bltu	s2,s1,8020169a <sys_mmap+0x68>
			return -1;
	}

	int perm = PTE_U; // start with user permission
	if (prot & PROT_READ) // add read permission if PROT_READ is set
    802016ae:	001af793          	andi	a5,s5,1
	int perm = PTE_U; // start with user permission
    802016b2:	4c41                	li	s8,16
	if (prot & PROT_READ) // add read permission if PROT_READ is set
    802016b4:	c391                	beqz	a5,802016b8 <sys_mmap+0x86>
		perm |= PTE_R;
    802016b6:	4c49                	li	s8,18
	if (prot & PROT_WRITE) // add write permission if PROT_WRITE is set
    802016b8:	002af793          	andi	a5,s5,2
    802016bc:	c399                	beqz	a5,802016c2 <sys_mmap+0x90>
		perm |= PTE_W;
    802016be:	004c6c13          	ori	s8,s8,4
	if (prot & PROT_EXEC) // add execute permission if PROT_EXEC is set
    802016c2:	004afa93          	andi	s5,s5,4
    802016c6:	000a8463          	beqz	s5,802016ce <sys_mmap+0x9c>
		perm |= PTE_X;
    802016ca:	008c6c13          	ori	s8,s8,8

	uint64 npages_done = 0;
	for (address = va; address < va + size_mapping; address += PGSIZE) { // map the pages
    802016ce:	029a7f63          	bgeu	s4,s1,8020170c <sys_mmap+0xda>
	uint64 npages_done = 0;
    802016d2:	8cda                	mv	s9,s6
	for (address = va; address < va + size_mapping; address += PGSIZE) { // map the pages
    802016d4:	8ad2                	mv	s5,s4
		void *pa = kalloc(); // allocate a page
    802016d6:	fffff097          	auipc	ra,0xfffff
    802016da:	a64080e7          	jalr	-1436(ra) # 8020013a <kalloc>
    802016de:	892a                	mv	s2,a0
		if (pa == 0) { // return -1 if the page is not allocated
    802016e0:	c129                	beqz	a0,80201722 <sys_mmap+0xf0>
			uvmunmap(pt, va, npages_done, 1);
			return -1;
		}
		memset(pa, 0, PGSIZE);
    802016e2:	6605                	lui	a2,0x1
    802016e4:	4581                	li	a1,0
    802016e6:	00000097          	auipc	ra,0x0
    802016ea:	a32080e7          	jalr	-1486(ra) # 80201118 <memset>
		if (mappages(pt, address, PGSIZE, (uint64)pa, perm) != 0) {
    802016ee:	8762                	mv	a4,s8
    802016f0:	86ca                	mv	a3,s2
    802016f2:	6605                	lui	a2,0x1
    802016f4:	85d6                	mv	a1,s5
    802016f6:	855e                	mv	a0,s7
    802016f8:	00001097          	auipc	ra,0x1
    802016fc:	822080e7          	jalr	-2014(ra) # 80201f1a <mappages>
    80201700:	e91d                	bnez	a0,80201736 <sys_mmap+0x104>
			kfree(pa);
			uvmunmap(pt, va, npages_done, 1);
			return -1;
		}
		npages_done++;
    80201702:	0c85                	addi	s9,s9,1
	for (address = va; address < va + size_mapping; address += PGSIZE) { // map the pages
    80201704:	6785                	lui	a5,0x1
    80201706:	9abe                	add	s5,s5,a5
    80201708:	fc9ae7e3          	bltu	s5,s1,802016d6 <sys_mmap+0xa4>
	}

	// max page index for uvmfree / fork
	{
		uint64 new_max = PGROUNDUP(va + size_mapping) / PGSIZE;
    8020170c:	6785                	lui	a5,0x1
    8020170e:	17fd                	addi	a5,a5,-1
    80201710:	94be                	add	s1,s1,a5
    80201712:	80b1                	srli	s1,s1,0xc
		if (new_max > p->max_page)
    80201714:	0989b783          	ld	a5,152(s3)
    80201718:	0297ff63          	bgeu	a5,s1,80201756 <sys_mmap+0x124>
			p->max_page = new_max;
    8020171c:	0899bc23          	sd	s1,152(s3)
    80201720:	a81d                	j	80201756 <sys_mmap+0x124>
			uvmunmap(pt, va, npages_done, 1);
    80201722:	4685                	li	a3,1
    80201724:	8666                	mv	a2,s9
    80201726:	85d2                	mv	a1,s4
    80201728:	855e                	mv	a0,s7
    8020172a:	00001097          	auipc	ra,0x1
    8020172e:	9de080e7          	jalr	-1570(ra) # 80202108 <uvmunmap>
			return -1;
    80201732:	5b7d                	li	s6,-1
    80201734:	a00d                	j	80201756 <sys_mmap+0x124>
			kfree(pa);
    80201736:	854a                	mv	a0,s2
    80201738:	fffff097          	auipc	ra,0xfffff
    8020173c:	910080e7          	jalr	-1776(ra) # 80200048 <kfree>
			uvmunmap(pt, va, npages_done, 1);
    80201740:	4685                	li	a3,1
    80201742:	8666                	mv	a2,s9
    80201744:	85d2                	mv	a1,s4
    80201746:	855e                	mv	a0,s7
    80201748:	00001097          	auipc	ra,0x1
    8020174c:	9c0080e7          	jalr	-1600(ra) # 80202108 <uvmunmap>
			return -1;
    80201750:	5b7d                	li	s6,-1
    80201752:	a011                	j	80201756 <sys_mmap+0x124>
		return -1;
    80201754:	5b7d                	li	s6,-1
	}
	return 0;
}
    80201756:	855a                	mv	a0,s6
    80201758:	60e6                	ld	ra,88(sp)
    8020175a:	6446                	ld	s0,80(sp)
    8020175c:	64a6                	ld	s1,72(sp)
    8020175e:	6906                	ld	s2,64(sp)
    80201760:	79e2                	ld	s3,56(sp)
    80201762:	7a42                	ld	s4,48(sp)
    80201764:	7aa2                	ld	s5,40(sp)
    80201766:	7b02                	ld	s6,32(sp)
    80201768:	6be2                	ld	s7,24(sp)
    8020176a:	6c42                	ld	s8,16(sp)
    8020176c:	6ca2                	ld	s9,8(sp)
    8020176e:	6125                	addi	sp,sp,96
    80201770:	8082                	ret
		return -1;
    80201772:	5b7d                	li	s6,-1
    80201774:	b7cd                	j	80201756 <sys_mmap+0x124>
		return -1;
    80201776:	5b7d                	li	s6,-1
    80201778:	bff9                	j	80201756 <sys_mmap+0x124>
		return 0;
    8020177a:	8b4a                	mv	s6,s2
    8020177c:	bfe9                	j	80201756 <sys_mmap+0x124>
			return -1;
    8020177e:	5b7d                	li	s6,-1
    80201780:	bfd9                	j	80201756 <sys_mmap+0x124>

0000000080201782 <sys_munmap>:

// sys_munmap: unmap a user range; every page in the range must be mapped
uint64 sys_munmap(uint64 start_va, uint64 len)
{
    80201782:	7139                	addi	sp,sp,-64
    80201784:	fc06                	sd	ra,56(sp)
    80201786:	f822                	sd	s0,48(sp)
    80201788:	f426                	sd	s1,40(sp)
    8020178a:	f04a                	sd	s2,32(sp)
    8020178c:	ec4e                	sd	s3,24(sp)
    8020178e:	e852                	sd	s4,16(sp)
    80201790:	e456                	sd	s5,8(sp)
    80201792:	e05a                	sd	s6,0(sp)
    80201794:	0080                	addi	s0,sp,64
    80201796:	8a2a                	mv	s4,a0
    80201798:	892e                	mv	s2,a1
	struct proc *p = curr_proc();
    8020179a:	fffff097          	auipc	ra,0xfffff
    8020179e:	1cc080e7          	jalr	460(ra) # 80200966 <curr_proc>
	pagetable_t pt = p->pagetable;
	uint64 va0 = start_va;
	uint64 end = PGROUNDUP(va0 + len);
    802017a2:	6985                	lui	s3,0x1
    802017a4:	19fd                	addi	s3,s3,-1
    802017a6:	994e                	add	s2,s2,s3
    802017a8:	9952                	add	s2,s2,s4
    802017aa:	767d                	lui	a2,0xfffff
    802017ac:	00c97933          	and	s2,s2,a2

	if ((va0 % PGSIZE) != 0)
    802017b0:	013a79b3          	and	s3,s4,s3
    802017b4:	04099963          	bnez	s3,80201806 <sys_munmap+0x84>
		return -1;

	end = PGROUNDUP(va0 + len);
	if (end < va0)
    802017b8:	05496963          	bltu	s2,s4,8020180a <sys_munmap+0x88>
	pagetable_t pt = p->pagetable;
    802017bc:	00853a83          	ld	s5,8(a0)
		return -1;

	for (uint64 ua = va0; ua < end; ua += PGSIZE) {
    802017c0:	012a7e63          	bgeu	s4,s2,802017dc <sys_munmap+0x5a>
    802017c4:	84d2                	mv	s1,s4
    802017c6:	6b05                	lui	s6,0x1
		if (walkaddr(pt, ua) == 0)
    802017c8:	85a6                	mv	a1,s1
    802017ca:	8556                	mv	a0,s5
    802017cc:	00000097          	auipc	ra,0x0
    802017d0:	6e4080e7          	jalr	1764(ra) # 80201eb0 <walkaddr>
    802017d4:	cd0d                	beqz	a0,8020180e <sys_munmap+0x8c>
	for (uint64 ua = va0; ua < end; ua += PGSIZE) {
    802017d6:	94da                	add	s1,s1,s6
    802017d8:	ff24e8e3          	bltu	s1,s2,802017c8 <sys_munmap+0x46>
			return -1;
	}

	uint64 npages = (end - va0) / PGSIZE;
    802017dc:	41490633          	sub	a2,s2,s4
	uvmunmap(pt, va0, npages, 1);
    802017e0:	4685                	li	a3,1
    802017e2:	8231                	srli	a2,a2,0xc
    802017e4:	85d2                	mv	a1,s4
    802017e6:	8556                	mv	a0,s5
    802017e8:	00001097          	auipc	ra,0x1
    802017ec:	920080e7          	jalr	-1760(ra) # 80202108 <uvmunmap>
	
	return 0;
}
    802017f0:	854e                	mv	a0,s3
    802017f2:	70e2                	ld	ra,56(sp)
    802017f4:	7442                	ld	s0,48(sp)
    802017f6:	74a2                	ld	s1,40(sp)
    802017f8:	7902                	ld	s2,32(sp)
    802017fa:	69e2                	ld	s3,24(sp)
    802017fc:	6a42                	ld	s4,16(sp)
    802017fe:	6aa2                	ld	s5,8(sp)
    80201800:	6b02                	ld	s6,0(sp)
    80201802:	6121                	addi	sp,sp,64
    80201804:	8082                	ret
		return -1;
    80201806:	59fd                	li	s3,-1
    80201808:	b7e5                	j	802017f0 <sys_munmap+0x6e>
		return -1;
    8020180a:	59fd                	li	s3,-1
    8020180c:	b7d5                	j	802017f0 <sys_munmap+0x6e>
			return -1;
    8020180e:	59fd                	li	s3,-1
    80201810:	b7c5                	j	802017f0 <sys_munmap+0x6e>

0000000080201812 <syscall>:


void syscall()
{
    80201812:	715d                	addi	sp,sp,-80
    80201814:	e486                	sd	ra,72(sp)
    80201816:	e0a2                	sd	s0,64(sp)
    80201818:	fc26                	sd	s1,56(sp)
    8020181a:	f84a                	sd	s2,48(sp)
    8020181c:	f44e                	sd	s3,40(sp)
    8020181e:	f052                	sd	s4,32(sp)
    80201820:	ec56                	sd	s5,24(sp)
    80201822:	e85a                	sd	s6,16(sp)
    80201824:	e45e                	sd	s7,8(sp)
    80201826:	0880                	addi	s0,sp,80
	struct trapframe *trapframe = curr_proc()->trapframe;
    80201828:	fffff097          	auipc	ra,0xfffff
    8020182c:	13e080e7          	jalr	318(ra) # 80200966 <curr_proc>
    80201830:	02053903          	ld	s2,32(a0)
	int id = trapframe->a7, ret;
    80201834:	0a892483          	lw	s1,168(s2)
	uint64 args[6] = { trapframe->a0, trapframe->a1, trapframe->a2,
    80201838:	07093983          	ld	s3,112(s2)
    8020183c:	07893a03          	ld	s4,120(s2)
    80201840:	08093a83          	ld	s5,128(s2)
			   trapframe->a3, trapframe->a4, trapframe->a5 };
    80201844:	08893b03          	ld	s6,136(s2)
    80201848:	09093b83          	ld	s7,144(s2)
	tracef("syscall %d args = [%x, %x, %x, %x, %x, %x]", id, args[0],
    8020184c:	09893883          	ld	a7,152(s2)
    80201850:	885e                	mv	a6,s7
    80201852:	87da                	mv	a5,s6
    80201854:	8756                	mv	a4,s5
    80201856:	86d2                	mv	a3,s4
    80201858:	864e                	mv	a2,s3
    8020185a:	85a6                	mv	a1,s1
    8020185c:	4501                	li	a0,0
    8020185e:	00000097          	auipc	ra,0x0
    80201862:	a68080e7          	jalr	-1432(ra) # 802012c6 <dummy>
	       args[1], args[2], args[3], args[4], args[5]);
	switch (id) {
    80201866:	0de00793          	li	a5,222
    8020186a:	0a97c563          	blt	a5,s1,80201914 <syscall+0x102>
    8020186e:	0a800793          	li	a5,168
    80201872:	0297d663          	bge	a5,s1,8020189e <syscall+0x8c>
    80201876:	f574879b          	addiw	a5,s1,-169
    8020187a:	0007869b          	sext.w	a3,a5
    8020187e:	03500713          	li	a4,53
    80201882:	16d76963          	bltu	a4,a3,802019f4 <syscall+0x1e2>
    80201886:	02079713          	slli	a4,a5,0x20
    8020188a:	01e75793          	srli	a5,a4,0x1e
    8020188e:	00003717          	auipc	a4,0x3
    80201892:	9be70713          	addi	a4,a4,-1602 # 8020424c <digits+0x11c>
    80201896:	97ba                	add	a5,a5,a4
    80201898:	439c                	lw	a5,0(a5)
    8020189a:	97ba                	add	a5,a5,a4
    8020189c:	8782                	jr	a5
    8020189e:	05d00793          	li	a5,93
    802018a2:	0af48463          	beq	s1,a5,8020194a <syscall+0x138>
    802018a6:	0297d263          	bge	a5,s1,802018ca <syscall+0xb8>
    802018aa:	07c00793          	li	a5,124
    802018ae:	0af48463          	beq	s1,a5,80201956 <syscall+0x144>
    802018b2:	08c00793          	li	a5,140
    802018b6:	12f49f63          	bne	s1,a5,802019f4 <syscall+0x1e2>
		break;
	case SYS_munmap:
		ret = sys_munmap(args[0], args[1]);
		break;
	case SYS_setpriority:
		ret = sys_set_priority(args[0]);
    802018ba:	854e                	mv	a0,s3
    802018bc:	00000097          	auipc	ra,0x0
    802018c0:	d3e080e7          	jalr	-706(ra) # 802015fa <sys_set_priority>
    802018c4:	0005059b          	sext.w	a1,a0
		break;
    802018c8:	a025                	j	802018f0 <syscall+0xde>
	switch (id) {
    802018ca:	03f00793          	li	a5,63
    802018ce:	06f48363          	beq	s1,a5,80201934 <syscall+0x122>
    802018d2:	04000793          	li	a5,64
    802018d6:	10f49f63          	bne	s1,a5,802019f4 <syscall+0x1e2>
		ret = sys_write(args[0], args[1], args[2]);
    802018da:	000a861b          	sext.w	a2,s5
    802018de:	85d2                	mv	a1,s4
    802018e0:	0009851b          	sext.w	a0,s3
    802018e4:	00000097          	auipc	ra,0x0
    802018e8:	a00080e7          	jalr	-1536(ra) # 802012e4 <sys_write>
    802018ec:	0005059b          	sext.w	a1,a0
	default:
		ret = -1;
		errorf("unknown syscall %d", id);
	}
	trapframe->a0 = ret;
    802018f0:	06b93823          	sd	a1,112(s2)
	tracef("syscall ret %d", ret);
    802018f4:	4501                	li	a0,0
    802018f6:	00000097          	auipc	ra,0x0
    802018fa:	9d0080e7          	jalr	-1584(ra) # 802012c6 <dummy>
}
    802018fe:	60a6                	ld	ra,72(sp)
    80201900:	6406                	ld	s0,64(sp)
    80201902:	74e2                	ld	s1,56(sp)
    80201904:	7942                	ld	s2,48(sp)
    80201906:	79a2                	ld	s3,40(sp)
    80201908:	7a02                	ld	s4,32(sp)
    8020190a:	6ae2                	ld	s5,24(sp)
    8020190c:	6b42                	ld	s6,16(sp)
    8020190e:	6ba2                	ld	s7,8(sp)
    80201910:	6161                	addi	sp,sp,80
    80201912:	8082                	ret
	switch (id) {
    80201914:	10400793          	li	a5,260
    80201918:	08f48c63          	beq	s1,a5,802019b0 <syscall+0x19e>
    8020191c:	19000793          	li	a5,400
    80201920:	0cf49a63          	bne	s1,a5,802019f4 <syscall+0x1e2>
		ret = sys_spawn(args[0]);
    80201924:	854e                	mv	a0,s3
    80201926:	00000097          	auipc	ra,0x0
    8020192a:	c50080e7          	jalr	-944(ra) # 80201576 <sys_spawn>
    8020192e:	0005059b          	sext.w	a1,a0
		break;
    80201932:	bf7d                	j	802018f0 <syscall+0xde>
		ret = sys_read(args[0], args[1], args[2]);
    80201934:	8656                	mv	a2,s5
    80201936:	85d2                	mv	a1,s4
    80201938:	0009851b          	sext.w	a0,s3
    8020193c:	00000097          	auipc	ra,0x0
    80201940:	a48080e7          	jalr	-1464(ra) # 80201384 <sys_read>
    80201944:	0005059b          	sext.w	a1,a0
		break;
    80201948:	b765                	j	802018f0 <syscall+0xde>
	exit(code);
    8020194a:	0009851b          	sext.w	a0,s3
    8020194e:	fffff097          	auipc	ra,0xfffff
    80201952:	608080e7          	jalr	1544(ra) # 80200f56 <exit>
	yield();
    80201956:	fffff097          	auipc	ra,0xfffff
    8020195a:	372080e7          	jalr	882(ra) # 80200cc8 <yield>
		ret = sys_sched_yield();
    8020195e:	4581                	li	a1,0
		break;
    80201960:	bf41                	j	802018f0 <syscall+0xde>
		ret = sys_gettimeofday(args[0], args[1]);
    80201962:	000a059b          	sext.w	a1,s4
    80201966:	854e                	mv	a0,s3
    80201968:	00000097          	auipc	ra,0x0
    8020196c:	ac2080e7          	jalr	-1342(ra) # 8020142a <sys_gettimeofday>
    80201970:	0005059b          	sext.w	a1,a0
		break;
    80201974:	bfb5                	j	802018f0 <syscall+0xde>
		ret = sys_getpid();
    80201976:	00000097          	auipc	ra,0x0
    8020197a:	b1c080e7          	jalr	-1252(ra) # 80201492 <sys_getpid>
    8020197e:	0005059b          	sext.w	a1,a0
		break;
    80201982:	b7bd                	j	802018f0 <syscall+0xde>
		ret = sys_getppid();
    80201984:	00000097          	auipc	ra,0x0
    80201988:	b28080e7          	jalr	-1240(ra) # 802014ac <sys_getppid>
    8020198c:	0005059b          	sext.w	a1,a0
		break;
    80201990:	b785                	j	802018f0 <syscall+0xde>
		ret = sys_clone();
    80201992:	00000097          	auipc	ra,0x0
    80201996:	b3a080e7          	jalr	-1222(ra) # 802014cc <sys_clone>
    8020199a:	0005059b          	sext.w	a1,a0
		break;
    8020199e:	bf89                	j	802018f0 <syscall+0xde>
		ret = sys_exec(args[0]);
    802019a0:	854e                	mv	a0,s3
    802019a2:	00000097          	auipc	ra,0x0
    802019a6:	b4c080e7          	jalr	-1204(ra) # 802014ee <sys_exec>
    802019aa:	0005059b          	sext.w	a1,a0
		break;
    802019ae:	b789                	j	802018f0 <syscall+0xde>
		ret = sys_wait(args[0], args[1]);
    802019b0:	85d2                	mv	a1,s4
    802019b2:	0009851b          	sext.w	a0,s3
    802019b6:	00000097          	auipc	ra,0x0
    802019ba:	b84080e7          	jalr	-1148(ra) # 8020153a <sys_wait>
    802019be:	0005059b          	sext.w	a1,a0
		break;
    802019c2:	b73d                	j	802018f0 <syscall+0xde>
		ret = sys_mmap(args[0], args[1], args[2], args[3], args[4]);
    802019c4:	000b871b          	sext.w	a4,s7
    802019c8:	000b069b          	sext.w	a3,s6
    802019cc:	000a861b          	sext.w	a2,s5
    802019d0:	85d2                	mv	a1,s4
    802019d2:	854e                	mv	a0,s3
    802019d4:	00000097          	auipc	ra,0x0
    802019d8:	c5e080e7          	jalr	-930(ra) # 80201632 <sys_mmap>
    802019dc:	0005059b          	sext.w	a1,a0
		break;
    802019e0:	bf01                	j	802018f0 <syscall+0xde>
		ret = sys_munmap(args[0], args[1]);
    802019e2:	85d2                	mv	a1,s4
    802019e4:	854e                	mv	a0,s3
    802019e6:	00000097          	auipc	ra,0x0
    802019ea:	d9c080e7          	jalr	-612(ra) # 80201782 <sys_munmap>
    802019ee:	0005059b          	sext.w	a1,a0
		break;
    802019f2:	bdfd                	j	802018f0 <syscall+0xde>
		errorf("unknown syscall %d", id);
    802019f4:	fffff097          	auipc	ra,0xfffff
    802019f8:	f5c080e7          	jalr	-164(ra) # 80200950 <threadid>
    802019fc:	86aa                	mv	a3,a0
    802019fe:	8726                	mv	a4,s1
    80201a00:	00003617          	auipc	a2,0x3
    80201a04:	82060613          	addi	a2,a2,-2016 # 80204220 <digits+0xf0>
    80201a08:	45fd                	li	a1,31
    80201a0a:	00003517          	auipc	a0,0x3
    80201a0e:	81e50513          	addi	a0,a0,-2018 # 80204228 <digits+0xf8>
    80201a12:	fffff097          	auipc	ra,0xfffff
    80201a16:	d68080e7          	jalr	-664(ra) # 8020077a <printf>
		ret = -1;
    80201a1a:	55fd                	li	a1,-1
    80201a1c:	bdd1                	j	802018f0 <syscall+0xde>

0000000080201a1e <get_cycle>:
#include "riscv.h"
#include "sbi.h"

/// read the `mtime` regiser
uint64 get_cycle()
{
    80201a1e:	1141                	addi	sp,sp,-16
    80201a20:	e422                	sd	s0,8(sp)
    80201a22:	0800                	addi	s0,sp,16

// machine-mode cycle counter
static inline uint64 r_time()
{
	uint64 x;
	asm volatile("csrr %0, time" : "=r"(x));
    80201a24:	c0102573          	rdtime	a0
	return r_time();
}
    80201a28:	6422                	ld	s0,8(sp)
    80201a2a:	0141                	addi	sp,sp,16
    80201a2c:	8082                	ret

0000000080201a2e <set_next_timer>:
	set_next_timer();
}

/// Set the next timer interrupt
void set_next_timer()
{
    80201a2e:	1141                	addi	sp,sp,-16
    80201a30:	e406                	sd	ra,8(sp)
    80201a32:	e022                	sd	s0,0(sp)
    80201a34:	0800                	addi	s0,sp,16
    80201a36:	c0102573          	rdtime	a0
	const uint64 timebase = CPU_FREQ / TICKS_PER_SEC;
	set_timer(get_cycle() + timebase);
    80201a3a:	67fd                	lui	a5,0x1f
    80201a3c:	84878793          	addi	a5,a5,-1976 # 1e848 <_entry-0x801e17b8>
    80201a40:	953e                	add	a0,a0,a5
    80201a42:	fffff097          	auipc	ra,0xfffff
    80201a46:	6c0080e7          	jalr	1728(ra) # 80201102 <set_timer>
    80201a4a:	60a2                	ld	ra,8(sp)
    80201a4c:	6402                	ld	s0,0(sp)
    80201a4e:	0141                	addi	sp,sp,16
    80201a50:	8082                	ret

0000000080201a52 <timer_init>:
{
    80201a52:	1141                	addi	sp,sp,-16
    80201a54:	e406                	sd	ra,8(sp)
    80201a56:	e022                	sd	s0,0(sp)
    80201a58:	0800                	addi	s0,sp,16
	asm volatile("csrr %0, sie" : "=r"(x));
    80201a5a:	104027f3          	csrr	a5,sie
	w_sie(r_sie() | SIE_STIE);
    80201a5e:	0207e793          	ori	a5,a5,32
	asm volatile("csrw sie, %0" : : "r"(x));
    80201a62:	10479073          	csrw	sie,a5
	set_next_timer();
    80201a66:	00000097          	auipc	ra,0x0
    80201a6a:	fc8080e7          	jalr	-56(ra) # 80201a2e <set_next_timer>
}
    80201a6e:	60a2                	ld	ra,8(sp)
    80201a70:	6402                	ld	s0,0(sp)
    80201a72:	0141                	addi	sp,sp,16
    80201a74:	8082                	ret

0000000080201a76 <kerneltrap>:

extern char trampoline[], uservec[];
extern char userret[];

void kerneltrap()
{
    80201a76:	1141                	addi	sp,sp,-16
    80201a78:	e406                	sd	ra,8(sp)
    80201a7a:	e022                	sd	s0,0(sp)
    80201a7c:	0800                	addi	s0,sp,16
	asm volatile("csrr %0, sstatus" : "=r"(x));
    80201a7e:	100027f3          	csrr	a5,sstatus
	if ((r_sstatus() & SSTATUS_SPP) == 0)
    80201a82:	1007f793          	andi	a5,a5,256
    80201a86:	c3a1                	beqz	a5,80201ac6 <kerneltrap+0x50>
		panic("kerneltrap: not from supervisor mode");
	panic("trap from kerne");
    80201a88:	fffff097          	auipc	ra,0xfffff
    80201a8c:	ec8080e7          	jalr	-312(ra) # 80200950 <threadid>
    80201a90:	86aa                	mv	a3,a0
    80201a92:	47b9                	li	a5,14
    80201a94:	00003717          	auipc	a4,0x3
    80201a98:	89470713          	addi	a4,a4,-1900 # 80204328 <digits+0x1f8>
    80201a9c:	00002617          	auipc	a2,0x2
    80201aa0:	57460613          	addi	a2,a2,1396 # 80204010 <e_text+0x10>
    80201aa4:	45fd                	li	a1,31
    80201aa6:	00003517          	auipc	a0,0x3
    80201aaa:	8d250513          	addi	a0,a0,-1838 # 80204378 <digits+0x248>
    80201aae:	fffff097          	auipc	ra,0xfffff
    80201ab2:	ccc080e7          	jalr	-820(ra) # 8020077a <printf>
    80201ab6:	fffff097          	auipc	ra,0xfffff
    80201aba:	634080e7          	jalr	1588(ra) # 802010ea <shutdown>
}
    80201abe:	60a2                	ld	ra,8(sp)
    80201ac0:	6402                	ld	s0,0(sp)
    80201ac2:	0141                	addi	sp,sp,16
    80201ac4:	8082                	ret
		panic("kerneltrap: not from supervisor mode");
    80201ac6:	fffff097          	auipc	ra,0xfffff
    80201aca:	e8a080e7          	jalr	-374(ra) # 80200950 <threadid>
    80201ace:	86aa                	mv	a3,a0
    80201ad0:	47b5                	li	a5,13
    80201ad2:	00003717          	auipc	a4,0x3
    80201ad6:	85670713          	addi	a4,a4,-1962 # 80204328 <digits+0x1f8>
    80201ada:	00002617          	auipc	a2,0x2
    80201ade:	53660613          	addi	a2,a2,1334 # 80204010 <e_text+0x10>
    80201ae2:	45fd                	li	a1,31
    80201ae4:	00003517          	auipc	a0,0x3
    80201ae8:	85450513          	addi	a0,a0,-1964 # 80204338 <digits+0x208>
    80201aec:	fffff097          	auipc	ra,0xfffff
    80201af0:	c8e080e7          	jalr	-882(ra) # 8020077a <printf>
    80201af4:	fffff097          	auipc	ra,0xfffff
    80201af8:	5f6080e7          	jalr	1526(ra) # 802010ea <shutdown>
    80201afc:	b771                	j	80201a88 <kerneltrap+0x12>

0000000080201afe <set_usertrap>:

// set up to take exceptions and traps while in the kernel.
void set_usertrap()
{
    80201afe:	1141                	addi	sp,sp,-16
    80201b00:	e422                	sd	s0,8(sp)
    80201b02:	0800                	addi	s0,sp,16
	w_stvec(((uint64)TRAMPOLINE + (uservec - trampoline)) & ~0x3); // DIRECT
    80201b04:	04000737          	lui	a4,0x4000
    80201b08:	00001797          	auipc	a5,0x1
    80201b0c:	4f878793          	addi	a5,a5,1272 # 80203000 <trampoline>
    80201b10:	00001697          	auipc	a3,0x1
    80201b14:	4f068693          	addi	a3,a3,1264 # 80203000 <trampoline>
    80201b18:	8f95                	sub	a5,a5,a3
    80201b1a:	177d                	addi	a4,a4,-1
    80201b1c:	0732                	slli	a4,a4,0xc
    80201b1e:	97ba                	add	a5,a5,a4
    80201b20:	9bf1                	andi	a5,a5,-4
	asm volatile("csrw stvec, %0" : : "r"(x));
    80201b22:	10579073          	csrw	stvec,a5
}
    80201b26:	6422                	ld	s0,8(sp)
    80201b28:	0141                	addi	sp,sp,16
    80201b2a:	8082                	ret

0000000080201b2c <set_kerneltrap>:

void set_kerneltrap()
{
    80201b2c:	1141                	addi	sp,sp,-16
    80201b2e:	e422                	sd	s0,8(sp)
    80201b30:	0800                	addi	s0,sp,16
	w_stvec((uint64)kerneltrap & ~0x3); // DIRECT
    80201b32:	00000797          	auipc	a5,0x0
    80201b36:	f4478793          	addi	a5,a5,-188 # 80201a76 <kerneltrap>
    80201b3a:	9bf1                	andi	a5,a5,-4
    80201b3c:	10579073          	csrw	stvec,a5
}
    80201b40:	6422                	ld	s0,8(sp)
    80201b42:	0141                	addi	sp,sp,16
    80201b44:	8082                	ret

0000000080201b46 <trap_init>:

// set up to take exceptions and traps while in the kernel.
void trap_init()
{
    80201b46:	1141                	addi	sp,sp,-16
    80201b48:	e422                	sd	s0,8(sp)
    80201b4a:	0800                	addi	s0,sp,16
	w_stvec((uint64)kerneltrap & ~0x3); // DIRECT
    80201b4c:	00000797          	auipc	a5,0x0
    80201b50:	f2a78793          	addi	a5,a5,-214 # 80201a76 <kerneltrap>
    80201b54:	9bf1                	andi	a5,a5,-4
    80201b56:	10579073          	csrw	stvec,a5
	// intr_on();
	set_kerneltrap();
}
    80201b5a:	6422                	ld	s0,8(sp)
    80201b5c:	0141                	addi	sp,sp,16
    80201b5e:	8082                	ret

0000000080201b60 <unknown_trap>:

void unknown_trap()
{
    80201b60:	1141                	addi	sp,sp,-16
    80201b62:	e406                	sd	ra,8(sp)
    80201b64:	e022                	sd	s0,0(sp)
    80201b66:	0800                	addi	s0,sp,16
	errorf("unknown trap: %p, stval = %p", r_scause(), r_stval());
    80201b68:	fffff097          	auipc	ra,0xfffff
    80201b6c:	de8080e7          	jalr	-536(ra) # 80200950 <threadid>
    80201b70:	86aa                	mv	a3,a0
	asm volatile("csrr %0, scause" : "=r"(x));
    80201b72:	14202773          	csrr	a4,scause
	asm volatile("csrr %0, stval" : "=r"(x));
    80201b76:	143027f3          	csrr	a5,stval
    80201b7a:	00002617          	auipc	a2,0x2
    80201b7e:	6a660613          	addi	a2,a2,1702 # 80204220 <digits+0xf0>
    80201b82:	45fd                	li	a1,31
    80201b84:	00003517          	auipc	a0,0x3
    80201b88:	82450513          	addi	a0,a0,-2012 # 802043a8 <digits+0x278>
    80201b8c:	fffff097          	auipc	ra,0xfffff
    80201b90:	bee080e7          	jalr	-1042(ra) # 8020077a <printf>
	exit(-1);
    80201b94:	557d                	li	a0,-1
    80201b96:	fffff097          	auipc	ra,0xfffff
    80201b9a:	3c0080e7          	jalr	960(ra) # 80200f56 <exit>
}
    80201b9e:	60a2                	ld	ra,8(sp)
    80201ba0:	6402                	ld	s0,0(sp)
    80201ba2:	0141                	addi	sp,sp,16
    80201ba4:	8082                	ret

0000000080201ba6 <usertrapret>:

//
// return to user space
//
void usertrapret()
{
    80201ba6:	7179                	addi	sp,sp,-48
    80201ba8:	f406                	sd	ra,40(sp)
    80201baa:	f022                	sd	s0,32(sp)
    80201bac:	ec26                	sd	s1,24(sp)
    80201bae:	e84a                	sd	s2,16(sp)
    80201bb0:	e44e                	sd	s3,8(sp)
    80201bb2:	e052                	sd	s4,0(sp)
    80201bb4:	1800                	addi	s0,sp,48
	w_stvec(((uint64)TRAMPOLINE + (uservec - trampoline)) & ~0x3); // DIRECT
    80201bb6:	00001a17          	auipc	s4,0x1
    80201bba:	44aa0a13          	addi	s4,s4,1098 # 80203000 <trampoline>
    80201bbe:	00001797          	auipc	a5,0x1
    80201bc2:	44278793          	addi	a5,a5,1090 # 80203000 <trampoline>
    80201bc6:	414787b3          	sub	a5,a5,s4
    80201bca:	040004b7          	lui	s1,0x4000
    80201bce:	14fd                	addi	s1,s1,-1
    80201bd0:	04b2                	slli	s1,s1,0xc
    80201bd2:	97a6                	add	a5,a5,s1
    80201bd4:	9bf1                	andi	a5,a5,-4
	asm volatile("csrw stvec, %0" : : "r"(x));
    80201bd6:	10579073          	csrw	stvec,a5
	set_usertrap();
	struct trapframe *trapframe = curr_proc()->trapframe;
    80201bda:	fffff097          	auipc	ra,0xfffff
    80201bde:	d8c080e7          	jalr	-628(ra) # 80200966 <curr_proc>
    80201be2:	02053903          	ld	s2,32(a0)
	asm volatile("csrr %0, satp" : "=r"(x));
    80201be6:	180027f3          	csrr	a5,satp
	trapframe->kernel_satp = r_satp(); // kernel page table
    80201bea:	00f93023          	sd	a5,0(s2)
	trapframe->kernel_sp =
		curr_proc()->kstack + KSTACK_SIZE; // process's kernel stack
    80201bee:	fffff097          	auipc	ra,0xfffff
    80201bf2:	d78080e7          	jalr	-648(ra) # 80200966 <curr_proc>
    80201bf6:	6d1c                	ld	a5,24(a0)
    80201bf8:	6705                	lui	a4,0x1
    80201bfa:	97ba                	add	a5,a5,a4
	trapframe->kernel_sp =
    80201bfc:	00f93423          	sd	a5,8(s2)
	trapframe->kernel_trap = (uint64)usertrap;
    80201c00:	00000797          	auipc	a5,0x0
    80201c04:	07a78793          	addi	a5,a5,122 # 80201c7a <usertrap>
    80201c08:	00f93823          	sd	a5,16(s2)
// read and write tp, the thread pointer, which holds
// this core's hartid (core number), the index into cpus[].
static inline uint64 r_tp()
{
	uint64 x;
	asm volatile("mv %0, tp" : "=r"(x));
    80201c0c:	8792                	mv	a5,tp
	trapframe->kernel_hartid = r_tp(); // unuesd
    80201c0e:	02f93023          	sd	a5,32(s2)
	asm volatile("csrw sepc, %0" : : "r"(x));
    80201c12:	01893783          	ld	a5,24(s2)
    80201c16:	14179073          	csrw	sepc,a5
	asm volatile("csrr %0, sstatus" : "=r"(x));
    80201c1a:	100027f3          	csrr	a5,sstatus
	// set up the registers that trampoline.S's sret will use
	// to get to user space.

	// set S Previous Privilege mode to User.
	uint64 x = r_sstatus();
	x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80201c1e:	eff7f793          	andi	a5,a5,-257
	x |= SSTATUS_SPIE; // enable interrupts in user mode
    80201c22:	0207e793          	ori	a5,a5,32
	asm volatile("csrw sstatus, %0" : : "r"(x));
    80201c26:	10079073          	csrw	sstatus,a5
	w_sstatus(x);

	// tell trampoline.S the user page table to switch to.
	uint64 satp = MAKE_SATP(curr_proc()->pagetable);
    80201c2a:	fffff097          	auipc	ra,0xfffff
    80201c2e:	d3c080e7          	jalr	-708(ra) # 80200966 <curr_proc>
    80201c32:	00853983          	ld	s3,8(a0)
    80201c36:	00c9d993          	srli	s3,s3,0xc
    80201c3a:	57fd                	li	a5,-1
    80201c3c:	17fe                	slli	a5,a5,0x3f
    80201c3e:	00f9e9b3          	or	s3,s3,a5
	uint64 fn = TRAMPOLINE + (userret - trampoline);
	tracef("return to user @ %p", trapframe->epc);
    80201c42:	01893583          	ld	a1,24(s2)
    80201c46:	4501                	li	a0,0
    80201c48:	fffff097          	auipc	ra,0xfffff
    80201c4c:	67e080e7          	jalr	1662(ra) # 802012c6 <dummy>
	uint64 fn = TRAMPOLINE + (userret - trampoline);
    80201c50:	00001797          	auipc	a5,0x1
    80201c54:	44878793          	addi	a5,a5,1096 # 80203098 <userret>
    80201c58:	414787b3          	sub	a5,a5,s4
    80201c5c:	94be                	add	s1,s1,a5
	((void (*)(uint64, uint64))fn)(TRAPFRAME, satp);
    80201c5e:	85ce                	mv	a1,s3
    80201c60:	02000537          	lui	a0,0x2000
    80201c64:	157d                	addi	a0,a0,-1
    80201c66:	0536                	slli	a0,a0,0xd
    80201c68:	9482                	jalr	s1
    80201c6a:	70a2                	ld	ra,40(sp)
    80201c6c:	7402                	ld	s0,32(sp)
    80201c6e:	64e2                	ld	s1,24(sp)
    80201c70:	6942                	ld	s2,16(sp)
    80201c72:	69a2                	ld	s3,8(sp)
    80201c74:	6a02                	ld	s4,0(sp)
    80201c76:	6145                	addi	sp,sp,48
    80201c78:	8082                	ret

0000000080201c7a <usertrap>:
{
    80201c7a:	1101                	addi	sp,sp,-32
    80201c7c:	ec06                	sd	ra,24(sp)
    80201c7e:	e822                	sd	s0,16(sp)
    80201c80:	e426                	sd	s1,8(sp)
    80201c82:	e04a                	sd	s2,0(sp)
    80201c84:	1000                	addi	s0,sp,32
	w_stvec((uint64)kerneltrap & ~0x3); // DIRECT
    80201c86:	00000797          	auipc	a5,0x0
    80201c8a:	df078793          	addi	a5,a5,-528 # 80201a76 <kerneltrap>
    80201c8e:	9bf1                	andi	a5,a5,-4
	asm volatile("csrw stvec, %0" : : "r"(x));
    80201c90:	10579073          	csrw	stvec,a5
	struct trapframe *trapframe = curr_proc()->trapframe;
    80201c94:	fffff097          	auipc	ra,0xfffff
    80201c98:	cd2080e7          	jalr	-814(ra) # 80200966 <curr_proc>
    80201c9c:	02053903          	ld	s2,32(a0) # 2000020 <_entry-0x7e1fffe0>
	tracef("trap from user epc = %p", trapframe->epc);
    80201ca0:	01893583          	ld	a1,24(s2)
    80201ca4:	4501                	li	a0,0
    80201ca6:	fffff097          	auipc	ra,0xfffff
    80201caa:	620080e7          	jalr	1568(ra) # 802012c6 <dummy>
	asm volatile("csrr %0, sstatus" : "=r"(x));
    80201cae:	100027f3          	csrr	a5,sstatus
	if ((r_sstatus() & SSTATUS_SPP) != 0)
    80201cb2:	1007f793          	andi	a5,a5,256
    80201cb6:	e395                	bnez	a5,80201cda <usertrap+0x60>
	asm volatile("csrr %0, scause" : "=r"(x));
    80201cb8:	142024f3          	csrr	s1,scause
	if (cause & (1ULL << 63)) {
    80201cbc:	0404cc63          	bltz	s1,80201d14 <usertrap+0x9a>
		switch (cause) {
    80201cc0:	47bd                	li	a5,15
    80201cc2:	1097e963          	bltu	a5,s1,80201dd4 <usertrap+0x15a>
    80201cc6:	00249713          	slli	a4,s1,0x2
    80201cca:	00002697          	auipc	a3,0x2
    80201cce:	7e268693          	addi	a3,a3,2018 # 802044ac <digits+0x37c>
    80201cd2:	9736                	add	a4,a4,a3
    80201cd4:	431c                	lw	a5,0(a4)
    80201cd6:	97b6                	add	a5,a5,a3
    80201cd8:	8782                	jr	a5
		panic("usertrap: not from user mode");
    80201cda:	fffff097          	auipc	ra,0xfffff
    80201cde:	c76080e7          	jalr	-906(ra) # 80200950 <threadid>
    80201ce2:	86aa                	mv	a3,a0
    80201ce4:	03300793          	li	a5,51
    80201ce8:	00002717          	auipc	a4,0x2
    80201cec:	64070713          	addi	a4,a4,1600 # 80204328 <digits+0x1f8>
    80201cf0:	00002617          	auipc	a2,0x2
    80201cf4:	32060613          	addi	a2,a2,800 # 80204010 <e_text+0x10>
    80201cf8:	45fd                	li	a1,31
    80201cfa:	00002517          	auipc	a0,0x2
    80201cfe:	6de50513          	addi	a0,a0,1758 # 802043d8 <digits+0x2a8>
    80201d02:	fffff097          	auipc	ra,0xfffff
    80201d06:	a78080e7          	jalr	-1416(ra) # 8020077a <printf>
    80201d0a:	fffff097          	auipc	ra,0xfffff
    80201d0e:	3e0080e7          	jalr	992(ra) # 802010ea <shutdown>
    80201d12:	b75d                	j	80201cb8 <usertrap+0x3e>
		cause &= ~(1ULL << 63);
    80201d14:	0486                	slli	s1,s1,0x1
    80201d16:	8085                	srli	s1,s1,0x1
		switch (cause) {
    80201d18:	4795                	li	a5,5
    80201d1a:	02f48063          	beq	s1,a5,80201d3a <usertrap+0xc0>
			unknown_trap();
    80201d1e:	00000097          	auipc	ra,0x0
    80201d22:	e42080e7          	jalr	-446(ra) # 80201b60 <unknown_trap>
	usertrapret();
    80201d26:	00000097          	auipc	ra,0x0
    80201d2a:	e80080e7          	jalr	-384(ra) # 80201ba6 <usertrapret>
}
    80201d2e:	60e2                	ld	ra,24(sp)
    80201d30:	6442                	ld	s0,16(sp)
    80201d32:	64a2                	ld	s1,8(sp)
    80201d34:	6902                	ld	s2,0(sp)
    80201d36:	6105                	addi	sp,sp,32
    80201d38:	8082                	ret
			tracef("time interrupt!");
    80201d3a:	4501                	li	a0,0
    80201d3c:	fffff097          	auipc	ra,0xfffff
    80201d40:	58a080e7          	jalr	1418(ra) # 802012c6 <dummy>
			set_next_timer();
    80201d44:	00000097          	auipc	ra,0x0
    80201d48:	cea080e7          	jalr	-790(ra) # 80201a2e <set_next_timer>
			yield();
    80201d4c:	fffff097          	auipc	ra,0xfffff
    80201d50:	f7c080e7          	jalr	-132(ra) # 80200cc8 <yield>
			break;
    80201d54:	bfc9                	j	80201d26 <usertrap+0xac>
			trapframe->epc += 4;
    80201d56:	01893783          	ld	a5,24(s2)
    80201d5a:	0791                	addi	a5,a5,4
    80201d5c:	00f93c23          	sd	a5,24(s2)
			syscall();
    80201d60:	00000097          	auipc	ra,0x0
    80201d64:	ab2080e7          	jalr	-1358(ra) # 80201812 <syscall>
			break;
    80201d68:	bf7d                	j	80201d26 <usertrap+0xac>
			errorf("%d in application, bad addr = %p, bad instruction = %p, "
    80201d6a:	fffff097          	auipc	ra,0xfffff
    80201d6e:	be6080e7          	jalr	-1050(ra) # 80200950 <threadid>
    80201d72:	86aa                	mv	a3,a0
	asm volatile("csrr %0, stval" : "=r"(x));
    80201d74:	143027f3          	csrr	a5,stval
    80201d78:	01893803          	ld	a6,24(s2)
    80201d7c:	8726                	mv	a4,s1
    80201d7e:	00002617          	auipc	a2,0x2
    80201d82:	4a260613          	addi	a2,a2,1186 # 80204220 <digits+0xf0>
    80201d86:	45fd                	li	a1,31
    80201d88:	00002517          	auipc	a0,0x2
    80201d8c:	68850513          	addi	a0,a0,1672 # 80204410 <digits+0x2e0>
    80201d90:	fffff097          	auipc	ra,0xfffff
    80201d94:	9ea080e7          	jalr	-1558(ra) # 8020077a <printf>
			exit(-2);
    80201d98:	5579                	li	a0,-2
    80201d9a:	fffff097          	auipc	ra,0xfffff
    80201d9e:	1bc080e7          	jalr	444(ra) # 80200f56 <exit>
			break;
    80201da2:	b751                	j	80201d26 <usertrap+0xac>
			errorf("IllegalInstruction in application, core dumped.");
    80201da4:	fffff097          	auipc	ra,0xfffff
    80201da8:	bac080e7          	jalr	-1108(ra) # 80200950 <threadid>
    80201dac:	86aa                	mv	a3,a0
    80201dae:	00002617          	auipc	a2,0x2
    80201db2:	47260613          	addi	a2,a2,1138 # 80204220 <digits+0xf0>
    80201db6:	45fd                	li	a1,31
    80201db8:	00002517          	auipc	a0,0x2
    80201dbc:	6b050513          	addi	a0,a0,1712 # 80204468 <digits+0x338>
    80201dc0:	fffff097          	auipc	ra,0xfffff
    80201dc4:	9ba080e7          	jalr	-1606(ra) # 8020077a <printf>
			exit(-3);
    80201dc8:	5575                	li	a0,-3
    80201dca:	fffff097          	auipc	ra,0xfffff
    80201dce:	18c080e7          	jalr	396(ra) # 80200f56 <exit>
			break;
    80201dd2:	bf91                	j	80201d26 <usertrap+0xac>
			unknown_trap();
    80201dd4:	00000097          	auipc	ra,0x0
    80201dd8:	d8c080e7          	jalr	-628(ra) # 80201b60 <unknown_trap>
			break;
    80201ddc:	b7a9                	j	80201d26 <usertrap+0xac>

0000000080201dde <walk>:
//   30..38 -- 9 bits of level-2 index.
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80201dde:	7139                	addi	sp,sp,-64
    80201de0:	fc06                	sd	ra,56(sp)
    80201de2:	f822                	sd	s0,48(sp)
    80201de4:	f426                	sd	s1,40(sp)
    80201de6:	f04a                	sd	s2,32(sp)
    80201de8:	ec4e                	sd	s3,24(sp)
    80201dea:	e852                	sd	s4,16(sp)
    80201dec:	e456                	sd	s5,8(sp)
    80201dee:	e05a                	sd	s6,0(sp)
    80201df0:	0080                	addi	s0,sp,64
    80201df2:	84aa                	mv	s1,a0
    80201df4:	89ae                	mv	s3,a1
    80201df6:	8ab2                	mv	s5,a2
	if (va >= MAXVA)
    80201df8:	57fd                	li	a5,-1
    80201dfa:	83e9                	srli	a5,a5,0x1a
    80201dfc:	00b7e563          	bltu	a5,a1,80201e06 <walk+0x28>
{
    80201e00:	4a79                	li	s4,30
		panic("walk");

	for (int level = 2; level > 0; level--) {
    80201e02:	4b31                	li	s6,12
    80201e04:	a0b5                	j	80201e70 <walk+0x92>
		panic("walk");
    80201e06:	fffff097          	auipc	ra,0xfffff
    80201e0a:	b4a080e7          	jalr	-1206(ra) # 80200950 <threadid>
    80201e0e:	86aa                	mv	a3,a0
    80201e10:	03400793          	li	a5,52
    80201e14:	00002717          	auipc	a4,0x2
    80201e18:	6dc70713          	addi	a4,a4,1756 # 802044f0 <digits+0x3c0>
    80201e1c:	00002617          	auipc	a2,0x2
    80201e20:	1f460613          	addi	a2,a2,500 # 80204010 <e_text+0x10>
    80201e24:	45fd                	li	a1,31
    80201e26:	00002517          	auipc	a0,0x2
    80201e2a:	6d250513          	addi	a0,a0,1746 # 802044f8 <digits+0x3c8>
    80201e2e:	fffff097          	auipc	ra,0xfffff
    80201e32:	94c080e7          	jalr	-1716(ra) # 8020077a <printf>
    80201e36:	fffff097          	auipc	ra,0xfffff
    80201e3a:	2b4080e7          	jalr	692(ra) # 802010ea <shutdown>
    80201e3e:	b7c9                	j	80201e00 <walk+0x22>
		pte_t *pte = &pagetable[PX(level, va)];
		if (*pte & PTE_V) {
			pagetable = (pagetable_t)PTE2PA(*pte);
		} else {
			if (!alloc || (pagetable = (pde_t *)kalloc()) == 0)
    80201e40:	060a8663          	beqz	s5,80201eac <walk+0xce>
    80201e44:	ffffe097          	auipc	ra,0xffffe
    80201e48:	2f6080e7          	jalr	758(ra) # 8020013a <kalloc>
    80201e4c:	84aa                	mv	s1,a0
    80201e4e:	c529                	beqz	a0,80201e98 <walk+0xba>
				return 0;
			memset(pagetable, 0, PGSIZE);
    80201e50:	6605                	lui	a2,0x1
    80201e52:	4581                	li	a1,0
    80201e54:	fffff097          	auipc	ra,0xfffff
    80201e58:	2c4080e7          	jalr	708(ra) # 80201118 <memset>
			*pte = PA2PTE(pagetable) | PTE_V;
    80201e5c:	00c4d793          	srli	a5,s1,0xc
    80201e60:	07aa                	slli	a5,a5,0xa
    80201e62:	0017e793          	ori	a5,a5,1
    80201e66:	00f93023          	sd	a5,0(s2)
	for (int level = 2; level > 0; level--) {
    80201e6a:	3a5d                	addiw	s4,s4,-9
    80201e6c:	036a0063          	beq	s4,s6,80201e8c <walk+0xae>
		pte_t *pte = &pagetable[PX(level, va)];
    80201e70:	0149d933          	srl	s2,s3,s4
    80201e74:	1ff97913          	andi	s2,s2,511
    80201e78:	090e                	slli	s2,s2,0x3
    80201e7a:	9926                	add	s2,s2,s1
		if (*pte & PTE_V) {
    80201e7c:	00093483          	ld	s1,0(s2)
    80201e80:	0014f793          	andi	a5,s1,1
    80201e84:	dfd5                	beqz	a5,80201e40 <walk+0x62>
			pagetable = (pagetable_t)PTE2PA(*pte);
    80201e86:	80a9                	srli	s1,s1,0xa
    80201e88:	04b2                	slli	s1,s1,0xc
    80201e8a:	b7c5                	j	80201e6a <walk+0x8c>
		}
	}
	return &pagetable[PX(0, va)];
    80201e8c:	00c9d513          	srli	a0,s3,0xc
    80201e90:	1ff57513          	andi	a0,a0,511
    80201e94:	050e                	slli	a0,a0,0x3
    80201e96:	9526                	add	a0,a0,s1
}
    80201e98:	70e2                	ld	ra,56(sp)
    80201e9a:	7442                	ld	s0,48(sp)
    80201e9c:	74a2                	ld	s1,40(sp)
    80201e9e:	7902                	ld	s2,32(sp)
    80201ea0:	69e2                	ld	s3,24(sp)
    80201ea2:	6a42                	ld	s4,16(sp)
    80201ea4:	6aa2                	ld	s5,8(sp)
    80201ea6:	6b02                	ld	s6,0(sp)
    80201ea8:	6121                	addi	sp,sp,64
    80201eaa:	8082                	ret
				return 0;
    80201eac:	4501                	li	a0,0
    80201eae:	b7ed                	j	80201e98 <walk+0xba>

0000000080201eb0 <walkaddr>:
uint64 walkaddr(pagetable_t pagetable, uint64 va)
{
	pte_t *pte;
	uint64 pa;

	if (va >= MAXVA)
    80201eb0:	57fd                	li	a5,-1
    80201eb2:	83e9                	srli	a5,a5,0x1a
    80201eb4:	00b7f463          	bgeu	a5,a1,80201ebc <walkaddr+0xc>
		return 0;
    80201eb8:	4501                	li	a0,0
		return 0;
	if ((*pte & PTE_U) == 0)
		return 0;
	pa = PTE2PA(*pte);
	return pa;
}
    80201eba:	8082                	ret
{
    80201ebc:	1141                	addi	sp,sp,-16
    80201ebe:	e406                	sd	ra,8(sp)
    80201ec0:	e022                	sd	s0,0(sp)
    80201ec2:	0800                	addi	s0,sp,16
	pte = walk(pagetable, va, 0);
    80201ec4:	4601                	li	a2,0
    80201ec6:	00000097          	auipc	ra,0x0
    80201eca:	f18080e7          	jalr	-232(ra) # 80201dde <walk>
	if (pte == 0)
    80201ece:	c105                	beqz	a0,80201eee <walkaddr+0x3e>
	if ((*pte & PTE_V) == 0)
    80201ed0:	611c                	ld	a5,0(a0)
	if ((*pte & PTE_U) == 0)
    80201ed2:	0117f693          	andi	a3,a5,17
    80201ed6:	4745                	li	a4,17
		return 0;
    80201ed8:	4501                	li	a0,0
	if ((*pte & PTE_U) == 0)
    80201eda:	00e68663          	beq	a3,a4,80201ee6 <walkaddr+0x36>
}
    80201ede:	60a2                	ld	ra,8(sp)
    80201ee0:	6402                	ld	s0,0(sp)
    80201ee2:	0141                	addi	sp,sp,16
    80201ee4:	8082                	ret
	pa = PTE2PA(*pte);
    80201ee6:	00a7d513          	srli	a0,a5,0xa
    80201eea:	0532                	slli	a0,a0,0xc
	return pa;
    80201eec:	bfcd                	j	80201ede <walkaddr+0x2e>
		return 0;
    80201eee:	4501                	li	a0,0
    80201ef0:	b7fd                	j	80201ede <walkaddr+0x2e>

0000000080201ef2 <useraddr>:

// Look up a virtual address, return the physical address,
uint64 useraddr(pagetable_t pagetable, uint64 va)
{
    80201ef2:	1101                	addi	sp,sp,-32
    80201ef4:	ec06                	sd	ra,24(sp)
    80201ef6:	e822                	sd	s0,16(sp)
    80201ef8:	e426                	sd	s1,8(sp)
    80201efa:	1000                	addi	s0,sp,32
    80201efc:	84ae                	mv	s1,a1
	uint64 page = walkaddr(pagetable, va);
    80201efe:	00000097          	auipc	ra,0x0
    80201f02:	fb2080e7          	jalr	-78(ra) # 80201eb0 <walkaddr>
	if (page == 0)
    80201f06:	c509                	beqz	a0,80201f10 <useraddr+0x1e>
		return 0;
	return page | (va & 0xFFFULL);
    80201f08:	03449593          	slli	a1,s1,0x34
    80201f0c:	91d1                	srli	a1,a1,0x34
    80201f0e:	8d4d                	or	a0,a0,a1
}
    80201f10:	60e2                	ld	ra,24(sp)
    80201f12:	6442                	ld	s0,16(sp)
    80201f14:	64a2                	ld	s1,8(sp)
    80201f16:	6105                	addi	sp,sp,32
    80201f18:	8082                	ret

0000000080201f1a <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80201f1a:	715d                	addi	sp,sp,-80
    80201f1c:	e486                	sd	ra,72(sp)
    80201f1e:	e0a2                	sd	s0,64(sp)
    80201f20:	fc26                	sd	s1,56(sp)
    80201f22:	f84a                	sd	s2,48(sp)
    80201f24:	f44e                	sd	s3,40(sp)
    80201f26:	f052                	sd	s4,32(sp)
    80201f28:	ec56                	sd	s5,24(sp)
    80201f2a:	e85a                	sd	s6,16(sp)
    80201f2c:	e45e                	sd	s7,8(sp)
    80201f2e:	0880                	addi	s0,sp,80
    80201f30:	8aaa                	mv	s5,a0
    80201f32:	8b3a                	mv	s6,a4
	uint64 a, last;
	pte_t *pte;

	a = PGROUNDDOWN(va);
    80201f34:	777d                	lui	a4,0xfffff
    80201f36:	00e5f7b3          	and	a5,a1,a4
	last = PGROUNDDOWN(va + size - 1);
    80201f3a:	167d                	addi	a2,a2,-1
    80201f3c:	00b609b3          	add	s3,a2,a1
    80201f40:	00e9f9b3          	and	s3,s3,a4
	a = PGROUNDDOWN(va);
    80201f44:	893e                	mv	s2,a5
    80201f46:	40f68a33          	sub	s4,a3,a5
			return -1;
		}
		*pte = PA2PTE(pa) | perm | PTE_V;
		if (a == last)
			break;
		a += PGSIZE;
    80201f4a:	6b85                	lui	s7,0x1
    80201f4c:	a0ad                	j	80201fb6 <mappages+0x9c>
			errorf("pte invalid, va = %p", a);
    80201f4e:	fffff097          	auipc	ra,0xfffff
    80201f52:	a02080e7          	jalr	-1534(ra) # 80200950 <threadid>
    80201f56:	86aa                	mv	a3,a0
    80201f58:	874a                	mv	a4,s2
    80201f5a:	00002617          	auipc	a2,0x2
    80201f5e:	2c660613          	addi	a2,a2,710 # 80204220 <digits+0xf0>
    80201f62:	45fd                	li	a1,31
    80201f64:	00002517          	auipc	a0,0x2
    80201f68:	5b450513          	addi	a0,a0,1460 # 80204518 <digits+0x3e8>
    80201f6c:	fffff097          	auipc	ra,0xfffff
    80201f70:	80e080e7          	jalr	-2034(ra) # 8020077a <printf>
			return -1;
    80201f74:	557d                	li	a0,-1
		pa += PGSIZE;
	}
	return 0;
}
    80201f76:	60a6                	ld	ra,72(sp)
    80201f78:	6406                	ld	s0,64(sp)
    80201f7a:	74e2                	ld	s1,56(sp)
    80201f7c:	7942                	ld	s2,48(sp)
    80201f7e:	79a2                	ld	s3,40(sp)
    80201f80:	7a02                	ld	s4,32(sp)
    80201f82:	6ae2                	ld	s5,24(sp)
    80201f84:	6b42                	ld	s6,16(sp)
    80201f86:	6ba2                	ld	s7,8(sp)
    80201f88:	6161                	addi	sp,sp,80
    80201f8a:	8082                	ret
			errorf("remap");
    80201f8c:	fffff097          	auipc	ra,0xfffff
    80201f90:	9c4080e7          	jalr	-1596(ra) # 80200950 <threadid>
    80201f94:	86aa                	mv	a3,a0
    80201f96:	00002617          	auipc	a2,0x2
    80201f9a:	28a60613          	addi	a2,a2,650 # 80204220 <digits+0xf0>
    80201f9e:	45fd                	li	a1,31
    80201fa0:	00002517          	auipc	a0,0x2
    80201fa4:	5a050513          	addi	a0,a0,1440 # 80204540 <digits+0x410>
    80201fa8:	ffffe097          	auipc	ra,0xffffe
    80201fac:	7d2080e7          	jalr	2002(ra) # 8020077a <printf>
			return -1;
    80201fb0:	557d                	li	a0,-1
    80201fb2:	b7d1                	j	80201f76 <mappages+0x5c>
		a += PGSIZE;
    80201fb4:	995e                	add	s2,s2,s7
	for (;;) {
    80201fb6:	012a04b3          	add	s1,s4,s2
		if ((pte = walk(pagetable, a, 1)) == 0) {
    80201fba:	4605                	li	a2,1
    80201fbc:	85ca                	mv	a1,s2
    80201fbe:	8556                	mv	a0,s5
    80201fc0:	00000097          	auipc	ra,0x0
    80201fc4:	e1e080e7          	jalr	-482(ra) # 80201dde <walk>
    80201fc8:	d159                	beqz	a0,80201f4e <mappages+0x34>
		if (*pte & PTE_V) {
    80201fca:	611c                	ld	a5,0(a0)
    80201fcc:	8b85                	andi	a5,a5,1
    80201fce:	ffdd                	bnez	a5,80201f8c <mappages+0x72>
		*pte = PA2PTE(pa) | perm | PTE_V;
    80201fd0:	80b1                	srli	s1,s1,0xc
    80201fd2:	04aa                	slli	s1,s1,0xa
    80201fd4:	0164e4b3          	or	s1,s1,s6
    80201fd8:	0014e493          	ori	s1,s1,1
    80201fdc:	e104                	sd	s1,0(a0)
		if (a == last)
    80201fde:	fd391be3          	bne	s2,s3,80201fb4 <mappages+0x9a>
	return 0;
    80201fe2:	4501                	li	a0,0
    80201fe4:	bf49                	j	80201f76 <mappages+0x5c>

0000000080201fe6 <kvmmap>:
{
    80201fe6:	1141                	addi	sp,sp,-16
    80201fe8:	e406                	sd	ra,8(sp)
    80201fea:	e022                	sd	s0,0(sp)
    80201fec:	0800                	addi	s0,sp,16
    80201fee:	87b6                	mv	a5,a3
	if (mappages(kpgtbl, va, sz, pa, perm) != 0)
    80201ff0:	86b2                	mv	a3,a2
    80201ff2:	863e                	mv	a2,a5
    80201ff4:	00000097          	auipc	ra,0x0
    80201ff8:	f26080e7          	jalr	-218(ra) # 80201f1a <mappages>
    80201ffc:	e509                	bnez	a0,80202006 <kvmmap+0x20>
}
    80201ffe:	60a2                	ld	ra,8(sp)
    80202000:	6402                	ld	s0,0(sp)
    80202002:	0141                	addi	sp,sp,16
    80202004:	8082                	ret
		panic("kvmmap");
    80202006:	fffff097          	auipc	ra,0xfffff
    8020200a:	94a080e7          	jalr	-1718(ra) # 80200950 <threadid>
    8020200e:	86aa                	mv	a3,a0
    80202010:	06900793          	li	a5,105
    80202014:	00002717          	auipc	a4,0x2
    80202018:	4dc70713          	addi	a4,a4,1244 # 802044f0 <digits+0x3c0>
    8020201c:	00002617          	auipc	a2,0x2
    80202020:	ff460613          	addi	a2,a2,-12 # 80204010 <e_text+0x10>
    80202024:	45fd                	li	a1,31
    80202026:	00002517          	auipc	a0,0x2
    8020202a:	53250513          	addi	a0,a0,1330 # 80204558 <digits+0x428>
    8020202e:	ffffe097          	auipc	ra,0xffffe
    80202032:	74c080e7          	jalr	1868(ra) # 8020077a <printf>
    80202036:	fffff097          	auipc	ra,0xfffff
    8020203a:	0b4080e7          	jalr	180(ra) # 802010ea <shutdown>
}
    8020203e:	b7c1                	j	80201ffe <kvmmap+0x18>

0000000080202040 <kvmmake>:
{
    80202040:	1101                	addi	sp,sp,-32
    80202042:	ec06                	sd	ra,24(sp)
    80202044:	e822                	sd	s0,16(sp)
    80202046:	e426                	sd	s1,8(sp)
    80202048:	e04a                	sd	s2,0(sp)
    8020204a:	1000                	addi	s0,sp,32
	kpgtbl = (pagetable_t)kalloc();
    8020204c:	ffffe097          	auipc	ra,0xffffe
    80202050:	0ee080e7          	jalr	238(ra) # 8020013a <kalloc>
    80202054:	84aa                	mv	s1,a0
	memset(kpgtbl, 0, PGSIZE);
    80202056:	6605                	lui	a2,0x1
    80202058:	4581                	li	a1,0
    8020205a:	fffff097          	auipc	ra,0xfffff
    8020205e:	0be080e7          	jalr	190(ra) # 80201118 <memset>
	kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)e_text - KERNBASE,
    80202062:	00002917          	auipc	s2,0x2
    80202066:	f9e90913          	addi	s2,s2,-98 # 80204000 <e_text>
    8020206a:	4729                	li	a4,10
    8020206c:	bff00693          	li	a3,-1025
    80202070:	06d6                	slli	a3,a3,0x15
    80202072:	96ca                	add	a3,a3,s2
    80202074:	40100613          	li	a2,1025
    80202078:	0656                	slli	a2,a2,0x15
    8020207a:	85b2                	mv	a1,a2
    8020207c:	8526                	mv	a0,s1
    8020207e:	00000097          	auipc	ra,0x0
    80202082:	f68080e7          	jalr	-152(ra) # 80201fe6 <kvmmap>
	kvmmap(kpgtbl, (uint64)e_text, (uint64)e_text, PHYSTOP - (uint64)e_text,
    80202086:	4719                	li	a4,6
    80202088:	46c5                	li	a3,17
    8020208a:	06ee                	slli	a3,a3,0x1b
    8020208c:	412686b3          	sub	a3,a3,s2
    80202090:	864a                	mv	a2,s2
    80202092:	85ca                	mv	a1,s2
    80202094:	8526                	mv	a0,s1
    80202096:	00000097          	auipc	ra,0x0
    8020209a:	f50080e7          	jalr	-176(ra) # 80201fe6 <kvmmap>
	kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8020209e:	4729                	li	a4,10
    802020a0:	6685                	lui	a3,0x1
    802020a2:	00001617          	auipc	a2,0x1
    802020a6:	f5e60613          	addi	a2,a2,-162 # 80203000 <trampoline>
    802020aa:	040005b7          	lui	a1,0x4000
    802020ae:	15fd                	addi	a1,a1,-1
    802020b0:	05b2                	slli	a1,a1,0xc
    802020b2:	8526                	mv	a0,s1
    802020b4:	00000097          	auipc	ra,0x0
    802020b8:	f32080e7          	jalr	-206(ra) # 80201fe6 <kvmmap>
}
    802020bc:	8526                	mv	a0,s1
    802020be:	60e2                	ld	ra,24(sp)
    802020c0:	6442                	ld	s0,16(sp)
    802020c2:	64a2                	ld	s1,8(sp)
    802020c4:	6902                	ld	s2,0(sp)
    802020c6:	6105                	addi	sp,sp,32
    802020c8:	8082                	ret

00000000802020ca <kvm_init>:
{
    802020ca:	1141                	addi	sp,sp,-16
    802020cc:	e406                	sd	ra,8(sp)
    802020ce:	e022                	sd	s0,0(sp)
    802020d0:	0800                	addi	s0,sp,16
	kernel_pagetable = kvmmake();
    802020d2:	00000097          	auipc	ra,0x0
    802020d6:	f6e080e7          	jalr	-146(ra) # 80202040 <kvmmake>
    802020da:	0048e797          	auipc	a5,0x48e
    802020de:	f4a7b323          	sd	a0,-186(a5) # 80690020 <kernel_pagetable>
	w_satp(MAKE_SATP(kernel_pagetable));
    802020e2:	8131                	srli	a0,a0,0xc
    802020e4:	57fd                	li	a5,-1
    802020e6:	17fe                	slli	a5,a5,0x3f
    802020e8:	8d5d                	or	a0,a0,a5
	asm volatile("csrw satp, %0" : : "r"(x));
    802020ea:	18051073          	csrw	satp,a0

// flush the TLB.
static inline void sfence_vma()
{
	// the zero, zero means flush all TLB entries.
	asm volatile("sfence.vma zero, zero");
    802020ee:	12000073          	sfence.vma
	asm volatile("csrr %0, satp" : "=r"(x));
    802020f2:	180025f3          	csrr	a1,satp
	infof("enable pageing at %p", r_satp());
    802020f6:	4501                	li	a0,0
    802020f8:	fffff097          	auipc	ra,0xfffff
    802020fc:	1ce080e7          	jalr	462(ra) # 802012c6 <dummy>
}
    80202100:	60a2                	ld	ra,8(sp)
    80202102:	6402                	ld	s0,0(sp)
    80202104:	0141                	addi	sp,sp,16
    80202106:	8082                	ret

0000000080202108 <uvmunmap>:

// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80202108:	711d                	addi	sp,sp,-96
    8020210a:	ec86                	sd	ra,88(sp)
    8020210c:	e8a2                	sd	s0,80(sp)
    8020210e:	e4a6                	sd	s1,72(sp)
    80202110:	e0ca                	sd	s2,64(sp)
    80202112:	fc4e                	sd	s3,56(sp)
    80202114:	f852                	sd	s4,48(sp)
    80202116:	f456                	sd	s5,40(sp)
    80202118:	f05a                	sd	s6,32(sp)
    8020211a:	ec5e                	sd	s7,24(sp)
    8020211c:	e862                	sd	s8,16(sp)
    8020211e:	e466                	sd	s9,8(sp)
    80202120:	e06a                	sd	s10,0(sp)
    80202122:	1080                	addi	s0,sp,96
    80202124:	8a2a                	mv	s4,a0
    80202126:	892e                	mv	s2,a1
    80202128:	89b2                	mv	s3,a2
    8020212a:	8b36                	mv	s6,a3
	uint64 a;
	pte_t *pte;

	if ((va % PGSIZE) != 0)
    8020212c:	03459793          	slli	a5,a1,0x34
    80202130:	e785                	bnez	a5,80202158 <uvmunmap+0x50>
		panic("uvmunmap: not aligned");

	for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    80202132:	09b2                	slli	s3,s3,0xc
    80202134:	99ca                	add	s3,s3,s2
    80202136:	0d397263          	bgeu	s2,s3,802021fa <uvmunmap+0xf2>
		if ((pte = walk(pagetable, a, 0)) == 0)
			continue;
		if ((*pte & PTE_V) != 0) {
			if (PTE_FLAGS(*pte) == PTE_V)
    8020213a:	4b85                	li	s7,1
				panic("uvmunmap: not a leaf");
    8020213c:	00002d17          	auipc	s10,0x2
    80202140:	3b4d0d13          	addi	s10,s10,948 # 802044f0 <digits+0x3c0>
    80202144:	00002c97          	auipc	s9,0x2
    80202148:	eccc8c93          	addi	s9,s9,-308 # 80204010 <e_text+0x10>
    8020214c:	00002c17          	auipc	s8,0x2
    80202150:	45cc0c13          	addi	s8,s8,1116 # 802045a8 <digits+0x478>
	for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    80202154:	6a85                	lui	s5,0x1
    80202156:	a0bd                	j	802021c4 <uvmunmap+0xbc>
		panic("uvmunmap: not aligned");
    80202158:	ffffe097          	auipc	ra,0xffffe
    8020215c:	7f8080e7          	jalr	2040(ra) # 80200950 <threadid>
    80202160:	86aa                	mv	a3,a0
    80202162:	09200793          	li	a5,146
    80202166:	00002717          	auipc	a4,0x2
    8020216a:	38a70713          	addi	a4,a4,906 # 802044f0 <digits+0x3c0>
    8020216e:	00002617          	auipc	a2,0x2
    80202172:	ea260613          	addi	a2,a2,-350 # 80204010 <e_text+0x10>
    80202176:	45fd                	li	a1,31
    80202178:	00002517          	auipc	a0,0x2
    8020217c:	40050513          	addi	a0,a0,1024 # 80204578 <digits+0x448>
    80202180:	ffffe097          	auipc	ra,0xffffe
    80202184:	5fa080e7          	jalr	1530(ra) # 8020077a <printf>
    80202188:	fffff097          	auipc	ra,0xfffff
    8020218c:	f62080e7          	jalr	-158(ra) # 802010ea <shutdown>
    80202190:	b74d                	j	80202132 <uvmunmap+0x2a>
				panic("uvmunmap: not a leaf");
    80202192:	ffffe097          	auipc	ra,0xffffe
    80202196:	7be080e7          	jalr	1982(ra) # 80200950 <threadid>
    8020219a:	86aa                	mv	a3,a0
    8020219c:	09900793          	li	a5,153
    802021a0:	876a                	mv	a4,s10
    802021a2:	8666                	mv	a2,s9
    802021a4:	45fd                	li	a1,31
    802021a6:	8562                	mv	a0,s8
    802021a8:	ffffe097          	auipc	ra,0xffffe
    802021ac:	5d2080e7          	jalr	1490(ra) # 8020077a <printf>
    802021b0:	fffff097          	auipc	ra,0xfffff
    802021b4:	f3a080e7          	jalr	-198(ra) # 802010ea <shutdown>
    802021b8:	a03d                	j	802021e6 <uvmunmap+0xde>
			if (do_free) {
				uint64 pa = PTE2PA(*pte);
				kfree((void *)pa);
			}
		}
		*pte = 0;
    802021ba:	0004b023          	sd	zero,0(s1) # 4000000 <_entry-0x7c200000>
	for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    802021be:	9956                	add	s2,s2,s5
    802021c0:	03397d63          	bgeu	s2,s3,802021fa <uvmunmap+0xf2>
		if ((pte = walk(pagetable, a, 0)) == 0)
    802021c4:	4601                	li	a2,0
    802021c6:	85ca                	mv	a1,s2
    802021c8:	8552                	mv	a0,s4
    802021ca:	00000097          	auipc	ra,0x0
    802021ce:	c14080e7          	jalr	-1004(ra) # 80201dde <walk>
    802021d2:	84aa                	mv	s1,a0
    802021d4:	d56d                	beqz	a0,802021be <uvmunmap+0xb6>
		if ((*pte & PTE_V) != 0) {
    802021d6:	611c                	ld	a5,0(a0)
    802021d8:	0017f713          	andi	a4,a5,1
    802021dc:	df79                	beqz	a4,802021ba <uvmunmap+0xb2>
			if (PTE_FLAGS(*pte) == PTE_V)
    802021de:	3ff7f793          	andi	a5,a5,1023
    802021e2:	fb7788e3          	beq	a5,s7,80202192 <uvmunmap+0x8a>
			if (do_free) {
    802021e6:	fc0b0ae3          	beqz	s6,802021ba <uvmunmap+0xb2>
				uint64 pa = PTE2PA(*pte);
    802021ea:	6088                	ld	a0,0(s1)
    802021ec:	8129                	srli	a0,a0,0xa
				kfree((void *)pa);
    802021ee:	0532                	slli	a0,a0,0xc
    802021f0:	ffffe097          	auipc	ra,0xffffe
    802021f4:	e58080e7          	jalr	-424(ra) # 80200048 <kfree>
    802021f8:	b7c9                	j	802021ba <uvmunmap+0xb2>
	}
}
    802021fa:	60e6                	ld	ra,88(sp)
    802021fc:	6446                	ld	s0,80(sp)
    802021fe:	64a6                	ld	s1,72(sp)
    80202200:	6906                	ld	s2,64(sp)
    80202202:	79e2                	ld	s3,56(sp)
    80202204:	7a42                	ld	s4,48(sp)
    80202206:	7aa2                	ld	s5,40(sp)
    80202208:	7b02                	ld	s6,32(sp)
    8020220a:	6be2                	ld	s7,24(sp)
    8020220c:	6c42                	ld	s8,16(sp)
    8020220e:	6ca2                	ld	s9,8(sp)
    80202210:	6d02                	ld	s10,0(sp)
    80202212:	6125                	addi	sp,sp,96
    80202214:	8082                	ret

0000000080202216 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t uvmcreate(uint64 trapframe)
{
    80202216:	1101                	addi	sp,sp,-32
    80202218:	ec06                	sd	ra,24(sp)
    8020221a:	e822                	sd	s0,16(sp)
    8020221c:	e426                	sd	s1,8(sp)
    8020221e:	e04a                	sd	s2,0(sp)
    80202220:	1000                	addi	s0,sp,32
    80202222:	892a                	mv	s2,a0
	pagetable_t pagetable;
	pagetable = (pagetable_t)kalloc();
    80202224:	ffffe097          	auipc	ra,0xffffe
    80202228:	f16080e7          	jalr	-234(ra) # 8020013a <kalloc>
    8020222c:	84aa                	mv	s1,a0
	if (pagetable == 0) {
    8020222e:	cd29                	beqz	a0,80202288 <uvmcreate+0x72>
		errorf("uvmcreate: kalloc error");
		return 0;
	}
	memset(pagetable, 0, PGSIZE);
    80202230:	6605                	lui	a2,0x1
    80202232:	4581                	li	a1,0
    80202234:	fffff097          	auipc	ra,0xfffff
    80202238:	ee4080e7          	jalr	-284(ra) # 80201118 <memset>
	if (mappages(pagetable, TRAMPOLINE, PAGE_SIZE, (uint64)trampoline,
    8020223c:	4729                	li	a4,10
    8020223e:	00001697          	auipc	a3,0x1
    80202242:	dc268693          	addi	a3,a3,-574 # 80203000 <trampoline>
    80202246:	6605                	lui	a2,0x1
    80202248:	040005b7          	lui	a1,0x4000
    8020224c:	15fd                	addi	a1,a1,-1
    8020224e:	05b2                	slli	a1,a1,0xc
    80202250:	8526                	mv	a0,s1
    80202252:	00000097          	auipc	ra,0x0
    80202256:	cc8080e7          	jalr	-824(ra) # 80201f1a <mappages>
    8020225a:	04054a63          	bltz	a0,802022ae <uvmcreate+0x98>
		     PTE_R | PTE_X) < 0) {
		panic("mappages fail");
	}
	if (mappages(pagetable, TRAPFRAME, PGSIZE, trapframe, PTE_R | PTE_W) <
    8020225e:	4719                	li	a4,6
    80202260:	86ca                	mv	a3,s2
    80202262:	6605                	lui	a2,0x1
    80202264:	020005b7          	lui	a1,0x2000
    80202268:	15fd                	addi	a1,a1,-1
    8020226a:	05b6                	slli	a1,a1,0xd
    8020226c:	8526                	mv	a0,s1
    8020226e:	00000097          	auipc	ra,0x0
    80202272:	cac080e7          	jalr	-852(ra) # 80201f1a <mappages>
    80202276:	06054963          	bltz	a0,802022e8 <uvmcreate+0xd2>
	    0) {
		panic("mappages fail");
	}
	return pagetable;
}
    8020227a:	8526                	mv	a0,s1
    8020227c:	60e2                	ld	ra,24(sp)
    8020227e:	6442                	ld	s0,16(sp)
    80202280:	64a2                	ld	s1,8(sp)
    80202282:	6902                	ld	s2,0(sp)
    80202284:	6105                	addi	sp,sp,32
    80202286:	8082                	ret
		errorf("uvmcreate: kalloc error");
    80202288:	ffffe097          	auipc	ra,0xffffe
    8020228c:	6c8080e7          	jalr	1736(ra) # 80200950 <threadid>
    80202290:	86aa                	mv	a3,a0
    80202292:	00002617          	auipc	a2,0x2
    80202296:	f8e60613          	addi	a2,a2,-114 # 80204220 <digits+0xf0>
    8020229a:	45fd                	li	a1,31
    8020229c:	00002517          	auipc	a0,0x2
    802022a0:	33c50513          	addi	a0,a0,828 # 802045d8 <digits+0x4a8>
    802022a4:	ffffe097          	auipc	ra,0xffffe
    802022a8:	4d6080e7          	jalr	1238(ra) # 8020077a <printf>
		return 0;
    802022ac:	b7f9                	j	8020227a <uvmcreate+0x64>
		panic("mappages fail");
    802022ae:	ffffe097          	auipc	ra,0xffffe
    802022b2:	6a2080e7          	jalr	1698(ra) # 80200950 <threadid>
    802022b6:	86aa                	mv	a3,a0
    802022b8:	0b000793          	li	a5,176
    802022bc:	00002717          	auipc	a4,0x2
    802022c0:	23470713          	addi	a4,a4,564 # 802044f0 <digits+0x3c0>
    802022c4:	00002617          	auipc	a2,0x2
    802022c8:	d4c60613          	addi	a2,a2,-692 # 80204010 <e_text+0x10>
    802022cc:	45fd                	li	a1,31
    802022ce:	00002517          	auipc	a0,0x2
    802022d2:	33a50513          	addi	a0,a0,826 # 80204608 <digits+0x4d8>
    802022d6:	ffffe097          	auipc	ra,0xffffe
    802022da:	4a4080e7          	jalr	1188(ra) # 8020077a <printf>
    802022de:	fffff097          	auipc	ra,0xfffff
    802022e2:	e0c080e7          	jalr	-500(ra) # 802010ea <shutdown>
    802022e6:	bfa5                	j	8020225e <uvmcreate+0x48>
		panic("mappages fail");
    802022e8:	ffffe097          	auipc	ra,0xffffe
    802022ec:	668080e7          	jalr	1640(ra) # 80200950 <threadid>
    802022f0:	86aa                	mv	a3,a0
    802022f2:	0b400793          	li	a5,180
    802022f6:	00002717          	auipc	a4,0x2
    802022fa:	1fa70713          	addi	a4,a4,506 # 802044f0 <digits+0x3c0>
    802022fe:	00002617          	auipc	a2,0x2
    80202302:	d1260613          	addi	a2,a2,-750 # 80204010 <e_text+0x10>
    80202306:	45fd                	li	a1,31
    80202308:	00002517          	auipc	a0,0x2
    8020230c:	30050513          	addi	a0,a0,768 # 80204608 <digits+0x4d8>
    80202310:	ffffe097          	auipc	ra,0xffffe
    80202314:	46a080e7          	jalr	1130(ra) # 8020077a <printf>
    80202318:	fffff097          	auipc	ra,0xfffff
    8020231c:	dd2080e7          	jalr	-558(ra) # 802010ea <shutdown>
    80202320:	bfa9                	j	8020227a <uvmcreate+0x64>

0000000080202322 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void freewalk(pagetable_t pagetable)
{
    80202322:	7179                	addi	sp,sp,-48
    80202324:	f406                	sd	ra,40(sp)
    80202326:	f022                	sd	s0,32(sp)
    80202328:	ec26                	sd	s1,24(sp)
    8020232a:	e84a                	sd	s2,16(sp)
    8020232c:	e44e                	sd	s3,8(sp)
    8020232e:	e052                	sd	s4,0(sp)
    80202330:	1800                	addi	s0,sp,48
    80202332:	8a2a                	mv	s4,a0
	// there are 2^9 = 512 PTEs in a page table.
	for (int i = 0; i < 512; i++) {
    80202334:	84aa                	mv	s1,a0
    80202336:	6905                	lui	s2,0x1
    80202338:	992a                	add	s2,s2,a0
		pte_t pte = pagetable[i];
		if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    8020233a:	4985                	li	s3,1
    8020233c:	a021                	j	80202344 <freewalk+0x22>
	for (int i = 0; i < 512; i++) {
    8020233e:	04a1                	addi	s1,s1,8
    80202340:	03248063          	beq	s1,s2,80202360 <freewalk+0x3e>
		pte_t pte = pagetable[i];
    80202344:	6088                	ld	a0,0(s1)
		if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    80202346:	00f57793          	andi	a5,a0,15
    8020234a:	ff379ae3          	bne	a5,s3,8020233e <freewalk+0x1c>
			// this PTE points to a lower-level page table.
			uint64 child = PTE2PA(pte);
    8020234e:	8129                	srli	a0,a0,0xa
			freewalk((pagetable_t)child);
    80202350:	0532                	slli	a0,a0,0xc
    80202352:	00000097          	auipc	ra,0x0
    80202356:	fd0080e7          	jalr	-48(ra) # 80202322 <freewalk>
			pagetable[i] = 0;
    8020235a:	0004b023          	sd	zero,0(s1)
    8020235e:	b7c5                	j	8020233e <freewalk+0x1c>
		} else if (pte & PTE_V) {
			// panic("freewalk: leaf");
		}
	}
	kfree((void *)pagetable);
    80202360:	8552                	mv	a0,s4
    80202362:	ffffe097          	auipc	ra,0xffffe
    80202366:	ce6080e7          	jalr	-794(ra) # 80200048 <kfree>
}
    8020236a:	70a2                	ld	ra,40(sp)
    8020236c:	7402                	ld	s0,32(sp)
    8020236e:	64e2                	ld	s1,24(sp)
    80202370:	6942                	ld	s2,16(sp)
    80202372:	69a2                	ld	s3,8(sp)
    80202374:	6a02                	ld	s4,0(sp)
    80202376:	6145                	addi	sp,sp,48
    80202378:	8082                	ret

000000008020237a <uvmfree>:
 * @brief Free user memory pages, then free page-table pages.
 *
 * @param max_page The max vaddr of user-space.
 */
void uvmfree(pagetable_t pagetable, uint64 max_page)
{
    8020237a:	1101                	addi	sp,sp,-32
    8020237c:	ec06                	sd	ra,24(sp)
    8020237e:	e822                	sd	s0,16(sp)
    80202380:	e426                	sd	s1,8(sp)
    80202382:	1000                	addi	s0,sp,32
    80202384:	84aa                	mv	s1,a0
	if (max_page > 0)
    80202386:	e999                	bnez	a1,8020239c <uvmfree+0x22>
		uvmunmap(pagetable, 0, max_page, 1);
	freewalk(pagetable);
    80202388:	8526                	mv	a0,s1
    8020238a:	00000097          	auipc	ra,0x0
    8020238e:	f98080e7          	jalr	-104(ra) # 80202322 <freewalk>
}
    80202392:	60e2                	ld	ra,24(sp)
    80202394:	6442                	ld	s0,16(sp)
    80202396:	64a2                	ld	s1,8(sp)
    80202398:	6105                	addi	sp,sp,32
    8020239a:	8082                	ret
		uvmunmap(pagetable, 0, max_page, 1);
    8020239c:	4685                	li	a3,1
    8020239e:	862e                	mv	a2,a1
    802023a0:	4581                	li	a1,0
    802023a2:	00000097          	auipc	ra,0x0
    802023a6:	d66080e7          	jalr	-666(ra) # 80202108 <uvmunmap>
    802023aa:	bff9                	j	80202388 <uvmfree+0xe>

00000000802023ac <uvmcopy>:

// Used in fork.
// Copy the pagetable page and all the user pages.
// Return 0 on success, -1 on error.
int uvmcopy(pagetable_t old, pagetable_t new, uint64 max_page)
{
    802023ac:	715d                	addi	sp,sp,-80
    802023ae:	e486                	sd	ra,72(sp)
    802023b0:	e0a2                	sd	s0,64(sp)
    802023b2:	fc26                	sd	s1,56(sp)
    802023b4:	f84a                	sd	s2,48(sp)
    802023b6:	f44e                	sd	s3,40(sp)
    802023b8:	f052                	sd	s4,32(sp)
    802023ba:	ec56                	sd	s5,24(sp)
    802023bc:	e85a                	sd	s6,16(sp)
    802023be:	e45e                	sd	s7,8(sp)
    802023c0:	0880                	addi	s0,sp,80
	pte_t *pte;
	uint64 pa, i;
	uint flags;
	char *mem;

	for (i = 0; i < max_page * PAGE_SIZE; i += PGSIZE) {
    802023c2:	00c61a13          	slli	s4,a2,0xc
    802023c6:	080a0e63          	beqz	s4,80202462 <uvmcopy+0xb6>
    802023ca:	8aaa                	mv	s5,a0
    802023cc:	8b2e                	mv	s6,a1
    802023ce:	4481                	li	s1,0
    802023d0:	a029                	j	802023da <uvmcopy+0x2e>
    802023d2:	6785                	lui	a5,0x1
    802023d4:	94be                	add	s1,s1,a5
    802023d6:	0744fa63          	bgeu	s1,s4,8020244a <uvmcopy+0x9e>
		if ((pte = walk(old, i, 0)) == 0)
    802023da:	4601                	li	a2,0
    802023dc:	85a6                	mv	a1,s1
    802023de:	8556                	mv	a0,s5
    802023e0:	00000097          	auipc	ra,0x0
    802023e4:	9fe080e7          	jalr	-1538(ra) # 80201dde <walk>
    802023e8:	d56d                	beqz	a0,802023d2 <uvmcopy+0x26>
			continue;
		if ((*pte & PTE_V) == 0)
    802023ea:	6118                	ld	a4,0(a0)
    802023ec:	00177793          	andi	a5,a4,1
    802023f0:	d3ed                	beqz	a5,802023d2 <uvmcopy+0x26>
			continue;
		pa = PTE2PA(*pte);
    802023f2:	00a75593          	srli	a1,a4,0xa
    802023f6:	00c59b93          	slli	s7,a1,0xc
		flags = PTE_FLAGS(*pte);
    802023fa:	3ff77913          	andi	s2,a4,1023
		if ((mem = kalloc()) == 0)
    802023fe:	ffffe097          	auipc	ra,0xffffe
    80202402:	d3c080e7          	jalr	-708(ra) # 8020013a <kalloc>
    80202406:	89aa                	mv	s3,a0
    80202408:	c515                	beqz	a0,80202434 <uvmcopy+0x88>
			goto err;
		memmove(mem, (char *)pa, PGSIZE);
    8020240a:	6605                	lui	a2,0x1
    8020240c:	85de                	mv	a1,s7
    8020240e:	fffff097          	auipc	ra,0xfffff
    80202412:	d66080e7          	jalr	-666(ra) # 80201174 <memmove>
		if (mappages(new, i, PGSIZE, (uint64)mem, flags) != 0) {
    80202416:	874a                	mv	a4,s2
    80202418:	86ce                	mv	a3,s3
    8020241a:	6605                	lui	a2,0x1
    8020241c:	85a6                	mv	a1,s1
    8020241e:	855a                	mv	a0,s6
    80202420:	00000097          	auipc	ra,0x0
    80202424:	afa080e7          	jalr	-1286(ra) # 80201f1a <mappages>
    80202428:	d54d                	beqz	a0,802023d2 <uvmcopy+0x26>
			kfree(mem);
    8020242a:	854e                	mv	a0,s3
    8020242c:	ffffe097          	auipc	ra,0xffffe
    80202430:	c1c080e7          	jalr	-996(ra) # 80200048 <kfree>
		}
	}
	return 0;

err:
	uvmunmap(new, 0, i / PGSIZE, 1);
    80202434:	4685                	li	a3,1
    80202436:	00c4d613          	srli	a2,s1,0xc
    8020243a:	4581                	li	a1,0
    8020243c:	855a                	mv	a0,s6
    8020243e:	00000097          	auipc	ra,0x0
    80202442:	cca080e7          	jalr	-822(ra) # 80202108 <uvmunmap>
	return -1;
    80202446:	557d                	li	a0,-1
    80202448:	a011                	j	8020244c <uvmcopy+0xa0>
	return 0;
    8020244a:	4501                	li	a0,0
}
    8020244c:	60a6                	ld	ra,72(sp)
    8020244e:	6406                	ld	s0,64(sp)
    80202450:	74e2                	ld	s1,56(sp)
    80202452:	7942                	ld	s2,48(sp)
    80202454:	79a2                	ld	s3,40(sp)
    80202456:	7a02                	ld	s4,32(sp)
    80202458:	6ae2                	ld	s5,24(sp)
    8020245a:	6b42                	ld	s6,16(sp)
    8020245c:	6ba2                	ld	s7,8(sp)
    8020245e:	6161                	addi	sp,sp,80
    80202460:	8082                	ret
	return 0;
    80202462:	4501                	li	a0,0
    80202464:	b7e5                	j	8020244c <uvmcopy+0xa0>

0000000080202466 <copyout>:
// Return 0 on success, -1 on error.
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
	uint64 n, va0, pa0;

	while (len > 0) {
    80202466:	c6bd                	beqz	a3,802024d4 <copyout+0x6e>
{
    80202468:	715d                	addi	sp,sp,-80
    8020246a:	e486                	sd	ra,72(sp)
    8020246c:	e0a2                	sd	s0,64(sp)
    8020246e:	fc26                	sd	s1,56(sp)
    80202470:	f84a                	sd	s2,48(sp)
    80202472:	f44e                	sd	s3,40(sp)
    80202474:	f052                	sd	s4,32(sp)
    80202476:	ec56                	sd	s5,24(sp)
    80202478:	e85a                	sd	s6,16(sp)
    8020247a:	e45e                	sd	s7,8(sp)
    8020247c:	e062                	sd	s8,0(sp)
    8020247e:	0880                	addi	s0,sp,80
    80202480:	8b2a                	mv	s6,a0
    80202482:	8c2e                	mv	s8,a1
    80202484:	8a32                	mv	s4,a2
    80202486:	89b6                	mv	s3,a3
		va0 = PGROUNDDOWN(dstva);
    80202488:	7bfd                	lui	s7,0xfffff
		pa0 = walkaddr(pagetable, va0);
		if (pa0 == 0)
			return -1;
		n = PGSIZE - (dstva - va0);
    8020248a:	6a85                	lui	s5,0x1
    8020248c:	a015                	j	802024b0 <copyout+0x4a>
		if (n > len)
			n = len;
		memmove((void *)(pa0 + (dstva - va0)), src, n);
    8020248e:	9562                	add	a0,a0,s8
    80202490:	0004861b          	sext.w	a2,s1
    80202494:	85d2                	mv	a1,s4
    80202496:	41250533          	sub	a0,a0,s2
    8020249a:	fffff097          	auipc	ra,0xfffff
    8020249e:	cda080e7          	jalr	-806(ra) # 80201174 <memmove>

		len -= n;
    802024a2:	409989b3          	sub	s3,s3,s1
		src += n;
    802024a6:	9a26                	add	s4,s4,s1
		dstva = va0 + PGSIZE;
    802024a8:	01590c33          	add	s8,s2,s5
	while (len > 0) {
    802024ac:	02098263          	beqz	s3,802024d0 <copyout+0x6a>
		va0 = PGROUNDDOWN(dstva);
    802024b0:	017c7933          	and	s2,s8,s7
		pa0 = walkaddr(pagetable, va0);
    802024b4:	85ca                	mv	a1,s2
    802024b6:	855a                	mv	a0,s6
    802024b8:	00000097          	auipc	ra,0x0
    802024bc:	9f8080e7          	jalr	-1544(ra) # 80201eb0 <walkaddr>
		if (pa0 == 0)
    802024c0:	cd01                	beqz	a0,802024d8 <copyout+0x72>
		n = PGSIZE - (dstva - va0);
    802024c2:	418904b3          	sub	s1,s2,s8
    802024c6:	94d6                	add	s1,s1,s5
		if (n > len)
    802024c8:	fc99f3e3          	bgeu	s3,s1,8020248e <copyout+0x28>
    802024cc:	84ce                	mv	s1,s3
    802024ce:	b7c1                	j	8020248e <copyout+0x28>
	}
	return 0;
    802024d0:	4501                	li	a0,0
    802024d2:	a021                	j	802024da <copyout+0x74>
    802024d4:	4501                	li	a0,0
}
    802024d6:	8082                	ret
			return -1;
    802024d8:	557d                	li	a0,-1
}
    802024da:	60a6                	ld	ra,72(sp)
    802024dc:	6406                	ld	s0,64(sp)
    802024de:	74e2                	ld	s1,56(sp)
    802024e0:	7942                	ld	s2,48(sp)
    802024e2:	79a2                	ld	s3,40(sp)
    802024e4:	7a02                	ld	s4,32(sp)
    802024e6:	6ae2                	ld	s5,24(sp)
    802024e8:	6b42                	ld	s6,16(sp)
    802024ea:	6ba2                	ld	s7,8(sp)
    802024ec:	6c02                	ld	s8,0(sp)
    802024ee:	6161                	addi	sp,sp,80
    802024f0:	8082                	ret

00000000802024f2 <copyin>:
// Return 0 on success, -1 on error.
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
	uint64 n, va0, pa0;

	while (len > 0) {
    802024f2:	caa5                	beqz	a3,80202562 <copyin+0x70>
{
    802024f4:	715d                	addi	sp,sp,-80
    802024f6:	e486                	sd	ra,72(sp)
    802024f8:	e0a2                	sd	s0,64(sp)
    802024fa:	fc26                	sd	s1,56(sp)
    802024fc:	f84a                	sd	s2,48(sp)
    802024fe:	f44e                	sd	s3,40(sp)
    80202500:	f052                	sd	s4,32(sp)
    80202502:	ec56                	sd	s5,24(sp)
    80202504:	e85a                	sd	s6,16(sp)
    80202506:	e45e                	sd	s7,8(sp)
    80202508:	e062                	sd	s8,0(sp)
    8020250a:	0880                	addi	s0,sp,80
    8020250c:	8b2a                	mv	s6,a0
    8020250e:	8a2e                	mv	s4,a1
    80202510:	8c32                	mv	s8,a2
    80202512:	89b6                	mv	s3,a3
		va0 = PGROUNDDOWN(srcva);
    80202514:	7bfd                	lui	s7,0xfffff
		pa0 = walkaddr(pagetable, va0);
		if (pa0 == 0)
			return -1;
		n = PGSIZE - (srcva - va0);
    80202516:	6a85                	lui	s5,0x1
    80202518:	a01d                	j	8020253e <copyin+0x4c>
		if (n > len)
			n = len;
		memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    8020251a:	018505b3          	add	a1,a0,s8
    8020251e:	0004861b          	sext.w	a2,s1
    80202522:	412585b3          	sub	a1,a1,s2
    80202526:	8552                	mv	a0,s4
    80202528:	fffff097          	auipc	ra,0xfffff
    8020252c:	c4c080e7          	jalr	-948(ra) # 80201174 <memmove>

		len -= n;
    80202530:	409989b3          	sub	s3,s3,s1
		dst += n;
    80202534:	9a26                	add	s4,s4,s1
		srcva = va0 + PGSIZE;
    80202536:	01590c33          	add	s8,s2,s5
	while (len > 0) {
    8020253a:	02098263          	beqz	s3,8020255e <copyin+0x6c>
		va0 = PGROUNDDOWN(srcva);
    8020253e:	017c7933          	and	s2,s8,s7
		pa0 = walkaddr(pagetable, va0);
    80202542:	85ca                	mv	a1,s2
    80202544:	855a                	mv	a0,s6
    80202546:	00000097          	auipc	ra,0x0
    8020254a:	96a080e7          	jalr	-1686(ra) # 80201eb0 <walkaddr>
		if (pa0 == 0)
    8020254e:	cd01                	beqz	a0,80202566 <copyin+0x74>
		n = PGSIZE - (srcva - va0);
    80202550:	418904b3          	sub	s1,s2,s8
    80202554:	94d6                	add	s1,s1,s5
		if (n > len)
    80202556:	fc99f2e3          	bgeu	s3,s1,8020251a <copyin+0x28>
    8020255a:	84ce                	mv	s1,s3
    8020255c:	bf7d                	j	8020251a <copyin+0x28>
	}
	return 0;
    8020255e:	4501                	li	a0,0
    80202560:	a021                	j	80202568 <copyin+0x76>
    80202562:	4501                	li	a0,0
}
    80202564:	8082                	ret
			return -1;
    80202566:	557d                	li	a0,-1
}
    80202568:	60a6                	ld	ra,72(sp)
    8020256a:	6406                	ld	s0,64(sp)
    8020256c:	74e2                	ld	s1,56(sp)
    8020256e:	7942                	ld	s2,48(sp)
    80202570:	79a2                	ld	s3,40(sp)
    80202572:	7a02                	ld	s4,32(sp)
    80202574:	6ae2                	ld	s5,24(sp)
    80202576:	6b42                	ld	s6,16(sp)
    80202578:	6ba2                	ld	s7,8(sp)
    8020257a:	6c02                	ld	s8,0(sp)
    8020257c:	6161                	addi	sp,sp,80
    8020257e:	8082                	ret

0000000080202580 <copyinstr>:
// Copy a null-terminated string from user to kernel.
// Copy bytes to dst from virtual address srcva in a given page table,
// until a '\0', or max.
// Return 0 on success, -1 on error.
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
    80202580:	715d                	addi	sp,sp,-80
    80202582:	e486                	sd	ra,72(sp)
    80202584:	e0a2                	sd	s0,64(sp)
    80202586:	fc26                	sd	s1,56(sp)
    80202588:	f84a                	sd	s2,48(sp)
    8020258a:	f44e                	sd	s3,40(sp)
    8020258c:	f052                	sd	s4,32(sp)
    8020258e:	ec56                	sd	s5,24(sp)
    80202590:	e85a                	sd	s6,16(sp)
    80202592:	e45e                	sd	s7,8(sp)
    80202594:	e062                	sd	s8,0(sp)
    80202596:	0880                	addi	s0,sp,80
	uint64 n, va0, pa0;
	int got_null = 0, len = 0;

	while (got_null == 0 && max > 0) {
    80202598:	c6c9                	beqz	a3,80202622 <copyinstr+0xa2>
    8020259a:	8aaa                	mv	s5,a0
    8020259c:	8bae                	mv	s7,a1
    8020259e:	8c32                	mv	s8,a2
    802025a0:	8936                	mv	s2,a3
	int got_null = 0, len = 0;
    802025a2:	4481                	li	s1,0
		va0 = PGROUNDDOWN(srcva);
    802025a4:	7b7d                	lui	s6,0xfffff
		pa0 = walkaddr(pagetable, va0);
		if (pa0 == 0)
			return -1;
		n = PGSIZE - (srcva - va0);
    802025a6:	6a05                	lui	s4,0x1
    802025a8:	a025                	j	802025d0 <copyinstr+0x50>
			n = max;

		char *p = (char *)(pa0 + (srcva - va0));
		while (n > 0) {
			if (*p == '\0') {
				*dst = '\0';
    802025aa:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x801ff000>
		}

		srcva = va0 + PGSIZE;
	}
	return len;
}
    802025ae:	8526                	mv	a0,s1
    802025b0:	60a6                	ld	ra,72(sp)
    802025b2:	6406                	ld	s0,64(sp)
    802025b4:	74e2                	ld	s1,56(sp)
    802025b6:	7942                	ld	s2,48(sp)
    802025b8:	79a2                	ld	s3,40(sp)
    802025ba:	7a02                	ld	s4,32(sp)
    802025bc:	6ae2                	ld	s5,24(sp)
    802025be:	6b42                	ld	s6,16(sp)
    802025c0:	6ba2                	ld	s7,8(sp)
    802025c2:	6c02                	ld	s8,0(sp)
    802025c4:	6161                	addi	sp,sp,80
    802025c6:	8082                	ret
		srcva = va0 + PGSIZE;
    802025c8:	01498c33          	add	s8,s3,s4
	while (got_null == 0 && max > 0) {
    802025cc:	fe0901e3          	beqz	s2,802025ae <copyinstr+0x2e>
		va0 = PGROUNDDOWN(srcva);
    802025d0:	016c79b3          	and	s3,s8,s6
		pa0 = walkaddr(pagetable, va0);
    802025d4:	85ce                	mv	a1,s3
    802025d6:	8556                	mv	a0,s5
    802025d8:	00000097          	auipc	ra,0x0
    802025dc:	8d8080e7          	jalr	-1832(ra) # 80201eb0 <walkaddr>
		if (pa0 == 0)
    802025e0:	c139                	beqz	a0,80202626 <copyinstr+0xa6>
		n = PGSIZE - (srcva - va0);
    802025e2:	41898833          	sub	a6,s3,s8
    802025e6:	9852                	add	a6,a6,s4
		if (n > max)
    802025e8:	01097363          	bgeu	s2,a6,802025ee <copyinstr+0x6e>
    802025ec:	884a                	mv	a6,s2
		char *p = (char *)(pa0 + (srcva - va0));
    802025ee:	9562                	add	a0,a0,s8
    802025f0:	41350533          	sub	a0,a0,s3
		while (n > 0) {
    802025f4:	fc080ae3          	beqz	a6,802025c8 <copyinstr+0x48>
    802025f8:	985e                	add	a6,a6,s7
    802025fa:	87de                	mv	a5,s7
			if (*p == '\0') {
    802025fc:	41750633          	sub	a2,a0,s7
    80202600:	197d                	addi	s2,s2,-1
    80202602:	9bca                	add	s7,s7,s2
    80202604:	00f60733          	add	a4,a2,a5
    80202608:	00074703          	lbu	a4,0(a4)
    8020260c:	df59                	beqz	a4,802025aa <copyinstr+0x2a>
				*dst = *p;
    8020260e:	00e78023          	sb	a4,0(a5)
			--max;
    80202612:	40fb8933          	sub	s2,s7,a5
			dst++;
    80202616:	0785                	addi	a5,a5,1
			len++;
    80202618:	2485                	addiw	s1,s1,1
		while (n > 0) {
    8020261a:	ff0795e3          	bne	a5,a6,80202604 <copyinstr+0x84>
			dst++;
    8020261e:	8bc2                	mv	s7,a6
    80202620:	b765                	j	802025c8 <copyinstr+0x48>
	int got_null = 0, len = 0;
    80202622:	4481                	li	s1,0
    80202624:	b769                	j	802025ae <copyinstr+0x2e>
			return -1;
    80202626:	54fd                	li	s1,-1
    80202628:	b759                	j	802025ae <copyinstr+0x2e>

000000008020262a <swtch>:
# Save current registers in old. Load from new.


.globl swtch
swtch:
        sd ra, 0(a0)
    8020262a:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    8020262e:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    80202632:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    80202634:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    80202636:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    8020263a:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    8020263e:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    80202642:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    80202646:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    8020264a:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    8020264e:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    80202652:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    80202656:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    8020265a:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    8020265e:	0005b083          	ld	ra,0(a1) # 2000000 <_entry-0x7e200000>
        ld sp, 8(a1)
    80202662:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    80202666:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    80202668:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    8020266a:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    8020266e:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    80202672:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    80202676:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    8020267a:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    8020267e:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    80202682:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    80202686:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    8020268a:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    8020268e:	0685bd83          	ld	s11,104(a1)

    80202692:	8082                	ret
	...

0000000080203000 <trampoline>:
        # mapped into user space, at TRAPFRAME.
        #

	# swap a0 and sscratch
        # so that a0 is TRAPFRAME
        csrrw a0, sscratch, a0
    80203000:	14051573          	csrrw	a0,sscratch,a0

        # save the user registers in TRAPFRAME
        sd ra, 40(a0)
    80203004:	02153423          	sd	ra,40(a0)
        sd sp, 48(a0)
    80203008:	02253823          	sd	sp,48(a0)
        sd gp, 56(a0)
    8020300c:	02353c23          	sd	gp,56(a0)
        sd tp, 64(a0)
    80203010:	04453023          	sd	tp,64(a0)
        sd t0, 72(a0)
    80203014:	04553423          	sd	t0,72(a0)
        sd t1, 80(a0)
    80203018:	04653823          	sd	t1,80(a0)
        sd t2, 88(a0)
    8020301c:	04753c23          	sd	t2,88(a0)
        sd s0, 96(a0)
    80203020:	f120                	sd	s0,96(a0)
        sd s1, 104(a0)
    80203022:	f524                	sd	s1,104(a0)
        sd a1, 120(a0)
    80203024:	fd2c                	sd	a1,120(a0)
        sd a2, 128(a0)
    80203026:	e150                	sd	a2,128(a0)
        sd a3, 136(a0)
    80203028:	e554                	sd	a3,136(a0)
        sd a4, 144(a0)
    8020302a:	e958                	sd	a4,144(a0)
        sd a5, 152(a0)
    8020302c:	ed5c                	sd	a5,152(a0)
        sd a6, 160(a0)
    8020302e:	0b053023          	sd	a6,160(a0)
        sd a7, 168(a0)
    80203032:	0b153423          	sd	a7,168(a0)
        sd s2, 176(a0)
    80203036:	0b253823          	sd	s2,176(a0)
        sd s3, 184(a0)
    8020303a:	0b353c23          	sd	s3,184(a0)
        sd s4, 192(a0)
    8020303e:	0d453023          	sd	s4,192(a0)
        sd s5, 200(a0)
    80203042:	0d553423          	sd	s5,200(a0)
        sd s6, 208(a0)
    80203046:	0d653823          	sd	s6,208(a0)
        sd s7, 216(a0)
    8020304a:	0d753c23          	sd	s7,216(a0)
        sd s8, 224(a0)
    8020304e:	0f853023          	sd	s8,224(a0)
        sd s9, 232(a0)
    80203052:	0f953423          	sd	s9,232(a0)
        sd s10, 240(a0)
    80203056:	0fa53823          	sd	s10,240(a0)
        sd s11, 248(a0)
    8020305a:	0fb53c23          	sd	s11,248(a0)
        sd t3, 256(a0)
    8020305e:	11c53023          	sd	t3,256(a0)
        sd t4, 264(a0)
    80203062:	11d53423          	sd	t4,264(a0)
        sd t5, 272(a0)
    80203066:	11e53823          	sd	t5,272(a0)
        sd t6, 280(a0)
    8020306a:	11f53c23          	sd	t6,280(a0)

        csrr t0, sscratch
    8020306e:	140022f3          	csrr	t0,sscratch
        sd t0, 112(a0)
    80203072:	06553823          	sd	t0,112(a0)
        csrr t1, sepc
    80203076:	14102373          	csrr	t1,sepc
        sd t1, 24(a0)
    8020307a:	00653c23          	sd	t1,24(a0)
        ld sp, 8(a0)
    8020307e:	00853103          	ld	sp,8(a0)
        ld tp, 32(a0)
    80203082:	02053203          	ld	tp,32(a0)
        ld t0, 16(a0)
    80203086:	01053283          	ld	t0,16(a0)
        ld t1, 0(a0)
    8020308a:	00053303          	ld	t1,0(a0)
        csrw satp, t1
    8020308e:	18031073          	csrw	satp,t1
        sfence.vma zero, zero
    80203092:	12000073          	sfence.vma
        jr t0
    80203096:	8282                	jr	t0

0000000080203098 <userret>:
        # usertrapret() calls here.
        # a0: TRAPFRAME, in user page table.
        # a1: user page table, for satp.

        # switch to the user page table.
        csrw satp, a1
    80203098:	18059073          	csrw	satp,a1
        sfence.vma zero, zero
    8020309c:	12000073          	sfence.vma

        # put the saved user a0 in sscratch, so we
        # can swap it with our a0 (TRAPFRAME) in the last step.
        ld t0, 112(a0)
    802030a0:	07053283          	ld	t0,112(a0)
        csrw sscratch, t0
    802030a4:	14029073          	csrw	sscratch,t0

        # restore all but a0 from TRAPFRAME
        ld ra, 40(a0)
    802030a8:	02853083          	ld	ra,40(a0)
        ld sp, 48(a0)
    802030ac:	03053103          	ld	sp,48(a0)
        ld gp, 56(a0)
    802030b0:	03853183          	ld	gp,56(a0)
        ld tp, 64(a0)
    802030b4:	04053203          	ld	tp,64(a0)
        ld t0, 72(a0)
    802030b8:	04853283          	ld	t0,72(a0)
        ld t1, 80(a0)
    802030bc:	05053303          	ld	t1,80(a0)
        ld t2, 88(a0)
    802030c0:	05853383          	ld	t2,88(a0)
        ld s0, 96(a0)
    802030c4:	7120                	ld	s0,96(a0)
        ld s1, 104(a0)
    802030c6:	7524                	ld	s1,104(a0)
        ld a1, 120(a0)
    802030c8:	7d2c                	ld	a1,120(a0)
        ld a2, 128(a0)
    802030ca:	6150                	ld	a2,128(a0)
        ld a3, 136(a0)
    802030cc:	6554                	ld	a3,136(a0)
        ld a4, 144(a0)
    802030ce:	6958                	ld	a4,144(a0)
        ld a5, 152(a0)
    802030d0:	6d5c                	ld	a5,152(a0)
        ld a6, 160(a0)
    802030d2:	0a053803          	ld	a6,160(a0)
        ld a7, 168(a0)
    802030d6:	0a853883          	ld	a7,168(a0)
        ld s2, 176(a0)
    802030da:	0b053903          	ld	s2,176(a0)
        ld s3, 184(a0)
    802030de:	0b853983          	ld	s3,184(a0)
        ld s4, 192(a0)
    802030e2:	0c053a03          	ld	s4,192(a0)
        ld s5, 200(a0)
    802030e6:	0c853a83          	ld	s5,200(a0)
        ld s6, 208(a0)
    802030ea:	0d053b03          	ld	s6,208(a0)
        ld s7, 216(a0)
    802030ee:	0d853b83          	ld	s7,216(a0)
        ld s8, 224(a0)
    802030f2:	0e053c03          	ld	s8,224(a0)
        ld s9, 232(a0)
    802030f6:	0e853c83          	ld	s9,232(a0)
        ld s10, 240(a0)
    802030fa:	0f053d03          	ld	s10,240(a0)
        ld s11, 248(a0)
    802030fe:	0f853d83          	ld	s11,248(a0)
        ld t3, 256(a0)
    80203102:	10053e03          	ld	t3,256(a0)
        ld t4, 264(a0)
    80203106:	10853e83          	ld	t4,264(a0)
        ld t5, 272(a0)
    8020310a:	11053f03          	ld	t5,272(a0)
        ld t6, 280(a0)
    8020310e:	11853f83          	ld	t6,280(a0)

	# restore user a0, and save TRAPFRAME in sscratch
        csrrw a0, sscratch, a0
    80203112:	14051573          	csrrw	a0,sscratch,a0

        # return to user mode and user pc.
        # usertrapret() set up sstatus and sepc.
        sret
    80203116:	10200073          	sret
	...
