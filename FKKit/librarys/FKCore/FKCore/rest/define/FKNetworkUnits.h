//
//  FKNetworkUnits.h
//  FKCore
//
//  Created by fengsh on 16/3/10.
//  Copyright © 2016年 fengsh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FKNetworkUnits : NSObject
//Gzip 压缩 level -1 /* default */
+ (NSData *)FKGzipData:(NSData *)input withLevel:(float)level;
//string 转为base64 string
+ (NSString *)Base64EncodedStringFromString:(NSString *)string;
@end