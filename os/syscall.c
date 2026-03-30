#include "syscall.h"
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
	debugf("sys_write fd = %d va = %x, len = %d", fd, va, len);
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

uint64 sys_gettimeofday(uint64 timeval_va, int _tz)
{
	struct proc *p = curr_proc();
	uint64 cycle = get_cycle();
	TimeVal tv;

	tv.sec = cycle / CPU_FREQ;
	tv.usec = (cycle % CPU_FREQ) * 1000000 / CPU_FREQ;

	if (copyout(p->pagetable, timeval_va, (char *)&tv, sizeof(TimeVal)) == -1)
		return -1;

	return 0;
}

// TODO: add support for mmap and munmap syscall.
// hint: read through docstrings in vm.c. Watching CH4 video may also help.
// Note the return value and PTE flags (especially U,X,W,R)
/*
* LAB1: you may need to define sys_task_info here
*/
int sys_task_info(uint64 info_va)
{
	struct proc *p = curr_proc();
	struct TaskInfo info;

	info.status = 2; // 2 means running

	for (int i = 0; i < MAX_SYSCALL_NUM; i++)
		info.syscall_counts[i] = p->syscall_counts[i]; // copy syscall counts to info

	uint64 current_cycle = get_cycle();
	uint64 elapsed_cycles = current_cycle - p->initial_cycle;
	info.time = (int)(elapsed_cycles / (CPU_FREQ / 1000)); // cycles per sec to per ms

	if (copyout(p->pagetable, info_va, (char *)&info, sizeof(info)) == -1)
		return -1;
	return 0;
}

// sys_mmap: map anonymous pages at user VA with permissions from prot
int sys_mmap(uint64 va, uint64 len, int prot)
{
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
		if (walkpages(pt, address, (uint64)pa, perm) != 0) {
			kfree(pa);
			uvmunmap(pt, va, npages_done, 1);
			return -1;
		}
		npages_done++;
	}

	return 0;
}

// sys_munmap: unmap a user range; every page in the range must be mapped
int sys_munmap(uint64 start_va, uint64 len)
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

// sys_munmap: unmap a user range; every page in the range must be mapped
int sys_munmap(uint64 start_va, uint64 len)
{
	struct proc *p = curr_proc();
	pagetable_t pt = p->pagetable;
	uint64 va0, end, address;

	va0 = start_va;
	if ((va0 % PGSIZE) != 0)
		return -1;

	end = PGROUNDUP(va0 + len); 
	if (end < va0)
		return -1;

	for (address = va0; address < end; address += PGSIZE) {
		if (walkaddr(pt, address) == 0)
			return -1;
	}

	uint64 npages = (end - va0) / PGSIZE;
	uvmunmap(pt, va0, npages, 1);
	return 0;
}

extern char trap_page[];

void syscall()
{
	struct trapframe *trapframe = curr_proc()->trapframe;
	int id = trapframe->a7, ret;
	uint64 args[6] = { trapframe->a0, trapframe->a1, trapframe->a2,
			   trapframe->a3, trapframe->a4, trapframe->a5 };
	tracef("syscall %d args = [%x, %x, %x, %x, %x, %x]", id, args[0],
	       args[1], args[2], args[3], args[4], args[5]);
	/*
	* LAB1: you may need to update syscall counter for task info here
	*/
	struct proc *p = curr_proc();

	if (id >= 0 && id < MAX_SYSCALL_NUM) {
		p->syscall_counts[id]++;
	}
	switch (id) {
	case SYS_write:
		ret = sys_write(args[0], args[1], args[2]);
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
	/*
	* LAB1: you may need to add SYS_taskinfo case here
	*/
	case SYS_task_info:
		ret = sys_task_info(args[0]);
		break;
	case SYS_mmap:
		ret = sys_mmap(args[0], args[1], (int)args[2]);
		break;
	case SYS_munmap:
		ret = sys_munmap(args[0], args[1]);
		break;
	case 172:
		ret = p->pid;
		break;
	default:
		ret = -1;
		errorf("unknown syscall %d", id);
	}
	trapframe->a0 = ret;
	tracef("syscall ret %d", ret);
}
