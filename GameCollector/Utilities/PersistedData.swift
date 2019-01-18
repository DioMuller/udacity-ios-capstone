//
//  ApplicationData.swift
//  GameCollector
//
//  Created by Diogo Muller on 17/01/19.
//  Copyright © 2019 Diogo Muller. All rights reserved.
//

import Foundation
import CoreData

class PersistedData {
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Private Attributes
    //////////////////////////////////////////////////////////////////////////////////////////////////
    private static let controller : DataController = DataController.getInstanceOf(key: "GameCollector")
    
    private static var genreList : [Genre] = []
    private static var platformList : [Platform] = []

    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Properties
    //////////////////////////////////////////////////////////////////////////////////////////////////
    public static var genres : [Genre] {
        return genreList
    }
    
    public static var platforms : [Platform] {
        return platformList
    }
    
    public static var favorites : [Game] {
        return []
    }
    
    public static var wishlist : [Game] {
        return []
    }
    

    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Initializers
    //////////////////////////////////////////////////////////////////////////////////////////////////
    public static func initialize() {
        fetchGenres()
        fetchPlatforms()
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Methods
    //////////////////////////////////////////////////////////////////////////////////////////////////
    public static func addFavorite(model : GameModel) {
        
    }
    
    public static func addWishlist(model : GameModel) {
        
    }
    
    public static func removeFavorite(game : Game) {
        
    }
    
    public static func removeWishlist(game : Game) {
        
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Private Methods
    //////////////////////////////////////////////////////////////////////////////////////////////////
    private static func fetchGenres() {
        let fetchRequest : NSFetchRequest<Genre> = Genre.fetchRequest()
        genreList = GetList(fetchRequest)
    }
    
    private static func fetchPlatforms() {
        let fetchRequest : NSFetchRequest<Platform> = Platform.fetchRequest()
        platformList = GetList(fetchRequest)
    }
    
    public static func importGenres() {
        
    }
    
    public static func importPlatforms() {
        
    }
    
    private static func GetList<T>(_ fetchRequest : NSFetchRequest<T>) -> [T] {
        let sortDesctiptor = NSSortDescriptor(key: "id", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDesctiptor]
        
        if let result = try? controller.backgroundContext.fetch(fetchRequest) {
            return result
        } else {
            return []
        }
    }
}
