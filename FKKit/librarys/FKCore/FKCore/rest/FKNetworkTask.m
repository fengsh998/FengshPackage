//
//  FKNetworkTask.m
//  FKCore
//
//  Created by fengsh on 16/3/10.
//  Copyright © 2016年 fengsh. All rights reserved.
//

#import "FKNetworkTask.h"

#define FUNCTION_NOT_IMPLEMENTED(method) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wmissing-method-return-type\"") \
_Pragma("clang diagnostic ignored \"-Wunused-parameter\"") \
NSException *_FKNotImplementedException(SEL, Class); \
method NS_UNAVAILABLE { @throw _FKNotImplementedException(_cmd, [self class]); } \
_Pragma("clang diagnostic pop")

NSException *_FKNotImplementedException(SEL, Class);
NSException *_FKNotImplementedException(SEL cmd, Class cls)
{
    NSString *msg = [NSString stringWithFormat:@"%s is not implemented "
                     "for the class %@", sel_getName(cmd), cls];
    return [NSException exceptionWithName:@"FKNotDesignatedInitializerException"
                                   reason:msg userInfo:nil];
}

@implementation FKNetworkTask
{
    NSMutableData *_data;
    id<FKURLRequestHandler> _handler;
    FKNetworkTask *_selfReference;
}

- (instancetype)initWithRequest:(NSURLRequest *)request
                        handler:(id<FKURLRequestHandler>)handler
                completionBlock:(FKURLRequestCompletionBlock)completionBlock
{
    static NSUInteger requestID = 0;
    
    if ((self = [super init])) {
        _requestID = @(requestID++);
        _request = request;
        _handler = handler;
        _completionBlock = completionBlock;
    }
    return self;
}

FUNCTION_NOT_IMPLEMENTED(- (instancetype)init)

- (void)invalidate
{
    _selfReference = nil;
    _completionBlock = nil;
    _downloadProgressBlock = nil;
    _incrementalDataBlock = nil;
    _responseBlock = nil;
    _uploadProgressBlock = nil;
}


- (void)start
{
    if (_requestToken == nil) {
        //TODO : requestSerializer
        
        
        if ([self validateRequestToken:[_handler sendRequest:_request
                                                withDelegate:self]]) {
            _selfReference = self;
        }
    }
}

- (void)cancel
{
    __strong id strongToken = _requestToken;
    if (strongToken && [_handler respondsToSelector:@selector(cancelRequest:)]) {
        [_handler cancelRequest:strongToken];
    }
    [self invalidate];
}

- (BOOL)validateRequestToken:(id)requestToken
{
    if (_requestToken == nil) {
        if (requestToken == nil) {
            return NO;
        }
        _requestToken = requestToken;
    }
    
    if (![requestToken isEqual:_requestToken]) {

        if (_completionBlock) {
            
            _completionBlock(_response, _data, [NSError errorWithDomain:@"FKErrorDomain" code:0
                                                               userInfo:@{NSLocalizedDescriptionKey: @"Unrecognized request token."}]);
            [self invalidate];
        }
        return NO;
    }
    return YES;
}

#pragma 代理
- (void)URLRequest:(id)requestToken didSendDataWithProgress:(int64_t)bytesSent
{
    if ([self validateRequestToken:requestToken]) {
        if (_uploadProgressBlock) {
            _uploadProgressBlock(bytesSent, _request.HTTPBody.length);
        }
    }
}

- (void)URLRequest:(id)requestToken didReceiveResponse:(NSURLResponse *)response
{
    if ([self validateRequestToken:requestToken]) {
        _response = response;
        if (_responseBlock) {
            _responseBlock(response);
        }
    }
}

- (void)URLRequest:(id)requestToken didReceiveData:(NSData *)data
{
    if ([self validateRequestToken:requestToken]) {
        if (!_data) {
            _data = [NSMutableData new];
        }
        [_data appendData:data];
        if (_incrementalDataBlock) {
            _incrementalDataBlock(data);
        }
        if (_downloadProgressBlock && _response.expectedContentLength > 0) {
            _downloadProgressBlock(_data.length, _response.expectedContentLength);
        }
    }
}

- (void)URLRequest:(id)requestToken didCompleteWithError:(NSError *)error
{
    if ([self validateRequestToken:requestToken]) {
        if (_completionBlock) {
            
            ////TODO : responseSerializer
            _completionBlock(_response, _data, error);
            [self invalidate];
        }
    }
}

@end
