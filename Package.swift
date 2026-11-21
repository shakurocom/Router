// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Router",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Router",
            targets: ["Router"]),
    ],
    dependencies: [
        .package(url: "https://github.com/shakurocom/CommonTypes.git", from: "1.9.6"),
        .package(url: "https://github.com/shakurocom/ContainerViewController.git", from: "1.0.1"),
    ],
    targets: [
        .target(
            name: "Router",
            dependencies: [
                .product(name: "CommonTypes", package: "CommonTypes"),
                .product(name: "ContainerViewController", package: "ContainerViewController"),
            ],
            path: "Source"),
    ]
)
