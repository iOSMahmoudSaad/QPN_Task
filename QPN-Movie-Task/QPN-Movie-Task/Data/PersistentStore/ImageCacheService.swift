//
//  ImageCacheService.swift
//  QPN-Movie-Task
//
//  Created by Mahmoud Saad on 03/06/2025.
//

import Foundation
import UIKit

protocol ImageCacheService {
    func getImage(for url: URL) async -> UIImage?
    func cacheImage(_ image: UIImage, for url: URL) async
    func clearCache() async
}
