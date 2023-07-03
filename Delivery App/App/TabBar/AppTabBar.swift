//
//  TabBarVC.swift
//  Delivery App
//
//  Created by Николай Лермонтов on 29.06.2023.
//

import Foundation
import UIKit

class AppTabBar: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    private func setupTabBar() {
        let firstNavController = UINavigationController(rootViewController: ScreenFactory.makeMainPageScreen())
        let secondNavController = UINavigationController(rootViewController: ScreenFactory.makeSearchScreen())
        let thirdNavController = UINavigationController(rootViewController: ScreenFactory.makeCartScreen())
        let fourthNavController = UINavigationController(rootViewController: ScreenFactory.makeAccountScreen())
        
        firstNavController.tabBarItem = UITabBarItem(title: "Главная", image: UIImage(named: "HomeIcon"), selectedImage: nil)
        secondNavController.tabBarItem = UITabBarItem(title: "Поиск", image: UIImage(named: "SearchIcon"), selectedImage: nil)
        thirdNavController.tabBarItem = UITabBarItem(title: "Корзина", image: UIImage(named: "CartIcon"), selectedImage: nil)
        fourthNavController.tabBarItem = UITabBarItem(title: "Аккаунт", image: UIImage(named: "AccountIcon"), selectedImage: nil)
        
        viewControllers = [firstNavController,secondNavController, thirdNavController, fourthNavController]
    }
    
    
    private func setupVCs(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        return viewController
    }
    
    private func setupTabBarSettings() {
        
        let positionOnY: CGFloat = 14
        let height = tabBar.bounds.height + positionOnY * 2
        
        let roundLayer = CAShapeLayer()
        
        let bezierPath = UIBezierPath(roundedRect: CGRect(x: 0,
                                                          y: tabBar.bounds.minY,
                                                          width: tabBar.bounds.width,
                                                          height: height * 2),
                                      cornerRadius: 0)
        
        roundLayer.path = bezierPath.cgPath
        tabBar.layer.insertSublayer(roundLayer, at: 0)
        tabBar.itemWidth = tabBar.bounds.width / 3
        tabBar.itemPositioning = .centered
        
        roundLayer.fillColor = UIColor.black.cgColor
        
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = .lightGray
        self.selectedIndex = 1
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        animationWhenItemSelected(item)
    }
    
    //MARK: TabBar Animation Settings
    func animationWhenItemSelected(_ item: UITabBarItem) {
        guard let barItemView = item.value(forKey: "view") as? UIView else { return }
        
        let timeInterval: TimeInterval = 0.5
        let propertyAnimator = UIViewPropertyAnimator(duration: timeInterval, dampingRatio: 0.5) {
            barItemView.transform = CGAffineTransform.identity.scaledBy(x: 1.25, y: 1.25)
        }
        propertyAnimator.addAnimations({ barItemView.transform = .identity},
                                       delayFactor: CGFloat(timeInterval))
        propertyAnimator.startAnimation()
    }
}
