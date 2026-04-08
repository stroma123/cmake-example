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