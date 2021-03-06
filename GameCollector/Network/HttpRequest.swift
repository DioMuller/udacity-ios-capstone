//
//  HttpRequest.swift
//  GameCollector
//
//  Created by Diogo Muller on 30/12/18.
//  Copyright © 2018 Diogo Muller. All rights reserved.
//

import Foundation

struct HttpRequest {
    var scheme: String
    var host : String
    var path : String
    var withExtension : String
    var method : HttpMethod
    var parameters : [String:AnyObject]? = nil
    var headers : [String:String]? = nil
    var body : String? = nil
    
    var url : URL {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path + withExtension
        
        if let parameters = parameters {
            components.queryItems = [URLQueryItem]()
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                components.queryItems!.append(queryItem)
            }
        }
        
        return components.url!
    }
}
