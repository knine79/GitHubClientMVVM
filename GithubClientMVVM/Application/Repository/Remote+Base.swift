//
//  Remote+Base.swift
//  GithubClientMVVM
//
//  Created by Samuel Kim on 2023/06/12.
//

import Foundation

enum RemoteError: Error {
    case invalidUrl
    case invalidServerResponse
    case decodeFailure
}

struct RemoteConfigurations {
    let hostname: String
    let httpsHeaders: [String: String]
}

enum HTTPMethod: String {
    case get, post, put, patch, delete
}

final class Remote {
    private let remoteConfigurations: RemoteConfigurations
    
    init(remoteConfigurations: RemoteConfigurations) {
        self.remoteConfigurations = remoteConfigurations
    }
    
    private func httpsURL(path: String, bodyParameters: [String: String]) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = remoteConfigurations.hostname
        bodyParameters.forEach { (key: String, value: String) in
            urlComponents.queryItems?.append(.init(name: key, value: value))
        }
        urlComponents.path = path
        return urlComponents.url
    }
    
    func request<Model: Decodable>(endpoint: String, method: HTTPMethod = .get, additionalHeaders: [String: String] = [:], bodyParameters: [String: String] = [:]) async throws -> Model {
        guard let requestUrl = httpsURL(path: endpoint, bodyParameters: bodyParameters) else { throw RemoteError.invalidUrl }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = method.rawValue
        remoteConfigurations.httpsHeaders.merging(additionalHeaders, uniquingKeysWith: { lhs, rhs in
            rhs
        })
        .forEach { (key: String, value: String) in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw RemoteError.invalidServerResponse
        }
        guard let value = try? JSONDecoder().decode(Model.self, from: data) else {
            throw RemoteError.decodeFailure
        }
        return value
    }
}
