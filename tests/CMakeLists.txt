# this_file: tests/CMakeLists.txt

cmake_minimum_required(VERSION 3.15)

# Find Catch2
find_package(Catch2 3 QUIET)
if(NOT Catch2_FOUND)
    include(FetchContent)
    FetchContent_Declare(
        Catch2
        GIT_REPOSITORY https://github.com/catchorg/Catch2.git
        GIT_TAG v3.5.1
    )
    FetchContent_MakeAvailable(Catch2)
endif()

# Test executable
file(GLOB_RECURSE TEST_SOURCES 
    unit/*.cpp 
    integration/*.cpp
)

add_executable(svg2keynote_tests
    test_main.cpp
    ${TEST_SOURCES}
)

# Link against Catch2, our library, and dependencies
target_link_libraries(svg2keynote_tests PRIVATE 
    Catch2::Catch2WithMain
    keynote_lib
    Boost::filesystem
    staticZipper
)

# Include directories
target_include_directories(svg2keynote_tests PRIVATE
    ${CMAKE_SOURCE_DIR}/keynote_lib/headers
    ${CMAKE_SOURCE_DIR}/keynote_lib
)

# Enable testing
enable_testing()
add_test(NAME svg2keynote_tests COMMAND svg2keynote_tests)

# Discover tests for CTest
if(TARGET Catch2::Catch2)
    include(Catch)
    catch_discover_tests(svg2keynote_tests)
endif()