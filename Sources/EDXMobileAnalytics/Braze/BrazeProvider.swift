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
    
    private let segmentAnalyticService: SegmentAnalyticsServiceProtocol?
    
    public init(segmentAnalyticService: SegmentAnalyticsServiceProtocol? = nil) {
        self.segmentAnalyticService = segmentAnalyticService
    }
    
    public func didRegisterWithDeviceToken(deviceToken: Data) {
        guard let segmentService = segmentAnalyticService else { return }
        segmentService.add(
            plugin: BrazeDestination(
                additionalConfiguration: { configuration in
                    configuration.logger.level = .info
                }, additionalSetup: { braze in
                    braze.notifications.register(deviceToken: deviceToken)
                }
            )
        )
        
        segmentService.registeredForRemoteNotifications(deviceToken: deviceToken)
    }
}
