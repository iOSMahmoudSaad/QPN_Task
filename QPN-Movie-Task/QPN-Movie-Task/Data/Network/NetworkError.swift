//
//  NetworkError.swift
//  QPN-Movie-Task
//
//  Created by Mahmoud Saad on 03/06/2025.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noInternetConnection
    case timeout
    case invalidResponse(statusCode: Int)
    case decodingError(underlying: Error)
    case encodingError(underlying: Error)
    case serverError(message: String)
    case unauthorized
    case forbidden
    case notFound
    case unknown(underlying: Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noInternetConnection:
            return "No internet connection"
        case .timeout:
            return "Request timed out"
        case .invalidResponse(let statusCode):
            return "Invalid response with status code: \(statusCode)"
        case .decodingError:
            return "Failed to decode response"
        case .encodingError:
            return "Failed to encode request"
        case .serverError(let message):
            return "Server error: \(message)"
        case .unauthorized:
            return "Unauthorized access"
        case .forbidden:
            return "Access forbidden"
        case .notFound:
            return "Resource not found"
        case .unknown:
            return "An unknown error occurred"
        }
    }
}
