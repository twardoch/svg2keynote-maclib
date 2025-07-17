// this_file: tests/unit/test_svg_parser.cpp

#include <catch2/catch_test_macros.hpp>
#include <string>
#include "keynote.h"

TEST_CASE("SVG to Keynote conversion basic tests", "[svg_conversion]") {
    
    SECTION("Empty SVG input") {
        std::string empty_svg = "";
        std::string result = generateTSPNativeDataClipboardFromSVG(empty_svg);
        REQUIRE(result.empty() == false); // Should handle empty input gracefully
    }
    
    SECTION("Simple SVG circle") {
        std::string circle_svg = R"(
            <svg xmlns="http://www.w3.org/2000/svg" width="100" height="100">
                <circle cx="50" cy="50" r="40" fill="red"/>
            </svg>
        )";
        std::string result = generateTSPNativeDataClipboardFromSVG(circle_svg);
        REQUIRE(result.size() > 0);
    }
    
    SECTION("Simple SVG rectangle") {
        std::string rect_svg = R"(
            <svg xmlns="http://www.w3.org/2000/svg" width="100" height="100">
                <rect x="10" y="10" width="80" height="80" fill="blue"/>
            </svg>
        )";
        std::string result = generateTSPNativeDataClipboardFromSVG(rect_svg);
        REQUIRE(result.size() > 0);
    }
    
    SECTION("SVG with path element") {
        std::string path_svg = R"(
            <svg xmlns="http://www.w3.org/2000/svg" width="100" height="100">
                <path d="M10,10 L90,90 L10,90 Z" fill="green"/>
            </svg>
        )";
        std::string result = generateTSPNativeDataClipboardFromSVG(path_svg);
        REQUIRE(result.size() > 0);
    }
}