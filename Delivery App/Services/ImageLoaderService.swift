//
//  ImageLoaderService.swift
//  Delivery App
//
//  Created by Николай Лермонтов on 02.07.2023.
//

import Foundation
import UIKit

import UIKit

class ImageLoaderService {
    private let imageCache = URLCache.shared
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        let request = URLRequest(url: url)
        
        if let cachedResponse = imageCache.cachedResponse(for: request) {
            let image = UIImage(data: cachedResponse.data)
            completion(image)
            return
        }
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            let cachedResponse = CachedURLResponse(response: response!, data: data)
            self?.imageCache.storeCachedResponse(cachedResponse, for: request)
            
            completion(image)
        }.resume()
    }
}


