//
//  DependenciesSetup.swift
//  FusionGallery
//
//  Created by Yurii Boiko on 4/8/25.
//

import Foundation
import FusionDI
import PhotosServiceProtocols
import DependencyDefinitions

extension PhotosServiceDependency {
    /*
     This module is the single point where the production implementation is instantiated or consumed. By isolating the production code here, other modules remain lightweight and avoid compiling the heavy service implementation. This design ensures that the majority of the application can rely on lightweight mocks, while only the designated module handles the heavier production dependency.
     */
    public static var prod: PhotosServiceDependency {
        PhotosServiceDependency(service: PhotosService.photosService)
    }
}

protocol DependenciesPreviewSetup {
    static func initPreviewDependencies()
}

protocol DependenciesSetup: DependenciesPreviewSetup {
    static func initDependencies()
}
