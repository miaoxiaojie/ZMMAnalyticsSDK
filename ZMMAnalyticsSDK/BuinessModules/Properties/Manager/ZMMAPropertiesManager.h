//
//  ZMMAPropertiesManager.h
//  ZMMAnalyticsSDK
//
//  Created by 赵苗苗 on 2021/1/17.
//

#import <Foundation/Foundation.h>
#import "ZMMAPropertiesManagerInterface.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZMMAPropertiesManager : NSObject<ZMMAPropertiesManagerInterface>

/// 单利初始化
+ (ZMMAPropertiesManager * _Nullable)sharedInstance;

@end

NS_ASSUME_NONNULL_END
