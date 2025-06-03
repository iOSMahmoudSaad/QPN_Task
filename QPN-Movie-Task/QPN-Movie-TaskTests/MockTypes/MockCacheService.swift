//
//  MockCacheService.swift
//  QPN-Movie-Task
//
//  Created by Mahmoud Saad on 03/06/2025.
//

import XCTest
@testable import QPN_Movie_Task

class MockCacheService: CacheService {
    var mockCachedMovies: [Movie]?
    var cachedMovies: [Movie]?
    var cacheWasCalled = false
    var retrieveWasCalled = false
    
    func cache<T: Encodable>(_ object: T, forKey key: String) {
        cacheWasCalled = true
        if let movies = object as? [Movie] {
            cachedMovies = movies
        }
    }
    
    func retrieve<T: Decodable>(forKey key: String) -> T? {
        retrieveWasCalled = true
        return mockCachedMovies as? T
    }
}
