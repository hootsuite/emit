// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Emit",
    products: [
        .library(name: "Emit", targets: ["Emit"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "Emit", path: "Sources"),
        .testTarget(name: "EmitTests", dependencies: ["Emit"], path: "Tests")
    ]
)
