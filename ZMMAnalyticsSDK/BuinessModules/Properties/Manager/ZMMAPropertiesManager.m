//
//  ZMMAPropertiesManager.m
//  ZMMAnalyticsSDK
//
//  Created by 赵苗苗 on 2021/1/17.
//

#import "ZMMAPropertiesManager.h"
#import "ZMMDataComparison.h"
#import "ZMMAnalyticsFileStore.h"

static NSString *const ZMMAarchiveWithFileName = @"ZMMASuper_properties";

@interface ZMMAPropertiesManager ()

@property (nonatomic, strong) NSDictionary *superProperties;
@property (nonatomic, strong) dispatch_queue_t serialQueue;

@end

@implementation ZMMAPropertiesManager

+ (ZMMAPropertiesManager * _Nullable)sharedInstance
{
    static ZMMAPropertiesManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[self alloc]init];
    });
    return _manager;
}

#pragma mark - Public Method

- (void)registerSuperProperties:(NSDictionary *)propertyDict {
    
    dispatch_async(self.serialQueue, ^{
        NSArray *allNewKeys = [propertyDict.allKeys copy];
        NSArray *superPropertyAllKeys = [self.superProperties.allKeys copy];
        NSArray *unregisterPropertyKeys = [ZMMDataComparison sameLetterNewKeys:allNewKeys
                                                                  superAllKeys:superPropertyAllKeys];
        if (unregisterPropertyKeys.count > 0) {
            [self p_unregisterSuperProperty:unregisterPropertyKeys];
        }
    });
}

- (void)archiveSuperProperties {
    [ZMMAnalyticsFileStore archiveWithFileName:ZMMAarchiveWithFileName
                                         value:self.superProperties];
}

#pragma mark - Private Method
- (void)p_unregisterSuperProperty:(NSString *)property {
    dispatch_async(self.serialQueue, ^{
        NSMutableDictionary *superProperties = [NSMutableDictionary dictionaryWithDictionary:self.superProperties];
        if (property) {
            [superProperties removeObjectForKey:property];
        }
        self.superProperties = [NSDictionary dictionaryWithDictionary:superProperties];
        [self archiveSuperProperties];
    });
}

@end
