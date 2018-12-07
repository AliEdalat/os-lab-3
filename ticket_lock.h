struct ticket_lock
{
	int ticket;
	int turn;
	int pid;
	struct spinlock lk;
	// For debugging:
	char *name;        // Name of lock.
};
