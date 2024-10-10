// swift-tools-version: 5.10

import PackageDescription

let isSupportingDebugFeatures = BuildSettingCondition.when(configuration: .debug)
let isDebugSwiftSetting: [SwiftSetting] = [
    .define("DEBUG", isSupportingDebugFeatures)
]

let fusionDIName = "FusionDI"
let fusionDIPackage = Package.Dependency.package(path: "../../FusionDI")
let fusionDIDependencies: [Target.Dependency] = [
    Target.Dependency.product(name: fusionDIName, package: fusionDIName)
]

let name = "PhotosService"
let implementation = name
let protocols = name + "Protocols"
let mock = name + "Mock"

let package = Package(
    name: name,
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: name,
            targets: [name]
        ),
        .library(
            name: protocols,
            targets: [protocols]
        ),
        .library(
            name: mock,
            targets: [mock]
        ),
        .library(
            name: name + "AllTargets",
            targets: [name, protocols, mock]
        )
    ],
    dependencies: [fusionDIPackage],
    targets: [
        .target(
            name: name,
            dependencies: [Target.Dependency.byNameItem(name: protocols, condition: .none)] + fusionDIDependencies,
            swiftSettings: isDebugSwiftSetting
        ),
        .target(
            name: protocols,
            dependencies: fusionDIDependencies,
            swiftSettings: isDebugSwiftSetting
        ),
        .target(
            name: mock,
            dependencies: [Target.Dependency.byNameItem(name: protocols, condition: .none)] + fusionDIDependencies,
            swiftSettings: isDebugSwiftSetting
        ),
        
    ]
)
