//
//  GalleryListViewModel.swift
//  GalleryList
//
//  Created by Yurii Boiko on 10/10/24.
//

import SwiftUI
import PhotosServiceProtocols
import FusionDI

public final class PhotosServiceDependency: ValueDependencyWrapper<PhotosService> { }

extension GalleryList {
    public final class ViewModel: ObservableObject {
        @ServiceDependency private var photoService: PhotosServiceDependency
        @Published var photos: [GalleryPhoto] = []
        
        public init() {
            fetchPhotos()
        }
        
        func fetchPhotos() {
            Task {
                do {
                    let fetchedPhotos = try await photoService.service.fetchAllPhotos()
                    let galleryPhotos = fetchedPhotos.map { GalleryPhoto(from: $0) }
                    DispatchQueue.main.async {
                        self.photos = galleryPhotos
                    }
                } catch {
                    print("Error fetching photos: \(error)")
                }
            }
        }
    }
}
