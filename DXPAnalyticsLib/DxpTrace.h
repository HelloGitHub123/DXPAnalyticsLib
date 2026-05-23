//
//  DxpTrace.h
//  DXPAnalyticsLib
//
//  Created by li.biao on 2026/5/23.
//

#import <Foundation/Foundation.h>
#import "EventTraceData.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, DxpTraceType) {
    ONLY_CDP = 1,
    ONLY_GA = 2,
    BOTH = 3
};

@interface DxpTrace : NSObject

@property (nonatomic, assign) DxpTraceType traceType;
@property (nonatomic, copy, nullable) NSString *traceUrl;
@property (nonatomic, assign) NSInteger traceFlushBulkSize;
@property (nonatomic, copy, nullable) NSDictionary *tracePublicProperties;
@property (nonatomic, strong) NSDictionary *launchOptions;
@property (nonatomic, assign) BOOL isOpenLog;

+ (instancetype)getInstance;

// 第一个调用的方法，必须实现
- (void)sharedInstanceWithLaunchOptions;
// 
- (void)trace:(EventTraceData *)eventData;
- (void)addSuperProperties:(NSDictionary *)properties;
- (void)removeSuperProperty:(NSString *)key;
- (void)removeSuperProperties:(NSArray *)keys;
- (nullable id)getSuperProperty:(NSString *)key;
- (NSArray *)getAllSuperProperties;
- (void)clearAllSuperProperties;
- (void)setUserProfilePropertiesWithName:(NSString *)userId;
- (void)setUserProfilePropertiesWithName:(NSString *)propertiesName PropertiesValue:(NSString *)propertiesValue;
- (void)deleteUserProfilePropertiesWithName:(NSString *)propertiesName;

@end

NS_ASSUME_NONNULL_END
