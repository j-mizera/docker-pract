#!/bin/bash

mkdir -p /sys/fs/cgroup/parent_tasks

enable_controllers() {
    echo "+cpuset +cpu +io +memory +hugetlb +pids +rdma" | tee /sys/fs/cgroup/cgroup.subtree_control > /dev/null
    return $?
}

enable_controllers
cmd_status=$?

max_retries=20
retries=0

while [ $cmd_status -ne 0 ] && [ $retries -lt $max_retries ]; do
    echo "Enabling controllers failed, moving processes and retrying... (Attempt $((retries + 1)))"

    while read -r pid; do
        echo $pid | tee /sys/fs/cgroup/parent_tasks/cgroup.procs > /dev/null
    done < /sys/fs/cgroup/cgroup.procs

    enable_controllers
    cmd_status=$?
    retries=$((retries + 1))
done

if [ $cmd_status -eq 0 ]; then
    echo "Controllers successfully enabled."
else
    echo "Failed to enable controllers after $max_retries attempts."
    exit 1
fi