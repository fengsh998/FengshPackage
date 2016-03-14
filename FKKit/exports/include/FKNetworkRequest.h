//
//  FKNetworkRequest.h
//  FKCore
//
//  Created by fengsh on 16/3/12.
//  Copyright © 2016年 fengsh. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FKNetworkBase : NSMutableURLRequest

@end


@interface FKNetworkRequest : FKNetworkBase

@end

@interface FKNetworkUploadRequest : FKNetworkBase

@end


@interface FKNetworkDownloadRequest : FKNetworkBase

@end

