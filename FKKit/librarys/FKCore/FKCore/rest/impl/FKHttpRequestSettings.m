//
//  FKHttpRequestSettings.m
//  FKCore
//
//  Created by fengsh on 16/4/16.
//  Copyright © 2016年 fengsh. All rights reserved.
//

#import "FKHttpRequestSettings.h"
#import "FKNetworkUnits.h"
#import "FKMultipartFormData.h"
#import "FKQueryStringPair.h"

@interface FKHttpRequestSettings()
@property (readwrite, nonatomic, strong) NSMutableDictionary *mutableHTTPRequestHeaders;
@end

@implementation FKHttpRequestSettings

+ (instancetype)defaultRequestSettings
{
    return [[self alloc] init];
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (!self) {
        return nil;
    }
    
    self.mutableHTTPRequestHeaders  = [[decoder decodeObjectOfClass:[NSDictionary class] forKey:NSStringFromSelector(@selector(mutableHTTPRequestHeaders))] mutableCopy];
    
    self.stringEncoding = [[decoder decodeObjectOfClass:[NSNumber class] forKey:NSStringFromSelector(@selector(stringEncoding))] unsignedIntegerValue];
    self.allowsCellularAccess = [[decoder decodeObjectOfClass:[NSNumber class] forKey:NSStringFromSelector(@selector(allowsCellularAccess))] boolValue];
    self.cachePolicy = [[decoder decodeObjectOfClass:[NSNumber class] forKey:NSStringFromSelector(@selector(cachePolicy))] integerValue];
    self.HTTPShouldHandleCookies = [[decoder decodeObjectOfClass:[NSNumber class] forKey:NSStringFromSelector(@selector(HTTPShouldHandleCookies))] integerValue];
    self.HTTPShouldUsePipelining = [[decoder decodeObjectOfClass:[NSNumber class] forKey:NSStringFromSelector(@selector(HTTPShouldUsePipelining))] integerValue];
    self.networkServiceType = [[decoder decodeObjectOfClass:[NSNumber class] forKey:NSStringFromSelector(@selector(networkServiceType))] integerValue];
    self.timeoutInterval = [[decoder decodeObjectOfClass:[NSNumber class] forKey:NSStringFromSelector(@selector(timeoutInterval))] integerValue];
        
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.mutableHTTPRequestHeaders forKey:NSStringFromSelector(@selector(mutableHTTPRequestHeaders))];
    
    [coder encodeInteger:self.stringEncoding forKey:NSStringFromSelector(@selector(stringEncoding))];
    [coder encodeBool:self.allowsCellularAccess forKey:NSStringFromSelector(@selector(allowsCellularAccess))];
    [coder encodeInteger:self.cachePolicy forKey:NSStringFromSelector(@selector(cachePolicy))];
    [coder encodeInteger:self.HTTPShouldHandleCookies forKey:NSStringFromSelector(@selector(HTTPShouldHandleCookies))];
    [coder encodeInteger:self.HTTPShouldUsePipelining forKey:NSStringFromSelector(@selector(HTTPShouldUsePipelining))];
    [coder encodeInteger:self.networkServiceType forKey:NSStringFromSelector(@selector(networkServiceType))];
    [coder encodeDouble:self.timeoutInterval forKey:NSStringFromSelector(@selector(timeoutInterval))];
    
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    FKHttpRequestSettings *settings = [[[self class] allocWithZone:zone] init];
    settings.mutableHTTPRequestHeaders = [self.mutableHTTPRequestHeaders mutableCopyWithZone:zone];
    
    return settings;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.stringEncoding = NSUTF8StringEncoding;
        //http 头域
        self.mutableHTTPRequestHeaders = [NSMutableDictionary dictionary];
        
        // HTTP Method Definitions; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec9.html
        self.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET", @"HEAD", @"DELETE", nil];
        
        [self setDefaultHeaders];
    }
    
    return self;
}

#pragma mark - 默认头域
- (void)setDefaultHeaders
{
    // Accept-Language HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.4
    NSMutableArray *acceptLanguagesComponents = [NSMutableArray array];
    [[NSLocale preferredLanguages] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        float q = 1.0f - (idx * 0.1f);
        [acceptLanguagesComponents addObject:[NSString stringWithFormat:@"%@;q=%0.1g", obj, q]];
        *stop = q <= 0.5f;
    }];
    [self setValue:[acceptLanguagesComponents componentsJoinedByString:@", "] forHTTPHeaderField:@"Accept-Language"];
    
    NSString *userAgent = nil;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
#if TARGET_OS_IOS
    // User-Agent Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.43
    userAgent = [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)", [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleExecutableKey] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey], [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [[UIScreen mainScreen] scale]];
#elif TARGET_OS_WATCH
    // User-Agent Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.43
    userAgent = [NSString stringWithFormat:@"%@/%@ (%@; watchOS %@; Scale/%0.2f)", [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleExecutableKey] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey], [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey], [[WKInterfaceDevice currentDevice] model], [[WKInterfaceDevice currentDevice] systemVersion], [[WKInterfaceDevice currentDevice] screenScale]];
#elif defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
    userAgent = [NSString stringWithFormat:@"%@/%@ (Mac OS X %@)", [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleExecutableKey] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey], [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey], [[NSProcessInfo processInfo] operatingSystemVersionString]];
