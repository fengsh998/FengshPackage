//
//  FKNetworkClient.h
//  FKCore
//
//  Created by fengsh on 16/4/16.
//  Copyright © 2016年 fengsh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FKNetworking.h"
#import "FKNetworkTask.h"
#import "FKRequestSetting.h"
#import "FKResponseSetting.h"

@protocol FKRequestApi <NSObject>

- (FKNetworkTask *)requestGETUrlString:(NSString *)urlstring
                              headers:(NSDictionary *)headers
                           withParams:(id)params
                      completionBlock:(FKURLRequestCompletionBlock)completionBlock;

- (FKNetworkTask *)requestPOSTUrlString:(NSString *)urlstring
                               headers:(NSDictionary *)headers
                            withParams:(id)params
                       completionBlock:(FKURLRequestCompletionBlock)completionBlock;

- (FKNetworkTask *)requestHEADUrlString:(NSString *)urlstring
                               headers:(NSDictionary *)headers
                            withParams:(id)params
                       completionBlock:(FKURLRequestCompletionBlock)completionBlock;

@end

/*
        客户调用client
 */

@interface FKNetworkClient : NSObject<FKRequestApi>

@property (nonatomic,readonly) FKRequestSetting           *requestSetting;
@property (nonatomic,readonly) FKResponseSetting          *responseSetting;

- (void)setRequestSetting:(FKRequestSetting *)settings;
- (void)setResponseSetting:(FKResponseSetting *)settings;

@end
