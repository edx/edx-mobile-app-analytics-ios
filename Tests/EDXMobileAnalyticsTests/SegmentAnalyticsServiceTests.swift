import Testing
@testable import EDXMobileAnalytics
import Segment
import SegmentFirebase
import Foundation

@Suite struct SegmentAnalyticsServiceTests {
    @Suite(".init") struct InitTest {
        @Test("When addFirebaseAnalytics is false shouldn't add plugin") func check1() async throws {
            let analyticsService = SegmentAnalyticsService(
                writeKey: UUID().uuidString,
                addFirebaseAnalytics: false
            )
            let analytics = Mirror(reflecting: analyticsService).descendant("analytics") as? Analytics
            #expect(analytics != nil)
            #expect(analytics?.find(pluginType: FirebaseDestination.self) == nil)
        }
        
        @Test("When addFirebaseAnalytics is true should add plugin") func check2() async throws {
            let analyticsService = SegmentAnalyticsService(
                writeKey: UUID().uuidString,
                addFirebaseAnalytics: true
            )
            let analytics = Mirror(reflecting: analyticsService).descendant("analytics") as? Analytics
            #expect(analytics != nil)
            #expect(analytics?.find(pluginType: FirebaseDestination.self) != nil)
        }
    }
}
