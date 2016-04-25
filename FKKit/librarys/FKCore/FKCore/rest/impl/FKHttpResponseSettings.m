//
//  FKHttpResponseSettings.m
//  FKCore
//
//  Created by fengsh on 16/4/18.
//  Copyright © 2016年 fengsh. All rights reserved.
//

#import "FKHttpResponseSettings.h"
#import "FKNetworkingError.h"

@implementation FKHttpResponseSettings

+ (BOOL)supportsSecureCoding
{
    return YES;
}

+ (instancetype)defaultResponseSettings
{
    return [[[self class]alloc]init];
}

- (id)copyWithZone:(nullable NSZone *)zone
{
    FKHttpResponseSettings *settings = [[[self class]allocWithZone:zone]init];
    settings.stringEncoding = self.stringEncoding;
    settings.acceptableStatusCodes = [self.acceptableStatusCodes copyWithZone:zone];
    settings.acceptableContentTypes = [self.acceptableContentTypes copyWithZone:zone];
    return settings;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeInteger:self.stringEncoding forKey:NSStringFromSelector(@selector(stringEncoding))];
    [coder encodeObject:self.acceptableStatusCodes forKey:NSStringFromSelector(@selector(acceptableStatusCodes))];
    [coder encodeObject:self.acceptableContentTypes forKey:NSStringFromSelector(@selector(acceptableContentTypes))];
}

- (nullable instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        self.stringEncoding = [[decoder decodeObjectOfClass:[NSNumber class] forKey:NSStringFromSelector(@selector(stringEncoding))] unsignedIntegerValue];
        self.acceptableStatusCodes = [decoder decodeObjectOfClass:[NSIndexSet class] forKey:NSStringFromSelector(@selector(acceptableStatusCodes))];
        self.acceptableContentTypes = [decoder decodeObjectOfClass:[NSIndexSet class] forKey:NSStringFromSelector(@selector(acceptableContentTypes))];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.stringEncoding = NSUTF8StringEncoding;
        
        self.acceptableStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 100)];
        self.acceptableContentTypes = nil;
    }
    
    return self;
}

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError **)error
{
    [self validateResponse:(NSHTTPURLResponse *)response data:data error:error];
    
    return data;
}

- (BOOL)validateResponse:(NSHTTPURLResponse *)response
                    data:(NSData *)data
                   error:(NSError * __autoreleasing *)error
{
    BOOL responseIsValid = YES;
    NSError *validationError = nil;
    
    if (response && [response isKindOfClass:[NSHTTPURLResponse class]]) {
        if (self.acceptableContentTypes && ![self.acceptableContentTypes containsObject:[response MIMEType]]) {
            if ([data length] > 0 && [response URL]) {
                NSMutableDictionary *mutableUserInfo = [@{
                                                          NSLocalizedDescriptionKey: [NSString stringWithFormat:NSLocalizedStringFromTable(@"Request failed: unacceptable content-type: %@", @"FKNetworking", nil), [response MIMEType]],
                                                          NSURLErrorFailingURLErrorKey:[response URL],
                                                          NetworkingOperationFailingURLResponseErrorKey: response,
                                                          } mutableCopy];
                if (data) {
                    mutableUserInfo[NetworkingOperationFailingURLResponseDataErrorKey] = data;
                }
                
                validationError = [FKNetworkingError FKErrorWithUnderlyingError:[NSError errorWithDomain:URLResponseErrorDomain code:NSURLErrorCannotDecodeContentData userInfo:mutableUserInfo] withUnderlyingError:validationError];
            }
            
            responseIsValid = NO;
        }
        
        if (self.acceptableStatusCodes && ![self.acceptableStatusCodes containsIndex:(NSUInteger)response.statusCode] && [response URL]) {
            NSMutableDictionary *mutableUserInfo = [@{
                                                      NSLocalizedDescriptionKey: [NSString stringWithFormat:NSLocalizedStringFromTable(@"Request failed: %@ (%ld)", @"FKNetworking", nil), [NSHTTPURLResponse localizedStringForStatusCode:response.statusCode], (long)response.statusCode],
                                                      NSURLErrorFailingURLErrorKey:[response URL],
                                                      NetworkingOperationFailingURLResponseErrorKey: response,
                                                      } mutableCopy];
            
            if (data) {
                mutableUserInfo[NetworkingOperationFailingURLResponseDataErrorKey] = data;
            }
            
            validationError = [FKNetworkingError FKErrorWithUnderlyingError:[NSError errorWithDomain:URLResponseErrorDomain code:NSURLErrorBadServerResponse userInfo:mutableUserInfo] withUnderlyingError:validationError];
            
            responseIsValid = NO;
        }
    }
    
    if (error && !responseIsValid) {
        *error = validationError;
    }
    
    return responseIsValid;
}

@end
