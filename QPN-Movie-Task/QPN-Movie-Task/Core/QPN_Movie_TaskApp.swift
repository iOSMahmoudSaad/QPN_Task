//
//  QPN_Movie_TaskApp.swift
//  QPN-Movie-Task
//
//  Created by Mahmoud Saad on 03/06/2025.
//

import SwiftUI

@main
struct QPN_Movie_TaskApp: App {
    
    @StateObject private var coordinator = AppCoordinator(container: AppContainer.shared)

    
    var body: some Scene {
        WindowGroup {
            CoordinatorView(coordinator: coordinator)
                .environmentObject(coordinator)
        }
    }
}
