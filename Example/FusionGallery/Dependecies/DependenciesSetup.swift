//
//  DependenciesSetup.swift
//  FusionGallery
//
//  Created by Yurii Boiko on 4/8/25.
//

import Foundation
import FusionDI
import PhotosServiceProtocols
import GalleryList

extension PhotosServiceDependency {
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
