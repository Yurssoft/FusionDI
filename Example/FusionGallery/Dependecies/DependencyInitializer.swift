//
//  DependencyInitializations.swift
//  FusionGallery
//
//  Created by Yurii Boiko on 10/10/24.
//

import Foundation
import FusionDI

#if DEBUG

#else
import PhotosServiceProtocols
import PhotosService

enum DependenciesInitiator {
    static func initDependencies() {
        ServiceResolver.shared.register(PhotosServiceDependency.self) { PhotosServiceDependency.prod }
    }
}

#endif
