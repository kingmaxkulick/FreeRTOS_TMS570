# CMakeLists.txt - Main build configuration file for TMS570 FreeRTOS project
# Defines source files, compiler flags, and build targets for the project
# Uses TI ARM LLVM compiler to build for TMS570 with FPU
# Creator: Max Kulick

cmake_minimum_required(VERSION 3.15)
project(TMS570_FREERTOS C ASM)

# Path to TI ARM LLVM compiler
set(TI_CGT_DIR "C:/ti/ccs2010/ccs/tools/compiler/ti-cgt-armllvm_4.0.2.LTS")

# Specify the TI compiler
set(CMAKE_C_COMPILER "${TI_CGT_DIR}/bin/tiarmclang")
set(CMAKE_ASM_COMPILER "${TI_CGT_DIR}/bin/tiarmclang")

# For TMS570 with FPU (Cortex-R4 in big-endian mode with VFPv3D16)
set(CPU_FLAGS "-mcpu=cortex-r4 -mfloat-abi=hard -mfpu=vfpv3-d16 -mbig-endian")
set(OPT_FLAGS "-O2 -g --display_error_number --enum_type=packed")
set(CMAKE_C_FLAGS "${CPU_FLAGS} ${OPT_FLAGS} --c99")
set(CMAKE_ASM_FLAGS "${CPU_FLAGS} -g")

# Include directories
include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/Library
    ${CMAKE_CURRENT_SOURCE_DIR}/startup
    ${CMAKE_CURRENT_SOURCE_DIR}/FreeRTOS/include
    ${CMAKE_CURRENT_SOURCE_DIR}/FreeRTOS/portable/CCS/ARM_Cortex-R4
    ${CMAKE_CURRENT_SOURCE_DIR}/Common-Demo-Source/include
    "${TI_CGT_DIR}/include"
)

# Source files needed for the project
set(SOURCES
    main.c
    main_full.c
    main_blinky.c
    Library/gio.c
    Library/het.c
    flop_hercules.c
    serial.c
    ParTest.c
    startup/sys_phantom.c
    startup/sys_startup.c
    startup/sys_memory.asm
    startup/sys_core.asm
    startup/sys_intvecs.asm
    startup/sys_system.c
    startup/sys_esm.c
    reg_test.asm
    # FreeRTOS core files - these are linked from the main repo
    FreeRTOS/tasks.c
    FreeRTOS/queue.c
    FreeRTOS/list.c
    FreeRTOS/timers.c
    FreeRTOS/portable/MemMang/heap_4.c
    FreeRTOS/portable/CCS/ARM_Cortex-R4/port.c
    FreeRTOS/portable/CCS/ARM_Cortex-R4/portASM.asm
    # Demo application files
    Common-Demo-Source/Minimal/integer.c
    Common-Demo-Source/Minimal/BlockQ.c
    Common-Demo-Source/Minimal/semtest.c
    Common-Demo-Source/Minimal/PollQ.c
    Common-Demo-Source/Minimal/comtest.c
    Common-Demo-Source/Minimal/dynamic.c
    Common-Demo-Source/Minimal/blocktim.c
    Common-Demo-Source/Minimal/GenQTest.c
    Common-Demo-Source/Minimal/recmutex.c
    Common-Demo-Source/Minimal/countsem.c
    Common-Demo-Source/Minimal/death.c
)

# Create the executable
add_executable(${PROJECT_NAME}.out ${SOURCES})

# Add linker script
set(LINKER_SCRIPT ${CMAKE_CURRENT_SOURCE_DIR}/sys_link.cmd)
set(CMAKE_EXE_LINKER_FLAGS "--rom_model --heap_size=0 --stack_size=0 -m${PROJECT_NAME}.map -i${TI_CGT_DIR}/lib -llibc.a -l${LINKER_SCRIPT}")

# Generate hex file after building
add_custom_command(TARGET ${PROJECT_NAME}.out POST_BUILD
    COMMAND ${TI_CGT_DIR}/bin/tiarmhex -o ${PROJECT_NAME}.hex ${PROJECT_NAME}.out
    COMMAND ${TI_CGT_DIR}/bin/tiarmobjsize ${PROJECT_NAME}.out
)