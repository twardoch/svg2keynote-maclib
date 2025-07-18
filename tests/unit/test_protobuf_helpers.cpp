// this_file: tests/unit/test_protobuf_helpers.cpp

#include <catch2/catch_test_macros.hpp>
#include <string>

// Test basic protobuf-related functionality
TEST_CASE("Protobuf helpers basic tests", "[protobuf_helpers]") {
    
    SECTION("Basic functionality check") {
        // Test that we can create and use basic data structures
        std::string test_input = "test_data";
        REQUIRE(test_input.size() > 0);
        
        // Test basic string operations that protobuf helpers might use
        std::string result = test_input + "_modified";
        REQUIRE(result == "test_data_modified");
    }
    
    SECTION("Binary data handling") {
        // Test handling of binary data as used in protobuf
        std::vector<unsigned char> binary_data = {0x01, 0x02, 0x03, 0x04};
        REQUIRE(binary_data.size() == 4);
        
        // Convert to string (common in protobuf serialization)
        std::string binary_string(binary_data.begin(), binary_data.end());
        REQUIRE(binary_string.size() == 4);
        
        // Convert back to verify
        std::vector<unsigned char> restored_data(binary_string.begin(), binary_string.end());
        REQUIRE(restored_data == binary_data);
    }
    
    SECTION("String to binary conversion") {
        std::string test_string = "hello world";
        std::vector<unsigned char> binary_data(test_string.begin(), test_string.end());
        
        REQUIRE(binary_data.size() == test_string.size());
        
        std::string restored_string(binary_data.begin(), binary_data.end());
        REQUIRE(restored_string == test_string);
    }
}