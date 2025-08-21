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
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .tryMap { [targetSize] output -> UIImage? in
                if let size = targetSize {
                    return ImageLoader.downsample(data: output.data, maxDimension: size.width)
                } else {
                    return UIImage(data: output.data)
                }
            }
            .mapError { $0 } // 필요시 에러 처리
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                // 에러 로깅 등 필요시 처리
            } receiveValue: { [weak self] img in
                guard let self, let img else { return }
                ImageCache.shared.set(image: img, forKey: cacheKey)
                image = img
            }
    }
    
    func cancel() {
        cancellable?.cancel()
    }
    
    deinit {
        cancel()
    }
}

private extension ImageLoader {
    static func downsample(data: Data, maxDimension: CGFloat) -> UIImage? {
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary // 캐싱 적용 여부
        guard let imageSource = CGImageSourceCreateWithData(data as CFData, imageSourceOptions) else {
            return nil
        }
        
        let downsampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: false,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimension
        ] as CFDictionary
        
        guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else {
            return nil
        }
        
        return UIImage(cgImage: downsampledImage)
    }
}
