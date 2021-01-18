//
//  ZMMAPropertiesManagerInterface.h
//  ZMMAnalyticsSDK
//
//  Created by 赵苗苗 on 2021/1/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZMMAPropertiesManagerInterface <NSObject>

/// 公关属性
/// @param propertyDict 属性
- (void)registerSuperProperties:(NSDictionary *)propertyDict;

@end

NS_ASSUME_NONNULL_END
