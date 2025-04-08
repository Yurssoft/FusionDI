import Foundation

enum Endpoint {
    case products
    
    private var baseURL: String { "https://server.com" }
    
    var url: String {
        switch self {
        case .products:
            return baseURL + "products"
        }
    }
    
    fileprivate var mockData: Data {
        let data = mockString.data(using: .utf8)!
        return data
    }
    
    fileprivate var mockString: String {
        switch self {
        case .products:
            return ""
        }
    }
}

protocol NetworkClientProtocol {
    func request<ReturnType: Decodable & Sendable>(for endpoint: Endpoint) async throws -> ReturnType
}

final actor NetworkClient: NetworkClientProtocol {
    func request<ReturnType: Decodable & Sendable>(for endpoint: Endpoint) async throws -> ReturnType {
        let url = URL(string: endpoint.url)!
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(ReturnType.self, from: data)
        return response
    }
}

final actor NetworkClientMock: NetworkClientProtocol {
    func request<ReturnType: Decodable & Sendable>(for endpoint: Endpoint) async throws -> ReturnType {
        let response = try JSONDecoder().decode(ReturnType.self, from: endpoint.mockData)
        return response
    }
}
