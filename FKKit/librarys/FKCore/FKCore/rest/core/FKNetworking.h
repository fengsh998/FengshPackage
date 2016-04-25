//
//  FKNetworking.h
//  FKCore
//
//  Created by fengsh on 16/3/10.
//  Copyright © 2016年 fengsh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FKNetworkTask.h"

@interface FKNetworking : NSObject

- (FKNetworkTask *)networkTaskWithRequest:(NSURLRequest *)request
                           completionBlock:(FKURLRequestCompletionBlock)completionBlock;


@end
