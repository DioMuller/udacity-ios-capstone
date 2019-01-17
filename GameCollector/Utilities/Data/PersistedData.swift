//
//  ApplicationData.swift
//  GameCollector
//
//  Created by Diogo Muller on 17/01/19.
//  Copyright © 2019 Diogo Muller. All rights reserved.
//

import Foundation

class PersistedData {
    
    public static var genres : [Genre] {
        return []
    }
    
    public static var platforms : [Platform] {
        return []
    }
    
    public static var favorites : [Game] {
        return []
    }
    
    public static var wishlist : [Game] {
        return []
    }
    
    public static func importGenres() {
        
    }
    
    public static func importPlatforms() {
        
    }
    
    public static func addFavorite(model : GameModel) {
        
    }
    
    public static func addWishlist(model : GameModel) {
        
    }
    
    public static func removeFavorite(game : Game) {
        
    }
    
    public static func removeWishlist(game : Game) {
        
    }
}
