//
//  ZMMAnalyticsSDK.m
//  ZMMAnalyticsSDK
//
//  Created by 赵苗苗 on 2021/1/16.
//

#import "ZMMAnalyticsSDK.h"
#import "ZMMAPropertiesManagerInterface.h"
#import "ZMMAPropertiesOutgoingService.h"
#import "ZMMAnalyticsSDKPrivate.h"

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
        NSLog(@"注册公共属性失败");
    }
    propertyDict = [propertyDict copy];
    id<ZMMAPropertiesManagerInterface> manager = [ZMMAPropertiesOutgoingService getAPropertiesManage];
    [manager registerSuperProperties:propertyDict];
    
}

- (void)track:(NSString *)event withProperties:(nullable NSDictionary *)propertieDict
{
    [self track:event withProperties:propertieDict withTrackType:ZMMAnalyticsTrackTypeCode];
}

#pragma mark - Private Method

- (void)track:(NSString *)event withProperties:(NSDictionary *)propertieDict withTrackType:(ZMMAnalyticsTrackType)trackType {
   
    NSMutableDictionary *eventProperties = [NSMutableDictionary dictionary];
    
    // 添加 latest utms 属性，用户传入的属性优先级更高，最后添加到字典中
//    [eventProperties addEntriesFromDictionary:[_linkHandler latestUtmProperties]];
//    if ([SAValidator isValidDictionary:propertieDict]) {
        [eventProperties addEntriesFromDictionary:propertieDict];
//    }
   
    if (trackType == ZMMAnalyticsTrackTypeCode) {

        [self track:event withProperties:eventProperties withType:@"codeTrack"];
    } else {
        [self track:event withProperties:eventProperties withType:@"track"];
    }
}

- (void)track:(NSString *)event withProperties:(NSDictionary *)propertieDict withType:(NSString *)type {
    
    NSLog(@"\n【track event】:\n%@", propertieDict);
}

- (void)trackAppClickWithTableView:(UITableView *)tableView
          didSelectRowAtIndex_Path:(NSIndexPath *)indexPath
                        properties:(nullable NSDictionary<NSString *,id> *)properties
{
    NSMutableDictionary *eventProperties = [NSMutableDictionary dictionary];
    [eventProperties addEntriesFromDictionary:properties];
    [[ZMMAnalyticsSDK sharedInstance] trackAppClickWithView:tableView properties:eventProperties];
}


- (void)trackAppClickWithView:(UIView *)view
                   properties:(nullable NSDictionary<NSString *,id>*)properties
{
//    NSMutableDictionary *eventProperties = [NSMutableDictionary dictionary];
//    //类型
//    eventProperties[@"element_type"] = view.sensorsdata_elementType;
//    //文本
//    eventProperties[@"element_content"] = view.sensorsdata_elementContent;
//    UIViewController *vc = view.sensorsdata_viewController;
//    //设置页面相关属性
//    eventProperties[@"element_name"] = NSStringFromClass(vc.class);
//    [eventProperties addEntriesFromDictionary:properties];
    //触发
    [[ZMMAnalyticsSDK sharedInstance]track:@"APPClick" withProperties:properties];
}

@end
