//
//  Data.swift
//  QPN-Movie-Task
//
//  Created by Mahmoud Saad on 03/06/2025.
//

import Foundation

final class MovieRepositoryImpl: MovieRepository {
    
    private let networkService: NetworkService
    private let cacheService: CacheService
    
    init(networkService: NetworkService, cacheService: CacheService) {
        self.networkService = networkService
        self.cacheService = cacheService
    }
    
    func fetchMovies() async throws -> [Movie] {
        if let cachedMovies = getCachedMovies() {
            return cachedMovies
        }
        
        let request = PopularMoviesRequest()
        let response: Movie = try await networkService.execute(request)
        cacheMovies([response])
        return [response]
    }
    

    
    func cacheMovies(_ movies: [Movie]) {
        cacheService.cache(movies, forKey: "movies")
    }
    
    func getCachedMovies() -> [Movie]? {
        return cacheService.retrieve(forKey: "movies")
    }
}
