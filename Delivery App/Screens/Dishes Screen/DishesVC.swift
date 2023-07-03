//
//  DishesVC.swift
//  Delivery App
//
//  Created by Николай Лермонтов on 30.06.2023.
//

import UIKit

class DishesVC: UIViewController {
    var selectedTag: String?

    var category = String()
    var service: DishesDataService?
    var dishes: Dishes?

    var dishesView: DishesView { return self.view as! DishesView}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        fetchData()
        events()
    }
    
    override func loadView() {
        self.view = DishesView(frame: UIScreen.main.bounds)
    }
    
    init(category: String) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setNavigationBar() {
        
        self.navigationItem.setHidesBackButton(true, animated:false)
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 15, height: 20))
        
        if let imgBackArrow = UIImage(systemName: "chevron.left") {
            imageView.image = imgBackArrow
        }
        view.addSubview(imageView)
        
        let backTap = UITapGestureRecognizer(target: self, action: #selector(backToMain))
        view.addGestureRecognizer(backTap)
        
        let leftBarButtonItem = UIBarButtonItem(customView: view )
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationController?.navigationBar.tintColor = .black
        title = category
        
        
        let font = UIFont.boldSystemFont(ofSize: 19.0)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font
        ]
        
        navigationController?.navigationBar.titleTextAttributes = attributes
        navigationItem.title = category
        
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "avatar"), for: UIControl.State.normal)
        button.addTarget(self, action:Selector(("callMethod")), for: UIControl.Event.touchDragInside)
        button.frame=CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItems = [barButton]
    }
    
    @objc func backToMain() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func fetchData() {
        service?.loadFoodCategoriesData { [weak self] result in
            switch result {
            case .success(let dishes):
                DispatchQueue.main.async {
                    self?.dishes = dishes
                    self?.passCategoriesToTable(dishes.dishes)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func passCategoriesToTable(_ dishes: [Dish]) {
        dishesView.loadDishes(dishes)
        dishesView.dishesCollection.selectedTag = selectedTag 
        dishesView.dishesCollection.reloadData()
    }


    
    func events() {
        dishesView.dishesCollection.onDishIsSelected = { [weak self] dish in
            let vc = ScreenFactory.makeDishesPopUpView(dish)
            vc.configure(dish)
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            self?.present(vc, animated: true)
        }
    }



}
