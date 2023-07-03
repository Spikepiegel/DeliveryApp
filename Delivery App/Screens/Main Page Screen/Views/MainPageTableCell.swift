//
//  MainPageTableCell.swift
//  Delivery App
//
//  Created by Николай Лермонтов on 30.06.2023.
//

import Foundation
import UIKit

class MainPageTableCell: UITableViewCell {
    var onCategorySelected: ((String) ->())?

    lazy var containerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    static let identifier = "MainPageCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell() {
        self.selectionStyle = .none
        self.addSubview(containerStack)
        self.backgroundColor = .white
        self.contentView.isUserInteractionEnabled = false
    }
    
    func createCategoryButtons(_ categories: [Category]) {
        for categoryButton in 0..<categories.count {
            createButtons(categories, categoryButton)
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
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            containerStack.topAnchor.constraint(equalTo: self.topAnchor),
            containerStack.leftAnchor.constraint(equalTo: self.leftAnchor),
            containerStack.rightAnchor.constraint(equalTo: self.rightAnchor),
            containerStack.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            
        ])
        
    }
    
    func createButtons(_ categories: [Category], _ categoryButton: Int) {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 148))
        button.addTarget(self, action: #selector(categoryIsChoosen), for: .touchUpInside)
        button.layer.cornerRadius = 10
        
        if let imageURL = URL(string: categories[categoryButton].imageURL) {
            loadImage(from: imageURL) { image in
                DispatchQueue.main.async {
                    button.setBackgroundImage(image, for: .normal)
                }
            }
        }
        button.setTitle(categories[categoryButton].name, for: .normal)
        button.setTitleColor(.clear, for: .normal)
        let categoryLabel = createCategoryLabel(button, categoryButton, categories)
        containerStack.addArrangedSubview(button)
        button.addSubview(categoryLabel)

        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(equalTo: button.topAnchor, constant: 10),
            categoryLabel.leftAnchor.constraint(equalTo: button.leftAnchor, constant: 20),
            categoryLabel.rightAnchor.constraint(equalTo: button.rightAnchor, constant: -button.frame.width / 2)
        ])
    }

    func createCategoryLabel(_ button: UIButton, _ index: Int, _ categories: [Category]) -> UILabel {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = categories[index].name
        return label
    }
    
    @objc func categoryIsChoosen(sender: UIButton!) {
        onCategorySelected?(sender.titleLabel?.text ?? "")
    }

    
}




