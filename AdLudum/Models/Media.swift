//
//  Media.swift
//  AdLudum
//
//  Created by Diogo Muller on 09/01/19.
//  Copyright © 2019 Diogo Muller. All rights reserved.
//

import Foundation

struct Media : Codable {
    var id : Int64
    var mediaUrl : String
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Coding Keys
    //////////////////////////////////////////////////////////////////////////////////////////////////
    enum CodingKeys : String, CodingKey {
        case id
        case mediaUrl = "media_url_https"
    }
}
