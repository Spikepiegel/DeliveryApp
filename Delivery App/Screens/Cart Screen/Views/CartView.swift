//
//  CartView.swift
//  Delivery App
//
//  Created by Николай Лермонтов on 02.07.2023.
//

import UIKit

class CartView: UIView {

    var cartTable = CartTable.init()
    
    var fullPrice = Int()
    
    lazy var payButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .choosenScopeButtonColor
        button.setTitle("Оплатить \(fullPrice)", for: .normal)
        button.layer.cornerRadius = 10
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        //button.addTarget(self, action: #selector(addToCart), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updatePayButtonTitle() {
        payButton.setTitle("Оплатить \(fullPrice)", for: .normal)
    }
    
}

extension CartView {
    func setupViews() {
        self.backgroundColor = UIColor.white
           self.addSubview(cartTable)
           self.addSubview(payButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            payButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -100),
            payButton.widthAnchor.constraint(equalToConstant: 343),
            payButton.heightAnchor.constraint(equalToConstant: 48),
            payButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            cartTable.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            cartTable.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            cartTable.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -0),
            cartTable.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        
        ])
    }
}
