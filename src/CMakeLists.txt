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
        ${CMAKE_SOURCE_DIR}/generated
#        ${CMAKE_BINARY_DIR}/generated
)

# Ensure generated headers exist
#add_dependencies(sysnet generate_headers)

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