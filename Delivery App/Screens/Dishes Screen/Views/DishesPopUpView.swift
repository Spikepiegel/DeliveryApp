//
//  DishesPopUpView.swift
//  Delivery App
//
//  Created by Николай Лермонтов on 02.07.2023.
//

import Foundation
import UIKit

class DishesPopUpView: UIViewController {
    
    var dish: Dish?
    var archiever = CartProductsArchieverService(key: "test5")
    var dishInCart = [Dish: Int]()
    
    let cartTable = CartTable()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let maxDimmedAlpha: CGFloat = 0.6
    lazy var dimmedView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.alpha = maxDimmedAlpha
        return view
    }()
    
    lazy var imageBackGroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.whiteTheme
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "closeButton"), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHighlighted = false
        button.addTarget(self, action: #selector(closePopUp), for: .touchUpInside)
        return button
    }()
    
    @objc func closePopUp(){
        dismiss(animated: true, completion: nil)
    }
    
    lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "likeButton"), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.isHighlighted = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var productImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var productName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    lazy var weightLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    lazy var addToCartButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .choosenScopeButtonColor
        button.setTitle("Добавить в корзину", for: .normal)
        button.layer.cornerRadius = 10
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addToCart), for: .touchUpInside)
        return button
    }()
    
    @objc func addToCart(sender: UIButton!) {
        guard let dish = dish else { return }
        
        
        if dishInCart.count > 0 {
            
            for currentDish in dishInCart.keys {
                if currentDish.id == dish.id {
                    dishInCart[dish]! += 1
                } else {
                    dishInCart[dish] = 1
                }
            }
        } else {
            dishInCart[dish] = 1
        }
        archiever.save(dishInCart)
        cartTable.reloadData()
        dismiss(animated: true)
    }

    
    
    init(dish: Dish) {
        super.init(nibName: nil, bundle: nil)
        self.dish = dish
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dishInCart = archiever.retrieve()
        setupView()
        setupConstraints()
        
        
    }
    
    func configure(_ dish: Dish) {
        
        let imageLoader = ImageLoaderService()
        
        if let imageURL = URL(string: dish.imageURL ) {
            imageLoader.loadImage(from: imageURL) { image in
                DispatchQueue.main.async {
                    self.productImage.image = image
                }
            }
        }
        
        productName.text = dish.name
        priceLabel.text = "\(String(describing: dish.price)) ₽"
        weightLabel.text = "\(String(describing: dish.weight))г"
        descriptionLabel.text = dish.description
        
        
    }
    
    func setupView() {
        view.backgroundColor = .clear
        view.addSubview(dimmedView)
        view.addSubview(containerView)
        containerView.addSubview(imageBackGroundView)
        containerView.addSubview(closeButton)
        containerView.addSubview(likeButton)
        imageBackGroundView.addSubview(productImage)
        containerView.addSubview(productName)
        containerView.addSubview(priceLabel)
        containerView.addSubview(weightLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(addToCartButton)
        
    }
    
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            dimmedView.topAnchor.constraint(equalTo: self.view.topAnchor),
            dimmedView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            containerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 343),
            
            imageBackGroundView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            imageBackGroundView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            imageBackGroundView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            imageBackGroundView.heightAnchor.constraint(equalToConstant: 232),
            
            closeButton.topAnchor.constraint(equalTo: imageBackGroundView.topAnchor, constant: 8),
            closeButton.rightAnchor.constraint(equalTo: imageBackGroundView.rightAnchor, constant: -8),
            closeButton.heightAnchor.constraint(equalToConstant: 40),
            closeButton.widthAnchor.constraint(equalToConstant: 40),
            
            likeButton.topAnchor.constraint(equalTo: imageBackGroundView.topAnchor, constant: 8),
            likeButton.rightAnchor.constraint(equalTo: closeButton.leftAnchor, constant: -8),
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            likeButton.widthAnchor.constraint(equalToConstant: 40),
            
            productImage.centerYAnchor.constraint(equalTo: imageBackGroundView.centerYAnchor),
            productImage.centerXAnchor.constraint(equalTo: imageBackGroundView.centerXAnchor),
            productImage.heightAnchor.constraint(equalToConstant: 204),
            productImage.widthAnchor.constraint(equalToConstant: 198),
            
            productName.topAnchor.constraint(equalTo: imageBackGroundView.bottomAnchor, constant: 10),
            productName.leadingAnchor.constraint(equalTo: imageBackGroundView.leadingAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: productName.bottomAnchor, constant: 10),
            priceLabel.leadingAnchor.constraint(equalTo: productName.leadingAnchor),
            
            weightLabel.topAnchor.constraint(equalTo: productName.bottomAnchor, constant: 10),
            weightLabel.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 10),
            
            descriptionLabel.topAnchor.constraint(equalTo: weightLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: imageBackGroundView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: imageBackGroundView.trailingAnchor),
            
            addToCartButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            addToCartButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            addToCartButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15),
            addToCartButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -25),
            addToCartButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    
    
}
