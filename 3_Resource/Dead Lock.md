---
title: Dead Lock
date: 2024-07-25 22:46:00 +0900
aliases: 
tags:
  - deadlock
  - lock
categories: 
description: 
updated: 2024-07-25 22:46:30 +0900
---

## Dead Lock

- In a system, processes often require access to shared resources, such as CPU time or main memory
- They may also require access to resources that are held by other processes
- Deadlock occurs when a process in the set of waiting processes is waiting for an event that can be triggered only by another waiting process
- The two or more competing processes prevent each other from accessing the resource, creating a deadlock

### Conditions for Deadlock

1. Mutual exclusion: A resource can be used by only one process at a time.
2. Hold and wait: A process holding at least one resource is waiting to acquire additional resources held by other processes.
3. No preemption: A resource cannot be forcibly removed from a process holding it.
4. Circular wait: Two or more processes form a circular chain where each process waits for a resource held by the next member of the chain.

### Example of Deadlock

1. Two people are using one pair of scissors to cut their nails.
2. Process 1 has a pen and is asking for paper from Process 2 but it won't give anything until it gets its own pen back.

### Prevention Techniques

1. Prevention:
    - Ensure that at least one of the four necessary conditions does not hold.
    - For example, ensuring that there is no hold and wait condition would mean that all the required resources are allocated before execution begins.

2. Avoidance by Resource Allocation Graph:
    - The Resource Allocation Graph (RAG) consists of two types of nodes – `process` and `resource`.
    - Each instance of an edge represents either an `assignment` or a `request`.
    - If all instances of requests have been granted and there is still no deadlock then there will never be any deadlock in this system.


### Recovery Technique

- Detecting deadlocks after they occur and then taking steps to recover from them
- There are three basic techniques for dealing with deadlocks:
    1. Process Termination:
        - One method of breaking a deadlock is to abort one or more processes from the set of deadlocked processes.
        - The operating system selects a process from the set and aborts it.
        - This technique is effective in breaking only single resource deadlocks.

    2. Resource Preemption:
        - Selecting a victim and rollback its state by releasing all its held resources
        - There are two options:
            1. Selecting a victim that will require the minimum amount of rolling back, but this may cause other deadlocks to occur
            2. Selecting a victim that has one instance of a resource and then rolling back all processes holding an instance of that resource

    3. Combined approach: Involves both preemption and process termination

### Conclusion

- Deadlock is an unwanted situation in multitasking systems where due to unavailability or synchronization failure, two or more processes are unable to proceed and get stuck in an infinite loop waiting for each other.

## Starvation

- Starvation refers to the situation where a process does not get the required resources for a long time because the resources are being allocated to some other process on an indefinite basis
- The system fails to allocate available resources fairly among all the processes
- It can result when priorities are assigned unfairly so that some low-priority processes never obtain access to essential resources
- One way starvation can occur is if there is no upper bound associated with the priority levels of tasks.

### Example

A task responsible for updating data on disk may be starved by other CPU-bound tasks, which have higher priority levels than it.

### Prevention Techniques

1. Aging: A solution designed to avoid starvation by increasing the priority of jobs which wait in the system for long periods of time.
2. First-Come First-Served Algorithm: The process that requests the resource first is allocated the resource.
3. Round Robin: Each process is given a time slot to execute. If the process does not complete within that time, it is preempted and other processes are allowed to execute.
4. Priority Scheduling: Each process is assigned a priority and within a given period, the highest priority process executes.

### Conclusion

- Starvation is a situation in which a process does not get its fair share of CPU time or resources and is left waiting indefinitely for these resources.
- Some techniques to prevent starvation include Aging, First-Come First-Served Algorithm, Round Robin, and Priority Scheduling.

## Livelock

- Livelock occurs when two or more processes keep changing their states due to some conflict in their execution
- The difference between livelock and deadlock is that in livelock, each thread keeps running independently but they do not make any progress because of conflicting conditions
- In this case, threads may be running but no useful work is being done
- It is also known as "Deadly embrace" because both threads are stuck in an infinite loop waiting for each other while holding on to their resources

### Example

Two people meet in a narrow corridor, neither can get past the other without the other moving first.

### Prevention Techniques

1. Random Delays:
    - A solution to livelock involves introducing random delays when both processes try to reacquire their resources.
    - This ensures that only one of the two processes gets access at any one time.

2. Resource Prioritization:
    - When two processes require the same set of resources at different times (i.e., one after another), it may cause deadlock.
    - To avoid this problem, each resource can be assigned a unique priority level so that only one thread can hold onto it at any given time.

3. Preemptive Scheduling:
    - If one of the processes is given a higher priority than the other, it can complete its work and release the resources, thus allowing the other process to proceed.

### Conclusion

- Livelock is a situation in which two or more processes keep changing their states due to some conflict in their execution, but none of them make any progress.
- To prevent livelock, random delays can be introduced, resource prioritization can be used, or preemptive scheduling can be adopted.

## Reference

- [잠금(Locking) - 기계인간 John Grib](https://johngrib.github.io/wiki/locking/)
