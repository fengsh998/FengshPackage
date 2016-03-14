//
//  FKResopnseSerialization.m
//  FKCore
//
//  Created by fengsh on 16/3/14.
//  Copyright © 2016年 fengsh. All rights reserved.
//

#import "FKResopnseSerialization.h"

@implementation FKResopnseSerializer

+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError **)error
{
    return nil;
}

- (BOOL)validateResponse:( NSHTTPURLResponse *)response
                    data:( NSData *)data
                   error:(NSError * *)error
{
    return NO;
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
