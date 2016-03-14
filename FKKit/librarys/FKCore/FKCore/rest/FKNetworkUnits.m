//
//  FKNetworkUnits.m
//  FKCore
//
//  Created by fengsh on 16/3/10.
//  Copyright © 2016年 fengsh. All rights reserved.
//

#import "FKNetworkUnits.h"

//#import <mach/mach_time.h>
//#import <objc/message.h>
//#import <CommonCrypto/CommonCrypto.h>
#import <zlib.h>
#import <dlfcn.h>

BOOL FKIsGzippedData(NSData *data)
{
    UInt8 *bytes = (UInt8 *)data.bytes;
    return (data.length >= 2 && bytes[0] == 0x1f && bytes[1] == 0x8b);
}

NSData *FKGzipData(NSData *input, float level)
{
    if (input.length == 0 || FKIsGzippedData(input)) {
        return input;
    }
    
    void *libz = dlopen("/usr/lib/libz.dylib", RTLD_LAZY);
    int (*deflateInit2_)(z_streamp, int, int, int, int, int, const char *, int) = dlsym(libz, "deflateInit2_");
    int (*deflate)(z_streamp, int) = dlsym(libz, "deflate");
    int (*deflateEnd)(z_streamp) = dlsym(libz, "deflateEnd");
    
    z_stream stream;
    stream.zalloc = Z_NULL;
    stream.zfree = Z_NULL;
    stream.opaque = Z_NULL;
    stream.avail_in = (uint)input.length;
    stream.next_in = (Bytef *)input.bytes;
    stream.total_out = 0;
    stream.avail_out = 0;
    
    static const NSUInteger GZipChunkSize = 16384;
    
    NSMutableData *output = nil;
    int compression = (level < 0.0f)? Z_DEFAULT_COMPRESSION: (int)(roundf(level * 9));
    if (deflateInit2(&stream, compression, Z_DEFLATED, 31, 8, Z_DEFAULT_STRATEGY) == Z_OK) {
        output = [NSMutableData dataWithLength:GZipChunkSize];
        while (stream.avail_out == 0) {
            if (stream.total_out >= output.length) {
                output.length += GZipChunkSize;
            }
            stream.next_out = (uint8_t *)output.mutableBytes + stream.total_out;
            stream.avail_out = (uInt)(output.length - stream.total_out);
            deflate(&stream, Z_FINISH);
        }
        deflateEnd(&stream);
        output.length = stream.total_out;
    }
    
    dlclose(libz);
    
    return output;
}