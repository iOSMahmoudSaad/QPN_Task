//
//  MovieRepositoryTests.swift
//  QPN-Movie-Task
//
//  Created by Mahmoud Saad on 03/06/2025.
//

import XCTest
@testable import QPN_Movie_Task

final class MovieRepositoryTests: XCTestCase {
    
    var sut: MovieRepositoryImpl!
    var mockNetworkService: MockNetworkService!
    var mockCacheService: MockCacheService!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        mockCacheService = MockCacheService()
        sut = MovieRepositoryImpl(
            networkService: mockNetworkService,
            cacheService: mockCacheService
        )
    }
    
    override func tearDown() {
        sut = nil
        mockNetworkService = nil
        mockCacheService = nil
        super.tearDown()
    }
    
    func testFetchMoviesFromNetworkSuccess() async throws {
         let expectedMovies = createTestMovies()
        mockNetworkService.mockResponse = MovieList(results: expectedMovies)
        
         let result = try await sut.fetchMovies()
        
        XCTAssertEqual(result.count, expectedMovies.count)
        XCTAssertEqual(result.first?.id, expectedMovies.first?.id)
        XCTAssertEqual(result.first?.title, expectedMovies.first?.title)
        XCTAssertTrue(mockCacheService.cacheWasCalled)
    }
    
    func testFetchMoviesFromCacheWhenAvailable() async throws {
         let cachedMovies = createTestMovies()
        mockCacheService.mockCachedMovies = cachedMovies
        
         let result = try await sut.fetchMovies()
        
        XCTAssertEqual(result.count, cachedMovies.count)
        XCTAssertEqual(result.first?.id, cachedMovies.first?.id)
        XCTAssertFalse(mockNetworkService.executeWasCalled)
    }
    
    func testFetchMoviesNetworkErrorThrown() async {
         let expectedError = NetworkError.noInternetConnection
        mockNetworkService.mockError = expectedError
        
         do {
            _ = try await sut.fetchMovies()
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is NetworkError)
        }
    }
    
    func testCacheMoviesCallsCacheService() {
         let movies = createTestMovies()
        
         sut.cacheMovies(movies)
        
        XCTAssertTrue(mockCacheService.cacheWasCalled)
        XCTAssertEqual(mockCacheService.cachedMovies?.count, movies.count)
    }
    
    // MARK: - Helper Methods
    private func createTestMovies() -> [Movie] {
        return [
            Movie(
                id: 1,
                title: "Test Movie 1",
                overview: "Test Overview 1",
                posterPath: "/test1.jpg",
                releaseDate: "2024-01-01",
                voteAverage: 8.5,
                originalLanguage: "en",
                voteCount: 100
            ),
            Movie(
                id: 2,
                title: "Test Movie 2",
                overview: "Test Overview 2",
                posterPath: "/test2.jpg",
                releaseDate: "2024-01-02",
                voteAverage: 9.0,
                originalLanguage: "es",
                voteCount: 200
            )
        ]
    }
}
