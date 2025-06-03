//
//  MockNetworkService.swift
//  QPN-Movie-Task
//
//  Created by Mahmoud Saad on 03/06/2025.
//

import XCTest
@testable import QPN_Movie_Task


class MockNetworkService: NetworkService {
    var mockResponse: MovieList?
    var mockError: Error?
    var executeWasCalled = false
    
    func execute<T: Decodable>(_ request: NetworkRequest) async throws -> T {
        executeWasCalled = true
        
        if let error = mockError {
            throw error
        }
        
        guard let response = mockResponse as? T else {
            throw NetworkError.invalidResponse(statusCode: -1)
        }
        
        return response
    }
}
