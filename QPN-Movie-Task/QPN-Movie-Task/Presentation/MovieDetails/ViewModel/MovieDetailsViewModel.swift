//
//  MovieDetailsViewModel.swift
//  QPN-Movie-Task
//
//  Created by Mahmoud Saad on 03/06/2025.
//

import Foundation
import UIKit

@MainActor
final class MovieDetailViewModel: ObservableObject {
    @Published var posterImage: UIImage? = nil
    @Published var isLoading = false
    @Published var error: Error? = nil
    
    private let movie: Movie
    private let imageCacheService: ImageCacheService
    private let imageFetcher: (String) async -> UIImage?
    
    var movieTitle: String { movie.title }
    var movieOverview: String { movie.overview }
    var releaseDate: String { movie.releaseDate ?? "N/A" }
    var voteAverage: Double { movie.voteAverage }
    var originalLanguage: String { movie.originalLanguage ?? "N/A" }
    
    init(movie: Movie, imageCacheService:  ImageCacheService = ImageCacheServiceImpl.shared,
         imageFetcher: @escaping (String) async -> UIImage? = AsyncImageFetcher.loadImage) {
        self.movie = movie
        self.imageCacheService = imageCacheService
        self.imageFetcher = imageFetcher
        
    }
    
    func getMovieForRoute() -> Movie {
        movie
    }
    
    func loadPosterImage() async {
        isLoading = true
        error = nil
        
        defer { isLoading = false }
        
        guard let posterURL = movie.posterURL else {
            return
        }
        
        do {
            if let cachedImage = await imageCacheService.getImage(for: posterURL) {
                posterImage = cachedImage
            } else {
                if let downloadedImage = try await fetchAndCacheImage(from: posterURL) {
                    posterImage = downloadedImage
                }
            }
        } catch {
            self.error = error
            print("Error loading poster image: \(error)")
        }
    }
    
    private func fetchAndCacheImage(from url: URL) async throws -> UIImage? {
        let downloadedImage = await imageFetcher("\(url)")
        if let image = downloadedImage {
            await imageCacheService.cacheImage(image, for: url)
        }
        return downloadedImage
    }
}
