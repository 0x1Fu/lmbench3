APP_PLATFORM := android-26
APP_ABI := arm64-v8a
APP_BUILD_SCRIPT := Android.mk
APP_CFLAGS += -fno-jump-tables
APP_CFLAGS += -Dvalloc=malloc
APP_CFLAGS += -Iinc

NDK_TOOLCHAIN_VERSION := 4.9
