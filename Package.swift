// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "CommonKitUI",
    platforms: [.iOS(.v14), .macOS(.v12)],
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
            dependencies: [.byName(name: "SwiftUIExtension")]
        ),
        .target(name: "SwiftUIExtension"),
        .target(name: "UIKitExtension")
    ]
)
