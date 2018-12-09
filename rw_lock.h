struct rw_lock{
    int readers;
    int retry_threshold;
};