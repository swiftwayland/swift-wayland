// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftWayland",
    products: [
        .library(name: "Cwayland", targets: ["Cwayland"]),
        .library(name: "SwiftWayland", targets: ["SwiftWayland"]),
    ],
    targets: [
        .systemLibrary(name: "Cwayland"),
        .target(name: "SwiftWayland", dependencies: ["Cwayland"]),
    ]
)
