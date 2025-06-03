//
//  CacheSeviceProtocol.swift
//  QPN-Movie-Task
//
//  Created by Mahmoud Saad on 03/06/2025.
//


protocol CacheService {
    
    func cache<T: Encodable>(_ object: T, forKey key: String)
    func retrieve<T: Decodable>(forKey key: String) -> T?
}
