//
//  File.swift
//  EDXMobileAnalytics
//
//  Created by Anton Yarmolenka on 13/01/2025.
//

import Foundation
import Segment
import EDXMobileAnalytics

final class SegmentAnalyticsServiceMock: SegmentAnalyticsServiceProtocol, @unchecked Sendable {
    var registeredForRemoteNotificationsCallsCount: Int = 0
    var registeredForRemoteNotificationsDeviceToken: Data = Data()
    
    func registeredForRemoteNotifications(deviceToken: Data) {
        registeredForRemoteNotificationsDeviceToken = deviceToken
        registeredForRemoteNotificationsCallsCount += 1
    }
    
    var addPluginCallsCount: Int = 0
    var addPluginCalledWith: [any Segment.Plugin] = []
    
    func add(plugin: any Segment.Plugin) {
        addPluginCallsCount += 1
        addPluginCalledWith.append(plugin)
    }
    
    var receivedRemoteNotificationUserInfo: [AnyHashable: Any] = [:]
    var receivedRemoteNotificationCount: Int = 0
    
    func receivedRemoteNotification(userInfo: [AnyHashable: Any]) {
        receivedRemoteNotificationCount += 1
        receivedRemoteNotificationUserInfo = userInfo
    }
    
    func identify(id: String, username: String?, email: String?) {}
    
    func logEvent(_ event: String, parameters: [String: Any]?) {}
    
    func logScreenEvent(_ event: String, parameters: [String: Any]?) {}
}
