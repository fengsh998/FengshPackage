//
//  FKRequestSetting.h
//  FKCore
//
//  Created by fengsh on 16/4/16.
//  Copyright © 2016年 fengsh. All rights reserved.
//

#import <Foundation/Foundation.h>
#if TARGET_OS_IOS
#import <UIKit/UIKit.h>
#elif TARGET_OS_WATCH
#import <WatchKit/WatchKit.h>
#endif
#import "FKMultipartFormData.h"

@protocol FKRequestInterface <NSObject, NSSecureCoding, NSCopying>

- (NSMutableURLRequest *)requestByURLString:(NSString *)urlstring
                                  forMethod:(NSString *)method
                             withParameters:(id)parameters
                                      error:(NSError **)error;

- (NSMutableURLRequest *)requestByURLRequest:(NSURLRequest *)request
                              withParameters:(id)parameters
                                       error:(NSError **)error;

- (NSMutableURLRequest *)multipartFormRequestWithMethod:(NSString *)method
                                              URLString:(NSString *)URLString
                                             parameters:( NSDictionary *)parameters
                              constructingBodyWithBlock:( void (^)(id <FKFormdataInterface> formData))block
                                                  error:(NSError *  __autoreleasing *)error;

@end

/**
 *                              抽象类
 */

@interface FKRequestSetting : NSObject<FKRequestInterface>
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


@property (nonatomic, strong) NSSet *HTTPMethodsEncodingParametersInURI;

/**
 请求头set ,get
 */
- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;
- (NSString *)valueForHTTPHeaderField:(NSString *)field;

/**
 设置http 头域字段"Authorization" 使用 Base64 encoded username and password.
 调用后，将会复盖原有的Authorization 头域
 
 参数 username 用户名 HTTP basic 认证方式的 username
 参数 password 密码 HTTP basic 认证方式的 password
 */
- (void)setAuthorizationHeaderFieldWithUsername:(NSString *)username
                                       password:(NSString *)password;


/**
 移除"Authorization" HTTP 头域.
 */
- (void)clearAuthorizationHeader;

@end
