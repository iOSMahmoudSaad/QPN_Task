//
//  MovieListCoordinator.swift
//  QPN-Movie-Task
//
//  Created by Mahmoud Saad on 03/06/2025.
//

import UIKit
import SwiftUI
import Combine

final class MovieListCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    private let container: AppContainer
    private var viewModel: MovieListViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    init(navigationController: UINavigationController, container: AppContainer) {
        self.navigationController = navigationController
        self.container = container
    }
    
    func start() {
        let viewModel = container.makeMovieListViewModel()
        self.viewModel = viewModel
        let movieListView = MovieListView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: movieListView)
        
        viewModel.$selectedMovie
            .compactMap { $0 }
            .sink { [weak self] movie in
                self?.showMovieDetails(movie: movie)
                self?.viewModel?.selectMovie(nil)
            }
            .store(in: &cancellables)
            
        navigationController.setViewControllers([hostingController], animated: false)
    }
    
    func showMovieDetails(movie: Movie) {
        let coordinator = MovieDetailCoordinator(navigationController: navigationController, movie: movie)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
