ifeq ($(THEOS),)
  $(error THEOS is not set)
endif

export PATH := $(THEOS):$(PATH)
SHELL = /bin/bash

ASMS = obj/local/arm64-v8a/asms
COMMON_SRCS = \
	../src/lib_timing.c \
	../src/lib_mem.c \
	../src/lib_stats.c \
	../src/lib_debug.c \
	../src/getopt.c \
	../src/lib_sched.c
COMMON_CFLAGS = \
	-Wno-implicit-int -Wno-implicit-function-declaration \
	-Wno-unused-variable -Wno-unused-command-line-argument \
	-Wno-return-type -Wno-logical-op-parentheses \
	-Wno-comment -Wno-format -Wno-format-extra-args

COMMON_LDFLAGS = -Wno-deprecated

ifneq ($(ALPS),)
  COMMON_CFLAGS += -Dsysconf=ios_sysconf -DHAVE_BINDPROCESSOR
  COMMON_CFLAGS += -Iinc
  COMMON_LDFLAGS += -L$(ALPS) -lalps_core
endif

ARCHS = arm64
TARGET = iphone:clang::10.0

include $(THEOS)/makefiles/common.mk

TOOL_NAME = bw_mem lat_mem_rd

bw_mem_FILES = $(ASMS)/bw_mem.s $(COMMON_SRCS) src/helpers.c
bw_mem_CFLAGS = $(COMMON_CFLAGS)
bw_mem_LDFLAGS = $(COMMON_LDFLAGS)

lat_mem_rd_FILES = $(ASMS)/lat_mem_rd.s $(COMMON_SRCS) src/helpers.c
lat_mem_rd_CFLAGS = $(COMMON_CFLAGS)
lat_mem_rd_LDFLAGS = $(COMMON_LDFLAGS)

include $(THEOS)/makefiles/tool.mk
