//
//  FKRequestSerialization.h
//  FKCore
//
//  Created by fengsh on 16/3/14.
//  Copyright © 2016年 fengsh. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FKRequestSerialization <NSObject, NSSecureCoding, NSCopying>

- (NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request
                                        withParameters:(id)parameters
                                                 error:(NSError **)error;

@end

@interface FKHttpRequestSerializer : NSObject<FKRequestSerialization>
/**
    默认:NSUTF8StringEncoding
 */
@property (nonatomic, assign) NSStringEncoding stringEncoding;

/**
    默认YES
    查看 NSMutableURLRequest -setAllowsCellularAccess:
 */
@property (nonatomic, assign) BOOL allowsCellularAccess;

/**
    缓存策略 : 默认为 NSURLRequestUseProtocolCachePolicy .
 
    查看 NSMutableURLRequest -setCachePolicy:
 */
@property (nonatomic, assign) NSURLRequestCachePolicy cachePolicy;

/**
    http cookies
    默认YES
    查看 NSMutableURLRequest -setHTTPShouldHandleCookies:
 */
@property (nonatomic, assign) BOOL HTTPShouldHandleCookies;

/**
    默认`NO`
    查看 NSMutableURLRequest -setHTTPShouldUsePipelining:
 */
@property (nonatomic, assign) BOOL HTTPShouldUsePipelining;

/**
    默认`NSURLNetworkServiceTypeDefault`.
    查看 NSMutableURLRequest -setNetworkServiceType:
 */
@property (nonatomic, assign) NSURLRequestNetworkServiceType networkServiceType;

/**
    设置请求超时,默认为 60 秒.
 
    查看 NSMutableURLRequest -setTimeoutInterval:
 */
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

/**
    http 请求头域
 */
@property (readonly, nonatomic, strong) NSDictionary *HTTPRequestHeaders;


/**
    请求头set ,get
 */
- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;
- (NSString *)valueForHTTPHeaderField:(NSString *)field;

@end
