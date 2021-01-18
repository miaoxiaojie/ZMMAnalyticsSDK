//
//  ZMMDataComparison.m
//  ZMMAnalyticsSDK
//
//  Created by 赵苗苗 on 2021/1/18.
//

#import "ZMMDataComparison.h"

@implementation ZMMDataComparison

+ (nullable NSArray *)sameLetterNewKeys:(NSArray *)newKeys
                           superAllKeys:(NSArray *)superKeys
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    NSArray *allNewKeys = [newKeys copy];
    //如果包含仅大小写不同的 key ,unregisterSuperProperty
    NSArray *superPropertyAllKeys = [superKeys copy];
    NSMutableArray *unregisterPropertyKeys = [NSMutableArray array];
    for (NSString *newKey in allNewKeys) {
        [superPropertyAllKeys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *usedKey = (NSString *)obj;
            if ([usedKey caseInsensitiveCompare:newKey] == NSOrderedSame) { // 存在不区分大小写相同 key
                [unregisterPropertyKeys addObject:usedKey];
            }
            dispatch_semaphore_signal(semaphore);
        }];
    }
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return unregisterPropertyKeys;
}

@end
