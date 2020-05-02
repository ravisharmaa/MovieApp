//
//  NetworkManager.swift
//  MovieApp
//
//  Created by Ravi Bastola on 4/27/20.
//  Copyright © 2020 Ravi Bastola. All rights reserved.
//

import UIKit

enum NetworkError: String, Error {
    case InvalidURL = "The url is invalid"
    case InvalidResponse = "The response is invalid"
    case InvalidData = "The data is invalid"
    case JSONError = "The json is invalid"
}


struct NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    private var urlComponents: URLComponents =  {
        var component = URLComponents()
        component.scheme = "https"
        component.host = "api.themoviedb.org"
        return component
        
    }()
    
}

extension NetworkManager: ApiConfiguration {
     
    internal var apiKey: String {
        return "8d181bcb5e80a929053da01f6921e4a9"
    }
    
    internal var path: String {
        return "/3/search/"
    }
    
     func sendRequest<T: Codable>(to endpoint: String, model: T.Type, queryItems: [String: Any]?, completion: @escaping(Result<T, NetworkError>)->Void) {
        
        var innerUrl = urlComponents
        
        innerUrl.path = path + endpoint
        
        if let queryItems = queryItems {
            
            var urlQueryItem = [URLQueryItem]()
            
            for (key, data) in queryItems where queryItems.count > 0 {
                urlQueryItem.append(URLQueryItem(name:key, value: data as? String))
            }
            
            urlQueryItem.append(URLQueryItem(name: "api_key", value: apiKey))
           
            innerUrl.queryItems = urlQueryItem
        }
        
        
        guard let url = innerUrl.url else {
            completion(.failure(.InvalidURL))
            
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let _ = error {
                completion(.failure(.InvalidData))
                
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.InvalidResponse))
                
                return
            }
            
            guard let data = data else {
                completion(.failure(.InvalidData))
                
                return
            }
            
            do {
                let response = try JSONDecoder().decode(T.self, from: data)
                completion(.success(response))
                
            } catch  {
                //printing error allows to identify json faliure
                //print(error)
                completion(.failure(.InvalidData))
            }
            
        }.resume()
    }
}
