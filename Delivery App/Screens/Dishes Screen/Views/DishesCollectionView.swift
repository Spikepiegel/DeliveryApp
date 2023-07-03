//
//  DishesCollectionView.swift
//  Delivery App
//
//  Created by Николай Лермонтов on 30.06.2023.
//

import UIKit

class DishesCollectionView: UICollectionView {
    
    //let archiever = CartProductsArchieverService(key: "test1")
    
    private var filteredDishes = [Dish]()
    var selectedTag: String?
    
    var dishes = [Dish]()
    var onDishIsSelected: ((Dish) ->())?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setupCollection()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCollection() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        self.showsVerticalScrollIndicator = false
        self.delegate = self
        self.dataSource = self
        self.register(DishesCollectionViewCell.self, forCellWithReuseIdentifier: DishesCollectionViewCell.identifier)
    }
    
    func loadCollectionData(_ dishes: [Dish]) {
        self.dishes = dishes
        if let tag = selectedTag {
            self.filteredDishes = dishes.filter { $0.tegs.contains(Teg(rawValue: tag) ?? .allMenu) }
        } else {
            self.filteredDishes = dishes
        }
        
        self.reloadData()
    }
     
}

extension DishesCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 10
        let numberOfItemsInRow: CGFloat = 3
        
        let totalSpacing = (numberOfItemsInRow - 1) * spacing
        let itemWidth = (collectionView.bounds.width - totalSpacing) / numberOfItemsInRow
        
        return CGSize(width: itemWidth, height: 160)
    }
    
    
}

extension DishesCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredDishes.count 
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DishesCollectionViewCell.identifier, for: indexPath) as? DishesCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let dish = filteredDishes[indexPath.item]
        cell.configure(with: dish)
        
        cell.alpha = 0.0
        
        UIView.animate(withDuration: 0.3) {
            cell.alpha = 1.0
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dish = filteredDishes[indexPath.item]
        self.onDishIsSelected?(dish)
    }
    
    
}
