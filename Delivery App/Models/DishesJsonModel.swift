//
//  DishesJsonModel.swift
//  Delivery App
//
//  Created by Николай Лермонтов on 01.07.2023.
//

import Foundation

struct Dishes: Codable {
    let dishes: [Dish]
}

// MARK: - Dish
struct Dish: Codable, Hashable {
    let id: Int
    let name: String
    let price, weight: Int
    let description: String
    let imageURL: String
    let tegs: [Teg]
    var countInCart: Int?

    enum CodingKeys: String, CodingKey {
        case id, name, price, weight, description
        case imageURL = "image_url"
        case tegs
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lhs: Dish, rhs: Dish) -> Bool {
        return lhs.id == rhs.id
    }
}

enum Teg: String, Codable {
    case allMenu = "Все меню"
    case withRice = "С рисом"
    case withFish = "С рыбой"
    case salats = "Салаты"
}
