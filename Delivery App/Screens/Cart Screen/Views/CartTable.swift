//
//  CartTable.swift
//  Delivery App
//
//  Created by Николай Лермонтов on 02.07.2023.
//

import UIKit

class CartTable: UITableView {
    
    var onPriceIsChange: (() -> ())?
    
    var header = MainPageTableHeader(frame: CGRect(x: 0, y: 0, width: 0, height: 60))
    var archiever = CartProductsArchieverService(key: "test5")
    var productList = [Dish: Int]()
    var dishes = [Dish]()
    var countOfDishes = [Int]()
    
    var fullPriceIsChanged: (() -> ())?

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: .insetGrouped)
        configure()
        setupTable()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTable() {
        self.register(CartTableCell.self, forCellReuseIdentifier: CartTableCell.identifier)
        self.backgroundColor = .clear
        self.tableHeaderView = header
        self.delegate = self
        self.dataSource = self
        self.translatesAutoresizingMaskIntoConstraints = false
        self.separatorStyle = .none
    }
    
    func loadProductList(_ location: String, _ currentDate: String) {
        self.header.cityLabel.text = location
        self.header.dateLabel.text = currentDate
        self.reloadData()
    }
    
    func configure() {
        self.productList = archiever.retrieve()
        dishes = Array(productList.keys)
        countOfDishes = Array(productList.values)
    }
    
    func updateTable(_ index: Int, _ productCount: Int) {
        
        if productCount == 0 {
 
            dishes.remove(at: index)
            countOfDishes.remove(at: index)

            productList = Dictionary(uniqueKeysWithValues: zip(dishes, countOfDishes))

        } else {
            countOfDishes[index] = productCount
            productList = Dictionary(uniqueKeysWithValues: zip(dishes, countOfDishes))
        }
        archiever.save(productList)
        self.onPriceIsChange?()
        reloadData()
    }
}

extension CartTable: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartTableCell.identifier, for: indexPath) as? CartTableCell  else {
            return UITableViewCell() }
        cell.quantityStepper.value = Double(countOfDishes[indexPath.row])
        cell.configure(with: dishes[indexPath.row], quantity: countOfDishes[indexPath.row])
        cell.cellIndexPath = indexPath.row
        
        cell.onDeleteProduct = { [weak self]  productIndex, productCount in
            self?.updateTable(productIndex, productCount)
        }
        
        return cell

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}

extension CartTable: UITableViewDelegate {
    
}

