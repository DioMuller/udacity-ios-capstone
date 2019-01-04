//
//  Constants.swift
//  AdLudum
//
//  Created by Diogo Muller on 03/01/19.
//  Copyright © 2019 Diogo Muller. All rights reserved.
//

import Foundation

class Constants {
    // Twitter authorization
    class Authorization {
        // Authorization URL.
        static let requestTokenUrl = "https://api.twitter.com/oauth/request_token"
        static let authorizeUrl = "https://api.twitter.com/oauth/authorize"
        static let accessTokenUrl = "https://api.twitter.com/oauth/access_token"
        
        
        
        // Current scheme
        static let scheme = "gamedev://"
        
        // Auth Address
        static let authorization = "authorization"
        
        // Redirect URL.
        static let callbackUrl = "\(scheme)\(authorization)"
    }

}
