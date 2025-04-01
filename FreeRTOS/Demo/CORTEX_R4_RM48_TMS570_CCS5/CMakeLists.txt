cmake_minimum_required(VERSION 3.15)
project(TMS570_FREERTOS C ASM)

# Set compiler flags (consistent little-endian)
set(CMAKE_C_FLAGS "--little_endian --silicon_version=7R4 -g --diag_warning=225 --float_support=VFPv3D16")
set(CMAKE_ASM_FLAGS "${CMAKE_C_FLAGS}")

# Include directories
include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/Library
    ${CMAKE_CURRENT_SOURCE_DIR}/startup
    ${CMAKE_CURRENT_SOURCE_DIR}/../../Source/include
    ${CMAKE_CURRENT_SOURCE_DIR}/../../Source/portable/CCS/ARM_Cortex-R4
    ${CMAKE_CURRENT_SOURCE_DIR}/../Common/include
    ${TI_INCLUDE_DIRS}
)

# Source files
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
    startup/sys_core.asm
    startup/sys_intvecs.asm
    startup/sys_system.c
    startup/sys_esm.c
    reg_test.asm
    ../../Source/tasks.c
    ../../Source/queue.c
    ../../Source/list.c
    ../../Source/timers.c
    ../../Source/portable/MemMang/heap_4.c
    ../../Source/portable/CCS/ARM_Cortex-R4/port.c
    ../../Source/portable/CCS/ARM_Cortex-R4/portASM.asm
    ../Common/Minimal/integer.c
    ../Common/Minimal/BlockQ.c
    ../Common/Minimal/semtest.c
    ../Common/Minimal/PollQ.c
    ../Common/Minimal/comtest.c
    ../Common/Minimal/dynamic.c
    ../Common/Minimal/blocktim.c
    ../Common/Minimal/GenQTest.c
    ../Common/Minimal/recmutex.c
    ../Common/Minimal/countsem.c
    ../Common/Minimal/death.c
)

# Create executable
add_executable(${PROJECT_NAME}.out ${SOURCES})

# Linker configuration with linker script
set(LINKER_SCRIPT "${CMAKE_CURRENT_SOURCE_DIR}/TMS570.cmd")
set_target_properties(${PROJECT_NAME}.out PROPERTIES
    LINK_FLAGS "--library=${TOOLCHAIN_ROOT}/lib/rtsv7R4_T_le_v3D16_eabi.lib -l${LINKER_SCRIPT} --entry_point=_c_int00 --map_file=${PROJECT_NAME}.map"
)

# HEX generation
if(EXISTS "${TOOLCHAIN_ROOT}/bin/hex470")
    add_custom_command(TARGET ${PROJECT_NAME}.out POST_BUILD
        COMMAND ${TOOLCHAIN_ROOT}/bin/hex470 -o ${PROJECT_NAME}.hex ${PROJECT_NAME}.out
        COMMENT "Generating HEX file"
    )
else()
    message(WARNING "hex470 not found - skipping HEX generation")
endif()

message(STATUS "TOOLCHAIN_ROOT: ${TOOLCHAIN_ROOT}")
message(STATUS "TI_INCLUDE_DIRS: ${TI_INCLUDE_DIRS}")