import Testing
@testable import EDXMobileAnalytics
import Segment
import SegmentFirebase
import Foundation

@Suite struct SegmentAnalyticsServiceTests {
    @Suite(".init") struct InitTest {
        @Test("When addFirebaseAnalytics is false shouldn't add plugin") func check1() async throws {
            let writeKey = UUID().uuidString
            let analyticsService = SegmentAnalyticsService(
                writeKey: writeKey,
                addFirebaseAnalytics: false
            )
            let analytics =  analyticsService.testHooks.analytics
            #expect(analytics.writeKey == writeKey)
            #expect(analytics.find(pluginType: FirebaseDestination.self) == nil)
        }
        
        @Test("When addFirebaseAnalytics is true should add plugin") func check2() async throws {
            let writeKey = UUID().uuidString
            let analyticsService = SegmentAnalyticsService(
                writeKey: writeKey,
                addFirebaseAnalytics: true
            )
            let analytics =  analyticsService.testHooks.analytics
            #expect(analytics.writeKey == writeKey)
            #expect(analytics.find(pluginType: FirebaseDestination.self) != nil)
        }
    }
}
