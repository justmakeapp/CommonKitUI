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
            ],
            swiftSettings: makeMigrateSwift6SwiftSettings()
        ),
        .target(
            name: "SwiftUIExtension",
            dependencies: [
                "UIKitExtension"
            ],
            swiftSettings: makeMigrateSwift6SwiftSettings()
        ),
        .target(
            name: "UIKitExtension",
            swiftSettings: makeMigrateSwift6SwiftSettings()
        )
    ]
)

private func makeMigrateSwift6SwiftSettings() -> [SwiftSetting] {
    [
        //                .enableUpcomingFeature("SWIFT_UPCOMING_FEATURE_CONCISE_MAGIC_FILE"),
//        .enableUpcomingFeature("SWIFT_UPCOMING_FEATURE_DEPRECATE_APPLICATION_MAIN"),
//        .enableUpcomingFeature("SWIFT_UPCOMING_FEATURE_DISABLE_OUTWARD_ACTOR_ISOLATION"),
//        .enableUpcomingFeature("SWIFT_UPCOMING_FEATURE_FORWARD_TRAILING_CLOSURES"),
//        .enableUpcomingFeature("SWIFT_UPCOMING_FEATURE_IMPLICIT_OPEN_EXISTENTIALS"),
//        .enableUpcomingFeature("SWIFT_UPCOMING_FEATURE_IMPORT_OBJC_FORWARD_DECLS"),
//        .enableUpcomingFeature("SWIFT_UPCOMING_FEATURE_INFER_SENDABLE_FROM_CAPTURES"),
//        .enableUpcomingFeature("SWIFT_UPCOMING_FEATURE_ISOLATED_DEFAULT_VALUES"),
//        .enableUpcomingFeature("SWIFT_UPCOMING_FEATURE_GLOBAL_CONCURRENCY"),
//        .enableUpcomingFeature("SWIFT_UPCOMING_FEATURE_REGION_BASED_ISOLATION"),
//        .enableExperimentalFeature("StrictConcurrency=complete"),
//        .swiftLanguageVersion(.v6)
    ]
}
