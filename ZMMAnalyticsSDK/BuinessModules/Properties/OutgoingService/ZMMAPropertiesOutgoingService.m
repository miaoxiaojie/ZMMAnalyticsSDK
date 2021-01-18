//
//  ZMMAPropertiesOutgoingService.m
//  ZMMAnalyticsSDK
//
//  Created by 赵苗苗 on 2021/1/17.
//

#import "ZMMAPropertiesOutgoingService.h"
#import "ZMMAPropertiesManager.h"

@implementation ZMMAPropertiesOutgoingService

+ (id<ZMMAPropertiesManagerInterface>)getAPropertiesManage
{
    ZMMAPropertiesManager *manager = [ZMMAPropertiesManager sharedInstance];
    return manager;
}

@end
