//
//  CartTableCell.swift
//  Delivery App
//
//  Created by Николай Лермонтов on 02.07.2023.
//

import UIKit

class CartTableCell: UITableViewCell {
    
    static let identifier = "Cart Cell"
    
    var cellIndexPath = Int()
    
    var onDeleteProduct: ((Int, Int) -> ())?

    lazy var productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var productNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    lazy var productPrice: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var weightLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var quantityStepper: CartStepper = {
        let stepper = CartStepper()
        stepper.translatesAutoresizingMaskIntoConstraints = false
        return stepper
    }()
    
    @objc private func stepperValueChanged(_ stepper: UIStepper) {
        let quantity = Int(stepper.value)
        print(quantity, stepper.value)
        quantityChanged?(quantity)
        
        onDeleteProduct?(self.cellIndexPath, Int(stepper.value))
    }
    
    lazy var imageBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteTheme
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        return view
    }()
    
    var quantityChanged: ((Int) -> Void)?
    
    // MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none // Отключить выделение ячейки
        configureViews()
        setupConstraints()
        
        quantityStepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    
    func configure(with dish: Dish?, quantity: Int) {
        productImageView.image = UIImage(named: "avatar")
        productNameLabel.text = dish?.name
        quantityStepper.countLabel.text = "\(Int(quantity))"
        
        if let price = dish?.price, let weight = dish?.weight {
            productPrice.text = "\(price) ₽"
            weightLabel.text = "\(weight) г"
        }
        
        if let imageURLString = dish?.imageURL, let imageURL = URL(string: imageURLString) {
            ImageCache.shared.getImage(for: imageURL) { cachedImage in
                if let cachedImage = cachedImage {
                    DispatchQueue.main.async {
                        self.productImageView.image = cachedImage
                    }
                } else {
                    self.loadImage(from: imageURL) { [weak self] image in
                        DispatchQueue.main.async {
                            self?.productImageView.image = image
                        }
                    }
                }
            }
        } else {
            productImageView.image = nil
        }
        
    }
    
    // MARK: - Actions
    
    @objc private func stepperValueChanged() {
        let quantity = Int(quantityStepper.value)
        quantityChanged?(quantity)
        
    }
    
    // MARK: - View Setup
    
    private func configureViews() {
        contentView.addSubview(imageBackground)
        imageBackground.addSubview(productImageView)
        contentView.addSubview(productNameLabel)
        contentView.addSubview(quantityStepper)
        contentView.addSubview(productPrice)
        contentView.addSubview(weightLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageBackground.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imageBackground.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageBackground.widthAnchor.constraint(equalToConstant: 62),
            imageBackground.heightAnchor.constraint(equalToConstant: 62),
            
            productImageView.centerXAnchor.constraint(equalTo: imageBackground.centerXAnchor),
            productImageView.centerYAnchor.constraint(equalTo: imageBackground.centerYAnchor),
            productImageView.widthAnchor.constraint(equalToConstant: 50),
            productImageView.heightAnchor.constraint(equalToConstant: 50),
            
            productNameLabel.topAnchor.constraint(equalTo: imageBackground.topAnchor, constant: 4),
            productNameLabel.leadingAnchor.constraint(equalTo: imageBackground.trailingAnchor, constant: 16),
            productNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -self.frame.width / 3),
            
            productPrice.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 5),
            productPrice.leadingAnchor.constraint(equalTo: imageBackground.trailingAnchor, constant: 16),
            
            weightLabel.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 5),
            weightLabel.leadingAnchor.constraint(equalTo: productPrice.trailingAnchor, constant: 8),

            quantityStepper.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            quantityStepper.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            quantityStepper.widthAnchor.constraint(equalToConstant: 99),
            quantityStepper.heightAnchor.constraint(equalToConstant: 32)

        ])
    }
    
    override var isSelected: Bool {
        didSet {
            super.isSelected = false
        }
    }
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            completion(image)
        }.resume()
    }
    
}

