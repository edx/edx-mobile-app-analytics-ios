import Testing
@testable import EDXMobileAnalytics
import Foundation

private extension BrazeProviderTests {
    enum TestData {
        static let deviceToken: Data = Data([1, 2, 3])
    }
}

@Suite struct BrazeProviderTests {
    @Suite(".init") struct InitTest {
        @Test("Should set default value") func check1() async throws {
            let brazeProvider = BrazeProvider()
            let analyticService = Mirror(reflecting: brazeProvider).descendant("segmentAnalyticService") as? SegmentAnalyticsServiceProtocol
            #expect(analyticService == nil)
        }
    }

    @Suite(".didRegisterWithDeviceToken") struct DidRegisterWithDeviceTokenTest {
        let segmentAnalyticService = SegmentAnalyticsServiceMock()
        
        @Test("When segmentAnalyticService is nil should do nothing") func check1() async throws {
            let brazeProviderWithNilService: BrazeProvider = .init()
            brazeProviderWithNilService.didRegisterWithDeviceToken(deviceToken: TestData.deviceToken)
            #expect(segmentAnalyticService.addPluginCallsCount == 0)
            #expect(segmentAnalyticService.addPluginCalledWith.isEmpty)
            #expect(segmentAnalyticService.registeredForRemoteNotificationsCallsCount == 0)
            #expect(segmentAnalyticService.registeredForRemoteNotificationsDeviceToken.isEmpty)
        }
        
        
        @Test("When segmentAnalyticService is not nil should call segmentAnalyticService methods") func check2() async throws {
            let brazeProvider: BrazeProvider = .init(segmentAnalyticService: segmentAnalyticService)
            brazeProvider.didRegisterWithDeviceToken(deviceToken: TestData.deviceToken)
            #expect(segmentAnalyticService.addPluginCallsCount == 1)
            #expect(segmentAnalyticService.addPluginCalledWith.count == 1)
            #expect(segmentAnalyticService.registeredForRemoteNotificationsCallsCount == 1)
            #expect(segmentAnalyticService.registeredForRemoteNotificationsDeviceToken == TestData.deviceToken)
        }
    }
}
