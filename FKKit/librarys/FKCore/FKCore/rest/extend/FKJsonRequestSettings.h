//
//  FKJsonRequestSettings.h
//  FKCore
//
//  Created by fengsh on 16/4/18.
//  Copyright © 2016年 fengsh. All rights reserved.
//

#import "FKHttpRequestSettings.h"

@interface FKJsonRequestSettings : FKHttpRequestSettings
/**
    NSJSONSerialization
    "NSJSONWritingOptions". `0` by default.
 */
@property (nonatomic, assign) NSJSONWritingOptions writingOptions;


+ (instancetype)jsonRequestWithWritingOptions:(NSJSONWritingOptions)writingOptions;

@end
