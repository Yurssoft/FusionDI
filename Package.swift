// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "FusionDI",
    products: [
        .library(name: "FusionDI", targets: ["FusionDI"]),
    ],
    targets: [
        .target(name: "FusionDI"),
    ]
)
