//
//  DishesCollectionViewCell.swift
//  Delivery App
//
//  Created by Николай Лермонтов on 30.06.2023.
//

import UIKit


import UIKit

class DishesCollectionViewCell: UICollectionViewCell {
    static let identifier = "DishesCell"
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = false
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var cellView: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteTheme
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var productImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(cellView)
        cellView.addSubview(productImage)
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: topAnchor),
            cellView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            productImage.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 5),
            productImage.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 5),
            productImage.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -5),
            productImage.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -5),
            productImage.centerYAnchor.constraint(equalTo: cellView.centerYAnchor),
            productImage.centerXAnchor.constraint(equalTo: cellView.centerXAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: cellView.bottomAnchor, constant: 10),
            
            cellView.heightAnchor.constraint(equalToConstant: 115) 
        ])
        
        titleLabel.numberOfLines = 0
        titleLabel.adjustsFontSizeToFitWidth = false
        titleLabel.lineBreakMode = .byWordWrapping
    }

    
    func configure(with dish: Dish?) {
        titleLabel.text = dish?.name
        
        if let imageURLString = dish?.imageURL, let imageURL = URL(string: imageURLString) {
            ImageCache.shared.getImage(for: imageURL) { cachedImage in
                if let cachedImage = cachedImage {
                    DispatchQueue.main.async {
                        self.productImage.image = cachedImage
                    }
                } else {
                    self.loadImage(from: imageURL) { [weak self] image in
                        DispatchQueue.main.async {
                            self?.productImage.image = image
                        }
                    }
                }
            }
        } else {
            productImage.image = nil
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
