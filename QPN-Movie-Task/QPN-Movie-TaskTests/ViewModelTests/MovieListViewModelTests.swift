//
//  MovieListViewModelTests.swift
//  QPN-Movie-Task
//
//  Created by Mahmoud Saad on 03/06/2025.
//

import XCTest
@testable import QPN_Movie_Task

@MainActor
final class MovieListViewModelTests: XCTestCase {
    
    var sut: MovieListViewModel!
    var mockFetchMoviesUseCase: MockFetchMoviesUseCase!
    
    override func setUp() {
        super.setUp()
        mockFetchMoviesUseCase = MockFetchMoviesUseCase()
        sut = MovieListViewModel(fetchMoviesUseCase: mockFetchMoviesUseCase)
    }
    
    override func tearDown() {
        sut = nil
        mockFetchMoviesUseCase = nil
        super.tearDown()
    }
    
    func testInitialState() {
        
        XCTAssertTrue(sut.movies.isEmpty)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.error)
        XCTAssertNil(sut.selectedMovie)
    }
    
    func testLoadMoviesSuccess() async {
         let expectedMovies = createTestMovies()
        mockFetchMoviesUseCase.mockMovies = expectedMovies
        
         await sut.loadMovies()
        
         XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.error)
        XCTAssertEqual(sut.movies.count, expectedMovies.count)
        XCTAssertEqual(sut.movies.first?.id, expectedMovies.first?.id)
    }
    
    func testLoadMoviesError() async {
        
        let expectedError = NetworkError.noInternetConnection
        mockFetchMoviesUseCase.mockError = expectedError
        
        await sut.loadMovies()
        
        XCTAssertFalse(sut.isLoading)
        XCTAssertNotNil(sut.error, "Error should not be nil when loadMovies fails")
        XCTAssertTrue(sut.movies.isEmpty)
        
        if let error = sut.error {
            XCTAssertNotNil(error.localizedDescription, "Error should have a valid localizedDescription")
            XCTAssertFalse(error.localizedDescription.isEmpty, "Error description should not be empty")
        } else {
            XCTFail("Error should be set when loadMovies fails")
        }
    }
    
    func testLoadMoviesErrorType() async {
        
        let expectedError = NetworkError.noInternetConnection
        mockFetchMoviesUseCase.mockError = expectedError
        
        await sut.loadMovies()
        
        XCTAssertNotNil(sut.error)
        XCTAssertTrue(sut.error is NetworkError, "Error should be of type NetworkError")
        
        if let networkError = sut.error as? NetworkError {
            XCTAssertEqual(networkError, expectedError)
        }
    }
    
    func testLoadMoviesLoadingState() async {
        
        mockFetchMoviesUseCase.shouldDelay = true
        
        
        let loadTask = Task {
            await sut.loadMovies()
        }
        
        
        try? await Task.sleep(nanoseconds: 100_000_000)
        XCTAssertTrue(sut.isLoading)
        
        await loadTask.value
        XCTAssertFalse(sut.isLoading)
    }
    
    func testGetMovieAtValidIndex() async {
       
        let movies = createTestMovies()
        mockFetchMoviesUseCase.mockMovies = movies
        
        await sut.loadMovies()
        
         
        XCTAssertEqual(sut.getMovie(at: 0)?.id, movies[0].id)
        XCTAssertEqual(sut.getMovie(at: 1)?.id, movies[1].id)
    }
    
    func testGetMovieAtInvalidIndex() async {
        
        let movies = createTestMovies()
        mockFetchMoviesUseCase.mockMovies = movies
        
        await sut.loadMovies()
        
        
        XCTAssertNil(sut.getMovie(at: -1))
        XCTAssertNil(sut.getMovie(at: movies.count))
        XCTAssertNil(sut.getMovie(at: 999))
    }
    
    func testSelectMovie() {
         
        let movie = createTestMovies().first!
        
  
        sut.selectMovie(movie)
        
        
        XCTAssertEqual(sut.selectedMovie?.id, movie.id)
        XCTAssertEqual(sut.selectedMovie?.title, movie.title)
    }
    
    func testDeselectMovie() {
         
        let movie = createTestMovies().first!
        sut.selectMovie(movie)
        
         
        sut.selectMovie(nil)
        
    
        XCTAssertNil(sut.selectedMovie)
    }
    
    // MARK: - Helper Methods
    private func createTestMovies() -> [Movie] {
        return [
            Movie(
                id: 1,
                title: "First Movie",
                overview: "First Overview",
                posterPath: "/first.jpg",
                releaseDate: "2024-01-01",
                voteAverage: 8.5,
                originalLanguage: "en",
                voteCount: 100
            ),
            Movie(
                id: 2,
                title: "Second Movie",
                overview: "Second Overview",
                posterPath: "/second.jpg",
                releaseDate: "2024-01-02",
                voteAverage: 9.0,
                originalLanguage: "es",
                voteCount: 200
            )
        ]
    }
}

 
enum NetworkError: Error, Equatable {
    case noInternetConnection
    case invalidResponse(statusCode: Int)
    case decodingError
    
    var localizedDescription: String {
        switch self {
        case .noInternetConnection:
            return "No internet connection available"
        case .invalidResponse(let statusCode):
            return "Invalid response with status code: \(statusCode)"
        case .decodingError:
            return "Failed to decode response"
        }
    }
}
