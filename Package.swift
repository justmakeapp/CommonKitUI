// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "CommonKitUI",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "ViewComponent",
            targets: ["ViewComponent"]
        ),
        .library(
            name: "SwiftUIExtension",
            targets: ["SwiftUIExtension"]
        ),
        .library(
            name: "UIKitExtension",
            targets: ["UIKitExtension"]
        ),
    ],
    targets: [
        .target(
            name: "ViewComponent",
            dependencies: [
                "SwiftUIExtension"
            ]
        ),
        .target(
            name: "SwiftUIExtension",
            dependencies: [
                "UIKitExtension"
            ]
        ),
        .target(
            name: "UIKitExtension"
        )
    ]
)

for target in package.targets {
    target.swiftSettings = target.swiftSettings ?? []

    let swift6Settings: [SwiftSetting] = [
        .enableUpcomingFeature("SWIFT_UPCOMING_FEATURE_CONCISE_MAGIC_FILE"),
        .enableUpcomingFeature("SWIFT_UPCOMING_FEATURE_DEPRECATE_APPLICATION_MAIN"),
        .enableUpcomingFeature("SWIFT_UPCOMING_FEATURE_DISABLE_OUTWARD_ACTOR_ISOLATION"),
        .enableUpcomingFeature("SWIFT_UPCOMING_FEATURE_FORWARD_TRAILING_CLOSURES"),
        .enableUpcomingFeature("SWIFT_UPCOMING_FEATURE_IMPLICIT_OPEN_EXISTENTIALS"),
        .enableUpcomingFeature("SWIFT_UPCOMING_FEATURE_IMPORT_OBJC_FORWARD_DECLS"),
        .enableUpcomingFeature("SWIFT_UPCOMING_FEATURE_INFER_SENDABLE_FROM_CAPTURES"),
        .enableUpcomingFeature("SWIFT_UPCOMING_FEATURE_ISOLATED_DEFAULT_VALUES"),
        .enableUpcomingFeature("SWIFT_UPCOMING_FEATURE_GLOBAL_CONCURRENCY"),
        .enableUpcomingFeature("SWIFT_UPCOMING_FEATURE_REGION_BASED_ISOLATION"),
        .enableExperimentalFeature("StrictConcurrency=complete"),
    ]

    target.swiftSettings!.append(contentsOf: swift6Settings)
}
