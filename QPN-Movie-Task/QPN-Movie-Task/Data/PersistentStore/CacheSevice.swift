//
//  CacheSevice.swift
//  QPN-Movie-Task
//
//  Created by Mahmoud Saad on 03/06/2025.
//

import Foundation

final class CacheServiceImpl: CacheService {
    
    private let userDefaults = UserDefaults.standard
    
    func cache<T: Encodable>(_ object: T, forKey key: String) {
        do {
            let data = try JSONEncoder().encode(object)
            userDefaults.set(data, forKey: key)
        } catch {
            print("Error caching data: \(error)")
        }
    }
    
    func retrieve<T: Decodable>(forKey key: String) -> T? {
        guard let data = userDefaults.data(forKey: key) else { return nil }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("Error retrieving cached data: \(error)")
            return nil
        }
    }
} 
