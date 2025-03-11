//
//  File.swift
//  EDXMobileAnalytics
//
//  Created by Anton Yarmolenka on 21/02/2025.
//

import Foundation
import EDXMobileAnalytics
import FullStory

class FSPageMock: NSObject, FSPage {
    var startCallsCount: Int = 0
    
    func start() {
        startCallsCount += 1
    }
    
    var startWithPropertyUpdatesCallsCount: Int = 0
    var receivedStartPropertyUpdates: [String: Any]?
    
    func start(withPropertyUpdates propertyUpdates: [String: Any]?) {
        startWithPropertyUpdatesCallsCount += 1
        receivedStartPropertyUpdates = propertyUpdates
    }
    
    var endCallsCount: Int = 0
    
    func end() {
        endCallsCount += 1
    }
    
    var updatePropertiesCallsCount: Int = 0
    var receivedProperties: [String: Any]?
    
    func updateProperties(_ properties: [String: Any]?) {
        updatePropertiesCallsCount += 1
        receivedProperties = properties
    }
}

class FullStoryMock: FullStoryProtocol {
    nonisolated(unsafe) static var delegateStub: FSDelegate?
    nonisolated(unsafe) static var receivedDelegate: FSDelegate?
    
    static var delegate: FSDelegate? {
        get {
            if let stub = delegateStub {
                return stub
            }
            return receivedDelegate
        }
        set {
            receivedDelegate = newValue
        }
    }
    
    nonisolated(unsafe) static var restartCallsCount: Int = 0
    
    static func restart() {
        restartCallsCount += 1
    }
    
    nonisolated(unsafe) static var identifyCallsCount: Int = 0
    nonisolated(unsafe) static var receivedIdentifyUID: String?
    nonisolated(unsafe) static var receivedIdentifyUserVars: [String: Any]?
    
    static func identify(_ uid: String, userVars: [String: Any]) {
        identifyCallsCount += 1
        receivedIdentifyUID = uid
        receivedIdentifyUserVars = userVars
    }
    
    nonisolated(unsafe) static var eventCallsCount: Int = 0
    nonisolated(unsafe) static var receivedEventName: String?
    nonisolated(unsafe) static var receivedEventProperties: [String: Any]?
    
    static func event(_ name: String, properties: [String: Any]) {
        eventCallsCount += 1
        receivedEventName = name
        receivedEventProperties = properties
    }
    
    nonisolated(unsafe) static var pageStub: (any FSPage)?
    nonisolated(unsafe) static var pageCallsCount: Int = 0
    nonisolated(unsafe) static var receivedPageName: String?
    nonisolated(unsafe) static var receivedPageProperties: [String: Any]?
    
    static func page(withName pageName: String, properties: [String: Any]?) -> any FSPage {
        receivedPageProperties = properties
        receivedPageName = pageName
        pageCallsCount += 1
        return pageStub!
    }
    
    static func reset() {
        delegateStub = nil
        receivedDelegate = nil
        restartCallsCount = 0
        identifyCallsCount = 0
        receivedIdentifyUID = nil
        receivedIdentifyUserVars = nil
        eventCallsCount = 0
        receivedEventName = nil
        receivedEventProperties = nil
        pageStub = nil
        pageCallsCount = 0
        receivedPageName = nil
        receivedPageProperties = nil
    }
}
