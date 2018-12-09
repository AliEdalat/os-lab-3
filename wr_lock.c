// W/R lock

#include "types.h"
#include "defs.h"
#include "param.h"
#include "x86.h"
#include "date.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "spinlock.h"
#include "semaphore.h"
#include "wr_lock.h"

void init_wr_lock(struct wr_lock* lk)
{
    sem_init(&lk->CGuard,1);
    sem_init(&lk->WGuard,1);
    sem_init(&lk->W,1);
    sem_init(&lk->R,1);
    lk ->ar = 0;
    lk ->aw = 0;
    lk ->ww = 0;
    lk ->rr = 0;
}

void acquire_writer_b(struct wr_lock* lk)
{   
    sem_wait(&lk->CGuard);

    lk->aw+=1;
    if (lk->rr==0)
    {
        lk->ww+=1;
        sem_signal(&lk->W); 
    }
    sem_signal(&lk->CGuard);

    sem_wait(&lk->W);

    sem_wait(&lk->WGuard);
}

void release_writer_b(struct wr_lock* lk){
    sem_wait(&lk->WGuard);
    sem_signal(&lk->CGuard);
    lk -> ww-=1;
    lk -> aw-=1;
    if (lk -> aw==0)
        while (lk->rr<lk->ar)
        {
            lk->rr+=1;
            sem_signal(&lk->R); 
        }
    sem_signal(&lk->CGuard);
}

void acquire_reader_b(struct wr_lock* lk)
{
    sem_wait(&lk->CGuard);                  
    lk->ar+=1;                      
    if (lk->aw==0)                   
    {
        lk->rr+=1;                      
        sem_signal(&lk->R); 
    }                     
    sem_signal(&lk->CGuard);                   
    sem_wait(&lk->R);
}

void release_reader_b(struct wr_lock* lk)
{
    sem_wait(&lk->CGuard);             
    lk->rr-=1;                    
    lk->ar-=1;                     
    if (lk->rr==0)                
        while (lk->ww<lk->aw)          
        {
            lk->ww+=1;                 
            sem_signal(&lk->W);
        }              
    sem_signal(&lk->CGuard); 
}