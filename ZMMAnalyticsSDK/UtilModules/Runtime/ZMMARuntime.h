//
//  ZMMARuntime.h
//  ZMMAnalyticsSDK
//
//  Created by 赵苗苗 on 2021/2/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZMMARuntime : NSObject

extern const struct ZMMARuntime
{
    void (*transforInstanceMethod_zmma)(Class, SEL, SEL);
    
}runTime;


@end

NS_ASSUME_NONNULL_END
