//
//  NetworkServiceProtocol.swift
//  QPN-Movie-Task
//
//  Created by Mahmoud Saad on 03/06/2025.
//

protocol NetworkService {
    func execute<T: Decodable>(_ request: NetworkRequest) async throws -> T
}
