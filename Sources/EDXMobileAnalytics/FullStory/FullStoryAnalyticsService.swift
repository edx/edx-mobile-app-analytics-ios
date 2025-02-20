//
//  File.swift
//  EDXMobileAnalytics
//
//  Created by Anton Yarmolenka on 20/02/2025.
//

import Foundation
import FullStory
import OEXFoundation
import FirebaseCrashlytics

final public class FullStoryAnalyticsService: NSObject, AnalyticsService, FSDelegate {
    
    let firebaseEnabled: Bool
    
    public init(_ firebaseEnabled: Bool) {
        self.firebaseEnabled = firebaseEnabled
        super.init()
        FS.delegate = self
        FS.restart()
    }
    
    public func identify(id: String, username: String?, email: String?) {
        FS.identify(id, userVars: ["displayName": id])
    }
    
    public func logEvent(_ event: String, parameters: [String: Any]?) {
        FS.event(event, properties: parameters ?? [:])
    }
    
    public func logScreenEvent(_ event: String, parameters: [String: Any]?) {
        FS.page(withName: event, properties: parameters).start()
    }

    public func fullstoryDidStartSession(_ sessionUrl: String) {
        if firebaseEnabled {
            Crashlytics.crashlytics().setCustomValue(
                sessionUrl,
                forKey: "fullstory_session_url"
            )
        }
    }
}
