//
//  MainPageTableHead.swift
//  Delivery App
//
//  Created by Николай Лермонтов on 30.06.2023.
//

import UIKit

class MainPageTableHeader: UIView {
    
    lazy var navigationImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "NavigationImage")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.sizeToFit()
        return imageView
    }()
    
    lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var avatarButton: UIButton = {
        let button = UIButton(type: .custom)
        button.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.layer.cornerRadius = button.frame.size.width / 2
        button.setImage(UIImage(named: "avatar"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false

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
    
    func setupViews() {
        self.addSubview(navigationImage)
        self.addSubview(cityLabel)
        self.addSubview(dateLabel)
        self.addSubview(avatarButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            navigationImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            navigationImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25),
            navigationImage.widthAnchor.constraint(equalToConstant: 25),
            navigationImage.heightAnchor.constraint(equalToConstant: 25),
            
            cityLabel.topAnchor.constraint(equalTo: navigationImage.topAnchor, constant: -4),
            cityLabel.leadingAnchor.constraint(equalTo: navigationImage.trailingAnchor, constant: 5),
            
            dateLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 5),
            dateLabel.leadingAnchor.constraint(equalTo: navigationImage.trailingAnchor, constant: 5),
            

            avatarButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5),
            avatarButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            avatarButton.widthAnchor.constraint(equalToConstant: 80),
            avatarButton.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
}
