// this_file: tests/test_main.cpp

#include <catch2/catch_test_macros.hpp>

// Test that the test framework is working
TEST_CASE("Test framework setup", "[setup]") {
    REQUIRE(true);
    REQUIRE(1 + 1 == 2);
}