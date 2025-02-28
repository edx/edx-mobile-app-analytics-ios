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

    public convenience init(firebaseEnabled: Bool) {
        self.init(firebaseEnabled: firebaseEnabled, crashlytics: Crashlytics.crashlytics(), fullstoryType: FS.self)
    }
    
    init(
        firebaseEnabled: Bool,
        crashlytics: CrashlyticsProtocol?,
        fullstoryType: FullStoryProtocol.Type?
    ) {
        self.firebaseEnabled = firebaseEnabled
        self.crashlytics = crashlytics ?? Crashlytics.crashlytics()
        self.fullstoryType = fullstoryType ?? FS.self
        super.init()
        self.fullstoryType.delegate = self
        self.fullstoryType.restart()
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
