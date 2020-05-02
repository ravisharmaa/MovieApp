//
//  TicketCell.swift
//  MovieApp
//
//  Created by Ravi Bastola on 5/1/20.
//  Copyright © 2020 Ravi Bastola. All rights reserved.
//

import UIKit

class TicketCell: UICollectionViewCell {
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        return label
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray
        layer.cornerRadius = 8
        
        addSubview(infoLabel)
        
        NSLayoutConstraint.activate([
            infoLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            infoLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

