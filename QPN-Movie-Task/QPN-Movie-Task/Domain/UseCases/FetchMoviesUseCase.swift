//
//  FetchMoviesUseCase.swift
//  QPN-Movie-Task
//
//  Created by Mahmoud Saad on 03/06/2025.
//


final class FetchMoviesUseCase: FetchMoviesUseCaseProtocol {
    private let movieRepository: MovieRepository
    
    init(movieRepository: MovieRepository) {
        self.movieRepository = movieRepository
    }
    
    func execute() async throws -> [Movie] {
        try await movieRepository.fetchMovies()
    }
}
