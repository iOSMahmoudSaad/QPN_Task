//
//  MovieDetailViewModelTests.swift
//  QPN-Movie-Task
//
//  Created by Mahmoud Saad on 03/06/2025.
//

import XCTest
@testable import QPN_Movie_Task

@MainActor
final class MovieDetailViewModelTests: XCTestCase {
    
    var sut: MovieDetailViewModel!
    var mockImageCacheService: MockImageCacheService!
    var mockAsyncImageFetcher: MockAsyncImageFetcher!
    var testMovie: Movie!
    
    override func setUp() {
        super.setUp()
        mockImageCacheService = MockImageCacheService()
        mockAsyncImageFetcher = MockAsyncImageFetcher()
        testMovie = createTestMovie()
        sut = MovieDetailViewModel(
            movie: testMovie,
            imageCacheService: mockImageCacheService
        )
    }
    
    override func tearDown() {
        sut = nil
        mockImageCacheService = nil
        mockAsyncImageFetcher = nil
        testMovie = nil
        super.tearDown()
    }
    
    func testInitialState() {
        
        XCTAssertNil(sut.posterImage)
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.error)
    }
    
    func testMovieDetailsProperties() {
        
        XCTAssertEqual(sut.movieTitle, testMovie.title)
        XCTAssertEqual(sut.movieOverview, testMovie.overview)
        XCTAssertEqual(sut.releaseDate, testMovie.releaseDate)
        XCTAssertEqual(sut.voteAverage, testMovie.voteAverage)
        XCTAssertEqual(sut.originalLanguage, testMovie.originalLanguage)
    }
    
    func testLoadPosterImageFromCacheSuccess() async {
        
         let testImage = UIImage()
        mockImageCacheService.mockImage = testImage
        
         await sut.loadPosterImage()
        
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.error)
        XCTAssertNotNil(sut.posterImage)
        XCTAssertTrue(mockImageCacheService.getImageWasCalled)
    }
    
    func testLoadPosterImageFromNetworkWhenNotCached() async {
        
        mockImageCacheService.mockImage = nil
        mockImageCacheService.mockNetworkImage = UIImage()
        
         await sut.loadPosterImage()
        
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.error)
        XCTAssertNotNil(sut.posterImage)
        XCTAssertTrue(mockImageCacheService.getImageWasCalled)
        XCTAssertTrue(mockImageCacheService.cacheImageWasCalled)
    }
    
    func testLoadPosterImageFailure() async {
         mockImageCacheService.mockImage = nil
        mockImageCacheService.mockNetworkImage = nil
        
         await sut.loadPosterImage()
        
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.posterImage)  
        XCTAssertTrue(mockImageCacheService.getImageWasCalled)
     }
    
    func testLoadPosterImageWithNilPosterPath() async {
         let movieWithNilPoster = Movie(
            id: 1,
            title: "Test Movie",
            overview: "Test Overview",
            posterPath: nil,
            releaseDate: "2024-01-01",
            voteAverage: 8.5,
            originalLanguage: "en",
            voteCount: 100
        )
        sut = MovieDetailViewModel(movie: movieWithNilPoster, imageCacheService: mockImageCacheService)
        
         await sut.loadPosterImage()
        
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.error)
        XCTAssertNil(sut.posterImage)
        XCTAssertFalse(mockImageCacheService.getImageWasCalled)
    }
    
    func testGetMovieForRoute() {
         let movie = sut.getMovieForRoute()
        
        XCTAssertEqual(movie.id, testMovie.id)
        XCTAssertEqual(movie.title, testMovie.title)
    }
    
    // MARK: - Helper Methods
    private func createTestMovie() -> Movie {
        return Movie(
            id: 1,
            title: "Test Movie",
            overview: "Test Overview",
            posterPath: "/test.jpg",
            releaseDate: "2024-01-01",
            voteAverage: 8.5,
            originalLanguage: "en",
            voteCount: 100
        )
    }
}
