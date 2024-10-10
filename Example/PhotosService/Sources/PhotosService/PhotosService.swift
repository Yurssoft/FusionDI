//
//  PhotosService.swift
//  PhotosService
//
//  Created by Yurii Boiko on 10/10/24.
//

import Foundation
import PhotosServiceProtocols

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
    public func fetchAllPhotos() async throws -> [Photo] {
        let photos = try await fetchPhotosFromLibrary()
        return photos
    }

    private func fetchPhotosFromLibrary() async throws -> [Photo] {
        try await Task.sleep(nanoseconds: UInt64(1.0 * 1_000_000_000))
        let fetchedPhotos = [
            Photo(id: "1", imageData: Data(), creationDate: Date()),
            Photo(id: "2", imageData: Data(), creationDate: Date())
        ]
        return fetchedPhotos
    }
}
