//
//  MovieListViewModel.swift
//  QPN-Movie-Task
//
//  Created by Mahmoud Saad on 03/06/2025.
//

import Foundation

@MainActor
final class MovieListViewModel: ObservableObject {
    @Published private(set) var movies: [Movie] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error? = nil
    @Published private(set) var selectedMovie: Movie? = nil
    
    private let fetchMoviesUseCase: FetchMoviesUseCaseProtocol
    
    init(fetchMoviesUseCase: FetchMoviesUseCaseProtocol) {
        self.fetchMoviesUseCase = fetchMoviesUseCase
    }
    
    func loadMovies() async {
        isLoading = true
        error = nil
        
        defer { isLoading = false }
        
        do {
            movies = try await fetchMoviesUseCase.execute()
        } catch {
            self.error = error
        }
    }
    
    func getMovie(at index: Int) -> Movie? {
        guard index >= 0 && index < movies.count else { return nil }
        return movies[index]
    }
    
    func selectMovie(_ movie: Movie?) {
        selectedMovie = movie
    }
}
