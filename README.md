
# EDXMobileAnalytics

[![License](https://img.shields.io/badge/license-Apache%202.0-blue?style=flat-square)](LICENSE)

EDXMobileAnalytics is a Swift plugin for integrating analytics in edX iOS mobile application. This plugin includes support for **Segment Analytics**, **Braze** (via Segment) and **FullStory** to help developers efficiently track user behavior and events within their apps.

## Repository

[GitHub Repository](https://github.com/edx/edx-mobile-app-analytics-ios)

## Features

- **Segment Analytics**:
  - Easily integrate Segment for unified data collection and analytics.
  - Track events, user properties, and more.
- **Braze Integration** (via Segment):
  - Leverage Segment's Braze destination to deliver push notifications.
  - Track user engagement metrics seamlessly.
- **FullStory**:
  - Record and replay user sessions to analyze interactions in real-time.
  - Capture clicks, scrolls, form interactions, and more.
  - Track user journeys to identify friction points.
  - Inspect event timelines and console logs to diagnose issues efficiently.

## Installation

### Swift Package Manager (SPM)

#### Step 1
1. Open your edX iOS project in Xcode
2. Navigate to project settings > Package Dependencies
3. Click the '+' button to add a new package dependency
4. Enter the package URL: https://github.com/edx/edx-mobile-app-analytics-ios
5. Set the Dependency Rule to "Exact Version" and version to 1.0.3
6. Click "Add Package"


#### Step 2 
Import the library in your Swift code:
```swift
import EDXMobileAnalytics
```

## Usage

### Initializing Plugins

```swift
import EDXMobileAnalytics
import OEXFoundation

class AppDelegate: UIResponder, UIApplicationDelegate {
    private let pluginManager = PluginManager()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        initPlugins()
        return true
    }

    private func initPlugins() {
        // - Segment analytics
        let SegmentAnalyticsService = SegmentAnalyticsService(
            writeKey: "your_writeKey",
            addFirebaseAnalytics: true // or false
        )
        pluginManager.addPlugin(analyticsService: SegmentAnalyticsService)
        
        // - Braze
        let deepLinkManager = DeepLinkManager() // init DeepLinkManager here
        pluginManager.addPlugin(
            pushNotificationsProvider:
                BrazeProvider(
                    segmentAnalyticsService: SegmentAnalyticsService
                ),
            pushNotificationsListener:
                BrazeListener(
                    deepLinkManager: deepLinkManager,
                    segmentAnalyticsService: SegmentAnalyticsService
                )
        )
        
        // - FullStory
        let firebaseEnabled = true // or false. if true then FullStory's link will be added to Crashlytics logs
        pluginManager.addPlugin(analyticsService: FullStoryAnalyticsService(firebaseEnabled: firebaseEnabled))
    }
}
```

## Features

To use the analytics capabilities, you must use `AnalyticsManager` with the appropriate methods:

### User Identification
```swift
func identify(id: String, username: String?, email: String?)
```

### Event Logging
```swift
func logEvent(_ event: String, parameters: [String: Any]?)
```

### Screen View Tracking
```swift
func logScreenEvent(_ event: String, parameters: [String: Any]?)
```

## License

This project is licensed under the Apache License, Version 2.0. See the [LICENSE](LICENSE) file for details.

## Contact

For any questions or issues, please file a GitHub issue or contact the maintainers at [TBD](mailto:TBD).
