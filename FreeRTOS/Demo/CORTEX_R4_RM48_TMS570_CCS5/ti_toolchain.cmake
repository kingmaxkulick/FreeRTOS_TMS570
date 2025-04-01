# TI ARM CGT Toolchain File for TMS570
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)

# TI Compiler Path
set(TOOLCHAIN_ROOT "C:/ti/ccs2010/ccs/tools/compiler/ti-cgt-arm_20.2.5.LTS")

# Compiler executables
set(CMAKE_C_COMPILER "${TOOLCHAIN_ROOT}/bin/armcl.exe" CACHE FILEPATH "C compiler")
set(CMAKE_ASM_COMPILER "${TOOLCHAIN_ROOT}/bin/armcl.exe" CACHE FILEPATH "ASM compiler")
set(CMAKE_LINKER "${TOOLCHAIN_ROOT}/bin/armlnk.exe" CACHE FILEPATH "Linker")
set(CMAKE_AR "${TOOLCHAIN_ROOT}/bin/armar.exe" CACHE FILEPATH "Archiver")

# Required for TI compiler
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
set(CMAKE_C_COMPILER_WORKS 1)
set(CMAKE_ASM_COMPILER_WORKS 1)

# TI-specific flags (updated to little-endian)
set(COMMON_FLAGS "--abi=eabi -mv7R4 --code_state=32 --endian=little -me --float_support=VFPv3D16")
set(CMAKE_C_FLAGS_INIT "${COMMON_FLAGS} --include_path=\"${TOOLCHAIN_ROOT}/include\"")
set(CMAKE_ASM_FLAGS_INIT "${COMMON_FLAGS}")
set(CMAKE_EXE_LINKER_FLAGS_INIT "--reread_libs --rom_model --heap_size=0 --stack_size=0")

# Standard include paths
set(TI_INCLUDE_DIRS
    "${TOOLCHAIN_ROOT}/include"
    "C:/ti/Hercules/HALCoGen/include"  # Add if using HALCoGen
)

# Ensure consistent endianness for all build types
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} --endian=little")
set(CMAKE_ASM_FLAGS "${CMAKE_ASM_FLAGS} --endian=little")