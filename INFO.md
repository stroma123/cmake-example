
# CMake example

Here’s a clean, modern CMake-based C++ project template that matches your structure and is designed for:
```
✅ cross-compilation (toolchains, sysroots)
✅ clean dependency handling (find_package / FetchContent)
✅ generated headers
✅ modular source layout
```
## 📁 Project Structure
```
.
├── CMakeLists.txt
├── cmake/
│   ├── toolchains/
│   │   └── example-toolchain.cmake
│   └── dependencies.cmake
├── build/
├── generated/
│   └── vars_process.h
├── README.md
├── sysnet.conf
├── vars.xml
└── src/
    ├── CMakeLists.txt
    ├── daemon.cpp
    ├── network.cpp
    ├── network_events.cpp
    ├── network_setup.cpp
    ├── ntp.cpp
    └── network.h
```
## 🧠 Top-Level CMakeLists.txt
```cmake
cmake_minimum_required(VERSION 3.20)

project(sysnet
    VERSION 1.0
    LANGUAGES CXX
)

# Options
option(ENABLE_TESTS "Build tests" OFF)
option(ENABLE_WARNINGS "Enable strict warnings" ON)

# C++ standard
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Export compile_commands.json
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

# Modules
list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

# Dependencies
include(dependencies)

# Generated headers
set(GENERATED_DIR "${CMAKE_BINARY_DIR}/generated")
file(MAKE_DIRECTORY ${GENERATED_DIR})

# Example: generate header from vars.xml
add_custom_command(
    OUTPUT ${GENERATED_DIR}/vars_process.h
    COMMAND ${CMAKE_COMMAND} -E copy
            ${CMAKE_SOURCE_DIR}/generated/vars_process.h
            ${GENERATED_DIR}/vars_process.h
    DEPENDS ${CMAKE_SOURCE_DIR}/generated/vars_process.h
    COMMENT "Generating vars_process.h"
)

add_custom_target(generate_headers DEPENDS
    ${GENERATED_DIR}/vars_process.h
)

# Add source tree
add_subdirectory(src)
```
## 📦 cmake/dependencies.cmake

Handles dependencies cleanly:

```cmake
include(FetchContent)

# Example: header-only lib
FetchContent_Declare(
    fmt
    GIT_REPOSITORY https://github.com/fmtlib/fmt.git
    GIT_TAG 10.2.1
)

FetchContent_MakeAvailable(fmt)

# Example: system package
find_package(Threads REQUIRED)

# You can wrap deps in interface target
add_library(project_deps INTERFACE)

target_link_libraries(project_deps INTERFACE
    fmt::fmt
    Threads::Threads
)
```
⚙️ Cross-Compilation Toolchain Example

📄 cmake/toolchains/example-toolchain.cmake

```cmake
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR arm)

# Compiler
set(CMAKE_C_COMPILER arm-linux-gnueabihf-gcc)
set(CMAKE_CXX_COMPILER arm-linux-gnueabihf-g++)

# Sysroot
set(CMAKE_SYSROOT /opt/sysroots/arm)

# Search behavior
set(CMAKE_FIND_ROOT_PATH ${CMAKE_SYSROOT})

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
```
## 👉 Build with:

```Bash
cmake -B build \
  -DCMAKE_TOOLCHAIN_FILE=cmake/toolchains/example-toolchain.cmake

cmake --build build
```
📂 src/CMakeLists.txt
```cmake
add_executable(sysnet
    daemon.cpp
    network.cpp
    network_events.cpp
    network_setup.cpp
    ntp.cpp
)

# Include dirs
target_include_directories(sysnet
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}
        ${CMAKE_BINARY_DIR}/generated
)

# Ensure generated headers exist
add_dependencies(sysnet generate_headers)

# Link dependencies
target_link_libraries(sysnet
    PRIVATE
        project_deps
)

# Warnings
if(ENABLE_WARNINGS)
    target_compile_options(sysnet PRIVATE
        -Wall -Wextra -Wpedantic
    )
endif()
```
## 🧾 Example Source Snippets
network.h
```C++
#pragma once

void init_network();
network.cpp
C++
#include "network.h"
#include <iostream>

void init_network() {
    std::cout << "Network initialized\n";
}
```
daemon.cpp
```C++
#include "network.h"

int main() {
    init_network();
    return 0;
}
```
## ⚡ Generated Header Example

📄 generated/vars_process.h

```C++
#pragma once

#define SYSNET_VERSION "1.0"
```
📘 README.md (template)
```Markdown
# sysnet

## Build

### Native
```bash
cmake -B build
cmake --build build
```
Cross-compile
```Bash
cmake -B build \
  -DCMAKE_TOOLCHAIN_FILE=cmake/toolchains/example-toolchain.cmake
