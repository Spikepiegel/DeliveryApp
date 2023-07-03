//
//  CartStepper.swift
//  Delivery App
//
//  Created by Николай Лермонтов on 02.07.2023.
//

import Foundation

import UIKit

class CartStepper: UIStepper {
    var countLabel: UILabel
    var count = 0
    var indexPath: IndexPath?

    
    init(count: Int) {
        self.count = count
        countLabel = UILabel()
        super.init(frame: .zero)
        setupCountLabel(count)
    }
    
    override init(frame: CGRect) {
        countLabel = UILabel()
        super.init(frame: frame)
        setupCountLabel(count)
    }
    
    required init?(coder aDecoder: NSCoder) {
        countLabel = UILabel()
        super.init(coder: aDecoder)
        setupCountLabel(count)
    }
    
    private func setupCountLabel(_ count: Int) {
        countLabel.textAlignment = .center
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.text = String(count)
        addSubview(countLabel)

        NSLayoutConstraint.activate([
            countLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            countLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
        
        value = Double(count) // Устанавливаем начальное значение равным count
        
        updateCountLabel(count)

        DispatchQueue.main.async {
            if let minusButton = self.subviews.first(where: { $0 is UIButton }) as? UIButton {
                minusButton.tintColor = .systemBlue
                minusButton.isEnabled = true
            }
        }
    }

    @objc private func stepperValueChanged(_ sender: UIStepper) {
        count = Int(sender.value) // Обновляем значение count
        updateCountLabel(count)
        
        
    }
    
    private func updateCountLabel(_ count: Int) {
        countLabel.text = String(count)
    }
}
