//
//  BrazeListener.swift
//  OpenEdX
//
//  Created by Anton Yarmolenka on 24/01/2024.
//

import Foundation
import OEXFoundation

public class BrazeListener: PushNotificationsListener {
    
    private let deepLinkManager: DeepLinkManagerProtocol
    private let segmentAnalyticsService: SegmentAnalyticsServiceProtocol?
    
    public init(
        deepLinkManager: DeepLinkManagerProtocol,
        segmentAnalyticsService: SegmentAnalyticsServiceProtocol? = nil
    ) {
        self.deepLinkManager = deepLinkManager
        self.segmentAnalyticsService = segmentAnalyticsService
    }
    
    public func shouldListenNotification(userinfo: [AnyHashable: Any]) -> Bool {
        //A push notification sent from the braze has a key ab in it like ab = {c = "c_value";};
        let data = userinfo["ab"] as? [String: Any]
        return data != nil
    }
    
    public func didReceiveRemoteNotification(userInfo: [AnyHashable: Any]) {
        guard shouldListenNotification(userinfo: userInfo) else { return }
        
        segmentAnalyticsService?.receivedRemoteNotification(userInfo: userInfo)
        deepLinkManager.processLinkFrom(userInfo: userInfo)
    }
}
