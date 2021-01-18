//
//  ZMMDataComparison.h
//  ZMMAnalyticsSDK
//
//  Created by 赵苗苗 on 2021/1/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZMMDataComparison : NSObject

+ (nullable NSArray *)sameLetterNewKeys:(NSArray *)newKeys
                           superAllKeys:(NSArray *)superKeys;

@end

NS_ASSUME_NONNULL_END
