//
//  NetworkConfiguration.swift
//  QPN-Movie-Task
//
//  Created by Mahmoud Saad on 03/06/2025.
//

import Foundation

// MARK: - Network Configuration

struct NetworkConfiguration {
    let baseURL: String
    let apiKey: String
    let timeout: TimeInterval
    
    static let `default` = NetworkConfiguration(
        baseURL: "https://api.themoviedb.org/3",
        apiKey: "20fce186ae942f3cf318dcaec5791f8f",
        timeout: 30.0
    )
}


// MARK: - Request Building
protocol NetworkRequest {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String: Any]? { get }
    var headers: [String: String]? { get }
}

enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

// MARK: - Specific Movie Requests
struct PopularMoviesRequest: NetworkRequest {
    let path = "/movie/popular"
    let method = HTTPMethod.GET
    let parameters: [String: Any]? = nil
    let headers: [String: String]? = nil
}
