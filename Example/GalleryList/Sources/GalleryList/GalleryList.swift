import SwiftUI

public struct GalleryList: View {
    public init(viewModel: GalleryList.ViewModel) {
        self.viewModel = viewModel
    }
    
    @ObservedObject var viewModel: ViewModel
    
    public var body: some View {
        List(viewModel.photos) { photo in
            HStack {
                VStack(alignment: .leading) {
                    Text("Photo ID: \(photo.id)")
                        .font(.headline)
                    Text("Data Size: \(formatDataSize(photo.imageData.count))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("Date: \(photo.creationDate, formatter: dateFormatter)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.vertical, 4)
        }
        .onAppear {
            viewModel.fetchPhotos()
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
    
    private func formatDataSize(_ sizeInBytes: Int) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: Int64(sizeInBytes))
    }
}

#if DEBUG

import FusionDI
import PhotosServiceMock
import PhotosServiceProtocols

public extension GalleryList {
    static func setupPreview() {
        ServiceResolver.shared.turnOffServiceCache()
        ServiceResolver.shared.register(PhotosServiceDependency.self) { _ in
            PhotosServiceDependency.mock
        }
    }
}

#Preview {
    GalleryList.setupPreview()
    return GalleryList(viewModel: GalleryList.ViewModel())
}

#endif
