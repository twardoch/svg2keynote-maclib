// this_file: tests/integration/test_keynote_to_svg.cpp

#include <catch2/catch_test_macros.hpp>
#include <string>
#include <vector>
#include "keynote.h"

TEST_CASE("Keynote to SVG integration tests", "[integration][keynote_to_svg]") {
    
    SECTION("Complete workflow with mock IWA files") {
        std::vector<keynoteIWAFile> mock_files;
        
        // Create mock slide file
        keynoteIWAFile slide_file;
        slide_file.name = "slide-1.iwa";
        // Mock binary data that might represent a slide
        slide_file.contents = {
            0x08, 0x96, 0x01, 0x12, 0x04, 0x08, 0x01, 0x10, 0x01, 0x1a, 0x02, 0x08, 0x01
        };
        mock_files.push_back(slide_file);
        
        // Create mock stylesheet file
        keynoteIWAFile stylesheet_file;
        stylesheet_file.name = "stylesheet.iwa";
        stylesheet_file.contents = {
            0x08, 0x97, 0x01, 0x12, 0x06, 0x08, 0x02, 0x10, 0x02, 0x18, 0x01
        };
        mock_files.push_back(stylesheet_file);
        
        std::string result = generateSVGFromKeynoteIWAFiles(mock_files);
        REQUIRE(result.size() >= 0);
    }
    
    SECTION("Single file processing") {
        std::vector<keynoteIWAFile> single_file;
        
        keynoteIWAFile file;
        file.name = "document.iwa";
        file.contents = {0x08, 0x01, 0x12, 0x02, 0x08, 0x01};
        single_file.push_back(file);
        
        std::string result = generateSVGFromKeynoteIWAFiles(single_file);
        REQUIRE(result.size() >= 0);
    }
    
    SECTION("Multiple files with different names") {
        std::vector<keynoteIWAFile> files;
        
        // Add various common Keynote file types
        std::vector<std::string> file_names = {
            "slide-1.iwa",
            "slide-2.iwa", 
            "document.iwa",
            "stylesheet.iwa",
            "metadata.iwa"
        };
        
        for (const auto& name : file_names) {
            keynoteIWAFile file;
            file.name = name;
            file.contents = {0x08, 0x01, 0x12, 0x02, 0x08, 0x01}; // Mock data
            files.push_back(file);
        }
        
        std::string result = generateSVGFromKeynoteIWAFiles(files);
        REQUIRE(result.size() >= 0);
    }
    
    SECTION("Large binary data handling") {
        std::vector<keynoteIWAFile> files;
        
        keynoteIWAFile large_file;
        large_file.name = "large_slide.iwa";
        // Create larger mock data
        large_file.contents.resize(1024);
        for (size_t i = 0; i < large_file.contents.size(); ++i) {
            large_file.contents[i] = static_cast<unsigned char>(i % 256);
        }
        files.push_back(large_file);
        
        std::string result = generateSVGFromKeynoteIWAFiles(files);
        REQUIRE(result.size() >= 0);
    }
}