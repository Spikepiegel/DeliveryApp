//
//  CartProductsArchieverService.swift
//  Delivery App
//
//  Created by Николай Лермонтов on 02.07.2023.
//
//key - "CartProducts" - list of products in cart

import Foundation

final class CartProductsArchieverService {
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    var key: String
    
    init(key: String) {
        self.key = key
    }
    
    //MARK: - Public methods
    func save(_ cartProducts: [Dish: Int]) {
        do {
            let data = try encoder.encode(cartProducts)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print(error)
        }
    }
    
    func retrieve() -> [Dish: Int] {
        guard let data = UserDefaults.standard.data(forKey: key) else { return [:] }
        do {
            let dictionary = try decoder.decode(Dictionary<Dish, Int>.self, from: data)
            return dictionary
        } catch {
            print(error)
        }
        return [:]
    }
}

