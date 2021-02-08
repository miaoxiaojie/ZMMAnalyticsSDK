//
//  ZMMAnalyticsSDK.h
//  ZMMAnalyticsSDK
//
//  Created by 赵苗苗 on 2021/1/16.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZMMAnalyticsSDK : NSObject

#pragma mark- init instance

/// 单利初始化
+ (ZMMAnalyticsSDK * _Nullable)sharedInstance;

/// 用来设置每个事件都带有的一些公共属性
/// 当 track 的 Properties，superProperties 和 SDK 自动生成的 automaticProperties 有相同的 key 时，遵循如下的优先级：
/// track.properties > superProperties > automaticProperties
/// 另外，当这个接口被多次调用时，是用新传入的数据去 merge 先前的数据，并在必要时进行 merge
/// 例如，在调用接口前，dict 是 @{@"a":1, @"b": "bbb"}，传入的 dict 是 @{@"b": 123, @"c": @"asd"}，则 merge 后的结果是
/// @{"a":1, @"b": 123, @"c": @"asd"}，同时，SDK 会自动将 superProperties 保存到文件中，下次启动时也会从中读取
/// @param propertyDict 传入 merge 到公共属性
- (void)registerSuperProperties:(NSDictionary *)propertyDict;

#pragma mark track event

/// 调用 track 接口，追踪一个带有属性的 event
/// @param event event的名称
/// @param propertyDict  event的属性
- (void)track:(NSString *)event withProperties:(nullable NSDictionary *)propertieDict;

/// 支持UITableView 触发APPClick
/// @param tableView
/// @param indexPath 位置
/// @param properties 自定义事件属性
- (void)trackAppClickWithTableView:(UITableView *)tableView
          didSelectRowAtIndex_Path:(NSIndexPath *)indexPath
                        properties:(nullable NSDictionary<NSString *,id> *)properties;


@end

NS_ASSUME_NONNULL_END
