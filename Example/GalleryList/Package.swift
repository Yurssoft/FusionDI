// swift-tools-version: 5.10

import PackageDescription

let DIName = "DependencyDefinitions"
let DIPackage = Package.Dependency.package(path: "../DependencyDefinitions")
let DIDependencies: [Target.Dependency] = [
    Target.Dependency.product(name: "DependencyDefinitions", package: DIName),
]

let fusionDIName = "FusionDI"
let fusionDIPackage = Package.Dependency.package(path: "../../FusionDI")
let fusionDIDependencies: [Target.Dependency] = [
    Target.Dependency.product(name: fusionDIName, package: fusionDIName)
]

let isSupportingDebugFeatures = BuildSettingCondition.when(configuration: .debug)
let isDebugSwiftSetting: [SwiftSetting] = [
    .define("DEBUG", isSupportingDebugFeatures)
]

let package = Package(
    name: "GalleryList",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "GalleryList",
            targets: ["GalleryList"]),
    ],
    dependencies: [
        DIPackage,
        fusionDIPackage
    ],
    targets: [
        .target(
            name: "GalleryList",
            dependencies: DIDependencies + fusionDIDependencies,
            swiftSettings: isDebugSwiftSetting
        ),

    ]
)
