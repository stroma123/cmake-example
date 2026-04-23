set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR aarch64)

# Use FULL paths (recommended)
set(TOOLCHAIN_ROOT /home/ico/sysroots/aarch64-cortexa53-linux-gnu)
set(TRIPLET aarch64-cortexa53-linux-gnu)
# Compilers
set(CMAKE_C_COMPILER   ${TOOLCHAIN_ROOT}/bin/${TRIPLET}-gcc)
set(CMAKE_CXX_COMPILER ${TOOLCHAIN_ROOT}/bin/${TRIPLET}-g++)
#set(CMAKE_C_COMPILER /usr/bin/aarch64-linux-gnu-gcc)
#set(CMAKE_CXX_COMPILER /usr/bin/aarch64-linux-gnu-g++)

# DO NOT set CMAKE_SYSROOT (let GCC handle it)
# Optional sysroot (only if you actually have one)
# if not set use default from /usr/aarch64-linux-gnu on Debian/Ubuntu
# set(CMAKE_SYSROOT /opt/sysroots/aarch64)

# Root path for finding libs/headers
# set(CMAKE_FIND_ROOT_PATH ${CMAKE_SYSROOT})

# But DO restrict search paths to target
set(CMAKE_FIND_ROOT_PATH
    ${TOOLCHAIN_ROOT}/${TRIPLET}/sysroot
)

# Search behavior
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)