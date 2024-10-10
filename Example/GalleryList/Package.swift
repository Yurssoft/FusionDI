// swift-tools-version: 5.10

import PackageDescription

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
    name: "GalleryList",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "GalleryList",
            targets: ["GalleryList"]),
    ],
    dependencies: [
        photoPackage,
        fusionDIPackage
    ],
    targets: [
        .target(
            name: "GalleryList",
            dependencies: photoDependencies + fusionDIDependencies,
            swiftSettings: isDebugSwiftSetting
        ),

    ]
)
