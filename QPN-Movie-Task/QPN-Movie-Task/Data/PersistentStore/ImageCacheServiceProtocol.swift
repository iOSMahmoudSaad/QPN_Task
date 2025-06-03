//
//  ImageCacheServiceProtocol.swift
//  QPN-Movie-Task
//
//  Created by Mahmoud Saad on 03/06/2025.
//

import Foundation
import UIKit

class ImageCacheServiceImpl: ImageCacheService {
   // MARK: - Constants
   private enum Constants {
       static let cacheDirectoryName = "ImageCache"
       static let imageCompressionQuality: CGFloat = 0.8
   }
   
   // MARK: - Properties
   static let shared = ImageCacheServiceImpl()
   
   private let fileManager = FileManager.default
   private let cacheDirectory: URL
   
   // MARK: - Initialization
   private init() {
       
       let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
       
       cacheDirectory = documentsDirectory.appendingPathComponent("ImageCache", isDirectory: true)
       
       try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
   }
   
   // MARK: - Public Methods
   func getImage(for url: URL) async -> UIImage? {
       let fileURL = getCacheFileURL(for: url)
       
      
       guard fileManager.fileExists(atPath: fileURL.path) else {
           return nil
       }
       
       do {
           let data = try Data(contentsOf: fileURL)
           return UIImage(data: data)
       } catch {
           print("Error loading cached image: \(error)")
           return nil
       }
   }
   
   func cacheImage(_ image: UIImage, for url: URL) async {
       guard let data = image.jpegData(compressionQuality: 0.8) else { return }
       
       let fileURL = getCacheFileURL(for: url)
       
       do {
           try data.write(to: fileURL)
       } catch {
           print("Error caching image: \(error)")
       }
   }
   
   func clearCache() async {
       do {
           let fileURLs = try fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil)
           for fileURL in fileURLs {
               try fileManager.removeItem(at: fileURL)
           }
       } catch {
           print("Error clearing cache: \(error)")
       }
   }
   
   // MARK: - Private Methods
   private func getCacheFileURL(for url: URL) -> URL {
       
       let filename = url.lastPathComponent
       return cacheDirectory.appendingPathComponent(filename)
   }
}
