//
//  AppCoordinator.swift
//  QPN-Movie-Task
//
//  Created by Mahmoud Saad on 03/06/2025.
//

import UIKit
import SwiftUI
import Combine

final class AppCoordinator: NSObject, Coordinator, ObservableObject, UINavigationControllerDelegate {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    @Published private(set) var currentRoute: Route = .movieList
    
    private let container: AppContainer
    
    enum Route {
        case movieList
        case movieDetails(Movie)
    }
    
    init(container: AppContainer) {
        self.container = container
        self.navigationController = UINavigationController()
        super.init()
        self.navigationController.delegate = self
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        updateCurrentRoute()
    }
    
    private func updateCurrentRoute() {
        if let topVC = navigationController.topViewController {
            if topVC is UIHostingController<MovieListView> {
                currentRoute = .movieList
            } else if let detailVC = topVC as? MovieDetailViewController {
                currentRoute = .movieDetails(detailVC.viewModel.getMovieForRoute())
            }
        }
    }
    
    func start() {
        let coordinator = MovieListCoordinator(navigationController: navigationController, container: container)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    func showMovieDetails(movie: Movie) {
        let coordinator = MovieDetailCoordinator(navigationController: navigationController, movie: movie)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}
