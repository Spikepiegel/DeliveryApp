//
//  ScreenFactory.swift
//  Delivery App
//
//  Created by Николай Лермонтов on 29.06.2023.
//

import Foundation
import UIKit

class ScreenFactory {
    
    ///Method returns main page screen
    static func makeMainPageScreen() -> MainPageVC {
        let vc = MainPageVC.init()
        vc.service = FoodCategoriesService()
        return vc
    }
    
    static func makeSearchScreen() -> SearchVC {
        let vc = SearchVC.init()
        return vc
    }
    static func makeCartScreen() -> CartVC {
        let vc = CartVC.init()
        return vc
    }
    static func makeAccountScreen() -> AccountVC {
        let vc = AccountVC.init()
        return vc
    }
    
    static func makeDishesVC(category: String) -> DishesVC {
        let vc = DishesVC.init(category: category)
        vc.service = DishesDataService()
        return vc
    }
    
    static func makeDishesPopUpView(_ dish: Dish) -> DishesPopUpView {
        let vc = DishesPopUpView.init(dish: dish)
        return vc
    }
}
