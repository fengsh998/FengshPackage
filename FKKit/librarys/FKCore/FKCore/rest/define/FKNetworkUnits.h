//
//  FKNetworkUnits.h
//  FKCore
//
//  Created by fengsh on 16/3/10.
//  Copyright © 2016年 fengsh. All rights reserved.
//

#import <Foundation/Foundation.h>

//Gzip 压缩
NSData *FKGzipData(NSData *input, float level);
// 从dic 中获取querystring
FOUNDATION_EXPORT NSArray * QueryStringPairsFromDictionary(NSDictionary *dictionary);
// 通过key value 的方式生成 querystring
FOUNDATION_EXPORT NSArray * QueryStringPairsFromKeyAndValue(NSString *key, id value);

FOUNDATION_EXPORT NSString * PercentEscapedStringFromString(NSString *string);

NSString * Base64EncodedStringFromString(NSString *string);

NSString * QueryStringFromParameters(NSDictionary *parameters);