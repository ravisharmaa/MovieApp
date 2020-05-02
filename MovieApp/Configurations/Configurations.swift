//
//  Configurations.swift
//  MovieApp
//
//  Created by Ravi Bastola on 4/29/20.
//  Copyright © 2020 Ravi Bastola. All rights reserved.
//

import UIKit

//MARK:- Section Definition For Cells

enum MovieSections: Int, CaseIterable {
    
    case audi14
    case audi30
    
    static let columnCount: Int = 12
    
    var cellCount: Int {
        switch self {
        case .audi14:
            return 168
        default:
            return 360
        }
    }
    
    var headerSize: CGFloat {
        switch self {
        case .audi14:
            return 20.1
        case .audi30:
            return 0.1
        }
    }
    
    var footerSize: CGFloat {
        switch self {
        case .audi14:
            return 0.1
        case .audi30:
            return 20.1
        }
    }
    
    var randomSeats: [Int] {
        switch self {
        case .audi14:
            return (0..<20).map{ _ in Int(arc4random_uniform(167) + 1) }
        case .audi30:
            return (169..<200).map{ _ in Int(arc4random_uniform(529) + 1) }
        }
    }
}

protocol ApiConfiguration {
    
    var apiKey: String { get }
    
    var path: String { get }
}
