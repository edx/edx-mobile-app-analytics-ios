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
    
    private let segmentAnalyticsService: SegmentAnalyticsServiceProtocol
    
    public init(segmentAnalyticsService: SegmentAnalyticsServiceProtocol) {
        self.segmentAnalyticsService = segmentAnalyticsService
    }
    
    public func didRegisterWithDeviceToken(deviceToken: Data) {
        segmentAnalyticsService.add(
            plugin: BrazeDestination(
                additionalConfiguration: { configuration in
                    configuration.logger.level = .info
                }, additionalSetup: { braze in
                    braze.notifications.register(deviceToken: deviceToken)
                }
            )
        )
        
        segmentAnalyticsService.registeredForRemoteNotifications(deviceToken: deviceToken)
    }
}
