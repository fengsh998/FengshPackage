//
//  FKRequestSerialization.m
//  FKCore
//
//  Created by fengsh on 16/3/14.
//  Copyright © 2016年 fengsh. All rights reserved.
//

#import "FKRequestSerialization.h"

@implementation FKHttpRequestSerializer

+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request
                               withParameters:(id)parameters
                                        error:(NSError **)error
{
    return  nil;
}

- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field
{
    
}

- (NSString *)valueForHTTPHeaderField:(NSString *)field
{
    return nil;
}


- (id)copyWithZone:(nullable NSZone *)zone
{
    return nil;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    return nil;
}

@end
