import Foundation

public enum Endpoint: Sendable {
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

public class NetworkClient: AnyObject {
    public func request<ReturnType: Decodable & Sendable>(for endpoint: Endpoint) async throws -> ReturnType { fatalError() }
}

public final class NetworkClientAPI: NetworkClient {
    public override init() { }
    public override func request<ReturnType: Decodable & Sendable>(for endpoint: Endpoint) async throws -> ReturnType {
        let url = URL(string: endpoint.url)!
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(ReturnType.self, from: data)
        return response
    }
}

public final class NetworkClientMock: NetworkClient {
    public override init() { }
    public override func request<ReturnType: Decodable & Sendable>(for endpoint: Endpoint) async throws -> ReturnType {
        let response = try JSONDecoder().decode(ReturnType.self, from: endpoint.mockData)
        return response
    }
}
