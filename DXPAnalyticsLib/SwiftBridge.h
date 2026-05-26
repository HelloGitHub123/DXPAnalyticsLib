//
//  SwiftBridge.h
//  DXPAnalyticsLib
//
//  Objective-C 桥接层，供 SwiftAPI 调用，封装 DxpTrace 等底层实现。
//

#import <Foundation/Foundation.h>
#import "DxpTrace.h"

NS_ASSUME_NONNULL_BEGIN

/// 内部桥接类，Swift 侧通过 SwiftAPI 访问，ObjC 工程请直接使用 DxpTrace。
@interface DXPAnalyticsSwiftBridge : NSObject

+ (DxpTrace *)sharedTrace;

#pragma mark - Configuration

+ (DxpTraceType)traceType;
+ (void)setTraceType:(DxpTraceType)traceType;

+ (nullable NSString *)traceUrl;
+ (void)setTraceUrl:(nullable NSString *)traceUrl;

+ (NSInteger)traceFlushBulkSize;
+ (void)setTraceFlushBulkSize:(NSInteger)size;

+ (nullable NSDictionary *)tracePublicProperties;
+ (void)setTracePublicProperties:(nullable NSDictionary *)properties;

+ (NSDictionary *)launchOptions;
+ (void)setLaunchOptions:(NSDictionary *)launchOptions;

+ (BOOL)isOpenLog;
+ (void)setIsOpenLog:(BOOL)isOpenLog;

#pragma mark - Lifecycle

+ (void)initializeWithLaunchOptions;

#pragma mark - Tracking

+ (void)trackEventWithName:(NSString *)eventName
                properties:(nullable NSDictionary *)properties;

#pragma mark - Super Properties

+ (void)addSuperProperties:(NSDictionary *)properties;
+ (void)removeSuperProperty:(NSString *)key;
+ (void)removeSuperProperties:(NSArray<NSString *> *)keys;
+ (nullable id)getSuperPropertyForKey:(NSString *)key;
+ (NSDictionary *)getAllSuperProperties;
+ (void)clearAllSuperProperties;

#pragma mark - User Profile

+ (void)setUserId:(NSString *)userId;
+ (void)setUserProfilePropertyWithName:(NSString *)name value:(NSString *)value;
+ (void)deleteUserProfilePropertyWithName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
