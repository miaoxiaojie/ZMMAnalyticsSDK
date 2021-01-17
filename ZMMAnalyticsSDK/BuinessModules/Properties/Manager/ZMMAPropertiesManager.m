//
//  ZMMAPropertiesManager.m
//  ZMMAnalyticsSDK
//
//  Created by 赵苗苗 on 2021/1/17.
//

#import "ZMMAPropertiesManager.h"

@interface ZMMAPropertiesManager ()

@property (nonatomic, strong) NSDictionary *superProperties;

@end

@implementation ZMMAPropertiesManager

+ (ZMMAPropertiesManager * _Nullable)sharedInstance
{
    static ZMMAPropertiesManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[self alloc]init];
    })
    return _manager;
}

@end
