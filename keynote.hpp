//
// Created by Jonathan Lampérth on 20.05.21.
//

#ifndef KEYNOTE_CONCEPT_TEST_H
#define KEYNOTE_CONCEPT_TEST_H

#include<iostream>
#include <headers/keynote.h>
#include "src/key_to_svg/svg_wrapper.h"

std::string decodeAndEncode(std::string protobufString);
std::string decodeAddSquareDecode(std::string protobufString);
std::string generateTSPNativeDataClipboardFromSVG(std::string filePath);
std::string generateTSPNativeMetadataClipboard();




#endif //KEYNOTE_CONCEPT_TEST_H


