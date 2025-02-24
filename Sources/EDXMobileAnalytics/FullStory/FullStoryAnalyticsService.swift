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

public protocol CrashlyticsProtocol: Sendable {
    func setCustomValue(_ value: Any?, forKey key: String)
}
extension Crashlytics: CrashlyticsProtocol, @unchecked @retroactive Sendable {}

public protocol FullStoryProtocol {
    static var delegate: FSDelegate? { get set }
    static func restart()
    static func identify(_ uid: String, userVars: [String: Any])
    static func event(_ name: String, properties: [String: Any])
    static func page(withName pageName: String, properties: [String: Any]?) -> any FSPage
}
extension FS: FullStoryProtocol {}

final public class FullStoryAnalyticsService: NSObject, AnalyticsService, FSDelegate {
    let firebaseEnabled: Bool
    let crashlytics: CrashlyticsProtocol
    let fullstoryType: FullStoryProtocol.Type
    
    public init(
        _ firebaseEnabled: Bool,
        crashlytics: CrashlyticsProtocol = Crashlytics.crashlytics(),
        fullstoryType: FullStoryProtocol.Type = FS.self
    ) {
        self.firebaseEnabled = firebaseEnabled
        self.crashlytics = crashlytics
        self.fullstoryType = fullstoryType
        super.init()
        fullstoryType.delegate = self
        fullstoryType.restart()
    }
    
    public func identify(id: String, username: String?, email: String?) {
        fullstoryType.identify(id, userVars: ["displayName": id])
    }
    
    public func logEvent(_ event: String, parameters: [String: Any]?) {
        fullstoryType.event(event, properties: parameters ?? [:])
    }
    
    public func logScreenEvent(_ event: String, parameters: [String: Any]?) {
        fullstoryType.page(withName: event, properties: parameters).start()
    }

    public func fullstoryDidStartSession(_ sessionUrl: String) {
        if firebaseEnabled {
            crashlytics.setCustomValue(
                sessionUrl,
                forKey: "fullstory_session_url"
            )
        }
    }
}
