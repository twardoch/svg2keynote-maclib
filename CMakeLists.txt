cmake_minimum_required(VERSION 3.15)
project(keynote)

# Enable Objective-C only on macOS
if(APPLE)
    enable_language(OBJC)
endif()

# Version detection from git tags
find_package(Git QUIET)
if(GIT_FOUND)
    execute_process(
        COMMAND ${GIT_EXECUTABLE} describe --tags --abbrev=0 --match "v*"
        OUTPUT_VARIABLE GIT_TAG
        OUTPUT_STRIP_TRAILING_WHITESPACE
        ERROR_QUIET
    )
    if(GIT_TAG)
        string(REGEX REPLACE "^v" "" VERSION_STRING ${GIT_TAG})
        string(REGEX REPLACE "^([0-9]+)\\..*" "\\1" VERSION_MAJOR ${VERSION_STRING})
        string(REGEX REPLACE "^[0-9]+\\.([0-9]+).*" "\\1" VERSION_MINOR ${VERSION_STRING})
        string(REGEX REPLACE "^[0-9]+\\.[0-9]+\\.([0-9]+).*" "\\1" VERSION_PATCH ${VERSION_STRING})
    else()
        set(VERSION_STRING "0.0.0-dev")
        set(VERSION_MAJOR 0)
        set(VERSION_MINOR 0)
        set(VERSION_PATCH 0)
    endif()
else()
    set(VERSION_STRING "0.0.0-dev")
    set(VERSION_MAJOR 0)
    set(VERSION_MINOR 0)
    set(VERSION_PATCH 0)
endif()

# Set project version
set(PROJECT_VERSION ${VERSION_STRING})
message(STATUS "Project version: ${VERSION_STRING}")

# Generate version header
configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake/version.hpp.in"
    "${CMAKE_CURRENT_BINARY_DIR}/version.hpp"
    @ONLY
)

# Make version header available to all targets
include_directories(${CMAKE_CURRENT_BINARY_DIR})


set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_FLAGS_RELEASE "-O3")
set(CMAKE_CXX_FLAGS_DEBUG "-g")
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(Boost_USE_STATIC_LIBS ON)

find_package(Boost 1.70 COMPONENTS filesystem REQUIRED)

add_subdirectory(zipper)
add_subdirectory(keynote_lib)

# Add testing support
option(BUILD_TESTING "Build tests" ON)
if(BUILD_TESTING)
    enable_testing()
    add_subdirectory(tests)
endif()

# Add svg2key CLI tool (macOS only)
if(APPLE)
    add_executable(svg2key svg2key.mm keynote_lib/src/key_to_svg/svg_wrapper.cpp keynote_lib/src/key_to_svg/svg_wrapper.h)
    target_link_libraries(svg2key Boost::filesystem)
    target_link_libraries(svg2key staticZipper)

    target_include_directories(svg2key PUBLIC keynote_lib)
    target_link_directories(svg2key PRIVATE keynote_lib)
    target_link_libraries(svg2key keynote_lib)

    # Link Objective-C frameworks
    find_library(COCOA_LIBRARY Cocoa)
    target_link_libraries(svg2key ${COCOA_LIBRARY})
endif()
