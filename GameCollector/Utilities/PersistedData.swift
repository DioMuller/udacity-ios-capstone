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
    
    private static var genreList : [Int32:Genre] = [:]
    private static var platformList : [Int32:Platform] = [:]
    private static var genresImported = false
    private static var platformsImported = false

    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Properties
    //////////////////////////////////////////////////////////////////////////////////////////////////
    public static var genres : [Int32:Genre] {
        return genreList
    }
    
    public static var platforms : [Int32:Platform] {
        return platformList
    }
    
    public static var favorites : [Game] {
        return []
    }
    
    public static var wishlist : [Game] {
        return []
    }
    
    public static var importDone : Bool {
        return genresImported && platformsImported
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
        let list = GetList(fetchRequest)
        
        for item in list {
            genreList[item.id] = item
        }
        
        // Update List
        importGenres(limit: Constants.Parameters.apiMaxLimit, offset: 0)
    }
    
    private static func fetchPlatforms() {
        let fetchRequest : NSFetchRequest<Platform> = Platform.fetchRequest()
        let list = GetList(fetchRequest)
        
        for item in list {
            platformList[item.id] = item
        }
        
        // Update List
        importPlatforms(limit: Constants.Parameters.apiMaxLimit, offset: 0)
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
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Service Methods
    //////////////////////////////////////////////////////////////////////////////////////////////////
    private static func importGenres(limit : Int, offset : Int) {
        // TODO: Filter by last update date.
        IGDBClient.instance.getGenres(limit: limit, offset: offset) { (result, error) in
            let imported = importData(result: result, error: error, toExecute: { (item) in
                var games : NSSet? = nil
                if let existing = genreList.removeValue(forKey: Int32(item.id)) {
                    games = existing.games
                    controller.backgroundContext.delete(existing)
                }
                
                let newItem = Genre(context: controller.backgroundContext)
                newItem.id = Int32(item.id)
                newItem.name = item.name
                newItem.games = games
                
                genreList[newItem.id] = newItem
            })
            
            guard imported else {
                print("Failed to import Genres.")
                return
            }
            
            let newOffset = offset + limit
            
            if (newOffset < Constants.Parameters.apiMaxOffset && result!.count < limit) {
                importGenres(limit: limit, offset: newOffset)
            } else {
                genresImported = true
            }
        }
    }
    
    private static func importPlatforms(limit : Int, offset : Int) {
        // TODO: Filter by last update date.
        IGDBClient.instance.getPlatforms(limit: limit, offset: offset) { (result, error) in
            let imported = importData(result: result, error: error, toExecute: { (item) in
                var games : NSSet? = nil
                if let existing = platformList.removeValue(forKey: Int32(item.id)) {
                    games = existing.games
                    controller.backgroundContext.delete(existing)
                }
                
                let newItem = Platform(context: controller.backgroundContext)
                newItem.id = Int32(item.id)
                newItem.name = item.name
                newItem.games = games
                
                platformList[newItem.id] = newItem
            })
            
            guard imported else {
                print("Failed to import Platforms.")
                return
            }
            
            let newOffset = offset + limit
            
            if (newOffset < Constants.Parameters.apiMaxOffset && result!.count < limit) {
                importGenres(limit: limit, offset: newOffset)
            } else {
                platformsImported = true
            }
        }
    }
    
    private static func importData<T>(result : [T]?, error : Error?, toExecute : (_ item : T) -> Void ) -> Bool {
        guard error == nil else {
            print(error!.localizedDescription)
            return false
        }
        
        guard result != nil, result!.count > 0 else {
            print("Result was empty")
            return true // Result CAN be empty.
        }
        
        for item in result! {
            toExecute(item)
        }
        
        do {
            try controller.backgroundContext.save()
        } catch {
            print("Error saving context: \(error.localizedDescription)")
            return false
        }
        
        return true
    }
}
