//
//  ImageCasheService.swift
//  Delivery App
//
//  Created by Николай Лермонтов on 02.07.2023.
//

import Foundation
import UIKit

class ImageCache {
    static let shared = ImageCache()
    
    private var cache: NSCache<NSString, UIImage>
    
    private init() {
        cache = NSCache<NSString, UIImage>()
    }
    
    func getImage(for url: URL, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = cache.object(forKey: url.absoluteString as NSString) {
            completion(cachedImage)
        } else {
            loadImage(from: url) { [weak self] image in
                if let image = image {
                    // Кэшируем загруженное изображение
                    self?.cache.setObject(image, forKey: url.absoluteString as NSString)
                }
                completion(image)
            }
        }
    }
    
    private func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            completion(image)
        }.resume()
    }
}
