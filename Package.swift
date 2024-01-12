// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DBClient",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "DBClient",
            targets: ["DBClient"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-nio.git", .upToNextMajor(from: "2.62.0")),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "DBClient",
            dependencies: [.product(name: "NIOCore", package: "swift-nio"),
                           .product(name: "NIOPosix", package: "swift-nio"),
                           .product(name: "NIOHTTP1", package: "swift-nio"),
                           .product(name: "Logging", package: "swift-log")]),
        .testTarget(
            name: "DBClientTests",
            dependencies: ["DBClient"]),
    ]
)
