// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EDXMobileAnalytics",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "EDXMobileAnalytics",
            targets: ["EDXMobileAnalytics"])
    ],
    dependencies: [
        .package(url: "https://github.com/rnr/openedx-app-foundation-ios.git", branch: "anton/plugins-experiments"),
        .package(url: "https://github.com/segmentio/analytics-swift.git", from: "1.5.3"),
        .package(url: "https://github.com/segment-integrations/analytics-swift-firebase", from: "1.3.5"),
        .package(url: "https://github.com/braze-inc/braze-segment-swift.git", from: "2.2.0"),
        .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", from: "0.57.0"),
        .package(url: "https://github.com/fernandolucheti/TestableMacro.git", from: "0.0.2")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "EDXMobileAnalytics",
            dependencies: [
                .product(name: "OEXFoundation", package: "openedx-app-foundation-ios"),
                .product(name: "Segment", package: "analytics-swift"),
                .product(name: "SegmentFirebase", package: "analytics-swift-firebase"),
                .product(name: "SegmentBraze", package: "braze-segment-swift"),
                .product(name: "TestableMacro", package: "TestableMacro")
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),
        .testTarget(
            name: "EDXMobileAnalyticsTests",
            dependencies: ["EDXMobileAnalytics"],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        )
    ]
)
