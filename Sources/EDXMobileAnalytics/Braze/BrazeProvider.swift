//
//  BrazeProvider.swift
//  OpenEdX
//
//  Created by Anton Yarmolenka on 24/01/2024.
//

import Foundation
import OEXFoundation
import SegmentBraze

final public class BrazeProvider: PushNotificationsProvider {
    
    private let segmentAnalyticService: SegmentAnalyticsService?
    
    public init(segmentAnalyticService: SegmentAnalyticsService? = nil) {
        self.segmentAnalyticService = segmentAnalyticService
    }
    
    public func didRegisterWithDeviceToken(deviceToken: Data) {
        guard let segmentService = segmentAnalyticService else { return }
        segmentService.analytics?.add(
            plugin: BrazeDestination(
                additionalConfiguration: { configuration in
                    configuration.logger.level = .info
                }, additionalSetup: { braze in
                    braze.notifications.register(deviceToken: deviceToken)
                }
            )
        )
        
        segmentService.analytics?.registeredForRemoteNotifications(deviceToken: deviceToken)
    }
    
    public func didFailToRegisterForRemoteNotificationsWithError(error: Error) {
    }
    
    public func synchronizeToken() {
    }
    
    public func refreshToken() {
    }
}
