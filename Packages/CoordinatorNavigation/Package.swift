// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CoordinatorNavigation",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(name: "CoordinatorNavigation", targets: ["CoordinatorNavigation"]),
    ],
    targets: [
        .target(
            name: "CoordinatorNavigation",
            path: "Sources/CoordinatorNavigation"
        ),
    ]
)
