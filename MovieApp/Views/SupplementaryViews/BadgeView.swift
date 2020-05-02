//
//  BadgeView.swift
//  MovieApp
//
//  Created by Ravi Bastola on 4/30/20.
//  Copyright © 2020 Ravi Bastola. All rights reserved.
//

import UIKit

class BadgeView: UICollectionReusableView {
    
    lazy var seatLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 11)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemGreen
        clipsToBounds = true
        layer.cornerRadius = 2
        
        addSubview(seatLabel)
        
        NSLayoutConstraint.activate([
            seatLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            seatLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

