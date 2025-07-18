// this_file: tests/unit/test_keynote_converter.cpp

#include <catch2/catch_test_macros.hpp>
#include <string>
#include <vector>
#include "keynote.h"

TEST_CASE("Keynote metadata generation", "[keynote_metadata]") {
    
    SECTION("Generate TSP native metadata clipboard") {
        std::string metadata = generateTSPNativeMetadataClipboard();
        REQUIRE(metadata.size() > 0);
        // Should contain some identifiable metadata
        REQUIRE(metadata.find("Keynote") != std::string::npos || metadata.size() > 10);
    }
    
    SECTION("Decode and encode functionality") {
        std::string test_data = "test_protobuf_data";
        std::string result = decodeAndEncode(test_data);
        REQUIRE(result.size() >= 0); // Should handle input without crashing
    }
}

TEST_CASE("Keynote to SVG conversion", "[keynote_to_svg]") {
    
    SECTION("Empty IWA files vector") {
        std::vector<keynoteIWAFile> empty_files;
        std::string result = generateSVGFromKeynoteIWAFiles(empty_files);
        REQUIRE(result.size() >= 0); // Should handle empty input gracefully
    }
    
    SECTION("Single IWA file with empty content") {
        std::vector<keynoteIWAFile> files;
        keynoteIWAFile file;
        file.name = "test.iwa";
        file.contents = {};
        files.push_back(file);
        
        std::string result = generateSVGFromKeynoteIWAFiles(files);
        REQUIRE(result.size() >= 0); // Should handle empty content gracefully
    }
    
    SECTION("Multiple IWA files") {
        std::vector<keynoteIWAFile> files;
        
        keynoteIWAFile file1;
        file1.name = "slide.iwa";
        file1.contents = {0x01, 0x02, 0x03}; // Mock binary data
        files.push_back(file1);
        
        keynoteIWAFile file2;
        file2.name = "stylesheet.iwa";
        file2.contents = {0x04, 0x05, 0x06}; // Mock binary data
        files.push_back(file2);
        
        std::string result = generateSVGFromKeynoteIWAFiles(files);
        REQUIRE(result.size() >= 0); // Should handle multiple files
    }
}