//
//  File.swift
//  EDXMobileAnalytics
//
//  Created by Anton Yarmolenka on 21/02/2025.
//

import Foundation
import EDXMobileAnalytics

class CrashlyticsMock: CrashlyticsProtocol, @unchecked Sendable {
    var setCustomValueCallsCount: Int = 0
    var receivedCustomValue: Any?
    var receivedCustomValueKey: String?

    func setCustomValue(_ value: Any?, forKey key: String) {
        setCustomValueCallsCount += 1
        receivedCustomValue = value
        receivedCustomValueKey = key
    }
}
