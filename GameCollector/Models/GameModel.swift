//
//  Game.swift
//  GameCollector
//
//  Created by Diogo Muller on 15/01/19.
//  Copyright © 2019 Diogo Muller. All rights reserved.
//

import Foundation

struct GameModel : Codable {
    var id : Int
    var name : String
    var summary : String?
    var rating : Float?
    var ratingCount : Int?
    var totalRating : Float?
    var totalRatingCount : Int?
    var category : Int?
    var genres : [Int]?
    var platforms : [Int]?
    var cover : Int?
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Coding Keys
    //////////////////////////////////////////////////////////////////////////////////////////////////
    enum CodingKeys : String, CodingKey {
        case id
        case name
        case summary
        case rating
        case ratingCount = "rating_count"
        case totalRating = "total_rating"
        case totalRatingCount = "total_rating_count"
        case category
        case genres
        case platforms
    }
}
