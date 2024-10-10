//
//  GalleryPhoto.swift
//  GalleryList
//
//  Created by Yurii Boiko on 10/10/24.
//

import Foundation
import PhotosServiceProtocols

public struct GalleryPhoto: Identifiable {
    public let id: String
    public let imageData: Data
    public let creationDate: Date
    
    public init(id: String, imageData: Data, creationDate: Date) {
        self.id = id
        self.imageData = imageData
        self.creationDate = creationDate
    }
}

public extension GalleryPhoto {
    init(from photo: Photo) {
        self.id = photo.id
        self.imageData = photo.imageData
        self.creationDate = photo.creationDate
    }
}
