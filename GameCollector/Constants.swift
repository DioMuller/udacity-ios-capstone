//
//  Constants.swift
//  GameCollector
//
//  Created by Diogo Muller on 13/01/19.
//  Copyright © 2019 Diogo Muller. All rights reserved.
//

import Foundation

class Constants {
    class Parameters {
        // Is Auto-Saving enabled?
        static let autoSaveEnabled = false
        // Auto-Saving time.
        static let autoSaveTime = 20.0
    }
    
    class Api {
        static let scheme = "https"
        static let host = "api-v3.igdb.com"
        static let path = "/"
    }
    
    class Methods {
        static let artworks = "artworks"
        static let covers = "covers"
        static let games = "games"
        static let genres = "genres"
        static let platforms = "platforms"
    }
    
    class Headers {
        static let userKey = "user-key"
        static let accept = "Accept"
    }
    
    class Values {
        static let acceptType = "application/json"
        static let all = "*"
    }
}
