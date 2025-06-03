//
//  AppContainer.swift
//  QPN-Movie-Task
//
//  Created by Mahmoud Saad on 03/06/2025.
//

import Foundation

@MainActor
final class AppContainer {
    static let shared = AppContainer()
    
    private init() {}
    
    // MARK: - Services
    lazy var networkService: NetworkService = {
        return NetworkServiceImpl()
    }()
    
    lazy var cacheService: CacheService = {
        return CacheServiceImpl()
    }()
    
    // MARK: - Repositories
    lazy var movieRepository: MovieRepository = {
        return MovieRepositoryImpl(
            networkService: networkService,
            cacheService: cacheService
        )
    }()
    
    // MARK: - UseCases
    lazy var fetchMoviesUseCase: FetchMoviesUseCaseProtocol = {
        return FetchMoviesUseCase(movieRepository: movieRepository)
    }()
    
    // MARK: - ViewModels
    func makeMovieListViewModel() -> MovieListViewModel {
        return MovieListViewModel(fetchMoviesUseCase: fetchMoviesUseCase)
    }
    
    // MARK: - Coordinators
    func makeAppCoordinator() -> AppCoordinator {
        return AppCoordinator(container: self)
    }
}
