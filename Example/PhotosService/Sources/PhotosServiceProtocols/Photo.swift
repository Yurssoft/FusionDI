//
//  Photo.swift
//  PhotosService
//
//  Created by Yurii Boiko on 10/10/24.
//

import Foundation

public struct Photo {
    public let id: String
    public let imageData: Data
    public let creationDate: Date
    
    public init(id: String, imageData: Data, creationDate: Date) {
        self.id = id
        self.imageData = imageData
        self.creationDate = creationDate
    }
}
