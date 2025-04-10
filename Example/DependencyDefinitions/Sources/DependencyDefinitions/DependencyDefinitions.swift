import FusionDI
import NetworkingKit
import PhotosServiceProtocols

public final class PhotosServiceDependency: ValueDependencyWrapper<PhotosService> { }

#if DEBUG

import PhotosServiceMock

public extension PhotosServiceDependency {
    static var mock: PhotosServiceDependency {
        PhotosServiceDependency(service: PhotosService.mockPhotosService)
    }
}

#endif
