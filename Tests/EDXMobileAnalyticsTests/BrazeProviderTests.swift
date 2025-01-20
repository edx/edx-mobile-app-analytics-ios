import Testing
@testable import EDXMobileAnalytics
import Foundation

private extension BrazeProviderTests {
    enum TestData {
        static let deviceToken: Data = Data([1, 2, 3])
    }
}

@Suite struct BrazeProviderTests {
    @Suite(".didRegisterWithDeviceToken") struct DidRegisterWithDeviceTokenTest {
        let segmentAnalyticsService = SegmentAnalyticsServiceMock()
        @Test("Should call segmentAnalyticsService methods")
        func check2() async throws {
            let brazeProvider: BrazeProvider = .init(segmentAnalyticsService: segmentAnalyticsService)
            brazeProvider.didRegisterWithDeviceToken(deviceToken: TestData.deviceToken)
            #expect(segmentAnalyticsService.addPluginCallsCount == 1)
            #expect(segmentAnalyticsService.addPluginCalledWith.count == 1)
            #expect(segmentAnalyticsService.registeredForRemoteNotificationsCallsCount == 1)
            #expect(segmentAnalyticsService.registeredForRemoteNotificationsDeviceToken == TestData.deviceToken)
        }
    }
}
