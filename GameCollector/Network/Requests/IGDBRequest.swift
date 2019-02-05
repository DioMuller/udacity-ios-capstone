//
//  IGDBRequest.swift
//  GameCollector
//
//  Created by Diogo Muller on 15/01/19.
//  Copyright © 2019 Diogo Muller. All rights reserved.
//

import Foundation

struct IGDBRequest {
    var fields : String? = nil
    var limit : Int? = nil
    var offset : Int? = nil
    var sort : String? = nil
    var filter : String? = nil
    var search : String? = nil
    
    public func getContent() -> String {
        var result = ""
        
        if let fields = fields {
            result += "fields: \(fields);"
        }
        
        if let limit = limit {
            result += "limit: \(limit);"
        }
        
        if let offset = offset {
            result += "offset: \(offset);"
        }
        
        if let sort = sort, search == nil { // Search cannot be ordered.
            result += "sort: \(sort);"
        }
        
        if let filter = filter {
            result += "where: \(filter);"
        }
        
        if let search = search {
            result += "search: \"\(search)\";"
        }
        
        return result
    }
}
