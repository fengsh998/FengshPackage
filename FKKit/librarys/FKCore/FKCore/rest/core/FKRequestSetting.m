//
//  FKRequestSetting.m
//  FKCore
//
//  Created by fengsh on 16/4/16.
//  Copyright © 2016年 fengsh. All rights reserved.
//

#import "FKRequestSetting.h"


@implementation FKRequestSetting

- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field
{
    NSAssert(YES, @"Abstract class function not be allowed call.");
}

- (NSString *)valueForHTTPHeaderField:(NSString *)field
{
    NSAssert(YES, @"Abstract class function not be allowed call.");
    return nil;
}

- (void)setAuthorizationHeaderFieldWithUsername:(NSString *)username
                                       password:(NSString *)password
{
    NSAssert(YES, @"Abstract class function not be allowed call.");
}

- (void)clearAuthorizationHeader
{
    NSAssert(YES, @"Abstract class function not be allowed call.");
}

- (NSMutableURLRequest *)requestByURLString:(NSString *)urlstring
                                  forMethod:(NSString *)method
                             withParameters:(id)parameters
                                      error:(NSError **)error
{
    NSAssert(YES, @"Abstract class function not be allowed call.");
    return nil;
}

- (NSMutableURLRequest *)multipartFormRequestWithMethod:(NSString *)method
                                              URLString:(NSString *)URLString
                                             parameters:( NSDictionary *)parameters
                              constructingBodyWithBlock:( void (^)(id <FKFormdataInterface> formData))block
                                                  error:(NSError *  __autoreleasing *)error
{
    NSAssert(YES, @"Abstract class function not be allowed call.");
    return nil;
}

- (NSMutableURLRequest *)requestByURLRequest:(NSURLRequest *)request
                              withParameters:(id)parameters
                                       error:(NSError **)error
{
    NSAssert(YES, @"Abstract class function not be allowed call.");
    return nil;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    NSAssert(YES, @"Abstract class function not be allowed call.");
    return nil;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    NSAssert(YES, @"Abstract class function not be allowed call.");
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    NSAssert(YES, @"Abstract class function not be allowed call.");
    return nil;
}


@end
