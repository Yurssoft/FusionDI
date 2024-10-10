//
//  PhotosService.swift
//  PhotosService
//
//  Created by Yurii Boiko on 10/10/24.
//

import Foundation
import PhotosServiceProtocols
import FusionDI

extension PhotosServiceDependency {
    public static var prod: PhotosServiceDependency {
        PhotosServiceDependency(service: PhotosService.photosService())
    }
}

public struct PhotosService {
    public static func photosService() -> PhotosService {
        let manager = PhotosManager()
        let service = PhotosService(
            fetchAllPhotos: manager.fetchAllPhotos
        )
        return service
    }
    
    public var fetchAllPhotos: () async throws -> [Photo]
}

final class PhotosManager {
    let fetchedPhotos = [
        Photo(id: "1", imageData: Data(), creationDate: Date()),
        Photo(id: "2", imageData: Data(), creationDate: Date()),
        Photo(id: "3", imageData: Data(), creationDate: Date()),
        Photo(id: "4", imageData: Data(), creationDate: Date()),
        Photo(id: "5", imageData: Data(), creationDate: Date()),
        Photo(id: "6", imageData: Data(), creationDate: Date()),
        Photo(id: "7", imageData: Data(), creationDate: Date()),
        Photo(id: "8", imageData: Data(), creationDate: Date()),
        Photo(id: "9", imageData: Data(), creationDate: Date()),
        Photo(id: "10", imageData: Data(), creationDate: Date()),
        Photo(id: "11", imageData: Data(), creationDate: Date()),
        Photo(id: "12", imageData: Data(), creationDate: Date()),
        Photo(id: "13", imageData: Data(), creationDate: Date()),
        Photo(id: "14", imageData: Data(), creationDate: Date()),
        Photo(id: "15", imageData: Data(), creationDate: Date()),
        Photo(id: "16", imageData: Data(), creationDate: Date()),
        Photo(id: "17", imageData: Data(), creationDate: Date()),
        Photo(id: "18", imageData: Data(), creationDate: Date()),
        Photo(id: "19", imageData: Data(), creationDate: Date()),
        Photo(id: "20", imageData: Data(), creationDate: Date()),
        Photo(id: "21", imageData: Data(), creationDate: Date()),
        Photo(id: "22", imageData: Data(), creationDate: Date()),
        Photo(id: "23", imageData: Data(), creationDate: Date()),
        Photo(id: "24", imageData: Data(), creationDate: Date()),
        Photo(id: "25", imageData: Data(), creationDate: Date()),
        Photo(id: "26", imageData: Data(), creationDate: Date()),
        Photo(id: "27", imageData: Data(), creationDate: Date())
    ]
    
    public func fetchAllPhotos() async throws -> [Photo] {
        let photos = try await fetchPhotosFromLibrary()
        return photos
    }

    private func fetchPhotosFromLibrary() async throws -> [Photo] {
        try await Task.sleep(nanoseconds: UInt64(1.0 * 1_000_000_000))
        return fetchedPhotos
    }
}
