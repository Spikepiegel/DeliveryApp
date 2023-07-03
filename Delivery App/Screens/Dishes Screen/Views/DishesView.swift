//
//  DishesView.swift
//  Delivery App
//
//  Created by Николай Лермонтов on 30.06.2023.
//

import UIKit

class DishesView: UIView {
    
    var selectedTag: String?
    var dishes = [Dish]()

    var buttonNames = [String]()
    var scopeButtons = [UIButton]()
    var dishesCollection = DishesCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    lazy var scopeButtonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var scopeButtonScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    let topContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        self.addSubview(topContainerView)
        topContainerView.addSubview(scopeButtonScrollView)
        scopeButtonScrollView.addSubview(scopeButtonStackView)
        self.addSubview(dishesCollection)
        
        dishesCollection.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            topContainerView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            topContainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            topContainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            topContainerView.heightAnchor.constraint(equalToConstant: 35),

            scopeButtonScrollView.topAnchor.constraint(equalTo: topContainerView.topAnchor),
            scopeButtonScrollView.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor),
            scopeButtonScrollView.trailingAnchor.constraint(equalTo: topContainerView.trailingAnchor),
            scopeButtonScrollView.bottomAnchor.constraint(equalTo: topContainerView.bottomAnchor),

            scopeButtonStackView.topAnchor.constraint(equalTo: scopeButtonScrollView.topAnchor),
            scopeButtonStackView.leadingAnchor.constraint(equalTo: scopeButtonScrollView.leadingAnchor),
            scopeButtonStackView.trailingAnchor.constraint(equalTo: scopeButtonScrollView.trailingAnchor),
            scopeButtonStackView.bottomAnchor.constraint(equalTo: scopeButtonScrollView.bottomAnchor),
            scopeButtonStackView.heightAnchor.constraint(equalTo: scopeButtonScrollView.heightAnchor),

            dishesCollection.topAnchor.constraint(equalTo: topContainerView.bottomAnchor, constant: 15),
            dishesCollection.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            dishesCollection.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            dishesCollection.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        
    }

    
    func setupScopeButtons() {
        let buttonTitles = buttonNames
        for title in 0..<buttonTitles.count {
            
            
            let button = UIButton(type: .system)
            
            button.setTitle(buttonTitles[title], for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            button.backgroundColor = .whiteTheme
            button.layer.cornerRadius = 8
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(scopeButtonTapped(_:)), for: .touchUpInside)
            scopeButtonStackView.addArrangedSubview(button)
            button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.titleLabel?.minimumScaleFactor = 0.5
            
            if title == 0 {
                button.backgroundColor = .choosenScopeButtonColor
                button.tintColor = .white
            } else {
                button.backgroundColor = .whiteTheme
                button.tintColor = .black
            }
            scopeButtons.append(button)
        }
    }
    
    
    @objc func scopeButtonTapped(_ sender: UIButton) {
        if let tag = sender.title(for: .normal) {
               selectedTag = tag
               dishesCollection.selectedTag = selectedTag
               dishesCollection.loadCollectionData(dishes) 
           }
        scopeButtons.forEach { button in
                button.backgroundColor = .whiteTheme
                button.tintColor = .black
            }
            sender.backgroundColor = .choosenScopeButtonColor
            sender.tintColor = .whiteTheme
            
            if let tag = sender.title(for: .normal) {
                selectedTag = tag
                dishesCollection.reloadData()
            }
        
    }



    
    override func layoutSubviews() {
        super.layoutSubviews()
        scopeButtonStackView.frame = CGRect(x: 0, y: 0, width: scopeButtonStackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).width, height: scopeButtonScrollView.frame.height)
        scopeButtonScrollView.contentSize = scopeButtonStackView.frame.size
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view == self {
            return topContainerView
        }
        return view
    }
    
    func loadDishes(_ dishes: [Dish]) {
        
        self.dishes = dishes

        var arr = Set<String>()

        for dish in dishes {
            for teg in dish.tegs {
                arr.insert(teg.rawValue)
            }
        }
        if arr.contains(Teg.allMenu.rawValue) {
            arr.remove(Teg.allMenu.rawValue)
        }

        var buttonNames = [Teg.allMenu.rawValue]
        buttonNames.append(contentsOf: arr)

        self.buttonNames = buttonNames
        setupScopeButtons()
        
        dishesCollection.selectedTag = nil
        dishesCollection.loadCollectionData(dishes)
    }

    
}

