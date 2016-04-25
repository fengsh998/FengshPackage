//
//  FKResponseSetting.m
//  FKCore
//
//  Created by fengsh on 16/4/16.
//  Copyright © 2016年 fengsh. All rights reserved.
//

#import "FKResponseSetting.h"

@implementation FKResponseSetting

- (BOOL)validateResponse:( NSHTTPURLResponse *)response
                    data:( NSData *)data
                   error:(NSError * *)error
{
    return YES;
}

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
