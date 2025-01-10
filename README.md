
# EDXMobileAnalytics

[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)

EDXMobileAnalytics is a Swift plugin for integrating analytics in edX iOS mobile applications. This plugin includes support for **Segment Analytics** and **Braze** (via Segment) to help developers efficiently track user behavior and events within their apps.

## Repository

[GitHub Repository](https://github.com/edx/edx-mobile-app-analytics-ios)

## Features

- **Segment Analytics**:
  - Easily integrate Segment for unified data collection and analytics.
  - Track events, user properties, and more.
- **Braze Integration** (via Segment):
  - Leverage Segment's Braze destination to deliver push notifications.
  - Track user engagement metrics seamlessly.

## Installation

### Swift Package Manager (SPM)

#### Step 1
1. Open your edX iOS project in Xcode
2. Navigate to project settings > Package Dependencies
3. Click the '+' button to add a new package dependency
4. Enter the package URL: https://github.com/edx/edx-mobile-app-analytics-ios
5. Set the Dependency Rule to "Exact Version" and version to TBD
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
        // - Segment analytic
        if config.segment.enabled {
            pluginManager.addPlugin(analyticsService: Container.shared.resolve(SegmentAnalyticsService.self)!)
        }
        // - Braze
        if config.braze.pushNotificationsEnabled,
            let deepLinkManager = Container.shared.resolve(DeepLinkManager.self) {
            pluginManager.addPlugin(
                pushNotificationsProvider:
                    BrazeProvider(
                        segmentAnalyticService: Container.shared.resolve(SegmentAnalyticsService.self)
                    ),
                pushNotificationsListener:
                    BrazeListener(
                        deepLinkManager: deepLinkManager,
                        segmentAnalyticService: Container.shared.resolve(SegmentAnalyticsService.self)
                    )
            )
        }
        
    }
}
```

## Features

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

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contact

For any questions or issues, please file a GitHub issue or contact the maintainers at [TBD](mailto:TBD).
