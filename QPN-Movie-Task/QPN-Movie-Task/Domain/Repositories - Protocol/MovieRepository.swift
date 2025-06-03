//
//  usecase.swift
//  QPN-Movie-Task
//
//  Created by Mahmoud Saad on 03/06/2025.
//

protocol MovieRepository {
    
    func fetchMovies() async throws -> [Movie]
    func cacheMovies(_ movies: [Movie])
    func getCachedMovies() -> [Movie]?
    
}
