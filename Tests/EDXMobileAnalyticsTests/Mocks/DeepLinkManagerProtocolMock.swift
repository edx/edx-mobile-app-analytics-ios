//
//  DeepLinkManagerProtocolMock.swift
//  OEXFoundation
//
//  Created by Anton Yarmolenka on 13/01/2025.
//

import Foundation
import OEXFoundation

public class DeepLinkManagerProtocolMock: DeepLinkManagerProtocol {
    public var processLinkFromUserInfo: [AnyHashable: Any] = [:]
    public var processLinkFromCallsCount: Int = 0
    
    public func processLinkFrom(userInfo: [AnyHashable: Any]) {
        processLinkFromCallsCount += 1
        processLinkFromUserInfo = userInfo
    }
    
    public var processDeepLinkUserInfo: [AnyHashable: Any]?
    public var processDeepLinkCallsCount: Int = 0

    public func processDeepLink(with params: [AnyHashable: Any]?) {
        processDeepLinkCallsCount += 1
        processDeepLinkUserInfo = params
    }
    public init() {}
}
