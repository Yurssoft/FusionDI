//
//  PhotosServiceMock.swift
//  PhotosService
//
//  Created by Yurii Boiko on 10/10/24.
//

#if DEBUG

import Foundation
import PhotosServiceProtocols

public extension PhotosService {
    var asClient: PhotosService {
        PhotosService.createMock(client: self)
    }
}

public extension PhotosService {
    static func createMock(client: MockPhotosService) -> PhotosService {
        let service = PhotosService(
            fetchAllPhotos: client.fetchAllPhotos
        )
        return service
    }
    
    static var standardMock: MockPhotosService { MockPhotosService() }
    
    static var mockPhotosService: PhotosService {
        let client = standardMock
        let service = createMock(client: client)
        return service
    }
    
    static func testMockPhotosService(delaySeconds: Double) -> PhotosService {
        let client = MockPhotosService()
        client.delaySeconds = delaySeconds
        let service = PhotosService(
            fetchAllPhotos: client.fetchAllPhotos
        )
        return service
    }
    
    static func testErrorMockPhotosService(error: Error, delaySeconds: Double) -> PhotosService {
        let client = MockPhotosService()
        client.delaySeconds = delaySeconds
        client.error = error
        let service = PhotosService(
            fetchAllPhotos: client.fetchAllPhotos
        )
        return service
    }
}

public final class MockPhotosService {
    
    public init() {}
    
    public var delaySeconds: Double = 1
    public var error: Error?
    
    public func fetchAllPhotos() async throws -> [Photo] {
        if let error = error {
            throw error
        }
        
        try await Task.sleep(nanoseconds: UInt64(delaySeconds * 1_000_000_000))
        
        let photos = [
            Photo(id: "1555", imageData: Data(), creationDate: Date()),
            Photo(id: "24433", imageData: Data(), creationDate: Date())
        ]
        return photos
    }
}

#endif
