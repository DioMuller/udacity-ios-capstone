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
        static let baseUrl = "https://api.twitter.com/1.1"
    }
        
    class Authorization {
        // Authorization URL.
        static let requestTokenUrl = "https://www.tumblr.com/oauth/request_token"
        static let authorizeUrl = "https://www.tumblr.com/oauth/authorize"
        static let accessTokenUrl = "https://www.tumblr.com/oauth/access_token"
        
        // Current scheme
        static let scheme = "adludum://"
        
        // Auth Address
        static let authorization = "authorization"
        
        // Redirect URL.
        static let callbackUrl = "\(scheme)\(authorization)"
    }
    
    class Methods {

    }
    
    class Parameters {

    }
    
    class Values {
        
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
