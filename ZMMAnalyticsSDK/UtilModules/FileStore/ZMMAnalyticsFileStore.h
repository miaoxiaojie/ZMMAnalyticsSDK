//
//  ZMMAnalyticsFileStore.h
//  ZMMAnalyticsSDK
//
//  Created by 赵苗苗 on 2021/1/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZMMAnalyticsFileStore : NSObject

/// 文件本地存储
/// @param fileName 本地存储文件名
/// @param value 本地存储文件内容
+ (BOOL)archiveWithFileName:(NSString *)fileName value:(nullable id)value;

/// 获取本地存储的文件内容
/// @param fileName 本地存储文件名
+ (nullable id)unarchiveWithFileName:(NSString *)fileName;

/// 获取文件路径
/// @param fileName 文件名
+ (NSString *)filePath:(NSString *)fileName;

@end

NS_ASSUME_NONNULL_END
