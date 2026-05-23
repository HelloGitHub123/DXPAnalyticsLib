//
//  EventTraceData.h
//  DXPAnalyticsLib
//
//  Created by li.biao on 2026/5/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EventTraceData : NSObject

@property (nonatomic, copy) NSString *eventName;
@property (nonatomic, copy, nullable) NSDictionary *properties;

@end

NS_ASSUME_NONNULL_END
