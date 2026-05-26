//
//  DxpTrace.m
//  DXPAnalyticsLib
//
//  Created by li.biao on 2026/5/23.
//

#import "DxpTrace.h"
#import "GoogleAnalyticsManagement.h"
#import "SensorsManagement.h"

static DxpTrace *dxpTrace = nil;

@implementation DxpTrace

+ (instancetype)getInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dxpTrace = [[DxpTrace alloc] init];
    });
    return dxpTrace;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _traceType = BOTH;
        _traceFlushBulkSize = 0;
        _tracePublicProperties = @{};
    }
    return self;
}

// 神策启动初始化
- (void)sharedInstanceWithLaunchOptions {
	[SensorsManagement sharedInstanceWithLaunchOptions:self.launchOptions baseUrl:self.traceUrl toNativeSize:self.traceFlushBulkSize openLog:self.isOpenLog];
}

- (void)setTracePublicProperties:(NSDictionary *)tracePublicProperties {
	_tracePublicProperties = tracePublicProperties;
	[[SensorsManagement sharedInstance] setRegisterSuperProperties:tracePublicProperties];
}

- (void)setTraceType:(DxpTraceType)traceType {
	_traceType = traceType;
	if (traceType == ONLY_CDP || traceType == BOTH) {
		[SensorsManagement sharedInstance].sensorsDataEnabled = YES;
	}
	if (traceType == ONLY_GA || traceType == BOTH) {
		[GoogleAnalyticsManagement sharedInstance].gaEnable = YES;
	}
}

#pragma mark - Trace
- (void)trace:(EventTraceData *)eventData {
    if (!eventData || eventData.eventName.length == 0) {
        return;
    }

    switch (self.traceType) {
        case ONLY_CDP:
            // CDP 埋点上报
			[[SensorsManagement sharedInstance] trackWithName:eventData.eventName withProperties:eventData.properties];
            break;
        case ONLY_GA:
            // GA 埋点上报
			[[GoogleAnalyticsManagement sharedInstance] logEventWithName:eventData.eventName withProperties:eventData.properties];
            break;
        case BOTH:
            // CDP + GA 埋点上报
			[[SensorsManagement sharedInstance] trackWithName:eventData.eventName withProperties:eventData.properties];
			[[GoogleAnalyticsManagement sharedInstance] logEventWithName:eventData.eventName withProperties:eventData.properties];
            break;
    }
}

#pragma mark - Super Properties
// 添加全局公共属性
- (void)addSuperProperties:(NSDictionary *)properties {
	switch (self.traceType) {
		case ONLY_CDP:
			// CDP 埋点上报
			[[SensorsManagement sharedInstance] setRegisterSuperProperties:properties];
			break;
		case ONLY_GA:
			// GA 埋点上报
			break;
		case BOTH:
			// CDP + GA 埋点上报
			[[SensorsManagement sharedInstance] setRegisterSuperProperties:properties];
			break;
	}
}

- (void)removeSuperProperty:(NSString *)key {
    // 移除单个公共属性
	[[SensorsManagement sharedInstance] setUnregisterSuperProperty:key];	
}

// 批量移除公共属性
- (void)removeSuperProperties:(NSArray *)keys {
	for (NSString *key in keys) {
		[[SensorsManagement sharedInstance] setUnregisterSuperProperty:key];
	}
}

// 获取单个公共属性
- (nullable id)getSuperProperty:(NSString *)key {
	NSDictionary *dic = [[SensorsManagement sharedInstance] getCurrentSuperProperties];
    return dic[key];
}

// 获取所有公共属性
- (NSDictionary *)getAllSuperProperties {
	NSDictionary *dic = [[SensorsManagement sharedInstance] getPresetProperties];
    return dic;
}

- (void)clearAllSuperProperties {
    // TODO: 清除所有公共属性
}

// 设置用户属性
- (void)setUserProfilePropertiesWithName:(NSString *)userId {
	if (self.traceType == ONLY_GA || self.traceType == BOTH) {
		[[GoogleAnalyticsManagement sharedInstance] setGoogleAnalyticsUserID:userId];
	}
}

// 设置用户ID
- (void)setUserProfilePropertiesWithName:(NSString *)propertiesName PropertiesValue:(NSString *)propertiesValue {
	if (self.traceType == ONLY_GA || self.traceType == BOTH) {
		[[GoogleAnalyticsManagement sharedInstance] setUserProfilePropertiesWithName:propertiesName PropertiesValue:propertiesValue];
	}
}

// 删除用户属性
- (void)deleteUserProfilePropertiesWithName:(NSString *)propertiesName {
	if (self.traceType == ONLY_GA || self.traceType == BOTH) {
		[[GoogleAnalyticsManagement sharedInstance] deleteUserProfilePropertiesWithName:propertiesName];
	}
}


@end
