//
//  FKNetworkingError.m
//  FKCore
//
//  Created by fengsh on 16/4/18.
//  Copyright © 2016年 fengsh. All rights reserved.
//

#import "FKNetworkingError.h"

//response
NSString * const URLResponseErrorDomain = @"com.fk.error.response";
NSString * const NetworkingOperationFailingURLResponseErrorKey = @"com.fk.error.response.error.response";
NSString * const NetworkingOperationFailingURLResponseDataErrorKey = @"com.fk.error.response.error.data";

// request
NSString * const URLRequestErrorDomain = @"com.fk.error.request";
NSString * const NetworkingOperationFailingURLRequestErrorKey = @"com.fk.request.error.response";

@implementation FKNetworkingError

+ (NSError *)FKErrorWithUnderlyingError:(NSError *)error withUnderlyingError:(NSError *)underlyingError;
{
    if (!error) {
        return underlyingError;
    }
    
    if (!underlyingError || error.userInfo[NSUnderlyingErrorKey]) {
        return error;
    }
    
    NSMutableDictionary *mutableUserInfo = [error.userInfo mutableCopy];
    mutableUserInfo[NSUnderlyingErrorKey] = underlyingError;
    
    return [[NSError alloc] initWithDomain:error.domain code:error.code userInfo:mutableUserInfo];
}


+ (BOOL)FKErrorOrUnderlyingErrorHasCodeInDomain:(NSError *)error withCode:(NSInteger) code withDomain:(NSString *)domain
{
    if ([error.domain isEqualToString:domain] && error.code == code) {
        return YES;
    } else if (error.userInfo[NSUnderlyingErrorKey]) {
        return [self FKErrorOrUnderlyingErrorHasCodeInDomain:error.userInfo[NSUnderlyingErrorKey] withCode:code withDomain:domain];
    }
    
    return NO;
}

+ (id)JSONObjectByRemovingKeysWithNullValues:(id)JSONObject withJsonReadingOptions:(NSJSONReadingOptions) readingOptions
{
    if ([JSONObject isKindOfClass:[NSArray class]]) {
        NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:[(NSArray *)JSONObject count]];
        for (id value in (NSArray *)JSONObject) {
            [mutableArray addObject:[self JSONObjectByRemovingKeysWithNullValues:value withJsonReadingOptions:readingOptions]];
        }
        
        return (readingOptions & NSJSONReadingMutableContainers) ? mutableArray : [NSArray arrayWithArray:mutableArray];
    } else if ([JSONObject isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:JSONObject];
        for (id <NSCopying> key in [(NSDictionary *)JSONObject allKeys]) {
            id value = (NSDictionary *)JSONObject[key];
            if (!value || [value isEqual:[NSNull null]]) {
                [mutableDictionary removeObjectForKey:key];
            } else if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) {
                mutableDictionary[key] = [self JSONObjectByRemovingKeysWithNullValues:value withJsonReadingOptions:readingOptions];
            }
        }
        
        return (readingOptions & NSJSONReadingMutableContainers) ? mutableDictionary : [NSDictionary dictionaryWithDictionary:mutableDictionary];
    }
    
    return JSONObject;
}

@end
