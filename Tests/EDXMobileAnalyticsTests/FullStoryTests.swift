import Testing
@testable import EDXMobileAnalytics
import Foundation
import FullStory
import FirebaseCrashlytics

private extension FullStoryTests {
    enum TestData {
        static let sessionURLString: String = "some_session_url_string"
        static let identifyID: String = "some_identifiID"
        static let eventName: String = "some_event_name"
        static let someParameterKey: String = "some_parameter_key"
        nonisolated(unsafe) static let eventParameters: [String: Any] = [someParameterKey: "some_value"]
    }
}

@Suite struct FullStoryTests {
    @Suite(".init")
    @MainActor
    struct InitTest {
        @Test("When init with parameters should have parameters set") func check1() async throws {
            // given
            let crashlytics: CrashlyticsProtocol = CrashlyticsMock()
            let fullstory = FullStoryMock.self
            fullstory.reset()
            // when
            let analyticService = FullStoryAnalyticsService(
                firebaseEnabled: false,
                crashlytics: crashlytics,
                fullstoryType: fullstory
            )
            // then
            #expect(analyticService.firebaseEnabled == false)
            #expect(analyticService.crashlytics is CrashlyticsMock)
            let isFullstoryTypeEqual: Bool = analyticService.fullstoryType == fullstory.self
            #expect(isFullstoryTypeEqual)
            #expect(fullstory.delegate === analyticService)
            #expect(fullstory.restartCallsCount == 1)
        }
        @Test("When init without parameters should set default values") func check2() async throws {
            // when
            let analyticService = FullStoryAnalyticsService(firebaseEnabled: true)
            // then
            #expect(analyticService.crashlytics is Crashlytics)
            let isFullstoryTypeEqual: Bool = analyticService.fullstoryType == FS.self
            #expect(isFullstoryTypeEqual)
        }
        @Test("When init with nil parameters should set default values") func check3() async throws {
            // when
            let analyticService = FullStoryAnalyticsService(
                firebaseEnabled: false,
                crashlytics: nil,
                fullstoryType: nil
            )
            // then
            #expect(analyticService.crashlytics is Crashlytics)
            let isFullstoryTypeEqual: Bool = analyticService.fullstoryType == FS.self
            #expect(isFullstoryTypeEqual)
        }
    }
    
    @Suite(".identify")
    @MainActor
    struct IdentifyTests {
        @Test("When identify with id") func check1() async throws {
            // given
            let fullstory = FullStoryMock.self
            fullstory.reset()
            let analyticService = FullStoryAnalyticsService(
                firebaseEnabled: true,
                crashlytics: nil,
                fullstoryType: fullstory
            )
            // when
            analyticService.identify(id: TestData.identifyID, username: nil, email: nil)
            // then
            #expect(fullstory.identifyCallsCount == 1)
            #expect(fullstory.receivedIdentifyUID == TestData.identifyID)
            let displayName = fullstory.receivedIdentifyUserVars?["displayName"] as? String ?? ""
            #expect(displayName == TestData.identifyID)
        }
    }
    
    @Suite(".logEvent")
    @MainActor
    struct LogEventTests {
        @Test("When call with parameters should set parameters") func check1() throws {
            // given
            let fullstory = FullStoryMock.self
            fullstory.reset()
            let analyticService = FullStoryAnalyticsService(
                firebaseEnabled: true,
                crashlytics: nil,
                fullstoryType: fullstory
            )
            // when
            analyticService.logEvent(TestData.eventName, parameters: TestData.eventParameters)
            // then
            #expect(fullstory.eventCallsCount == 1)
            #expect(fullstory.receivedEventName == TestData.eventName)
            #expect(
                fullstory.receivedEventProperties?[TestData.someParameterKey] as? String
                == TestData.eventParameters[TestData.someParameterKey] as? String
            )
        }
        @Test("When call with nil parameters should set empty dictionary") func check2() throws {
            // given
            let crashlytics: CrashlyticsProtocol = CrashlyticsMock()
            let fullstory = FullStoryMock.self
            fullstory.reset()
            let analyticService = FullStoryAnalyticsService(
                firebaseEnabled: true,
                crashlytics: nil,
                fullstoryType: fullstory
            )
            // when
            analyticService.logEvent(TestData.eventName, parameters: nil)
            // then
            #expect(fullstory.eventCallsCount == 1)
            #expect(fullstory.receivedEventName == TestData.eventName)
            #expect(fullstory.receivedEventProperties?.count == 0)
        }
    }
    
    @Suite(".logScreen")
    @MainActor
    struct LogScreenTests {
        @Test("When call with parameters should set parameters") func check1() throws {
            // given
            let crashlytics: CrashlyticsProtocol = CrashlyticsMock()
            let fullstory = FullStoryMock.self
            fullstory.reset()
            let page = FSPageMock()
            fullstory.pageStub = page
            let analyticService = FullStoryAnalyticsService(
                firebaseEnabled: true,
                crashlytics: nil,
                fullstoryType: fullstory
            )
            // when
            analyticService.logScreenEvent(TestData.eventName, parameters: TestData.eventParameters)
            // then
            #expect(fullstory.pageCallsCount == 1)
            #expect(fullstory.receivedPageName == TestData.eventName)
            #expect(
                fullstory.receivedPageProperties?[TestData.someParameterKey] as? String
                == TestData.eventParameters[TestData.someParameterKey] as? String
            )
            #expect(page.startCallsCount == 1)
            #expect(page.receivedStartPropertyUpdates == nil)
        }
        @Test("When call with nil parameters should set nil value") func check2() throws {
            // given
            let fullstory = FullStoryMock.self
            fullstory.reset()
            let page = FSPageMock()
            fullstory.pageStub = page
            let analyticService = FullStoryAnalyticsService(
                firebaseEnabled: true,
                crashlytics: nil,
                fullstoryType: fullstory
            )
            // when
            analyticService.logScreenEvent(TestData.eventName, parameters: nil)
            // then
            #expect(fullstory.pageCallsCount == 1)
            #expect(fullstory.receivedPageName == TestData.eventName)
            #expect(fullstory.receivedPageProperties == nil)
            #expect(page.startCallsCount == 1)
            #expect(page.receivedStartPropertyUpdates == nil)
        }
    }
    @Suite(".fullstoryDidStartSession")
    struct FullstoryDidStartSessionTest {
        @Test("When firebaseEnabled is true should set Crashlytics custom value for key 'fullstory_session_url'")
        func check1() {
            // given
            let crashlytics = CrashlyticsMock()
            let analyticService = FullStoryAnalyticsService(
                firebaseEnabled: true,
                crashlytics: crashlytics,
                fullstoryType: nil
            )
            // when
            analyticService.fullstoryDidStartSession(TestData.sessionURLString)
            // then
            #expect(crashlytics.setCustomValueCallsCount == 1)
            #expect(crashlytics.receivedCustomValue as? String == TestData.sessionURLString)
            #expect(crashlytics.receivedCustomValueKey == "fullstory_session_url")
        }
        @Test("When firebaseEnabled is false shouldn't set Crashlytics custom value for key 'fullstory_session_url'")
        func check2() {
            // given
            let crashlytics = CrashlyticsMock()
            let analyticService = FullStoryAnalyticsService(
                firebaseEnabled: false,
                crashlytics: crashlytics,
                fullstoryType: nil
            )
            // when
            analyticService.fullstoryDidStartSession(TestData.sessionURLString)
            // then
            #expect(crashlytics.setCustomValueCallsCount == 0)
            #expect(crashlytics.receivedCustomValue == nil)
            #expect(crashlytics.receivedCustomValueKey == nil)
        }
    }
}
