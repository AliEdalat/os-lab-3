// R/W lock

#include "types.h"
#include "defs.h"
#include "param.h"
#include "x86.h"
#include "date.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "spinlock.h"
#include "rw_lock.h"

#define HAS_WRITER 0xffffffff

void init_rw_lock(struct rw_lock* lk, int readers, int retry_threshold)
{
    lk->readers = readers;
    lk->retry_threshold = retry_threshold;
}

void acquire_writer(struct rw_lock* lk)
{
    int retry = 0;
    while (1)
    {
        int prev_readers = lk->readers;
        if (prev_readers == 0)
        {
            if (cas(&lk->readers, prev_readers, HAS_WRITER))
            {
                // we've won the race
                return;
            }
        }

        retry++;
        if (retry > lk->retry_threshold)
        {
            // save some cpu cycles
            retry = 0;
            // sleep proc this_thread::yield();
        }
    }
}

void acquire_reader(struct rw_lock* lk)
{
    int retry = 0;
    while (1)
    {
        int prev_readers = lk->readers;
        if (prev_readers != HAS_WRITER)
        {
            int new_readers = prev_readers + 1;
            if (cas(&lk->readers, prev_readers, new_readers))
            {
                // we've won the race
                return;
            }
        }

        retry++;
        if (retry > lk->retry_threshold)
        {
            retry = 0;
            // sleep proc this_thread::yield();
        }
    }
}

// void release_writer(struct rw_lock* lk)
// {
    
// }

// void release_reader(struct rw_lock* lk)
// {

//             int new_readers = prev_readers + 1;
//             if (cas(&lk->readers, prev_readers, new_readers))
//             {
//                 // we've won the race
//                 return;
//             }

// }