#endif
    
#pragma clang diagnostic pop
    if (userAgent) {
        if (![userAgent canBeConvertedToEncoding:NSASCIIStringEncoding]) {
            NSMutableString *mutableUserAgent = [userAgent mutableCopy];
            if (CFStringTransform((__bridge CFMutableStringRef)(mutableUserAgent), NULL, (__bridge CFStringRef)@"Any-Latin; Latin-ASCII; [:^ASCII:] Remove", false)) {
                userAgent = mutableUserAgent;
            }
        }
        [self setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    }
}

#pragma mark - Getter 方法
- (NSDictionary *)HTTPRequestHeaders {
    return [NSDictionary dictionaryWithDictionary:self.mutableHTTPRequestHeaders];
}

- (void)setValue:(NSString *)value
forHTTPHeaderField:(NSString *)field
{
    [self.mutableHTTPRequestHeaders setValue:value forKey:field];
}

- (NSString *)valueForHTTPHeaderField:(NSString *)field {
    return [self.mutableHTTPRequestHeaders valueForKey:field];
}

- (void)setAuthorizationHeaderFieldWithUsername:(NSString *)username
                                       password:(NSString *)password
{
    NSString *basicAuthCredentials = [NSString stringWithFormat:@"%@:%@", username, password];
    [self setValue:[NSString stringWithFormat:@"Basic %@", Base64EncodedStringFromString(basicAuthCredentials)] forHTTPHeaderField:@"Authorization"];
}

- (void)clearAuthorizationHeader {
    [self.mutableHTTPRequestHeaders removeObjectForKey:@"Authorization"];
}

#pragma mark - 构造请求参数
- (NSMutableURLRequest *)requestByURLString:(NSString *)urlstring
                                  forMethod:(NSString *)method
                             withParameters:(id)parameters
                                      error:(NSError **)error
{
    NSParameterAssert(method);
    NSParameterAssert(urlstring);
    
    NSURL *url = [NSURL URLWithString:urlstring];
    
    NSParameterAssert(url);
    
    NSMutableURLRequest *mutableRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    mutableRequest.HTTPMethod = method;
    
    mutableRequest = [self requestByURLRequest:mutableRequest withParameters:parameters error:error];
    
    return mutableRequest;
}

- (NSMutableURLRequest *)requestByURLRequest:(NSURLRequest *)request
                              withParameters:(id)parameters
                                       error:(NSError **)error
{
    NSParameterAssert(request);
    
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    
    [self.HTTPRequestHeaders enumerateKeysAndObjectsUsingBlock:^(id field, id value, BOOL * __unused stop) {
        if (![request valueForHTTPHeaderField:field]) {
            [mutableRequest setValue:value forHTTPHeaderField:field];
        }
    }];
    
    NSString *query = nil;
    
    if (parameters) {
        query = QueryStringFromParameters(parameters);
    }
    
    //对GET HEAD DELETE 使用querystring 的方式传参
    if ([self.HTTPMethodsEncodingParametersInURI containsObject:[[request HTTPMethod] uppercaseString]]) {
        if (query) {
            mutableRequest.URL = [NSURL URLWithString:[[mutableRequest.URL absoluteString] stringByAppendingFormat:mutableRequest.URL.query ? @"&%@" : @"?%@", query]];
        }
    }
    else
    {
        // #2864: an empty string is a valid x-www-form-urlencoded payload
        if (!query) {
            query = @"";
        }
        
        if (![mutableRequest valueForHTTPHeaderField:@"Content-Type"]) {
            [mutableRequest setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        }
        
        [mutableRequest setHTTPBody:[query dataUsingEncoding:self.stringEncoding]];
    }
    
    return mutableRequest;
}

- (NSMutableURLRequest *)multipartFormRequestWithMethod:(NSString *)method
                                              URLString:(NSString *)URLString
                                             parameters:( NSDictionary *)parameters
                              constructingBodyWithBlock:( void (^)(id <FKFormdataInterface> formData))block
                                                  error:(NSError *  __autoreleasing *)error
{
    NSParameterAssert(method);
    NSParameterAssert(![method isEqualToString:@"GET"] && ![method isEqualToString:@"HEAD"]);
    
    NSMutableURLRequest *mutableRequest = [self requestByURLString:URLString forMethod:method withParameters:parameters error:error];
    
    __block FKMultipartFormData *formData = [[FKMultipartFormData alloc] initWithURLRequest:mutableRequest stringEncoding:NSUTF8StringEncoding];
    
    if (parameters) {
        for (FKQueryStringPair *pair in QueryStringPairsFromDictionary(parameters)) {
            NSData *data = nil;
            if ([pair.value isKindOfClass:[NSData class]]) {
                data = pair.value;
            } else if ([pair.value isEqual:[NSNull null]]) {
                data = [NSData data];
            } else {
                data = [[pair.value description] dataUsingEncoding:self.stringEncoding];
            }
            
            if (data) {
                [formData appendPartWithFormData:data name:[pair.field description]];
            }
        }
    }
    
    if (block) {
        block(formData);
    }
    
    return [formData requestFromMultipartFormData];
}

@end
