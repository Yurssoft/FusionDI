import Foundation

enum Endpoint {
    case products
    
    var url: String {
        switch self {
        case .products:
            return "https://server.com"
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
        let response = try JSONDecoder().decode(ReturnType.self, from: Self.mockResponse)
        return response
    }
}

extension NetworkClientMock {
    static var mockResponse: Data {
        let response = ""
        let data = response.data(using: .utf8)!
        return data
    }
}
