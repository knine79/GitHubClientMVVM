//
//  ImageCache.swift
//  GithubClientMVVM
//
//  Created by Samuel Kim on 2023/06/12.
//

import SwiftUI

final class ImageCache {
    static let shared = ImageCache()
    private var caches = NSCache<NSString, UIImage>()
    private var fileMgr = FileManager.default
    private init() {}
    
    var diskCacheUrl: URL {
        try! fileMgr.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("\(Bundle.main.bundleIdentifier?.appending("/") ?? "")ImageCaches", conformingTo: .directory)
    }
    
    func diskCacheFilePath(url: URL) -> String {
        diskCacheUrl.appendingPathComponent("\(url.absoluteString.hash)", conformingTo: .image).path()
    }
    
    subscript(url: URL) -> UIImage? {
        get {
            if let memoryCache = caches.object(forKey: url.absoluteString as NSString) {
                return memoryCache
            } else if let diskCaheData = fileMgr.contents(atPath: diskCacheFilePath(url: url)), let diskCache = UIImage(data: diskCaheData) {
                caches.setObject(diskCache, forKey: url.absoluteString as NSString)
                return diskCache
            } else {
                return nil
            }
        }
        set {
            if let uiImage = newValue {
                caches.setObject(uiImage, forKey: url.absoluteString as NSString)
                do {
                    if !fileMgr.fileExists(atPath: diskCacheUrl.path()) {
                        try fileMgr.createDirectory(atPath: diskCacheUrl.path(), withIntermediateDirectories: true)
                    }
                    fileMgr.createFile(atPath: diskCacheFilePath(url: url), contents: uiImage.pngData())
                } catch {
                    printLog(error.localizedDescription)
                }
            } else {
                caches.removeObject(forKey: url.absoluteString as NSString)
                try? fileMgr.removeItem(atPath: diskCacheFilePath(url: url))
            }
        }
    }
}

struct CachedAsyncImage<Content> : View where Content : View {
    let url: URL
    let scale: CGFloat
    let transaction: Transaction
    let content: (AsyncImagePhase) -> Content

    @State private var phase: AsyncImagePhase = .empty

    init(url: URL, scale: CGFloat = 1, transaction: Transaction = Transaction(), @ViewBuilder content: @escaping (AsyncImagePhase) -> Content) {
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.content = content
    }

    var body: some View {
        content(phase)
            .task {
                UIImage.from(url: url) {
                    switch $0 {
                    case .success(let uiImage):
                        phase = .success(Image(uiImage: uiImage))
                    case .failure(let error):
                        phase = .failure(error)
                    }
                }
            }
    }
}

extension UIImage {
    enum LoadingError: Error {
        case serverError(statusCode: Int)
        case invalidData
    }
    
    static func from(url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let completionInMainThread: (Result<UIImage, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        if let cachedImage = ImageCache.shared[url] {
            completionInMainThread(.success(cachedImage))
            return
        }
        
        Task {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                printLog("[\(url.lastPathComponent)] status code is \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
                completionInMainThread(.failure(LoadingError.serverError(statusCode: (response as? HTTPURLResponse)?.statusCode ?? -1)))
                return
            }
            guard let uiImage = UIImage(data: data) else {
                printLog("[\(url.lastPathComponent)] image data is invalid")
                completionInMainThread(.failure(LoadingError.invalidData))
                return
            }
            ImageCache.shared[url] = uiImage
            printLog("[\(url.lastPathComponent)] use remote image")
            completionInMainThread(.success(uiImage))
        }
    }
}

extension UIImageView {
    func setImage(url: URL) {
        UIImage.from(url: url) { self.image = try? $0.get() }
    }
}

extension UIButton {
    func setImage(url: URL, for state: UIControl.State) {
        UIImage.from(url: url) {
            self.setImage(try? $0.get(), for: state)
        }
    }
}
