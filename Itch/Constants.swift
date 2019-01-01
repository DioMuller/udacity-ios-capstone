//
//  Constants.swift
//  Itch
//
//  Created by Diogo Muller on 01/01/19.
//  Copyright © 2019 Diogo Muller. All rights reserved.
//

import Foundation

class Constants {
    // itch.io authorization
    class Authorization {
        // Authorization URL.
        static let authorizationUrl = "https://itch.io/user/oauth"
        
        // Client ID.
        static let clientId = "2887297412473cfe7e755b60927160d3"
        
        // App Scope.
        static let scope = "profile:me"
                
        // Redirect URL.
        static let redirectUrl = URL(string:"itch://authorization")
        
        // Access Token Path Name.
        static let accessToken = "access_token"
    }
    
    class UserData {
        static let token = "token"
    }
}
