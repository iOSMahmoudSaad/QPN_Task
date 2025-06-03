//
//  Untitled.swift
//  QPN-Movie-Task
//
//  Created by Mahmoud Saad on 03/06/2025.
//

import UIKit

final class MovieDetailCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    private let movie: Movie
    
    init(navigationController: UINavigationController, movie: Movie) {
        self.navigationController = navigationController
        self.movie = movie
    }
    
    func start() {
        let viewModel = MovieDetailViewModel(movie: movie)
        let viewController = MovieDetailViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
