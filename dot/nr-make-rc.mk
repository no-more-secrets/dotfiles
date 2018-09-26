# 0. Enable this to use all system compiler defaults.  If
#    it is disabled then proceed.
#SYSTEM_DEFAULTS :=

ifeq ($(origin SYSTEM_DEFAULTS),undefined)
  # 1. Enable this to use clang.
  USE_CLANG :=

  # 2. If using clang, enable this to tell clang which libstdc++
  #    to use (by default it uses the one on the system).
  #CLANG_USE_LIBSTDCXX = $(GCC_ROOT)

  # 3. Select versions of clang/gcc.
  LLVM_TAG := v700.final
  GCC_TAG  := 8-2-0

  # Don't need to change these.
  CLANG_ROOT := $(HOME)/dev/tools/llvm-$(LLVM_TAG)
  GCC_ROOT   := $(HOME)/dev/tools/gcc-$(GCC_TAG)

  # Note that the static linking of libstdc++ will only apply to
  # the binaries themselves, and not to the dependencies. So if we
  # link against something that in turn links against libstdc++
  # then the running process may have two copies of libstdc++
  # loaded (one static, one dynamic) which is probably not good.

  ifneq ($(origin USE_CLANG),undefined)
      CC  := $(CLANG_ROOT)/bin/clang
      CXX := $(CLANG_ROOT)/bin/clang++
      LD  := $(CLANG_ROOT)/bin/clang++
      AR  := $(CLANG_ROOT)/bin/llvm-ar
      STATIC_LIBSTDCXX=
  else
      # This is kind of sketchy because this gcc build does not
      # even run unless we set an LD_LIBRARY_PATH.
      export LD_LIBRARY_PATH = $(GCC_ROOT)/lib
      CC  := $(GCC_ROOT)/bin/gcc-$(GCC_TAG)
      CXX := $(GCC_ROOT)/bin/g++-$(GCC_TAG)
      LD  := $(GCC_ROOT)/bin/g++-$(GCC_TAG)
      AR  := $(GCC_ROOT)/bin/gcc-ar-$(GCC_TAG)
      STATIC_LIBSTDCXX=
  endif
endif # SYSTEM_DEFAULTS origin undefined
