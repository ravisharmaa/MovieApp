//
//  VisualQueueView.swift
//  MovieApp
//
//  Created by Ravi Bastola on 4/30/20.
//  Copyright © 2020 Ravi Bastola. All rights reserved.
//

import UIKit

class VisualQueueView: UIView {
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
       // imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    lazy var proceedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Checkout", for: .normal)
        button.setTitleColor(.systemBackground, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.layer.cornerRadius = 2
        button.backgroundColor = .systemBlue
        return button
    }()
    
    
    lazy var selectedSeatsLabel: UILabel = {
        let label = MovieLabel()
        label.numberOfLines = 0
        return label
    }()
    
    
    lazy var priceLabel: UILabel = {
        let label = MovieLabel()
        label.numberOfLines = 0
        return label
    }()
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 0.4
        
        translatesAutoresizingMaskIntoConstraints = false
        
         imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
         proceedButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        let verticalStackView = UIStackView(arrangedSubviews: [
            selectedSeatsLabel, priceLabel, UIView()
        ])
        
        verticalStackView.distribution = .fill
        verticalStackView.axis = .vertical
        
        let stackView = UIStackView(arrangedSubviews: [
            imageView, verticalStackView, proceedButton
        ])
        
        stackView.distribution = .fill
        stackView.spacing = 0
            
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
