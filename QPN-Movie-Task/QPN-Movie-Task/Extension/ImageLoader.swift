//
//  ImageLoader.swift
//  QPN-Movie-Task
//
//  Created by Mahmoud Saad on 03/06/2025.
//

import Foundation
import UIKit

class AsyncImageFetcher {
    
    static func loadImage(from urlString: String) async -> UIImage? {
        guard let url = URL(string: urlString) else {
            return nil
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return UIImage(data: data)
        } catch {
            print("Image loading failed: \(error)")
            return nil
        }
    }
}
