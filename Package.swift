// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "CommonKitUI",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .visionOS(.v1),
        .watchOS(.v9)
    ],
    products: [
        .library(name: "CoreGraphicsExt", targets: ["CoreGraphicsExt"]),
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
            name: "UIKitExtension",
            dependencies: ["CoreGraphicsExt"]
        ),
        .target(name: "CoreGraphicsExt")
    ],
    swiftLanguageModes: [.v6]
)
