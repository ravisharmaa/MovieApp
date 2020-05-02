//
//  Movie.swift
//  MovieApp
//
//  Created by Ravi Bastola on 4/30/20.
//  Copyright © 2020 Ravi Bastola. All rights reserved.
//

import Foundation

struct Movie: Codable {
    
    var results: [MovieResult]
    
}

struct MovieResult: Codable {
    
    var popularity: Float
    
    var adult:  Bool
    
    var releaseDate: String
    
    var title: String
    
    var posterPath: String?
    
    enum CodingKeys: String, CodingKey {
        
        case popularity, adult, title
    
        case releaseDate = "release_date"
        
        case posterPath = "poster_path"
    }
    
}
