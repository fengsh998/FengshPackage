//
//  FKNetworkTask.h
//  FKCore
//
//  Created by fengsh on 16/3/10.
//  Copyright © 2016年 fengsh. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FKURLRequestDelegate.h"
#import "FKURLRequestHandler.h"

typedef void (^FKURLRequestCompletionBlock)(NSURLResponse *response, NSData *data, NSError *error);
typedef void (^FKURLRequestCancellationBlock)(void);
typedef void (^FKURLRequestIncrementalDataBlock)(NSData *data);
typedef void (^FKURLRequestProgressBlock)(int64_t progress, int64_t total);
typedef void (^FKURLRequestResponseBlock)(NSURLResponse *response);

@interface FKNetworkTask : NSObject <FKURLRequestDelegate>

@property (nonatomic, readonly) NSURLRequest *request;
@property (nonatomic, readonly) NSNumber *requestID;
@property (nonatomic, readonly, weak) id requestToken;
@property (nonatomic, readonly) NSURLResponse *response;
@property (nonatomic, readonly) FKURLRequestCompletionBlock completionBlock;

@property (nonatomic, copy) FKURLRequestProgressBlock downloadProgressBlock;
@property (nonatomic, copy) FKURLRequestIncrementalDataBlock incrementalDataBlock;
@property (nonatomic, copy) FKURLRequestResponseBlock responseBlock;
@property (nonatomic, copy) FKURLRequestProgressBlock uploadProgressBlock;

- (instancetype)initWithRequest:(NSURLRequest *)request
                        handler:(id<FKURLRequestHandler>)handler
                completionBlock:(FKURLRequestCompletionBlock)completionBlock NS_DESIGNATED_INITIALIZER;

//开始请求
- (void)start;
//取消请求
- (void)cancel;

@end
