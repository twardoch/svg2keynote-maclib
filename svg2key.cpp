#include <iostream>
#include <sstream>
#include <string>
#include "headers/keynote.h"

int main() {
    // Read the SVG from stdin
    std::stringstream buffer;
    buffer << std::cin.rdbuf();
    std::string svg_string = buffer.str();

    // Call generateTSPNativeDataClipboardFromSVG
    std::string data_clipboard_result = generateTSPNativeDataClipboardFromSVG(svg_string);
    // Call generateTSPNativeMetadataClipboard
    std::string metadata_clipboard_result = generateTSPNativeMetadataClipboard();

    // Output the results
    std::cout << data_clipboard_result << std::endl;
    std::cerr << metadata_clipboard_result << std::endl;

    return 0;
}
