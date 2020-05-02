//
//  MovieLabel.swift
//  MovieApp
//
//  Created by Ravi Bastola on 5/1/20.
//  Copyright © 2020 Ravi Bastola. All rights reserved.
//

import UIKit

class MovieLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func draw(_ rect: CGRect) {
        super.drawText(in: rect.insetBy(dx: 5, dy: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

