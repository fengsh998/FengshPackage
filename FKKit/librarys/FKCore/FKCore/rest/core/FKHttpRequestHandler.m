//
//  FKHttpRequestHandler.m
//  FKCore
//
//  Created by fengsh on 16/3/10.
//  Copyright © 2016年 fengsh. All rights reserved.
//
//              默认http/https请求
//
//

#import "FKHttpRequestHandler.h"

@interface FKHttpRequestHandler () <NSURLSessionDataDelegate>

@end

@implementation FKHttpRequestHandler
{
    NSMapTable *_delegates;
    NSURLSession *_session;
}

- (void)invalidate
{
    [_session invalidateAndCancel];
    _session = nil;
}

- (BOOL)isValid
{
    // if session == nil and delegates != nil, we've been invalidated
    return _session || !_delegates;
}

//URL 包含http或https时允许
- (BOOL)canHandleRequest:(NSURLRequest *)request
{
    static NSSet<NSString *> *schemes = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        schemes = [[NSSet alloc] initWithObjects:@"http", @"https", nil];
    });
    return [schemes containsObject:request.URL.scheme.lowercaseString];
}

- (id)sendRequest:(NSURLRequest *)request
     withDelegate:(id<FKURLRequestDelegate>)delegate
{
    if (!_session && [self isValid]) {
        
        NSOperationQueue *callbackQueue = [NSOperationQueue new];
        callbackQueue.maxConcurrentOperationCount = 5;
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:configuration
                                                 delegate:self
                                            delegateQueue:callbackQueue];
        
        _delegates = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsStrongMemory
                                               valueOptions:NSPointerFunctionsStrongMemory
                                                   capacity:0];
    }
    
    NSURLSessionDataTask *task = [_session dataTaskWithRequest:request];
    [_delegates setObject:delegate forKey:task];
    [task resume];
    return task;
}

- (void)cancelRequest:(NSURLSessionDataTask *)task
{
    [task cancel];
    [_delegates removeObjectForKey:task];
}

#pragma mark - NSURLSession 委托
/**
 *  @param session                  URLSession
 *  @param task                     task
 *  @param bytesSent                单次发送的大小
 *  @param totalBytesSent           多次发送后累加的大小
 *  @param totalBytesExpectedToSend 总大小
 */
- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    [[_delegates objectForKey:task] URLRequest:task didSendDataWithProgress:totalBytesSent withTotalBytesSend:totalBytesExpectedToSend];
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)task
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    [[_delegates objectForKey:task] URLRequest:task didReceiveResponse:response];
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)task
    didReceiveData:(NSData *)data
{
    [[_delegates objectForKey:task] URLRequest:task didReceiveData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    [[_delegates objectForKey:task] URLRequest:task didCompleteWithError:error];
    [_delegates removeObjectForKey:task];
}

@end
