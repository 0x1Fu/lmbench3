UNAME_S := $(shell uname -s)

ifeq ($(ANDROID_NDK_HOME),)
  $(error ANDROID_NDK_HOME is not set)
endif

export PATH := $(ANDROID_NDK_HOME):$(PATH)
SHELL = /bin/bash

NDK_BUILD_PARAMS := NDK_PROJECT_PATH=. NDK_APPLICATION_MK=Application.mk

OUT = obj/local/arm64-v8a
ASMS = $(OUT)/asms
ifeq ($(UNAME_S), Darwin)
SED = @sed -i ''
else
SED = @sed -i
endif

all: bins asms ios
	@echo done

bins:
	@ndk-build $(NDK_BUILD_PARAMS) V=0

asms: $(ASMS)/bw_mem.s $(ASMS)/lat_mem_rd.s

$(ASMS)/bw_mem.s: $(OUT)/objs/bw_mem/__/src/bw_mem.s
	@mkdir -p $(dir $@)
	@echo Generating $@
	@python convert_asm.py $^ > $@
	@$(SED) 's/_stderr/___stderrp/' $@
	@$(SED) 's/fprintf/fprintf_d/' $@

$(ASMS)/lat_mem_rd.s: $(OUT)/objs/lat_mem_rd/__/src/lat_mem_rd.s
	@mkdir -p $(dir $@)
	@echo Generating $@
	@python convert_asm.py $^ > $@
	@$(SED) 's/stride_initialize/_&/' $@
	@$(SED) 's/_stderr/___stderrp/' $@
	@perl -pi -e 's/fprintf/$$& . ++$$n/ge' $@

ios:
ifeq ($(UNAME_S), Darwin)
ifneq ($(THEOS),)
	@make -f ios.mk debug=no messages=no
else
	$(warning THEOS is not set, bypass iOS build )
endif
endif

clean:
	@ndk-build clean $(NDK_BUILD_PARAMS)
	rm -f $(ASMS)/*.s
ifeq ($(UNAME_S), Darwin)
	@make -f ios.mk clean
endif

.PHONY: all asms ios
