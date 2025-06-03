//
//  CachedAsyncImageView.swift
//  QPN-Movie-Task
//
//  Created by Mahmoud Saad on 03/06/2025.
//


import SwiftUI

struct CachedAsyncImage<Content: View, Placeholder: View>: View {
    
    private let url: URL?
    private let scale: CGFloat
    private let transaction: Transaction
    private let content: (Image) -> Content
    private let placeholder: () -> Placeholder
    
    @State private var image: UIImage?
    @State private var isLoading = false
    
    init(
        url: URL?,
        scale: CGFloat = 1.0,
        transaction: Transaction = Transaction(),
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.content = content
        self.placeholder = placeholder
    }
    
    var body: some View {
        Group {
            if let image = image {
                content(Image(uiImage: image))
            } else if isLoading {
                placeholder()
            } else {
                placeholder()
                    .onAppear {
                        loadImage()
                    }
            }
        }
    }
    
    private func loadImage() {
        guard let url = url else { return }
        
        isLoading = true
        Task {
            if let cachedImage = await ImageCacheServiceImpl.shared.getImage(for: url) {
                await MainActor.run {
                    self.image = cachedImage
                    self.isLoading = false
                }
                return
            }
            
            if let downloadedImage = await AsyncImageFetcher.loadImage(from: url.absoluteString) {
                await MainActor.run {
                    self.image = downloadedImage
                    self.isLoading = false
                }
                await ImageCacheServiceImpl.shared.cacheImage(downloadedImage, for: url)
            } else {
                await MainActor.run {
                    self.isLoading = false
                }
            }
        }
    }
}
