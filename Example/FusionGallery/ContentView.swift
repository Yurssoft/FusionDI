//
//  ContentView.swift
//  FusionGallery
//
//  Created by Yurii Boiko on 10/10/24.
//

import SwiftUI
import GalleryList

struct ContentView: View {
    let vm = GalleryList.ViewModel()
    var body: some View {
        NavigationView {
            GalleryList(viewModel: vm)
            .navigationTitle("Gallery List")
        }
    }
}

#if DEBUG

#Preview {
    GalleryList.setupPreview()
    return ContentView()
}

#endif
