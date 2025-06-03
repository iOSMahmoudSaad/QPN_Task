//
//  MockImageCacheService.swift
//  QPN-Movie-Task
//
//  Created by Mahmoud Saad on 03/06/2025.
//

import XCTest
@testable import QPN_Movie_Task


class MockImageCacheService: ImageCacheService {
    var mockImage: UIImage?
    var mockNetworkImage: UIImage?
    var mockError: Error?
    var getImageWasCalled = false
    var cacheImageWasCalled = false
    var clearCacheWasCalled = false
    
    func getImage(for url: URL) async -> UIImage? {
        getImageWasCalled = true
        
        if let cachedImage = mockImage {
            return cachedImage
        }
        
        if let networkImage = mockNetworkImage {
            await cacheImage(networkImage, for: url)
            return networkImage
        }
        
        return nil
    }
    
    func cacheImage(_ image: UIImage, for url: URL) async {
        cacheImageWasCalled = true
    }
    
    func clearCache() async {
        clearCacheWasCalled = true
    }
}
