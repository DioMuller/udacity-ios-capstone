//
//  Platform.swift
//  GameCollector
//
//  Created by Diogo Muller on 15/01/19.
//  Copyright © 2019 Diogo Muller. All rights reserved.
//

import Foundation

struct PlatformModel : Codable {
    var id : Int
    var name : String
    var category : Int
    var generation : Int?
    var platformLogo : Int?
    
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Coding Keys
    //////////////////////////////////////////////////////////////////////////////////////////////////
    enum CodingKeys : String, CodingKey {
        case id
        case name
        case category
        case generation
        case platformLogo = "platform_logo"
    }
}
