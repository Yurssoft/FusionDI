//
//  NetworkingView.swift
//  FusionGallery
//
//  Created by Yurii Boiko on 4/8/25.
//

import SwiftUI
import FusionDI
import NetworkingKit

struct NetworkingView: View {
    @ServiceDependency private var network: NetworkClient
    var body: some View {
        Text("The text")
            .onAppear() {
                ServiceResolver.shared.register(NetworkClient.self) { NetworkClientAPI() }
                ServiceResolver.shared.register(NetworkClient.self) { NetworkClientMock() }
            }
            .task {
                let response: EmptyResponse = try! await network.request(for: .products)
                print(response)
            }
    }
}

struct EmptyResponse: Decodable { }
