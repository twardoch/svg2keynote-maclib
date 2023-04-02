#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#include "keynote.hpp"

@interface CPP_Wrapper : NSObject
- (NSData *)generateClipboardForTSPNativeData:(NSString *)filePath;
- (NSData *)generateClipboardMetadata;
@end

@implementation CPP_Wrapper

- (NSData *)generateClipboardForTSPNativeData:(NSString *)filePath {
    std::string stddata([filePath UTF8String]);
    std::string response = generateTSPNativeDataClipboardFromSVG(stddata);
    return [[NSData alloc] initWithBytes:response.data() length:response.length()];
}

- (NSData *)generateClipboardMetadata {
    std::string response = generateTSPNativeMetadataClipboard();
    return [[NSData alloc] initWithBytes:response.data() length:response.length()];
}
@end

int main(int argc, const char *argv[]) {
    @autoreleasepool {
        CPP_Wrapper *wrapper = [[CPP_Wrapper alloc] init];

        NSFileHandle *stdinHandle = [NSFileHandle fileHandleWithStandardInput];
        NSData *inputData = [stdinHandle readDataToEndOfFile];
        NSString *inputString = [[NSString alloc] initWithData:inputData encoding:NSUTF8StringEncoding];

        NSData *clipboardData = [wrapper generateClipboardForTSPNativeData:inputString];
        NSData *clipboardMetadata = [wrapper generateClipboardMetadata];

        NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
        [pasteboard clearContents];

        [pasteboard setData:clipboardData forType:@"com.apple.iWork.TSPNativeData"];
        [pasteboard setData:clipboardMetadata forType:@"com.apple.iWork.TSPNativeMetadata"];
    }
    return 0;
}
