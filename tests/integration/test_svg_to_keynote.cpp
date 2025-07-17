// this_file: tests/integration/test_svg_to_keynote.cpp

#include <catch2/catch_test_macros.hpp>
#include <string>
#include "keynote.h"

TEST_CASE("SVG to Keynote integration tests", "[integration][svg_to_keynote]") {
    
    SECTION("Complete SVG to clipboard workflow") {
        std::string sample_svg = R"(
            <svg xmlns="http://www.w3.org/2000/svg" width="200" height="200">
                <rect x="20" y="20" width="160" height="160" fill="lightblue" stroke="navy" stroke-width="2"/>
                <circle cx="100" cy="100" r="50" fill="red" opacity="0.7"/>
                <text x="100" y="180" text-anchor="middle" fill="black">Test SVG</text>
            </svg>
        )";
        
        // Generate clipboard data
        std::string clipboard_data = generateTSPNativeDataClipboardFromSVG(sample_svg);
        REQUIRE(clipboard_data.size() > 0);
        
        // Generate metadata
        std::string metadata = generateTSPNativeMetadataClipboard();
        REQUIRE(metadata.size() > 0);
        
        // Verify they're different (not the same data)
        REQUIRE(clipboard_data != metadata);
    }
    
    SECTION("Complex SVG with multiple elements") {
        std::string complex_svg = R"(
            <svg xmlns="http://www.w3.org/2000/svg" width="300" height="300">
                <defs>
                    <linearGradient id="grad1" x1="0%" y1="0%" x2="100%" y2="0%">
                        <stop offset="0%" style="stop-color:rgb(255,255,0);stop-opacity:1" />
                        <stop offset="100%" style="stop-color:rgb(255,0,0);stop-opacity:1" />
                    </linearGradient>
                </defs>
                <rect x="10" y="10" width="280" height="280" fill="url(#grad1)"/>
                <circle cx="150" cy="150" r="80" fill="blue" opacity="0.5"/>
                <polygon points="150,50 200,150 100,150" fill="green"/>
                <path d="M50,200 Q100,250 150,200 T250,200" stroke="purple" stroke-width="3" fill="none"/>
            </svg>
        )";
        
        std::string result = generateTSPNativeDataClipboardFromSVG(complex_svg);
        REQUIRE(result.size() > 0);
        
        // Complex SVG should produce more data than simple ones
        std::string simple_svg = "<svg><rect x='0' y='0' width='10' height='10'/></svg>";
        std::string simple_result = generateTSPNativeDataClipboardFromSVG(simple_svg);
        
        // Complex SVG should generally produce more clipboard data
        REQUIRE(result.size() >= simple_result.size());
    }
    
    SECTION("SVG with styling attributes") {
        std::string styled_svg = R"(
            <svg xmlns="http://www.w3.org/2000/svg" width="150" height="150">
                <rect x="10" y="10" width="130" height="130" 
                      fill="orange" 
                      stroke="black" 
                      stroke-width="5" 
                      stroke-dasharray="5,5"
                      opacity="0.8"/>
            </svg>
        )";
        
        std::string result = generateTSPNativeDataClipboardFromSVG(styled_svg);
        REQUIRE(result.size() > 0);
    }
}