cmake --build build
```
---

# 🧩 Key Design Choices

### 1. ✅ Dependency isolation
- `project_deps` interface target = clean linking
- easy to swap system vs fetched libs

### 2. ✅ Cross-compilation ready
- toolchain file only (no hacks in main CMake)
- proper `SYSROOT` + `FIND_ROOT_PATH`

### 3. ✅ Generated files handled properly
- `add_custom_command` + `add_dependencies`
- avoids race conditions

### 4. ✅ Out-of-source builds
- everything goes into `build/`

---

# 🚀 Optional Improvements

If you want to extend this:

- Add **install rules**
- Add **CTest**
- Add **CPack packaging**
- Add **clang-tidy / sanitizers**
- Split into **libraries + executables**
- Add **config header generation (configure_file)**

---

If you want, I can turn this into a **GitHub-ready repo** or add:
- Conan/vcpkg integration
- systemd service install
- real XML → header codegen instead of copy

---

```cmake
# set(CMAKE_SYSROOT ...)
```
⚠️ Common pitfall

If you're just experimenting and don’t actually need cross-compilation yet:

👉 Remove the toolchain file entirely

```Bash
cmake -B build
```
## 🚀 Recommendation

For a solid setup:

- install toolchain via package manager OR SDK
- use absolute compiler paths in toolchain file
- verify with --version
- ensure SYSROOT is valid


## 🔍 Verify toolchain exists
```Bash
which aarch64-linux-gnu-g++
```
Expected:
```
/usr/bin/aarch64-linux-gnu-g++
```
If not installed:

```Bash
sudo apt install g++-aarch64-linux-gnu
```
## 🚀 Reconfigure cleanly

Always wipe cache after toolchain changes:

```Bash
rm -rf build

cmake -B build \
  -DCMAKE_TOOLCHAIN_FILE=cmake/toolchains/example-toolchain.cmake
```
## ⚠️ Important: sysroot (don’t fake it)

If you don’t have a real sysroot:

👉 leave it unset

```cmake
# set(CMAKE_SYSROOT ...)
```
Otherwise you’ll get mysterious errors like:
```
missing <iostream>

missing libc

linker failures
```
## 🧠 Optional: safer auto-detection

If you don’t want hardcoded paths:

```cmake
find_program(CMAKE_C_COMPILER aarch64-linux-gnu-gcc REQUIRED)
find_program(CMAKE_CXX_COMPILER aarch64-linux-gnu-g++ REQUIRED)
```
## 🧪 Test it worked

After configure:

```Bash
cmake --build build
file build/src/sysnet
```
Expected output:
```
ELF 64-bit LSB executable, ARM aarch64
```
## ⚡ Pro tip (very useful)

If you're targeting something like:

Raspberry Pi 4 (64-bit OS)

ARM server

embedded Linux board

You’ll eventually want a real sysroot from the target (via rsync or SDK). That ensures ABI compatibility.

If you want, I can:

generate a Yocto / Buildroot / Raspberry Pi–specific toolchain file

show how to extract sysroot from a live device

or wire this into vcpkg/Conan for cross builds


## ✅ Minimal working flow
```Bash
rm -rf build

cmake -B build \
  -DCMAKE_TOOLCHAIN_FILE=cmake/toolchains/example-toolchain.cmake

cmake --build build -j

ls build/src/
```
## 🧠 If still no binary

Tell me what this outputs:

```Bash
cmake --build build --target help
```

## 👉 CMake is expecting:
```
<project_root>/generated/vars_process.h
```
But your tree shows:
```
generated/
└── vars_process.h
```
So one of these is true:

1. the file does NOT actually exist there
2. OR you're mixing source vs build generated dirs


## Fix options

### Option 1 (simplest): treat it as a normal header

If vars_process.h already exists and is NOT generated:

👉 Remove the custom command entirely

🔧 Top-level CMakeLists.txt — delete this:
```cmake
add_custom_command(...)
add_custom_target(generate_headers ...)
🔧 In src/CMakeLists.txt, just include it:
cmake
target_include_directories(sysnet
    PRIVATE
        ${CMAKE_SOURCE_DIR}/generated
)
```
👉 Done. No generation needed.

### Option 2: fix the path (if you really want copy step)

Check file exists:

```Bash
ls generated/vars_process.h
```
If it does, then fix robustness:

```cmake
set(SRC_GENERATED_FILE
    ${CMAKE_SOURCE_DIR}/generated/vars_process.h
)

set(DST_GENERATED_FILE
    ${CMAKE_BINARY_DIR}/generated/vars_process.h
)

add_custom_command(
    OUTPUT ${DST_GENERATED_FILE}
    COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_BINARY_DIR}/generated
    COMMAND ${CMAKE_COMMAND} -E copy ${SRC_GENERATED_FILE} ${DST_GENERATED_FILE}
    DEPENDS ${SRC_GENERATED_FILE}
    COMMENT "Copying vars_process.h"
)

add_custom_target(generate_headers
    DEPENDS ${DST_GENERATED_FILE}
)
```
⚠️ Subtle issue you hit

The error path:
```
../generated/vars_process.h
```
means:

👉 CMake is resolving paths relative to build/src/, not root

This happens when:

relative paths sneak in

or dependency graph is slightly off

### Option 3 (best long-term): real generation

If this header is supposed to come from vars.xml, do it properly:

```cmake
add_custom_command(
    OUTPUT ${CMAKE_BINARY_DIR}/generated/vars_process.h
    COMMAND my_generator_tool ${CMAKE_SOURCE_DIR}/vars.xml
            ${CMAKE_BINARY_DIR}/generated/vars_process.h
    DEPENDS ${CMAKE_SOURCE_DIR}/vars.xml
)
```
🚀 Quick fix (recommended right now)

👉 Do this:

Delete generation logic

Include directory directly:

```cmake
target_include_directories(sysnet PRIVATE
    ${CMAKE_SOURCE_DIR}/generated
)
```
Rebuild:

```Bash
rm -rf build
cmake -B build \
  -DCMAKE_TOOLCHAIN_FILE=cmake/toolchains/example-toolchain.cmake
cmake --build build -j
```
🧠 Takeaway

Use add_custom_command only if you truly generate files

Don’t “copy” headers unless you have a strong reason

Always prefer absolute paths in CMake

If you want, I can show you a proper XML → C++ header generator pipeline (with Python or XSLT) that plugs cleanly into CMake.