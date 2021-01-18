//
//  ZMMAPropertiesOutgoingService.h
//  ZMMAnalyticsSDK
//
//  Created by 赵苗苗 on 2021/1/17.
//

#import <Foundation/Foundation.h>
#import "ZMMAPropertiesManagerInterface.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZMMAPropertiesOutgoingService : NSObject

/// 获得单利类
+ (id<ZMMAPropertiesManagerInterface>)getAPropertiesManage;

@end

NS_ASSUME_NONNULL_END
