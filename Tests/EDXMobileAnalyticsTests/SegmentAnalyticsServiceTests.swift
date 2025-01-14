import Testing
@testable import EDXMobileAnalytics
import Segment
import SegmentFirebase
import Foundation

@Suite struct SegmentAnalyticsServiceTests {
    @Suite(".init") struct InitTest {
        @Test("When firebaseAnalyticSourceIsSegment is false shouldn't add plugin") func check1() async throws {
            let analyticService = SegmentAnalyticsService(writeKey: UUID().uuidString, firebaseAnalyticSourceIsSegment: false)
            let analytics = Mirror(reflecting: analyticService).descendant("analytics") as? Analytics
            #expect(analytics != nil)
            #expect(analytics?.find(pluginType: FirebaseDestination.self) == nil)
        }
        
        @Test("When firebaseAnalyticSourceIsSegment is true should add plugin") func check2() async throws {
            let analyticService = SegmentAnalyticsService(writeKey: UUID().uuidString, firebaseAnalyticSourceIsSegment: true)
            let analytics = Mirror(reflecting: analyticService).descendant("analytics") as? Analytics
            #expect(analytics != nil)
            #expect(analytics?.find(pluginType: FirebaseDestination.self) != nil)
        }
    }
}
