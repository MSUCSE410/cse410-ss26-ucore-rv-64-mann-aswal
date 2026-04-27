#include "syscall.h"
#include "console.h"
#include "defs.h"
#include "loader.h"
#include "syscall_ids.h"
#include "timer.h"
#include "trap.h"

#define PROT_READ 1
#define PROT_WRITE 2
#define PROT_EXEC 4

uint64 sys_write(int fd, uint64 va, uint len)
{
	debugf("sys_write fd = %d str = %x, len = %d", fd, va, len);
	if (fd != STDOUT)
		return -1;
	struct proc *p = curr_proc();
	char str[MAX_STR_LEN];
	int size = copyinstr(p->pagetable, str, va, MIN(len, MAX_STR_LEN));
	debugf("size = %d", size);
	for (int i = 0; i < size; ++i) {
		console_putchar(str[i]);
	}
	return size;
}

uint64 sys_read(int fd, uint64 va, uint64 len)
{
	debugf("sys_read fd = %d str = %x, len = %d", fd, va, len);
	if (fd != STDIN)
		return -1;
	struct proc *p = curr_proc();
	char str[MAX_STR_LEN];
	for (int i = 0; i < len; ++i) {
		int c = consgetc();
		str[i] = c;
	}
	copyout(p->pagetable, va, str, len);
	return len;
}

__attribute__((noreturn)) void sys_exit(int code)
{
	exit(code);
	__builtin_unreachable();
}

uint64 sys_sched_yield()
{
	yield();
	return 0;
}

uint64 sys_gettimeofday(uint64 val, int _tz)
{
	struct proc *p = curr_proc();
	uint64 cycle = get_cycle();
	TimeVal t;
	t.sec = cycle / CPU_FREQ;
	t.usec = (cycle % CPU_FREQ) * 1000000 / CPU_FREQ;
	copyout(p->pagetable, val, (char *)&t, sizeof(TimeVal));
	return 0;
}

uint64 sys_getpid()
{
	return curr_proc()->pid;
}

uint64 sys_getppid()
{
	struct proc *p = curr_proc();
	return p->parent == NULL ? IDLE_PID : p->parent->pid;
}

uint64 sys_clone()
{
	debugf("fork!\n");
	return fork();
}

uint64 sys_exec(uint64 va)
{
	struct proc *p = curr_proc();
	char name[200];
	copyinstr(p->pagetable, name, va, 200);
	debugf("sys_exec %s\n", name);
	return exec(name);
}

uint64 sys_wait(int pid, uint64 va)
{
	struct proc *p = curr_proc();
	int *code = (int *)useraddr(p->pagetable, va);
	return wait(pid, code);
}

uint64 sys_spawn(uint64 va)
{
	struct proc *parent = curr_proc();
	struct proc *child;
	char name[200];

	if (copyinstr(parent->pagetable, name, va, sizeof(name)) < 0)
		return -1;

	int id = get_id_by_name(name);
	if (id < 0)
		return -1;

	child = allocproc();
	if (child == 0)
		return -1;
	child->parent = parent;
	loader(id, child);
	add_task(child);
	return child->pid;
}

uint64 sys_set_priority(long long prio)
{
	if (prio <= 1)
		return -1;
	struct proc *p = curr_proc();

	p->priority = prio;
	p->pass = BIG_STRIDE / p->priority;

	return p->priority;
}

extern char trap_page[];

