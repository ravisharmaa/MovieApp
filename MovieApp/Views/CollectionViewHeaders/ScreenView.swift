//
//  ScreenViwe.swift
//  MovieApp
//
//  Created by Ravi Bastola on 4/28/20.
//  Copyright © 2020 Ravi Bastola. All rights reserved.
//

import UIKit

class ScreenView: UICollectionReusableView {
    
    static let reuseId: String = "ScreenView"
    
    lazy var screenLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
        
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray
        layer.cornerRadius = 8
        
        addSubview(screenLabel)
        
        NSLayoutConstraint.activate([
            screenLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            screenLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
