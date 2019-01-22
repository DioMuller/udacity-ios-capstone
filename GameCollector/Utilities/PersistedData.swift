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
    public static func getFavorites() -> [Game] {
        let fetchRequest : NSFetchRequest<Game> = Game.fetchRequest()
        let sortDesctiptor = NSSortDescriptor(key: "id", ascending: false)
        
        let predicate = NSPredicate(format: "favorited == 1")
        
        fetchRequest.sortDescriptors = [sortDesctiptor]
        fetchRequest.predicate = predicate
        
        if let result = try? controller.backgroundContext.fetch(fetchRequest) {
            return result
        }
        
        return []
    }
    
    public static func getWishlist() -> [Game] {
        let fetchRequest : NSFetchRequest<Game> = Game.fetchRequest()
        let sortDesctiptor = NSSortDescriptor(key: "id", ascending: false)
        
        let predicate = NSPredicate(format: "wishlisted == 1")
        
        fetchRequest.sortDescriptors = [sortDesctiptor]
        fetchRequest.predicate = predicate
        
        if let result = try? controller.backgroundContext.fetch(fetchRequest) {
            return result
        }
        
        return []
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
    // MARK: CoreData Methods
    //////////////////////////////////////////////////////////////////////////////////////////////////
    static func save() {
        do {
            try controller.backgroundContext.save()
        } catch {
            print("Error saving context.")
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Service Methods
    //////////////////////////////////////////////////////////////////////////////////////////////////
    private static func importGenres(limit : Int, offset : Int) {
        IGDBClient.instance.getGenres(limit: limit, offset: offset) { (result, error) in
            let imported = importData(result: result, error: error, toExecute: { (item) in
                if let existing = genreList[Int32(item.id)] {
                    existing.name = item.name
                } else {
                    let newItem = Genre(context: controller.backgroundContext)
                    newItem.id = Int32(item.id)
                    newItem.name = item.name
                    newItem.games = []
                    
                    genreList[newItem.id] = newItem
                }
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
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: CoreData/Model methods
    //////////////////////////////////////////////////////////////////////////////////////////////////
    private static func findGame(id : Int) -> Game? {
        let fetchRequest : NSFetchRequest<Game> = Game.fetchRequest()
        let sortDesctiptor = NSSortDescriptor(key: "id", ascending: false)
        
        let predicate = NSPredicate(format: "id == %d", Int32(id))
        
        fetchRequest.sortDescriptors = [sortDesctiptor]
        fetchRequest.predicate = predicate
        
        if let result = try? controller.backgroundContext.fetch(fetchRequest) {
            return result.first
        }
        
        return nil
    }
    
    private static func createGame(_ game : GameModel) -> Game {
        let newGame = Game(context: controller.backgroundContext)
        
        newGame.id = Int32(game.id)
        newGame.name = game.name
        newGame.summary = game.summary
        newGame.rating = game.rating ?? 0
        
        newGame.genres = NSSet(array: getGenres(game))
        newGame.platforms = NSSet(array: getPlatforms(game))

        return newGame
    }
    
    public static func createOrUpdateGame(_ game : GameModel) -> Game {
        if let existing = findGame(id: game.id) {
            existing.name = game.name
            existing.summary = game.summary
            existing.rating = game.rating ?? 0
            
            existing.genres = NSSet(array: getGenres(game))
            existing.platforms = NSSet(array: getPlatforms(game))
            
            return existing
        } else {
            return createGame(game)
        }
    }
    
    private static func getGenres(_ game : GameModel) -> [Genre] {
        var genreItemList : [Genre] = []
        
        if let genreIds = game.genres {
            for genreId in genreIds {
                if let genre = genres[Int32(genreId)] {
                    genreItemList.append(genre)
                }
            }
        }
        
        return genreItemList
    }
    
    private static func getPlatforms(_ game : GameModel) -> [Platform] {
        var platformItemList : [Platform] = []
        
        if let platformIds = game.platforms {
            for platformId in platformIds {
                if let platform = platforms[Int32(platformId)] {
                    platformItemList.append(platform)
                }
            }
        }
        
        return platformItemList
    }
}
