//
//  FKNetworkClient.h
//  FKCore
//
//  Created by fengsh on 16/4/16.
//  Copyright © 2016年 fengsh. All rights reserved.
//
/**
 *          FKNetworkclient 终端发起请求
 *
 *         每个client 实例最大支持5个并发线程，每个callback 都为子线程
 *
 */

#import <Foundation/Foundation.h>
#import "FKNetworking.h"
#import "FKNetworkTask.h"
#import "FKRequestSetting.h"
#import "FKResponseSetting.h"

@protocol FKRequestApi <NSObject>

/**
 *  GET 请求
 *
 *  @param urlstring       请求url
 *  @param headers         自定义请求头域key-value
 *  @param params          请求参数querystring
 *  @param completionBlock callback
 *
 *  @return 实例
 */
- (FKNetworkTask *)requestGETUrlString:(NSString *)urlstring
                              headers:(NSDictionary *)headers
                           withParams:(id)params
                      completionBlock:(FKURLRequestCompletionBlock)completionBlock;

/**
 *  POST 请求
 */
- (FKNetworkTask *)requestPOSTUrlString:(NSString *)urlstring
                               headers:(NSDictionary *)headers
                            withParams:(id)params
                       completionBlock:(FKURLRequestCompletionBlock)completionBlock;

/**
 *  HEAD 请求
 */
- (FKNetworkTask *)requestHEADUrlString:(NSString *)urlstring
                               headers:(NSDictionary *)headers
                            withParams:(id)params
                       completionBlock:(FKURLRequestCompletionBlock)completionBlock;

- (FKNetworkTask *)requestHEADUrlString:(NSString *)urlstring
                                headers:(NSDictionary *)headers
                             withParams:(id)params
                                 method:(NSString *)method
                           withFilepath:(NSString *)filepath
                        completionBlock:(FKURLRequestCompletionBlock)completionBlock;

@end

/*
        客户调用client
 */

@interface FKNetworkClient : NSObject<FKRequestApi>
///设置一批相同配置的请求配置
@property (nonatomic,readonly) FKRequestSetting           *requestSetting;
///设置一批相同请求的响应处理配置
@property (nonatomic,readonly) FKResponseSetting          *responseSetting;

- (void)setRequestSetting:(FKRequestSetting *)settings;
- (void)setResponseSetting:(FKResponseSetting *)settings;

@end
