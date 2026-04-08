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
#add_custom_command(
#    OUTPUT ${GENERATED_DIR}/vars_process.h
#    COMMAND ${CMAKE_COMMAND} -E copy
#            ${CMAKE_SOURCE_DIR}/generated/vars_process.h
#            ${GENERATED_DIR}/vars_process.h
#    DEPENDS ${CMAKE_SOURCE_DIR}/generated/vars_process.h
#    COMMENT "Generating vars_process.h"
#)

#add_custom_target(generate_headers DEPENDS
#    ${GENERATED_DIR}/vars_process.h
#)

# Add source tree
add_subdirectory(src)