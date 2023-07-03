//
//  MainPageView.swift
//  Delivery App
//
//  Created by Николай Лермонтов on 30.06.2023.
//

import UIKit

class MainPageView: UIView {

    var foodTable = MainPageTable.init()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension MainPageView {
    func setupViews() {
        self.backgroundColor = UIColor.white
        self.addSubview(foodTable)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            foodTable.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            foodTable.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            foodTable.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -0),
            foodTable.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        
        ])
    }
}
