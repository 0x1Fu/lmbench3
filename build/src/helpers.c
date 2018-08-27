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