// sys_mmap: map anonymous pages at user VA with permissions from prot
uint64 sys_mmap(uint64 va, uint64 len, int prot, int flags, int fd)
{
	(void)flags;
	(void)fd;

	struct proc *p = curr_proc();
	pagetable_t pt = p->pagetable;
	uint64 size_mapping;
	uint64 address;

	if (len > (uint64)-1 - (PGSIZE - 1))
		return -1;
	size_mapping = PGROUNDUP(len);
	if (va + size_mapping < va)
		return -1;

	if ((va % PGSIZE) != 0)
		return -1;
	if ((prot & ~0x7) != 0)
		return -1;
	if ((prot & 0x7) == 0)
		return -1;

	if (len == 0)
		return 0;

	for (address = va; address < va + size_mapping; address += PGSIZE) { // check if the address is already mapped
		if (walkaddr(pt, address) != 0) // return -1 if the address is already mapped
			return -1;
	}

	int perm = PTE_U; // start with user permission
	if (prot & PROT_READ) // add read permission if PROT_READ is set
		perm |= PTE_R;
	if (prot & PROT_WRITE) // add write permission if PROT_WRITE is set
		perm |= PTE_W;
	if (prot & PROT_EXEC) // add execute permission if PROT_EXEC is set
		perm |= PTE_X;

	uint64 npages_done = 0;
	for (address = va; address < va + size_mapping; address += PGSIZE) { // map the pages
		void *pa = kalloc(); // allocate a page
		if (pa == 0) { // return -1 if the page is not allocated
			uvmunmap(pt, va, npages_done, 1);
			return -1;
		}
		memset(pa, 0, PGSIZE);
		if (mappages(pt, address, PGSIZE, (uint64)pa, perm) != 0) {
			kfree(pa);
			uvmunmap(pt, va, npages_done, 1);
			return -1;
		}
		npages_done++;
	}

	// max page index for uvmfree / fork
	{
		uint64 new_max = PGROUNDUP(va + size_mapping) / PGSIZE;
		if (new_max > p->max_page)
			p->max_page = new_max;
	}
	return 0;
}

// sys_munmap: unmap a user range; every page in the range must be mapped
uint64 sys_munmap(uint64 start_va, uint64 len)
{
	struct proc *p = curr_proc();
	pagetable_t pt = p->pagetable;
	uint64 va0 = start_va;
	uint64 end = PGROUNDUP(va0 + len);

	if ((va0 % PGSIZE) != 0)
		return -1;

	end = PGROUNDUP(va0 + len);
	if (end < va0)
		return -1;

	for (uint64 ua = va0; ua < end; ua += PGSIZE) {
		if (walkaddr(pt, ua) == 0)
			return -1;
	}

	uint64 npages = (end - va0) / PGSIZE;
	uvmunmap(pt, va0, npages, 1);
	
	return 0;
}


void syscall()
{
	struct trapframe *trapframe = curr_proc()->trapframe;
	int id = trapframe->a7, ret;
	uint64 args[6] = { trapframe->a0, trapframe->a1, trapframe->a2,
			   trapframe->a3, trapframe->a4, trapframe->a5 };
	tracef("syscall %d args = [%x, %x, %x, %x, %x, %x]", id, args[0],
	       args[1], args[2], args[3], args[4], args[5]);
	switch (id) {
	case SYS_write:
		ret = sys_write(args[0], args[1], args[2]);
		break;
	case SYS_read:
		ret = sys_read(args[0], args[1], args[2]);
		break;
	case SYS_exit:
		sys_exit(args[0]);
		// __builtin_unreachable();
	case SYS_sched_yield:
		ret = sys_sched_yield();
		break;
	case SYS_gettimeofday:
		ret = sys_gettimeofday(args[0], args[1]);
		break;
	case SYS_getpid:
		ret = sys_getpid();
		break;
	case SYS_getppid:
		ret = sys_getppid();
		break;
	case SYS_clone: // SYS_fork
		ret = sys_clone();
		break;
	case SYS_execve:
		ret = sys_exec(args[0]);
		break;
	case SYS_wait4:
		ret = sys_wait(args[0], args[1]);
		break;
	case SYS_spawn:
		ret = sys_spawn(args[0]);
		break;
	// Switch cases for the new syscalls
	case SYS_mmap:
		ret = sys_mmap(args[0], args[1], args[2], args[3], args[4]);
		break;
	case SYS_munmap:
		ret = sys_munmap(args[0], args[1]);
		break;
	case SYS_setpriority:
		ret = sys_set_priority(args[0]);
		break;
	default:
		ret = -1;
		errorf("unknown syscall %d", id);
	}
	trapframe->a0 = ret;
	tracef("syscall ret %d", ret);
}
