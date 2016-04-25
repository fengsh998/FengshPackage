//
//  FKJsonResponseSettings.h
//  FKCore
//
//  Created by fengsh on 16/4/18.
//  Copyright © 2016年 fengsh. All rights reserved.
//

#import "FKHttpResponseSettings.h"

@interface FKJsonResponseSettings : FKHttpResponseSettings
/**
    NSJSONSerialization
    "NSJSONWritingOptions". `0` by default.
 */
@property (nonatomic, assign) NSJSONReadingOptions readingOptions;

/**
 Whether to remove keys with `NSNull` values from response JSON. Defaults to `NO`.
 */
@property (nonatomic, assign) BOOL removesKeysWithNullValues;

/**
    //非单例
  */
+ (instancetype)responseWithReadingOptions:(NSJSONReadingOptions)readingOptions;

@end
