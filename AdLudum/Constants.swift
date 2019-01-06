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
    
    class Api {
        static let apiScheme = "https"
        static let apiHost = "api.twitter.com"
        static let apiPath = "/1.1/"
    }
        
    class Authorization {
        // Authorization URL.
        static let requestTokenUrl = "https://api.twitter.com/oauth/request_token"
        static let authorizeUrl = "https://api.twitter.com/oauth/authorize"
        static let accessTokenUrl = "https://api.twitter.com/oauth/access_token"
        
        // Current scheme
        static let scheme = "adludum://"
        
        // Auth Address
        static let authorization = "authorization"
        
        // Redirect URL.
        static let callbackUrl = "\(scheme)\(authorization)"
    }
    
    class Methods {
        static let search = "search/tweets.json"
    }
    
    class Parameters {
        static let query = "q"
        static let searchType = "s"
        static let resultType = "result_type"
        static let count = "count"
    }
    
    class Values {
        static let count = 100

        // Result Type
        static let recent = "recent"
        static let popular = "popular"
        
        // Follows Filter
        static let follows = "follows"
        
        // Search Query
        static let query = "filter:media AND #screenshotsaturday OR #gamedev"
        
        static let urlAllowedSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~:/?")
    }

    class UserData {
        // User Token.
        static let token = "oauth_token"
        // User Token Secret.
        static let tokenSecret = "oauth_token_secret"
        // User Id.
        static let userId = "user_id"
        // User Screen Name.
        static let userName = "screen_name"
    }
}
