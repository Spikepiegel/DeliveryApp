//
//  FoodCategoriesJsonService.swift
//  Delivery App
//
//  Created by Николай Лермонтов on 30.06.2023.
//

import Foundation

protocol FoodCategoriesProtocol {
    func loadFoodCategoriesData(completion: @escaping (Result<FoodCategories, Error>) -> Void)
}

class FoodCategoriesService: FoodCategoriesProtocol {
    
    func loadFoodCategoriesData(completion: @escaping (Result<FoodCategories, Error>) -> Void) {
        let urlString = "https://run.mocky.io/v3/058729bd-1402-4578-88de-265481fd7d54"
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])
                completion(.failure(error))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let categories = try decoder.decode(FoodCategories.self, from: data)
                completion(.success(categories))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
