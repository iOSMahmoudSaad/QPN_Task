//
//  NetworkService.swift
//  QPN-Movie-Task
//
//  Created by Mahmoud Saad on 03/06/2025.
//

import Foundation


final class NetworkServiceImpl: NetworkService {
    private let configuration: NetworkConfiguration
    private let session: URLSession
    private let jsonDecoder: JSONDecoder
    
    init(
        configuration: NetworkConfiguration = .default,
        session: URLSession = .shared
    ) {
        self.configuration = configuration
        self.session = session
        self.jsonDecoder = JSONDecoder()
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = configuration.timeout
        config.timeoutIntervalForResource = configuration.timeout
    }
    
    func execute<T: Decodable>(_ request: NetworkRequest) async throws -> T {
        let url = try buildURL(for: request)
        let urlRequest = try buildURLRequest(url: url, request: request)
        
        NetworkLogger.logRequest(urlRequest)
        
        do {
            let (data, response) = try await session.data(for: urlRequest)
            try validateResponse(response)
            NetworkLogger.logResponse(response, data: data)

            return try decode(data: data, to: T.self)
        } catch let error as NetworkError {
            throw error
        } catch {
            throw mapError(error)
        }
    }
    
    // MARK: - Private Methods
    private func buildURL(for request: NetworkRequest) throws -> URL {
        guard var components = URLComponents(string: configuration.baseURL + request.path) else {
            throw NetworkError.invalidURL
        }
        
        var queryItems = [URLQueryItem(name: "api_key", value: configuration.apiKey)]
        
        if let parameters = request.parameters {
            let additionalItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            queryItems.append(contentsOf: additionalItems)
        }
        
        components.queryItems = queryItems
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        return url
    }
    
    private func buildURLRequest(url: URL, request: NetworkRequest) throws -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.timeoutInterval = configuration.timeout
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        request.headers?.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        return urlRequest
    }
    
    private func validateResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse(statusCode: -1)
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            return
        case 401:
            throw NetworkError.unauthorized
        case 403:
            throw NetworkError.forbidden
        case 404:
            throw NetworkError.notFound
        case 500...599:
            throw NetworkError.serverError(message: "Server error occurred")
        default:
            throw NetworkError.invalidResponse(statusCode: httpResponse.statusCode)
        }
    }
    
    private func decode<T: Decodable>(data: Data, to type: T.Type) throws -> T {
        do {
            return try jsonDecoder.decode(type, from: data)
        } catch {
            throw NetworkError.decodingError(underlying: error)
        }
    }
    
    private func mapError(_ error: Error) -> NetworkError {
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost:
                return .noInternetConnection
            case .timedOut:
                return .timeout
            default:
                return .unknown(underlying: error)
            }
        }
        return .unknown(underlying: error)
    }
}
