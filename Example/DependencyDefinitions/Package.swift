// swift-tools-version: 6.1

import PackageDescription

let networkName = "NetworkingKit"
let networkPackage = Package.Dependency.package(path: "../NetworkingKit")
let networkDependencies: [Target.Dependency] = [
    Target.Dependency.product(name: "NetworkingKit", package: networkName),
]

let photonsName = "PhotosService"
let photoPackage = Package.Dependency.package(path: "../PhotosService")
let photoDependencies: [Target.Dependency] = [
    Target.Dependency.product(name: photonsName + "Mock", package: photonsName),
    Target.Dependency.product(name: photonsName + "Protocols", package: photonsName)
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
    name: "DependencyDefinitions",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "DependencyDefinitions",
            targets: ["DependencyDefinitions"]),
    ],
    dependencies: [
        photoPackage,
        fusionDIPackage,
        networkPackage,
    ],
    targets: [
        .target(
            name: "DependencyDefinitions",
            dependencies: photoDependencies + fusionDIDependencies + networkDependencies,
            swiftSettings: isDebugSwiftSetting
        ),
    ]
)
