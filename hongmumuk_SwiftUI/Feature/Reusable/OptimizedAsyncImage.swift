//
//  OptimizedAsyncImage.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 3/25/25.
//

import Combine
import SwiftUI

// MARK: - 다운 샘플링, 캐싱이 적용된 최적화 이미지

struct OptimizedAsyncImage<Content: View, Placeholder: View>: View {
    @StateObject private var loader: ImageLoader
    @State private var opacity: Double = 0
    
    private let content: (Image) -> Content
    private let placeholder: () -> Placeholder
    
    init(url: URL?,
         targetSize: CGSize? = nil,
         @ViewBuilder content: @escaping (Image) -> Content,
         @ViewBuilder placeholder: @escaping () -> Placeholder)
    {
        _loader = StateObject(wrappedValue: ImageLoader(url: url ?? URL(string: "https://example.com/placeholder.png")!, targetSize: targetSize))
        self.content = content
        self.placeholder = placeholder
    }
    
    var body: some View {
        ZStack {
            if let image = loader.image {
                content(Image(uiImage: image))
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1.0)) {
                            opacity = 1.0
                        }
                    }
            } else {
                placeholder()
            }
        }
        .onAppear {
            loader.load()
        }
        .onDisappear {
            loader.cancel()
        }
    }
}

// MARK: - 이미지 캐싱을 위한 싱클톤 Class

class ImageCache {
    static let shared = ImageCache()
    private var cache = NSCache<NSString, UIImage>()
    
    func get(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func set(image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}

// MARK: - 이미지 로더

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    @Published var isLoading = false
    
    private let url: URL
    private var cancellable: AnyCancellable?
    private var targetSize: CGSize?
    
    init(url: URL, targetSize: CGSize? = nil) {
        self.url = url
        self.targetSize = targetSize
    }
    
    func load() {
        // 이미 이미지가 로드되었다면 중복 로드 방지
        if image != nil {
            return
        }
        
        // 캐시에서 이미지 확인
        let cacheKey = url.absoluteString
        if let cachedImage = ImageCache.shared.get(forKey: cacheKey) {
            image = cachedImage
            return
        }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] loadedImage in
                guard let self, let loadedImage else {
                    return
                }
                
                // 다운샘플링 적용
                let finalImage: UIImage = if let targetSize {
                    loadedImage.preparingThumbnail(of: targetSize) ?? loadedImage
                } else {
                    loadedImage
                }
                
                // 캐시에 저장
                ImageCache.shared.set(image: finalImage, forKey: cacheKey)
                image = finalImage
            }
    }
    
    func cancel() {
        cancellable?.cancel()
    }
    
    deinit {
        cancel()
    }
}
