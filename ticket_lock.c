// Ticket locks

#include "types.h"
#include "defs.h"
#include "param.h"
#include "x86.h"
#include "date.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "spinlock.h"
#include "ticket_lock.h"

void init_ticket_lock(struct ticket_lock* lk, char* name) {
	lk->name = name;
	lk->pid = 0;
	lk->ticket = 0;
	lk->turn = 0;
}

void ticket_acquire(struct ticket_lock* lk) {
	uint me = fetch_and_add(&lk->ticket, 1);
	//cprintf("after inc %d %d\n", me, lk->ticket);
	while(lk->turn != me){
		sleep_without_spin(lk);
	}
	lk->pid = myproc()->pid;
}

void ticket_release(struct ticket_lock* lk) {
	
	if (lk->pid == myproc()->pid)
	{
		lk->pid = 0;
		fetch_and_add(&lk->turn, 1);
		wakeup(lk);
	}
}

int ticket_holding(struct ticket_lock* lk) {
	return (lk->ticket != lk->turn) && (lk->pid == myproc()->pid);
}
