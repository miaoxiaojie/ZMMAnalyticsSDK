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
        /*
        //事件校验，预置事件提醒
        if ([_presetEventNames containsObject:event]) {
            SALogWarn(@"\n【event warning】\n %@ is a preset event name of us, it is recommended that you use a new one", event);
        };

        if (_configOptions.enableAutoAddChannelCallbackEvent) {
            // 后端匹配逻辑已经不需要 $channel_device_info 信息
            // 这里仍然添加此字段是为了解决服务端版本兼容问题
            eventProperties[SA_EVENT_PROPERTY_CHANNEL_INFO] = @"1";

            BOOL isNotContains = ![self.trackChannelEventNames containsObject:event];
            eventProperties[SA_EVENT_PROPERTY_CHANNEL_CALLBACK_EVENT] = @(isNotContains);
            if (isNotContains && event) {
                [self.trackChannelEventNames addObject:event];
                dispatch_async(self.serialQueue, ^{
                    [self archiveTrackChannelEventNames];
                });
            }
        }
         */
        [self track:event withProperties:eventProperties withType:@"codeTrack"];
    } else {
        [self track:event withProperties:eventProperties withType:@"track"];
    }
}

- (void)track:(NSString *)event withProperties:(NSDictionary *)propertieDict withType:(NSString *)type {
    
    /*
    if ([SARemoteConfigManager sharedInstance].isDisableSDK) {
        SALogDebug(@"【remote config】SDK is disabled");
        return;
    }
    
    if ([[SARemoteConfigManager sharedInstance] isBlackListContainsEvent:event]) {
        SALogDebug(@"【remote config】 %@ is ignored by remote config", event);
        return;
    }
    
    propertieDict = [propertieDict copy];
    
    NSMutableDictionary *libProperties = [self.presetProperty libPropertiesWithMethod:@"autoTrack"];

    // 对于type是track数据，它们的event名称是有意义的
    if ([type isEqualToString:@"track"] || [type isEqualToString:@"codeTrack"]) {
        if (event == nil || [event length] == 0) {
            NSString *errMsg = @"SensorsAnalytics track called with empty event parameter";
            SALogError(@"%@", errMsg);
            if (_debugMode != SensorsAnalyticsDebugOff) {
                [self showDebugModeWarning:errMsg withNoMoreButton:YES];
            }
            return;
        }
        if (![self isValidName:event]) {
            NSString *errMsg = [NSString stringWithFormat:@"Event name[%@] not valid", event];
            SALogError(@"%@", errMsg);
            if (_debugMode != SensorsAnalyticsDebugOff) {
                [self showDebugModeWarning:errMsg withNoMoreButton:YES];
            }
            return;
        }

        if ([type isEqualToString:@"codeTrack"]) {
            libProperties[SAEventPresetPropertyLibMethod] = @"code";
            type = @"track";
        }
    }

    if (propertieDict) {
        if (![self assertPropertyTypes:&propertieDict withEventType:type]) {
            SALogError(@"%@ failed to track event.", self);
            return;
        }
    }

    NSString *libDetail = nil;
    if ([self isAutoTrackEnabled] && propertieDict) {
        //不考虑 $AppClick 或者 $AppViewScreen 的计时采集，所以这里的 event 不会出现是 trackTimerStart 返回值的情况
        if ([event isEqualToString:SA_EVENT_NAME_APP_CLICK]) {
            if ([self isAutoTrackEventTypeIgnored: SensorsAnalyticsEventTypeAppClick] == NO) {
                libDetail = [NSString stringWithFormat:@"%@######", [propertieDict objectForKey:SA_EVENT_PROPERTY_SCREEN_NAME] ?: @""];
            }
        } else if ([event isEqualToString:SA_EVENT_NAME_APP_VIEW_SCREEN]) {
            if ([self isAutoTrackEventTypeIgnored: SensorsAnalyticsEventTypeAppViewScreen] == NO) {
                libDetail = [NSString stringWithFormat:@"%@######", [propertieDict objectForKey:SA_EVENT_PROPERTY_SCREEN_NAME] ?: @""];
            }
        }
    }
    libProperties[SAEventPresetPropertyLibDetail] = libDetail;
    
    __block NSDictionary *dynamicSuperPropertiesDict = [self acquireDynamicSuperProperties];
    
    UInt64 currentSystemUpTime = [[self class] getSystemUpTime];
    
    __block NSNumber *timeStamp = @([[self class] getCurrentTime]);
    
    dispatch_async(self.serialQueue, ^{
        //根据当前 event 解析计时操作时加工前的原始 eventName，若当前 event 不是 trackTimerStart 计时操作后返回的字符串，event 和 eventName 一致
        NSString *eventName = [self.trackTimer eventNameFromEventId:event];

        //获取用户自定义的动态公共属性
        if (dynamicSuperPropertiesDict && [dynamicSuperPropertiesDict isKindOfClass:NSDictionary.class] == NO) {
            SALogDebug(@"dynamicSuperProperties  returned: %@  is not an NSDictionary Obj.", dynamicSuperPropertiesDict);
            dynamicSuperPropertiesDict = nil;
        } else if (![self assertPropertyTypes:&dynamicSuperPropertiesDict withEventType:@"register_super_properties"]) {
            dynamicSuperPropertiesDict = nil;
        }
        //去重
        [self unregisterSameLetterSuperProperties:dynamicSuperPropertiesDict];

        NSMutableDictionary *eventPropertiesDic = [NSMutableDictionary dictionary];
        if ([type isEqualToString:@"track"] || [type isEqualToString:@"track_signup"]) {
            // track / track_signup 类型的请求，还是要加上各种公共property
            // 这里注意下顺序，按照优先级从低到高，依次是automaticProperties, superProperties,dynamicSuperPropertiesDict,propertieDict
            [eventPropertiesDic addEntriesFromDictionary:self.presetProperty.automaticProperties];
            [eventPropertiesDic addEntriesFromDictionary:self->_superProperties];
            [eventPropertiesDic addEntriesFromDictionary:dynamicSuperPropertiesDict];

            //update lib $app_version from super properties
            id appVersion = self->_superProperties[SAEventPresetPropertyAppVersion];
            if (appVersion) {
                libProperties[SAEventPresetPropertyAppVersion] = appVersion;
            }

            // 每次 track 时手机网络状态
            [eventPropertiesDic addEntriesFromDictionary:[self.presetProperty currentNetworkProperties]];

            //根据 event 获取事件时长，如返回为 Nil 表示此事件没有相应事件时长，不设置 event_duration 属性
            //为了保证事件时长准确性，当前开机时间需要在 serialQueue 队列外获取，再在此处传入方法内进行计算
            NSNumber *eventDuration = [self.trackTimer eventDurationFromEventId:event currentSysUpTime:currentSystemUpTime];
            if (eventDuration) {
                eventPropertiesDic[@"event_duration"] = eventDuration;
            }
        }
        
        if ([propertieDict isKindOfClass:[NSDictionary class]]) {
            [eventPropertiesDic addEntriesFromDictionary:propertieDict];
        }

        // 事件、公共属性和动态公共属性都需要支持修改 $project, $token, $time
        NSString *project = (NSString *)eventPropertiesDic[SA_EVENT_COMMON_OPTIONAL_PROPERTY_PROJECT];
        NSString *token = (NSString *)eventPropertiesDic[SA_EVENT_COMMON_OPTIONAL_PROPERTY_TOKEN];
        id originalTime = eventPropertiesDic[SA_EVENT_COMMON_OPTIONAL_PROPERTY_TIME];
        if ([originalTime isKindOfClass:NSDate.class]) {
            NSDate *customTime = (NSDate *)originalTime;
            NSInteger customTimeInt = [customTime timeIntervalSince1970] * 1000;
            if (customTimeInt >= SA_EVENT_COMMON_OPTIONAL_PROPERTY_TIME_INT) {
                timeStamp = @(customTimeInt);
            } else {
                SALogError(@"$time error %ld，Please check the value", (long)customTimeInt);
            }
        } else if (originalTime) {
            SALogError(@"$time '%@' invalid，Please check the value", originalTime);
        }
        
        // $project, $token, $time 处理完毕后需要移除
        NSArray<NSString *> *needRemoveKeys = @[SA_EVENT_COMMON_OPTIONAL_PROPERTY_PROJECT,
                                                SA_EVENT_COMMON_OPTIONAL_PROPERTY_TOKEN,
                                                SA_EVENT_COMMON_OPTIONAL_PROPERTY_TIME];
        [eventPropertiesDic removeObjectsForKeys:needRemoveKeys];
        
        // 序列化所有 NSDate 类型
        [eventPropertiesDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NSDate class]]) {
                NSDateFormatter *dateFormatter = [SADateFormatter dateFormatterFromString:@"yyyy-MM-dd HH:mm:ss.SSS"];
                NSString *dateStr = [dateFormatter stringFromDate:(NSDate *)obj];
                eventPropertiesDic[key] = dateStr;
            }
        }];

        //修正 $device_id，防止用户修改
        if (eventPropertiesDic[SAEventPresetPropertyDeviceID] && self.presetProperty.deviceID) {
            eventPropertiesDic[SAEventPresetPropertyDeviceID] = self.presetProperty.deviceID;
        }

        NSMutableDictionary *eventDic = nil;
        NSString *bestId = self.distinctId;

        if ([type isEqualToString:@"track_signup"]) {
            eventDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                        eventName, SA_EVENT_NAME,
                        eventPropertiesDic, SA_EVENT_PROPERTIES,
                        bestId, SA_EVENT_DISTINCT_ID,
                        self.anonymousId, @"original_id",
                        timeStamp, SA_EVENT_TIME,
                        type, SA_EVENT_TYPE,
                        libProperties, SA_EVENT_LIB,
                        @(arc4random()), SA_EVENT_TRACK_ID,
                        nil];
        } else if([type isEqualToString:@"track"]) {
            NSDictionary *presetPropertiesOfTrackType = [self.presetProperty presetPropertiesOfTrackType:[self isLaunchedPassively]
#ifndef SENSORS_ANALYTICS_DISABLE_TRACK_DEVICE_ORIENTATION
                                                                                       orientationConfig:self.deviceOrientationConfig
#endif
                                                         ];
            [eventPropertiesDic addEntriesFromDictionary:presetPropertiesOfTrackType];
            
            eventDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                        eventName, SA_EVENT_NAME,
                        eventPropertiesDic, SA_EVENT_PROPERTIES,
                        bestId, SA_EVENT_DISTINCT_ID,
                        timeStamp, SA_EVENT_TIME,
                        type, SA_EVENT_TYPE,
                        libProperties, SA_EVENT_LIB,
                        @(arc4random()), SA_EVENT_TRACK_ID,
                        nil];
        } else {
            // 此时应该都是对Profile的操作
            eventDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                        eventPropertiesDic, SA_EVENT_PROPERTIES,
                        bestId, SA_EVENT_DISTINCT_ID,
                        timeStamp, SA_EVENT_TIME,
                        type, SA_EVENT_TYPE,
                        libProperties, SA_EVENT_LIB,
                        @(arc4random()), SA_EVENT_TRACK_ID,
                        nil];
        }

        if (project) {
            eventDic[SA_EVENT_PROJECT] = project;
        }
        if (token) {
            eventDic[SA_EVENT_TOKEN] = token;
        }

        eventDic[SA_EVENT_LOGIN_ID] = self.loginId;
        eventDic[SA_EVENT_ANONYMOUS_ID] = self.anonymousId;

        NSDictionary *trackEventDic = [self willEnqueueWithType:type andEvent:eventDic];
        if (!trackEventDic) {
            return;
        }

        [[NSNotificationCenter defaultCenter] postNotificationName:SA_TRACK_EVENT_NOTIFICATION object:nil userInfo:trackEventDic];*/
        NSLog(@"\n【track event】:\n%@", propertieDict);

//        [self.eventTracker trackEvent:trackEventDic isSignUp:[type isEqualToString:@"track_signup"]];
//    });
}

@end
