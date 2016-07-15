//
//  FKQueryStringPair.h
//  FKCore
//
//  Created by fengsh on 16/4/25.
//  Copyright © 2016年 fengsh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FKQueryStringPair : NSObject
@property (readwrite, nonatomic, strong) id field;
@property (readwrite, nonatomic, strong) id value;

- (id)initWithField:(id)field value:(id)value;

- (NSString *)URLEncodedStringValue;
@end


// 从dic 中获取querystring
FOUNDATION_EXPORT NSArray * QueryStringPairsFromDictionary(NSDictionary *dictionary);
// 通过key value 的方式生成 querystring
FOUNDATION_EXPORT NSArray * QueryStringPairsFromKeyAndValue(NSString *key, id value);

FOUNDATION_EXPORT NSString * PercentEscapedStringFromString(NSString *string);

NSString * QueryStringFromParameters(NSDictionary *parameters);