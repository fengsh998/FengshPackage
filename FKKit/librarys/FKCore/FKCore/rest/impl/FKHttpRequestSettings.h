//
//  FKHttpRequestSettings.h
//  FKCore
//
//  Created by fengsh on 16/4/16.
//  Copyright © 2016年 fengsh. All rights reserved.
//

#import "FKRequestSetting.h"

@interface FKHttpRequestSettings : FKRequestSetting
//非单例
+ (instancetype)defaultRequestSettings;

@end
