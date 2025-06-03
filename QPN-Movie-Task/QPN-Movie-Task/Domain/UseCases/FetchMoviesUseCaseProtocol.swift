//
//  FetchMoviesUseCaseProtocol.swift
//  QPN-Movie-Task
//
//  Created by Mahmoud Saad on 03/06/2025.
//

import Foundation

protocol FetchMoviesUseCaseProtocol {
    func execute() async throws -> [Movie]
}

