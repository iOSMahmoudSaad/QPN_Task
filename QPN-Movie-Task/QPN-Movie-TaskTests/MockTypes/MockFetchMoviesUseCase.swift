//
//  MockFetchMoviesUseCase.swift
//  QPN-Movie-Task
//
//  Created by Mahmoud Saad on 03/06/2025.
//

import XCTest
@testable import QPN_Movie_Task


class MockFetchMoviesUseCase: FetchMoviesUseCaseProtocol {
    
    var mockMovies: [Movie] = []
    var mockError: Error?
    var shouldDelay = false
    
    func execute() async throws -> [Movie] {
        if shouldDelay {
            try await Task.sleep(nanoseconds: 500_000_000)
        }
        
        if let error = mockError {
            throw error
        }
        return mockMovies
    }
}
