//
//  FKNetworkingManager.m
//  FKCore
//
//  Created by fengsh on 16/3/14.
//  Copyright © 2016年 fengsh. All rights reserved.
//

#import "FKNetworkingManager.h"
#import "FKHttpRequestHandler.h"

@interface FKNetworkingManager()
{
    FKNetworking                                    *_networking;
}

@end

@implementation FKNetworkingManager

+ (instancetype)defaultManager
{
    static FKNetworkingManager *shareManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareManager = [[self alloc] init];
    });
    return shareManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self defaultConfig];
    }
    return self;
}

- (void)defaultConfig
{
    _networking = [[FKNetworking alloc]init];
    //普能rest api
    [_networking bundingRequestClass:[FKNetworkBase class] forRequestHandler:[FKHttpRequestHandler class]];
    
}

-(void)test
{
    FKNetworkBase *req = [[FKNetworkBase alloc]initWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    
    
    FKNetworkTask *task = [_networking networkTaskWithRequest:req completionBlock:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSLog(@"%@",[(NSHTTPURLResponse*)response allHeaderFields]);
        NSLog(@"%@",data);
    }];
    
    [task start];
    
    
}

@end
