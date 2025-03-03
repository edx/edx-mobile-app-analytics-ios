//
//  File.swift
//  OEXSegementAnalytics
//
//  Created by Anton Yarmolenka on 21/11/2024.
//

import Foundation
import OEXFoundation
@preconcurrency import Segment
import SegmentFirebase
import TestableMacro

public protocol SegmentAnalyticsServiceProtocol: AnalyticsService {
    func receivedRemoteNotification(userInfo: [AnyHashable: Any])
    func registeredForRemoteNotifications(deviceToken: Data)
    func add(plugin: Plugin)
}

@Testable
final public class SegmentAnalyticsService: SegmentAnalyticsServiceProtocol {
    private let analytics: Analytics
    
    // Init manager
    public init(writeKey: String, addFirebaseAnalytics: Bool) {
        let configuration = Configuration(writeKey: writeKey)
                        .trackApplicationLifecycleEvents(true)
                        .flushInterval(10)
        analytics = Analytics(configuration: configuration)
        if addFirebaseAnalytics {
            analytics.add(plugin: FirebaseDestination())
        }
    }
    
    public func identify(id: String, username: String?, email: String?) {
        guard let email = email, let username = username else {
            assertionFailure("Email and Username are required for identifying user")
            return
        }
        let traits: [String: String] = [
            "email": email,
            "username": username
        ]
        analytics.identify(userId: id, traits: traits)
    }
    
    public func logEvent(_ event: String, parameters: [String: Any]?) {
        analytics.track(
            name: event,
            properties: parameters
        )
    }
    
    public func logScreenEvent(_ event: String, parameters: [String: Any]?) {
        analytics.screen(title: event, properties: parameters)
    }
    
    public func receivedRemoteNotification(userInfo: [AnyHashable: Any]) {
        analytics.receivedRemoteNotification(userInfo: userInfo)
    }
    
    public func registeredForRemoteNotifications(deviceToken: Data) {
        analytics.registeredForRemoteNotifications(deviceToken: deviceToken)
    }
    
    public func add(plugin: Plugin) {
        analytics.add(plugin: plugin)
    }
}
