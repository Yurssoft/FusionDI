// swift-tools-version: 5.10

import PackageDescription

let isSupportingDebugFeatures = BuildSettingCondition.when(configuration: .debug)
let isDebugSwiftSetting: [SwiftSetting] = [
    .define("DEBUG", isSupportingDebugFeatures)
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
    targets: [
        .target(
            name: name,
            dependencies: [Target.Dependency.byNameItem(name: protocols, condition: .none)],
            swiftSettings: isDebugSwiftSetting
        ),
        .target(
            name: protocols,
            swiftSettings: isDebugSwiftSetting
        ),
        .target(
            name: mock,
            dependencies: [Target.Dependency.byNameItem(name: protocols, condition: .none)],
            swiftSettings: isDebugSwiftSetting
        ),
        
    ]
)
