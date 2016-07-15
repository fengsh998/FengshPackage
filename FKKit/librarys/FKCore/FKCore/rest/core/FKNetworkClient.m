//
//  FKNetworkClient.m
//  FKCore
//
//  Created by fengsh on 16/4/16.
//  Copyright © 2016年 fengsh. All rights reserved.
//

#import "FKNetworkClient.h"
#import "FKHttpRequestSettings.h"
#import "FKQueryStringPair.h"
#import "FKHttpResponseSettings.h"

@interface FKNetworkClient()
{
    FKNetworking            *_networking;
}
@property (nonatomic,strong,readwrite) FKRequestSetting           *requestSetting;
@property (nonatomic,strong,readwrite) FKResponseSetting          *responseSetting;
@end

@implementation FKNetworkClient

- (instancetype)init
{
    self = [super init];
    if (self) {
        _networking = [[FKNetworking alloc]init];
        _requestSetting = [FKHttpRequestSettings defaultRequestSettings];
        _responseSetting = [FKHttpResponseSettings defaultResponseSettings];
    }
    return self;
}

- (void)setRequestSetting:(FKRequestSetting *)settings
{
    _requestSetting = settings;
}

- (void)setResponseSetting:(FKResponseSetting *)settings
{
    _responseSetting = settings;
}

- (NSMutableURLRequest *)buildRequest:(NSString *)urlstring
                              headers:(NSDictionary *)headers
                               method:(NSString *)method
                           withParams:(id)params
{
     NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlstring] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0f];
    [request setHTTPMethod:method];
    
    for (NSString *key in headers.allKeys) {
        NSString *value = headers[key];
        
        [request setValue:value forHTTPHeaderField:key];
    }
    
    NSString *query = nil;
    
    if (params) {
        query = QueryStringFromParameters(params);
    }
    
    if ([@[@"GET",@"DELETE",@"HEAD"] containsObject:[method uppercaseString]]) {
        if (query) {
            request.URL = [NSURL URLWithString:[[request.URL absoluteString] stringByAppendingFormat:request.URL.query ? @"&%@" : @"?%@", query]];
        }
    }
    else
    {
        if (!query) {
            query = @"";
        }
        
        [request setHTTPBody:[query dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    return request;
}

- (FKNetworkTask *)requestUrlString:(NSString *)urlstring
                            headers:(NSDictionary *)headers
                            method:(NSString *)method
                        withParams:(id)params
                    completionBlock:(FKURLRequestCompletionBlock)completionBlock
{
    NSError *err = nil;
    
    NSMutableURLRequest *request = nil;
    
    if (_requestSetting) {
        
        for (NSString *key in headers.allKeys) {
            NSString *value = headers[key];
            
            [_requestSetting setValue:value forHTTPHeaderField:key];
        }

        request = [_requestSetting requestByURLString:urlstring forMethod:method withParameters:params error:&err];
        
        if (err) {
            if (completionBlock) {
                completionBlock(nil,nil,err);
            }
            
            return nil;
        }
    }
    else
    {
        request = [self buildRequest:urlstring headers:headers method:method withParams:params];
    }
    
    FKNetworkTask *ret = [_networking networkTaskWithRequest:request completionBlock:^(NSURLResponse *response, id responseObj, NSError *error) {
        if (_responseSetting) {
            id obj = [_responseSetting responseObjectForResponse:response data:responseObj error:&error];
            if (completionBlock) {
                completionBlock(response,obj,error);
            }
        }
        else
        {
            if (completionBlock) {
                completionBlock(response,responseObj,error);
            }
        }
    }];
    
    return ret;
}

- (FKNetworkTask *)requestGETUrlString:(NSString *)urlstring
                               headers:(NSDictionary *)headers
                            withParams:(id)params
                       completionBlock:(FKURLRequestCompletionBlock)completionBlock
{
    return [self requestUrlString:urlstring headers:headers method:@"GET" withParams:params completionBlock:completionBlock];
}

- (FKNetworkTask *)requestPOSTUrlString:(NSString *)urlstring
                                headers:(NSDictionary *)headers
                             withParams:(id)params
                        completionBlock:(FKURLRequestCompletionBlock)completionBlock
{
    return [self requestUrlString:urlstring headers:headers method:@"POST" withParams:params completionBlock:completionBlock];
}

- (FKNetworkTask *)requestHEADUrlString:(NSString *)urlstring
                                headers:(NSDictionary *)headers
                             withParams:(id)params
                        completionBlock:(FKURLRequestCompletionBlock)completionBlock
{
    return [self requestUrlString:urlstring headers:headers method:@"HEAD" withParams:params completionBlock:completionBlock];
}

- (FKNetworkTask *)requestHEADUrlString:(NSString *)urlstring
                                headers:(NSDictionary *)headers
                             withParams:(id)params
                                 method:(NSString *)method
                           withFilepath:(NSString *)filepath
                        completionBlock:(FKURLRequestCompletionBlock)completionBlock
{
    NSMutableURLRequest *request = [self buildRequest:urlstring headers:headers method:method withParams:params];
    
    return [_networking sendRequest:request withUploadFileUrl:filepath completionBlock:completionBlock];
    
}

@end
