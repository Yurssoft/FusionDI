//
//  MockDependencyInitializations.swift
//  FusionGallery
//
//  Created by Yurii Boiko on 10/10/24.
//

import Foundation
import FusionDI

#if DEBUG

#warning("This file is excluded from the release configuration during compilation. To configure this, navigate to your project’s build settings and locate the “Excluded Source File Names” section. For release builds, specify patterns such as *Debug* and *Mock* to ensure that debug and mock files are not included in the final release. For more detailed guidance on how to link Swift files exclusively in debug builds, refer to this article.")

/*
Steps to link a Swift file only in Debug builds:

1. Open the project’s Build Settings.
2. Locate the "Excluded Source File Names" setting.
3. In the Release configuration, exclude files by adding patterns such as `*Debug*` and `*Mock*`.
4. Ensure that debug-specific files (e.g., mocks, test helpers) are only included in Debug builds, and not in Release builds.

Reference: https://augmentedcode.io/2022/05/02/linking-a-swift-package-only-in-debug-builds/
*/

enum DebugSettings {
    static var isMockEnabled = false
    
    static func enableMocks() {
        DebugSettings.isMockEnabled = true
        DependenciesInitiator.initDependencies()
    }
}

import PhotosServiceProtocols
import PhotosServiceMock
import PhotosService

public extension PhotosServiceDependency {
    static var mock: PhotosServiceDependency {
        PhotosServiceDependency(service: PhotosService.mockPhotosService)
    }
}

enum DependenciesInitiator {
    static func initDependencies() {
        if DebugSettings.isMockEnabled {
            ServiceResolver.shared.turnOffServiceCache()
        }
        ServiceResolver.shared.register(PhotosServiceDependency.self) { DebugSettings.isMockEnabled ? .mock : .prod }
    }
}

#else

#endif
