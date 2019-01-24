//
//  Artwork.swift
//  GameCollector
//
//  Created by Diogo Muller on 16/01/19.
//  Copyright © 2019 Diogo Muller. All rights reserved.
//

import Foundation

struct ImageModel : Codable {
    var id : Int
    var url : String
    var imageId : String
    var height : Int
    var width : Int
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Coding Keys
    //////////////////////////////////////////////////////////////////////////////////////////////////
    enum CodingKeys : String, CodingKey {
        case id
        case url
        case imageId = "image_id"
        case height
        case width
    }
}
