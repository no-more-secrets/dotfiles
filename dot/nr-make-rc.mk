# ==============================================================
# Where are the Compilers

GCC_TAG := 8-2-0

# Don't need to change these.
CLANG_ROOT := $(HOME)/dev/tools/llvm-current
GCC_ROOT   := $(HOME)/dev/tools/gcc-$(GCC_TAG)

# ==============================================================
# Where are the Tools

CLANG_FORMAT := $(CLANG_ROOT)/bin/clang-format
CLANG_TIDY   := $(CLANG_ROOT)/bin/clang-tidy

# ==============================================================
# Which Compiler to Use

# Enable this to use all system compiler defaults.  If it is
# disabled then proceed.
SYSTEM_DEFAULTS :=

ifeq ($(origin SYSTEM_DEFAULTS),undefined)
  # Comment this to use gcc.
  USE_CLANG :=

  # If using clang, enable this to tell clang which libstdc++
  # to use (by default it uses the one on the system).
  CLANG_USE_LIBSTDCXX = $(GCC_ROOT)

  ifneq ($(origin USE_CLANG),undefined)
      CC  := $(CLANG_ROOT)/bin/clang
      CXX := $(CLANG_ROOT)/bin/clang++
      LD  := $(CLANG_ROOT)/bin/clang++
      AR  := $(CLANG_ROOT)/bin/llvm-ar
  else
      CC  := $(GCC_ROOT)/bin/gcc-$(GCC_TAG)
      CXX := $(GCC_ROOT)/bin/g++-$(GCC_TAG)
      LD  := $(GCC_ROOT)/bin/g++-$(GCC_TAG)
      AR  := $(GCC_ROOT)/bin/gcc-ar-$(GCC_TAG)
  endif
endif

# ==============================================================
# Compiler Behavior / Output

# Note that the static linking of libstdc++ will only apply to
# the binaries themselves, and not to the dependencies. So if we
# link against something that in turn links against libstdc++
# then the running process may have two copies of libstdc++
# loaded (one static, one dynamic) which is probably not good.
#STATIC_LIBSTDCXX=
