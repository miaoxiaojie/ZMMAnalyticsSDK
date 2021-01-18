//
//  ZMMAAutomaticProperties.m
//  ZMMAnalyticsSDK
//
//  Created by 赵苗苗 on 2021/1/18.
//

#import "ZMMAAutomaticProperties.h"

@implementation ZMMAAutomaticProperties

+ (NSMutableDictionary *)getAutomaticProperties
{
    static NSMutableDictionary *minsParams = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
        minsParams = [[NSMutableDictionary alloc] initWithCapacity:1];
        /*客户端版本号*/
        [minsParams setObject:@"1.0.0" forKey:@"clientVersion"];
        /*系统类型*/
        [minsParams setObject:@"IOS" forKey:@"ostype"];
        NSString *versionString = [ZMMAAutomaticProperties getSystemVersion_cmbc];
        NSString *sysVersion = [NSString stringWithFormat:@"ios%@",versionString];
        /*系统版本 如：ios7.0*/
        [minsParams setObject:sysVersion forKey:@"deviceSysVersion"];
        /*设备类型*/
        [minsParams setObject:[ZMMAAutomaticProperties getMachineName_cmbc] forKey:@"devNo"];
        /*默认为iPhone*/
        [minsParams setObject:@"iPhone" forKey:@"mobileType"];
    });
   
    return minsParams;
}

//获取设备的机型
+ (NSString *)getMachineName_cmbc
{
    static  NSString* deviceString;
    static  dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        struct utsname systemInfo;
        uname(&systemInfo);
        deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    });

    return deviceString;
}

+ (NSString *)getSystemVersion_cmbc
{

    static NSString *systemVersion;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        systemVersion = [[UIDevice currentDevice] systemVersion];
    });
    
    return systemVersion;
}


@end
