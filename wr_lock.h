// #include "semaphore.h"

struct wr_lock{
    struct semaphore CGuard, WGuard, W, R;
    int aw, ww, ar, rr; 
};  