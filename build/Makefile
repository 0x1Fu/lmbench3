export PATH := ../../android-ndk-r17b:$(PATH)

NDK_BUILD_PARAMS := NDK_PROJECT_PATH=. NDK_APPLICATION_MK=Application.mk

all:
	@ndk-build $(NDK_BUILD_PARAMS) V=0

clean:
	@ndk-build clean $(NDK_BUILD_PARAMS)

.PHONY: all

