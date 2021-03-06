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
    public static func initialize(finished: @escaping ((_ success : Bool) -> Void) ) {
        // Fetch from CoreData
        fetchGenres()
        fetchPlatforms()
        
        // Update Flags
        genresImported = genres.count > 0
        platformsImported = platforms.count > 0
        
        if importDone {
            // Update List
            importGenres(limit: Constants.Parameters.apiMaxLimit, offset: 0)
            importPlatforms(limit: Constants.Parameters.apiMaxLimit, offset: 0)
            
            finished(true)
        } else {
            importGenres(limit: Constants.Parameters.apiMaxLimit, offset: 0, finished: { (genreSuccess) in
                    if genreSuccess {
                        importPlatforms(limit: Constants.Parameters.apiMaxLimit, offset: 0, finished: finished)
                    } else {
                        finished(false)
                }
            })
        }
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
        
    }
    
    private static func fetchPlatforms() {
        let fetchRequest : NSFetchRequest<Platform> = Platform.fetchRequest()
        let list = GetList(fetchRequest)
        
        for item in list {
            platformList[item.id] = item
        }
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
    static func save(useBackgroundContext : Bool) {
        let context = useBackgroundContext ? controller.backgroundContext : controller.viewContext
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error.localizedDescription).")
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Service Methods
    //////////////////////////////////////////////////////////////////////////////////////////////////
    private static func importGenres(limit : Int, offset : Int, finished: ((_ success : Bool) -> Void)? = nil) {
        IGDBClient.instance.getGenres(limit: limit, offset: offset) { (result, error) in
            let imported = importData(result: result, error: error, toExecute: { (item) in
                // We won't update, since we only use the name, and that hopefully won't change.
                if !genreList.keys.contains(Int32(item.id)) {
                    let newItem = Genre(context: controller.backgroundContext)
                    newItem.id = Int32(item.id)
                    newItem.name = item.name
                    newItem.games = []
                    
                    genreList[newItem.id] = newItem
                }
            })
            
            guard imported else {
                print("Failed to import Genres.")
                finished?(false)
                return
            }
            
            let newOffset = offset + limit
            
            if (newOffset <= Constants.Parameters.apiMaxOffset && result!.count == limit) {
                importGenres(limit: limit, offset: newOffset, finished: finished)
            } else {
                genresImported = true
                finished?(true)
            }
        }
    }
    
    private static func importPlatforms(limit : Int, offset : Int, finished: ((_ success : Bool) -> Void)? = nil) {
        IGDBClient.instance.getPlatforms(limit: limit, offset: offset) { (result, error) in
            let imported = importData(result: result, error: error, toExecute: { (item) in
                // We won`t update the platform data, since that should not change ever.
                if !platformList.keys.contains(Int32(item.id)) {
                    let newItem = Platform(context: controller.backgroundContext)
                    newItem.id = Int32(item.id)
                    newItem.name = item.name
                    newItem.games = []
                    
                    platformList[newItem.id] = newItem
                }
            })
            
            guard imported else {
                print("Failed to import Platforms.")
                finished?(false)
                return
            }
            
            let newOffset = offset + limit
            
            if (newOffset <= Constants.Parameters.apiMaxOffset && result!.count == limit) {
                importPlatforms(limit: limit, offset: newOffset, finished: finished)
            } else {
                platformsImported = true
                finished?(true)
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
        
        // Only used for Genres and Platforms, no need to Sync for now.
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
    static func getGenres(_ game : GameModel) -> [Genre] {
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
    
    static func getPlatforms(_ game : GameModel) -> [Platform] {
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
    
    static func downloadImage(_ cover : Image ,  _ onDownloaded : @escaping (_ image : Image?, _ error : Error?) -> Void ) {
        
        IGDBClient.instance.getCover(id: Int(cover.id)) { (images, error) in
            
            guard error == nil else {
                onDownloaded(nil, error)
                return
            }
            
            guard let image = images?.first else {
                onDownloaded(nil, CustomError("Image not found on the server"))
                return
            }
            
            cover.imageId = image.imageId
            
            if let imageData = try? Data(contentsOf: URL(string: cover.imageUrl!)! ) {
                cover.data = imageData
                save(useBackgroundContext: true)
                onDownloaded(cover, nil)
            } else {
                onDownloaded(nil, CustomError("Error downloading image data."))
            }

        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Game Creation/Update Methods
    //////////////////////////////////////////////////////////////////////////////////////////////////
    private static func createGame(_ game : GameModel) -> Game {
        let newGame = Game(context: controller.backgroundContext)
        
        newGame.id = Int32(game.id)
        newGame.name = game.name
        newGame.summary = game.summary
        newGame.rating = game.rating ?? 0
        
        if let coverId = game.cover {
            newGame.cover = Image(context: controller.backgroundContext)
            newGame.cover!.id = Int32(coverId)
        }
        
        newGame.genres = NSSet(array: PersistedData.getGenres(game))
        newGame.platforms = NSSet(array: PersistedData.getPlatforms(game))
        
        return newGame
    }
    
    static func createOrUpdateGame(_ game : GameModel) -> Game {
        if let existing = findGame(id: game.id) {
            existing.name = game.name
            existing.summary = game.summary
            existing.rating = game.rating ?? 0
            
            existing.genres = NSSet(array: PersistedData.getGenres(game))
            existing.platforms = NSSet(array: PersistedData.getPlatforms(game))
            
            return existing
        } else {
            return createGame(game)
        }
    }
    
    private static func findGame(id : Int) -> Game? {
        let fetchRequest : NSFetchRequest<Game> = Game.fetchRequest()
        let sortDesctiptor = NSSortDescriptor(key: "id", ascending: false)
        
        let predicate = NSPredicate(format: "id = %d", Int32(id))
        
        fetchRequest.sortDescriptors = [sortDesctiptor]
        fetchRequest.predicate = predicate
        
        if let result = try? controller.backgroundContext.fetch(fetchRequest) {
            return result.first
        }
        
        return nil
    }
}
