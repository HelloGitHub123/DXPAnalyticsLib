//
//  SwiftAPI.swift
//  DXPAnalyticsLib
//
//  对外 Swift API，外部工程 import DXPAnalyticsLib 即可使用，无需自行编写 Bridging Header。
//

import Foundation
import UIKit

private func launchOptionsDictionary(
    from options: [UIApplication.LaunchOptionsKey: Any]
) -> [AnyHashable: Any] {
    Dictionary(uniqueKeysWithValues: options.map { (AnyHashable($0.rawValue), $1) })
}

// MARK: - Trace Type

/// 埋点通道类型（对应 ObjC `DxpTraceType`）
@objc(DXPAnalyticsTraceType)
public enum DXPAnalyticsTraceType: Int, Sendable {
    case onlyCDP = 1
    case onlyGA = 2
    case both = 3

    fileprivate var objcValue: DxpTraceType {
        DxpTraceType(rawValue: rawValue) ?? DxpTraceType(rawValue: 3)!
    }

    fileprivate init(objc: DxpTraceType) {
        self = DXPAnalyticsTraceType(rawValue: objc.rawValue) ?? .both
    }
}

// MARK: - Event Model

/// 埋点事件数据（对应 ObjC `EventTraceData`）
@objc(DXPEventTraceData)
public final class DXPEventTraceData: NSObject {
    @objc public let eventName: String
    @objc public let properties: [String: Any]?

    @objc public init(eventName: String, properties: [String: Any]? = nil) {
        self.eventName = eventName
        self.properties = properties
        super.init()
    }
}

// MARK: - Configuration

/// SDK 初始化配置
@objc(DXPAnalyticsConfiguration)
public final class DXPAnalyticsConfiguration: NSObject {
    @objc public var traceType: DXPAnalyticsTraceType = .both
    @objc public var traceURL: String?
    @objc public var flushBulkSize: Int = 0
    @objc public var publicProperties: [String: Any]?
    @objc public var launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    @objc public var isLogEnabled: Bool = false

    @objc public override init() {
        super.init()
    }

    fileprivate func apply(to bridge: DXPAnalyticsSwiftBridge.Type) {
        bridge.setTraceType(traceType.objcValue)
        bridge.setTraceUrl(traceURL)
        bridge.setTraceFlushBulkSize(flushBulkSize)
        bridge.setTracePublicProperties(publicProperties)
        bridge.setIsOpenLog(isLogEnabled)
        if let options = launchOptions {
            bridge.setLaunchOptions(launchOptionsDictionary(from: options))
        }
    }
}

// MARK: - Main API

/// DXP 埋点 SDK Swift 入口（单例）
///
/// Swift 工程用法：
/// ```swift
/// import DXPAnalyticsLib
/// let config = DXPAnalyticsConfiguration()
/// config.traceURL = "https://..."
/// DXPAnalytics.shared.configure(config)
/// DXPAnalytics.shared.initialize()
/// DXPAnalytics.shared.track(eventName: "click", properties: ["key": "value"])
/// ```
@objc(DXPAnalytics)
public final class DXPAnalytics: NSObject {

    @objc public static let shared = DXPAnalytics()

    private let bridge = DXPAnalyticsSwiftBridge.self

    private override init() {
        super.init()
    }

    // MARK: Configuration Properties

    @objc public var traceType: DXPAnalyticsTraceType {
        get { DXPAnalyticsTraceType(objc: bridge.traceType()) }
        set { bridge.setTraceType(newValue.objcValue) }
    }

    @objc public var traceURL: String? {
        get { bridge.traceUrl() }
        set { bridge.setTraceUrl(newValue) }
    }

    @objc public var flushBulkSize: Int {
        get { bridge.traceFlushBulkSize() }
        set { bridge.setTraceFlushBulkSize(newValue) }
    }

    @objc public var publicProperties: [String: Any]? {
        get { bridge.tracePublicProperties() as? [String: Any] }
        set { bridge.setTracePublicProperties(newValue) }
    }

    @objc public var isLogEnabled: Bool {
        get { bridge.isOpenLog() }
        set { bridge.setIsOpenLog(newValue) }
    }

    // MARK: Setup

    /// 批量写入配置项（需在 `initialize()` 之前调用）
    @objc(configureWithConfiguration:)
    public func configure(_ configuration: DXPAnalyticsConfiguration) {
        configuration.apply(to: bridge)
    }

    /// 设置 App 启动参数
    @objc(setLaunchOptions:)
    public func setLaunchOptions(_ options: [UIApplication.LaunchOptionsKey: Any]?) {
        guard let options else { return }
        bridge.setLaunchOptions(launchOptionsDictionary(from: options))
    }

    /// 初始化 SDK（对应 ObjC `-[DxpTrace sharedInstanceWithLaunchOptions]`，必须调用）
    @objc public func initialize() {
        bridge.initializeWithLaunchOptions()
    }

    // MARK: Tracking

    @objc(trackEventWithName:properties:)
    public func track(eventName: String, properties: [String: Any]? = nil) {
        bridge.trackEvent(withName: eventName, properties: properties)
    }

    @objc(trackWithEventData:)
    public func track(_ event: DXPEventTraceData) {
        bridge.trackEvent(withName: event.eventName, properties: event.properties)
    }

    // MARK: Super Properties

    @objc(addSuperProperties:)
    public func addSuperProperties(_ properties: [String: Any]) {
        bridge.addSuperProperties(properties)
    }

    @objc(removeSuperPropertyForKey:)
    public func removeSuperProperty(forKey key: String) {
        bridge.removeSuperProperty(key)
    }

    @objc(removeSuperPropertiesForKeys:)
    public func removeSuperProperties(forKeys keys: [String]) {
        bridge.removeSuperProperties(keys)
    }

    @objc(superPropertyForKey:)
    public func superProperty(forKey key: String) -> Any? {
        bridge.getSuperProperty(forKey: key)
    }

    @objc public func allSuperProperties() -> [String: Any] {
        bridge.getAllSuperProperties() as? [String: Any] ?? [:]
    }

    @objc public func clearAllSuperProperties() {
        bridge.clearAllSuperProperties()
    }

    // MARK: User Profile

    @objc(setUserId:)
    public func setUserId(_ userId: String) {
        bridge.setUserId(userId)
    }

    @objc(setUserProfilePropertyWithName:value:)
    public func setUserProfile(property name: String, value: String) {
        bridge.setUserProfilePropertyWithName(name, value: value)
    }

    @objc(deleteUserProfilePropertyWithName:)
    public func deleteUserProfile(property name: String) {
        bridge.deleteUserProfileProperty(withName: name)
    }
}
