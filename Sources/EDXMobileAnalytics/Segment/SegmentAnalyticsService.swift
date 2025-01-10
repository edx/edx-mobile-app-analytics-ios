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

final public class SegmentAnalyticsService: AnalyticsService {
    public let analytics: Analytics?
    
    // Init manager
    public init(writeKey: String, firebaseAnalyticSourceIsSegment: Bool) {
        let configuration = Configuration(writeKey: writeKey)
                        .trackApplicationLifecycleEvents(true)
                        .flushInterval(10)
        analytics = Analytics(configuration: configuration)
        if firebaseAnalyticSourceIsSegment {
            analytics?.add(plugin: FirebaseDestination())
        }
    }
    
    public func identify(id: String, username: String?, email: String?) {
        guard let email = email, let username = username else { return }
        let traits: [String: String] = [
            "email": email,
            "username": username
        ]
        analytics?.identify(userId: id, traits: traits)
    }
    
    public func logEvent(_ event: String, parameters: [String: Any]?) {
        analytics?.track(
            name: event,
            properties: parameters
        )
    }
    
    public func logScreenEvent(_ event: String, parameters: [String: Any]?) {
        analytics?.screen(title: event, properties: parameters)
    }
}
