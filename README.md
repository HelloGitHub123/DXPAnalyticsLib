# DXPAnalyticsLib

DXP 埋点 SDK，集成神策（CDP）与 Google Analytics（Firebase），同时提供 **Swift** 与 **Objective-C** 两套 API。

## 安装

- 最低支持 **iOS 12.2**（含 Swift 模块，依赖系统 Swift 运行时；集成后请设置 `ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES = NO`）

```ruby
pod 'DXPAnalyticsLib', '~> 1.0.33'
```

桌面示例工程（均已验证可编译）：

- Swift：`~/Desktop/DXPAnalyticsDemo`（`import DXPAnalyticsLib` → `DXPAnalytics`）
- Objective-C：`~/Desktop/DXPAnalyticsObjCDemo`（`#import <DXPAnalyticsLib/DXPAnalyticsLib.h>` → `DxpTrace`）

## Swift 工程（推荐）

无需在宿主工程添加 Bridging Header，直接 `import DXPAnalyticsLib`：

```swift
import DXPAnalyticsLib

// 1. 配置
let config = DXPAnalyticsConfiguration()
config.traceType = .both
config.traceURL = "https://your-sensors-server/sa?project=default"
config.flushBulkSize = 50
config.isLogEnabled = true
config.publicProperties = ["app_version": "1.0.0"]

DXPAnalytics.shared.configure(config)
DXPAnalytics.shared.setLaunchOptions(launchOptions) // AppDelegate 中的 launchOptions
DXPAnalytics.shared.initialize()

// 2. 埋点
DXPAnalytics.shared.track(eventName: "button_click", properties: ["page": "home"])

// 3. 公共属性 / 用户属性
DXPAnalytics.shared.addSuperProperties(["channel": "AppStore"])
DXPAnalytics.shared.setUserId("user_123")
```

也可使用事件模型：

```swift
let event = DXPEventTraceData(eventName: "purchase", properties: ["amount": 99])
DXPAnalytics.shared.track(event)
```

## Objective-C 工程

沿用原有 ObjC API，无需改动：

```objc
#import <DXPAnalyticsLib/DXPAnalyticsLib.h>

DxpTrace *trace = [DxpTrace getInstance];
trace.traceType = BOTH;
trace.traceUrl = @"https://your-sensors-server/sa?project=default";
trace.launchOptions = launchOptions;
[trace sharedInstanceWithLaunchOptions];

EventTraceData *event = [[EventTraceData alloc] init];
event.eventName = @"button_click";
event.properties = @{@"page": @"home"};
[trace trace:event];
```

## 架构说明

| 层级 | 文件 | 说明 |
|------|------|------|
| Swift API | `SwiftAPI.swift` | 对外 Swift 友好接口（`DXPAnalytics` 等） |
| 桥接层 | `SwiftBridge.h/m` | 封装 `DxpTrace`，供 Swift 层调用 |
| ObjC 核心 | `DxpTrace` 等 | 原有实现，ObjC 工程直接使用 |

## TraceType

| Swift (`DXPAnalyticsTraceType`) | ObjC (`DxpTraceType`) | 说明 |
|----------------------------------|------------------------|------|
| `.onlyCDP` | `ONLY_CDP` | 仅神策 |
| `.onlyGA` | `ONLY_GA` | 仅 GA |
| `.both` | `BOTH` | 双通道 |
