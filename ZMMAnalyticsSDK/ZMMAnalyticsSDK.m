//
//  ZMMAnalyticsSDK.m
//  ZMMAnalyticsSDK
//
//  Created by 赵苗苗 on 2021/1/16.
//

#import "ZMMAnalyticsSDK.h"
#import "ZMMAPropertiesManagerInterface.h"
#import "ZMMAPropertiesOutgoingService.h"

@interface ZMMAnalyticsSDK ()

@property (nonatomic, strong) dispatch_queue_t serialQueue;

@end

@implementation ZMMAnalyticsSDK

static ZMMAnalyticsSDK *sharedInstance = nil;

#pragma mark - Initialization

+ (ZMMAnalyticsSDK * _Nullable)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)registerSuperProperties:(NSDictionary *)propertyDict {
    if (!(propertyDict && [propertyDict isKindOfClass:[NSDictionary class]])) {
        NSLog(@"注册公共属性失败")
    }
    
    propertyDict = [propertyDict copy];
    id<ZMMAPropertiesManagerInterface> manager = [ZMMAPropertiesOutgoingService getAPropertiesManage];
    [manager registerSuperProperties:propertyDict];
    
}

#pragma mark - Private Method



@end
