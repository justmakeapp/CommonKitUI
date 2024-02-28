// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "CommonKitUI",
    platforms: [
        .iOS(.v14),
        .macOS(.v11),
        .macCatalyst(.v14),
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
        .target(name: "UIKitExtension")
    ]
)
