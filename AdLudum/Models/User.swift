//
//  User.swift
//  AdLudum
//
//  Created by Diogo Muller on 06/01/19.
//  Copyright © 2019 Diogo Muller. All rights reserved.
//

import Foundation

struct User : Codable {
    var id : UInt64
    var name : String
    var screenName : String
    var profileImage : String
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Coding Keys
    //////////////////////////////////////////////////////////////////////////////////////////////////
    enum CodingKeys : String, CodingKey {
        case id
        case name
        case screenName = "screen_name"
        case profileImage = "profile_image_url"
    }
}
