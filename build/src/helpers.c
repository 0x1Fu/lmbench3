#include <stdio.h>

#if __APPLE__

/* for bw_mem */
int fprintf_d(FILE *file, const char* fmt, double arg1)
{
	return fprintf(file, fmt, arg1);
}

/* for lat_mem_rd */
int fprintf1(FILE *file, const char* fmt, double arg1, double arg2)
{
	return fprintf(file, fmt, arg1, arg2);
}

int fprintf2(FILE *file, const char* fmt, size_t arg1)
{
	return fprintf(file, fmt, arg1);
}

int fprintf3(FILE *file, const char* fmt, size_t arg1)
{
	return fprintf(file, fmt, arg1);
}

#endif

#ifdef __ANDROID__

#include <memory.h>
#include <errno.h>
#include <sys/syscall.h>
#include <pthread.h>

#ifndef CPU_ZERO
#define CPU_SETSIZE 1024
#define __NCPUBITS (8 * sizeof (unsigned long))
typedef struct {
    unsigned long __bits[CPU_SETSIZE / __NCPUBITS];
} cpu_set_t;

#define CPU_SET(cpu, cpusetp) \
    ((cpusetp)->__bits[(cpu)/__NCPUBITS] |= (1UL << ((cpu) % __NCPUBITS)))
#define CPU_ZERO(cpusetp) \
    memset((cpusetp), 0, sizeof(cpu_set_t))
#else
    #define CPU_SET(cpu,cpustep) ((void)0)
    #define CPU_ZERO(cpu,cpustep) ((void)0)
#endif

int bindprocessor(int op, int pid, int cpu)
{
    int ret;
    cpu_set_t mask;

    CPU_ZERO(&mask);
    CPU_SET(cpu, &mask);

    ret = syscall(__NR_sched_setaffinity, pid, sizeof(mask), &mask);
    if (ret)
        return errno;

    return 0;
}

#endif
