//
//  FusionGalleryApp.swift
//  FusionGallery
//
//  Created by Yurii Boiko on 10/10/24.
//

import SwiftUI

@main
struct FusionGalleryApp: App {
    init() {
        DependenciesInitiator.initDependencies()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
