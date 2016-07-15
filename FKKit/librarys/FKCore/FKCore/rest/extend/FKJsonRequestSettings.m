//
//  FKJsonRequestSettings.m
//  FKCore
//
//  Created by fengsh on 16/4/18.
//  Copyright © 2016年 fengsh. All rights reserved.
//

#import "FKJsonRequestSettings.h"

@implementation FKJsonRequestSettings


+ (instancetype)defaultRequestSettings {
    return [self jsonRequestWithWritingOptions:(NSJSONWritingOptions)0];
}

+ (instancetype)jsonRequestWithWritingOptions:(NSJSONWritingOptions)writingOptions
{
    FKJsonRequestSettings *jsonrequest = [[FKJsonRequestSettings alloc] init];
    jsonrequest.writingOptions = writingOptions;
    return jsonrequest;
}

- (NSMutableURLRequest *)requestByURLRequest:(NSURLRequest *)request
                              withParameters:(id)parameters
                                       error:(NSError **)error
{
    NSParameterAssert(request);
    
    if ([self.HTTPMethodsEncodingParametersInURI containsObject:[[request HTTPMethod] uppercaseString]]) {
        return [super requestByURLRequest:request withParameters:parameters error:error];
    }
    
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    
    [self.HTTPRequestHeaders enumerateKeysAndObjectsUsingBlock:^(id field, id value, BOOL * __unused stop) {
        if (![request valueForHTTPHeaderField:field]) {
            [mutableRequest setValue:value forHTTPHeaderField:field];
        }
    }];
    
    if (parameters) {
        if (![mutableRequest valueForHTTPHeaderField:@"Content-Type"]) {
            [mutableRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        }
        
        [mutableRequest setHTTPBody:[NSJSONSerialization dataWithJSONObject:parameters options:self.writingOptions error:error]];
    }
    
    return mutableRequest;
}

#pragma mark - NSSecureCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (!self) {
        return nil;
    }
    
    self.writingOptions = [[decoder decodeObjectOfClass:[NSNumber class] forKey:NSStringFromSelector(@selector(writingOptions))] unsignedIntegerValue];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];
    
    [coder encodeInteger:self.writingOptions forKey:NSStringFromSelector(@selector(writingOptions))];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    FKJsonRequestSettings *jsonsettings = [super copyWithZone:zone];
    jsonsettings.writingOptions = self.writingOptions;
    
    return jsonsettings;
}

@end
