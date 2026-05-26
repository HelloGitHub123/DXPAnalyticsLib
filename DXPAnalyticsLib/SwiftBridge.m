//
//  SwiftBridge.m
//  DXPAnalyticsLib
//

#import "SwiftBridge.h"
#import "EventTraceData.h"

@implementation DXPAnalyticsSwiftBridge

+ (DxpTrace *)sharedTrace {
    return [DxpTrace getInstance];
}

#pragma mark - Configuration

+ (DxpTraceType)traceType {
    return [self sharedTrace].traceType;
}

+ (void)setTraceType:(DxpTraceType)traceType {
    [self sharedTrace].traceType = traceType;
}

+ (nullable NSString *)traceUrl {
    return [self sharedTrace].traceUrl;
}

+ (void)setTraceUrl:(nullable NSString *)traceUrl {
    [self sharedTrace].traceUrl = traceUrl;
}

+ (NSInteger)traceFlushBulkSize {
    return [self sharedTrace].traceFlushBulkSize;
}

+ (void)setTraceFlushBulkSize:(NSInteger)size {
    [self sharedTrace].traceFlushBulkSize = size;
}

+ (nullable NSDictionary *)tracePublicProperties {
    return [self sharedTrace].tracePublicProperties;
}

+ (void)setTracePublicProperties:(nullable NSDictionary *)properties {
    [self sharedTrace].tracePublicProperties = properties;
}

+ (NSDictionary *)launchOptions {
    return [self sharedTrace].launchOptions ?: @{};
}

+ (void)setLaunchOptions:(NSDictionary *)launchOptions {
    [self sharedTrace].launchOptions = launchOptions;
}

+ (BOOL)isOpenLog {
    return [self sharedTrace].isOpenLog;
}

+ (void)setIsOpenLog:(BOOL)isOpenLog {
    [self sharedTrace].isOpenLog = isOpenLog;
}

#pragma mark - Lifecycle

+ (void)initializeWithLaunchOptions {
    [[self sharedTrace] sharedInstanceWithLaunchOptions];
}

#pragma mark - Tracking

+ (void)trackEventWithName:(NSString *)eventName
                properties:(nullable NSDictionary *)properties {
    EventTraceData *eventData = [[EventTraceData alloc] init];
    eventData.eventName = eventName;
    eventData.properties = properties;
    [[self sharedTrace] trace:eventData];
}

#pragma mark - Super Properties

+ (void)addSuperProperties:(NSDictionary *)properties {
    [[self sharedTrace] addSuperProperties:properties];
}

+ (void)removeSuperProperty:(NSString *)key {
    [[self sharedTrace] removeSuperProperty:key];
}

+ (void)removeSuperProperties:(NSArray<NSString *> *)keys {
    [[self sharedTrace] removeSuperProperties:keys];
}

+ (nullable id)getSuperPropertyForKey:(NSString *)key {
    return [[self sharedTrace] getSuperProperty:key];
}

+ (NSDictionary *)getAllSuperProperties {
    return [[self sharedTrace] getAllSuperProperties];
}

+ (void)clearAllSuperProperties {
    [[self sharedTrace] clearAllSuperProperties];
}

#pragma mark - User Profile

+ (void)setUserId:(NSString *)userId {
    [[self sharedTrace] setUserProfilePropertiesWithName:userId];
}

+ (void)setUserProfilePropertyWithName:(NSString *)name value:(NSString *)value {
    [[self sharedTrace] setUserProfilePropertiesWithName:name PropertiesValue:value];
}

+ (void)deleteUserProfilePropertyWithName:(NSString *)name {
    [[self sharedTrace] deleteUserProfilePropertiesWithName:name];
}

@end
