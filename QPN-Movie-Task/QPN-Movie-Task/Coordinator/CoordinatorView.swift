//
//  CoordinatorView.swift
//  QPN-Movie-Task
//
//  Created by Mahmoud Saad on 03/06/2025.
//

import SwiftUI
struct CoordinatorView: UIViewControllerRepresentable {
    @ObservedObject var coordinator: AppCoordinator
    
    func makeUIViewController(context: Context) -> UINavigationController {
        coordinator.start()
        return coordinator.navigationController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}
