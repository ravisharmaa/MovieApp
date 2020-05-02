//
//  SeatsCell.swift
//  MovieApp
//
//  Created by Ravi Bastola on 4/28/20.
//  Copyright © 2020 Ravi Bastola. All rights reserved.
//

import UIKit

class SeatsCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "reuseMe"
    
    var section: MovieSections? {
        didSet {
            imageView.image = (section == .audi14) ? UIImage(named: "audi14") : UIImage(named: "audi30")
        }
    }
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .systemBackground
        
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
