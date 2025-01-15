import Testing
@testable import EDXMobileAnalytics
import OEXFoundation
import Segment
import Foundation

private extension BrazeListenerTests {
    enum TestData {
        nonisolated(unsafe) static let dataWithoutNeededKey: [AnyHashable: Any] = ["abc": ["c": "c_value"]]
        nonisolated(unsafe) static let dataWithNeededKey: [AnyHashable: Any] = ["ab": ["c": "c_value"]]
    }
}

@Suite struct BrazeListenerTests {
    @MainActor
    @Suite(".shouldListenNotification") struct ShouldListenNotification {
        let deepLinkMananger = DeepLinkManagerProtocolMock()
        let segmentAnalyticService = SegmentAnalyticsServiceMock()
        var brazeListener: BrazeListener {
            BrazeListener(
                deepLinkManager: deepLinkMananger,
                segmentAnalyticService: segmentAnalyticService
            )
        }
        
        @Test("When 'ab' key do exist in userInfo") func check1() async throws {
            #expect(brazeListener.shouldListenNotification(userinfo: TestData.dataWithNeededKey) == true)
        }
        @Test("When 'ab' key doesn't exist in userInfo") func check2() async throws {
            #expect(brazeListener.shouldListenNotification(userinfo: TestData.dataWithoutNeededKey) == false)
        }
    }
    
    @MainActor
    @Suite(".didReceiveRemoteNotification") struct DidReceiveRemoteNotification {
        let deepLinkMananger = DeepLinkManagerProtocolMock()
        let segmentAnalyticService = SegmentAnalyticsServiceMock()
        var brazeListener: BrazeListener {
            BrazeListener(
                deepLinkManager: deepLinkMananger,
                segmentAnalyticService: segmentAnalyticService
            )
        }

        @Test("When shouldListenNotification returns false should do nothing") func check1() async throws {
            brazeListener.didReceiveRemoteNotification(userInfo: TestData.dataWithoutNeededKey)
            #expect(segmentAnalyticService.receivedRemoteNotificationCount == 0)
            #expect(deepLinkMananger.processLinkFromCallsCount == 0)
        }
        
        @Test("When shouldListenNotification returns true should call processLinkFrom") func check2() async throws {
            brazeListener.didReceiveRemoteNotification(userInfo: TestData.dataWithNeededKey)
            #expect(segmentAnalyticService.receivedRemoteNotificationCount == 1)
            #expect(deepLinkMananger.processLinkFromCallsCount == 1)
            #expect(
                segmentAnalyticService.receivedRemoteNotificationUserInfo["ab"] as? [String: String] ==
                TestData.dataWithNeededKey["ab"] as? [String: String]
            )
        }
    }
    
    @MainActor
    @Suite(".init") struct InitTest {
        @Test("Should set default value") func check1() async throws {
            let deepLinkMananger = DeepLinkManagerProtocolMock()
            let brazeListener = BrazeListener(deepLinkManager: deepLinkMananger)
            let analyticService = Mirror(reflecting: brazeListener)
                .descendant("segmentAnalyticService") as? SegmentAnalyticsServiceProtocol
            #expect(analyticService == nil)
        }
    }
}
