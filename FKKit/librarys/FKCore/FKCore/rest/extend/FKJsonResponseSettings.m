//
//  FKJsonResponseSettings.m
//  FKCore
//
//  Created by fengsh on 16/4/18.
//  Copyright © 2016年 fengsh. All rights reserved.
//

#import "FKJsonResponseSettings.h"
#import "FKNetworkingError.h"

@implementation FKJsonResponseSettings

+ (instancetype)defaultResponseSettings
{
    return [self responseWithReadingOptions:(NSJSONReadingOptions)0];
}

+ (instancetype)responseWithReadingOptions:(NSJSONReadingOptions)readingOptions
{
    FKJsonResponseSettings *response = [[self alloc] init];
    response.readingOptions = readingOptions;
    
    return response;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    }
    
    return self;
}

#pragma mark - AFURLResponseSerialization

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError **)error;
{
    if (![self validateResponse:(NSHTTPURLResponse *)response data:data error:error]) {
        if (!error || [FKNetworkingError FKErrorOrUnderlyingErrorHasCodeInDomain:*error withCode:NSURLErrorCannotDecodeContentData withDomain:URLResponseErrorDomain]) {
            return nil;
        }
    }
    
    // Workaround for behavior of Rails to return a single space for `head :ok` (a workaround for a bug in Safari), which is not interpreted as valid input by NSJSONSerialization.
    // See https://github.com/rails/rails/issues/1742
    NSStringEncoding stringEncoding = self.stringEncoding;
    if (response.textEncodingName) {
        CFStringEncoding encoding = CFStringConvertIANACharSetNameToEncoding((CFStringRef)response.textEncodingName);
        if (encoding != kCFStringEncodingInvalidId) {
            stringEncoding = CFStringConvertEncodingToNSStringEncoding(encoding);
        }
    }
    
    id responseObject = nil;
    NSError *serializationError = nil;
    @autoreleasepool {
        NSString *responseString = [[NSString alloc] initWithData:data encoding:stringEncoding];
        if (responseString && ![responseString isEqualToString:@" "]) {
            // Workaround for a bug in NSJSONSerialization when Unicode character escape codes are used instead of the actual character
            // See http://stackoverflow.com/a/12843465/157142
            data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
            
            if (data) {
                if ([data length] > 0) {
                    responseObject = [NSJSONSerialization JSONObjectWithData:data options:self.readingOptions error:&serializationError];
                } else {
                    return nil;
                }
            } else {
                NSDictionary *userInfo = @{
                                           NSLocalizedDescriptionKey: NSLocalizedStringFromTable(@"Data failed decoding as a UTF-8 string", @"FKNetworking", nil),
                                           NSLocalizedFailureReasonErrorKey: [NSString stringWithFormat:NSLocalizedStringFromTable(@"Could not decode string: %@", @"FKNetworking", nil), responseString]
                                           };
                
                serializationError = [NSError errorWithDomain:URLResponseErrorDomain code:NSURLErrorCannotDecodeContentData userInfo:userInfo];
            }
        }
    }
    
    if (self.removesKeysWithNullValues && responseObject) {
        responseObject = [FKNetworkingError JSONObjectByRemovingKeysWithNullValues:responseObject withJsonReadingOptions:self.readingOptions];//JSONObjectByRemovingKeysWithNullValues(responseObject, self.readingOptions);
    }
    
    if (error) {
        *error = [FKNetworkingError FKErrorWithUnderlyingError:serializationError withUnderlyingError:*error];//FKErrorWithUnderlyingError(serializationError, *error);
    }
    
    return responseObject;
}

#pragma mark - NSSecureCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        self.readingOptions = [[decoder decodeObjectOfClass:[NSNumber class] forKey:NSStringFromSelector(@selector(readingOptions))] unsignedIntegerValue];
        self.removesKeysWithNullValues = [[decoder decodeObjectOfClass:[NSNumber class] forKey:NSStringFromSelector(@selector(removesKeysWithNullValues))] boolValue];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    
    [coder encodeObject:@(self.readingOptions) forKey:NSStringFromSelector(@selector(readingOptions))];
    [coder encodeObject:@(self.removesKeysWithNullValues) forKey:NSStringFromSelector(@selector(removesKeysWithNullValues))];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    FKJsonResponseSettings *response = [super copyWithZone:zone];
    response.readingOptions = self.readingOptions;
    response.removesKeysWithNullValues = self.removesKeysWithNullValues;
    
    return response;
}
@end
