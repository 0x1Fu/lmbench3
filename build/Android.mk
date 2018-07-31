LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := lmbench
LOCAL_SRC_FILES := \
	../src/lib_timing.c \
	../src/lib_mem.c \
	../src/lib_stats.c \
	../src/lib_debug.c \
	../src/getopt.c \
	../src/lib_sched.c
LOCAL_DISABLE_FORMAT_STRING_CHECKS := true
include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := bw_mem
LOCAL_SRC_FILES := ../src/bw_mem.c
LOCAL_CFLAGS := -O1 -save-temps=obj -Wa,-ad
LOCAL_LDFLAGS := -static
LOCAL_STATIC_LIBRARIES := lmbench
include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)
LOCAL_MODULE := lat_mem_rd
LOCAL_SRC_FILES := ../src/lat_mem_rd.c
LOCAL_CFLAGS := -O1 -save-temps=obj -Wa,-ad
LOCAL_LDFLAGS := -static
LOCAL_STATIC_LIBRARIES := lmbench
LOCAL_DISABLE_FORMAT_STRING_CHECKS := true
include $(BUILD_EXECUTABLE)
