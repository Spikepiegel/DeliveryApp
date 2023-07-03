//
//  FoodCategoriesJsonModel.swift
//  Delivery App
//
//  Created by Николай Лермонтов on 30.06.2023.
//

import Foundation


import Foundation

// MARK: - FoodCategories
struct FoodCategories: Codable {
    let сategories: [Category]
}

// MARK: - Сategory
struct Category: Codable {
    let id: Int
    let name: String
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case imageURL = "image_url"
    }
}
