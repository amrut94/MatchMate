//
//  NetworkService.swift
//  MatchMate
//
//  Created by AMRUT WAGHMARE on 24/07/24.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

class NetworkService {

    /// Performs an HTTP request using the provided URLRequest and publishes the response data as a generic type.
    /// - Parameter request: The URLRequest object representing the HTTP request to be performed.
    /// - Returns: decoded response data as the specified generic type or an error.
    func performRequest<T>(from request: URLRequest) async throws -> T where T : Decodable {
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.requestFailed
        }
        let decodedResponse = try JSONDecoder().decode(T.self, from: data)
        return decodedResponse
    }
    
    /// Constructs a URLRequest based on the provided URL, HTTP method, and optional parameters.
    /// - Parameters:
    ///   - url: The URL for the request.
    ///   - method: The HTTP method for the request.
    ///   - params: Optional dictionary containing parameters for the request.
    /// - Returns: A URLRequest object configured based on the provided parameters.
    private func generateUrlRequest(url: URL, method: HTTPMethod, params: [String : String]?) -> URLRequest {
        var request: URLRequest
        
        switch method {
        case .get:
            // Construct URL with query parameters for GET request
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
            if let params = params {
                urlComponents.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
            }
            guard let finalURL = urlComponents.url else {
                fatalError("Failed to construct URL")
            }
            request = URLRequest(url: finalURL)
            
        case .post:
            // Construct URL request with HTTP body for POST request
            request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            if let params = params {
                request.httpBody = try? JSONSerialization.data(withJSONObject: params)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        }
        return request
    }
}


// Implementation of the NetworkServiceProtocol
extension NetworkService: NetworkServiceProtocol {
    
    /// Fetche data from a specified URL with a given HTTP method and optional parameters.
    /// - Parameters:
    ///   - url: The URL for the request.
    ///   - method: The HTTP method for the request.
    ///   - params: Optional dictionary containing parameters for the request.
    /// - Returns: decoded result of type T or an error, conforming to the Decodable protocol
    func fetchProfileData<T>(from url: String, method: HTTPMethod, params: [String : String]?) async throws -> T where T : Decodable {
        
        guard let url = URL(string: url) else {
           throw NetworkError.invalidURL
        }
        
        let request: URLRequest = generateUrlRequest(url: url, method: method, params: params)
        return try await performRequest(from: request)
    }
}
