//
//  MockAsyncImageFetcher.swift
//  QPN-Movie-Task
//
//  Created by Mahmoud Saad on 03/06/2025.
//

import XCTest
@testable import QPN_Movie_Task

class MockAsyncImageFetcher {
    
    static var mockImage: UIImage?
    static var mockError: Error?
    static var shouldThrowError = false
    
    static func loadImage(from urlString: String) async throws -> UIImage? {
        if shouldThrowError, let error = mockError {
            throw error
        }
        return mockImage
    }
}
