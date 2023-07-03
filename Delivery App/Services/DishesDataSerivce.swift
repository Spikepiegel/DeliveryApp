//
//  DishesDataSerivce.swift
//  Delivery App
//
//  Created by Николай Лермонтов on 01.07.2023.
//

import Foundation

protocol DishesDataProtocol {
    func loadFoodCategoriesData(completion: @escaping (Result<Dishes, Error>) -> Void)
}

class DishesDataService: DishesDataProtocol {
    
    func loadFoodCategoriesData(completion: @escaping (Result<Dishes, Error>) -> Void) {
        let urlString = "https://run.mocky.io/v3/aba7ecaa-0a70-453b-b62d-0e326c859b3b"
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
                let categories = try decoder.decode(Dishes.self, from: data)
                completion(.success(categories))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
