//
//  ZMMAnalyticsSDK.m
//  ZMMAnalyticsSDK
//
//  Created by 赵苗苗 on 2021/1/16.
//

#import "ZMMAnalyticsSDK.h"

@interface ZMMAnalyticsSDK ()



@end

@implementation ZMMAnalyticsSDK

static ZMMAnalyticsSDK *sharedInstance = nil;

#pragma mark - Initialization

+ (ZMMAnalyticsSDK * _Nullable)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

@end
