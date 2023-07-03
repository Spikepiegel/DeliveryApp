//
//  MainPageTable.swift
//  Delivery App
//
//  Created by Николай Лермонтов on 30.06.2023.
//

import UIKit

class MainPageTable: UITableView {
    
    var onCategorySelected: ((String) -> ())?
    
    var categories = [Category]()
    var location = String()
    var header = MainPageTableHeader(frame: CGRect(x: 0, y: 0, width: 0, height: 60))
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: .insetGrouped)
        setupTable()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTable() {
        self.register(MainPageTableCell.self, forCellReuseIdentifier: MainPageTableCell.identifier)
        self.backgroundColor = .clear
        self.tableHeaderView = header
        self.delegate = self
        self.dataSource = self
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func loadCategories(_ categories: [Category], _ location: String, _ currentDate: String) {
        self.categories = categories
        self.header.cityLabel.text = location
        self.header.dateLabel.text = currentDate
        self.reloadData()
    }
    

    
}

extension MainPageTable: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(categories.count * 160)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainPageTableCell.identifier, for: indexPath) as? MainPageTableCell  else {
            return UITableViewCell() }
        
        cell.createCategoryButtons(categories)
        
        cell.onCategorySelected = { category in
            self.onCategorySelected?(category)
        }
        
        return cell
    }
    
}

extension MainPageTable: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }

}
