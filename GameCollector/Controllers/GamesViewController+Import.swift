//
//  GamesViewController+Import.swift
//  GameCollector
//
//  Created by Diogo Muller on 03/02/19.
//  Copyright © 2019 Diogo Muller. All rights reserved.
//

import CoreData
import Foundation

extension GamesViewController {
    //////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Game Creation/Update Methods
    //////////////////////////////////////////////////////////////////////////////////////////////////
    private func createGame(_ game : GameModel) -> Game {
        let newGame = Game(context: dataController.viewContext)
        
        newGame.id = Int32(game.id)
        newGame.name = game.name
        newGame.summary = game.summary
        newGame.rating = game.rating ?? 0
        
        newGame.cover = game.cover != nil ? createOrFindCover(game.cover!) : nil
        
        newGame.genres = NSSet(array: PersistedData.getGenres(game))
        newGame.platforms = NSSet(array: PersistedData.getPlatforms(game))
        
        return newGame
    }
    
    public func createOrUpdateGame(_ game : GameModel) -> Game {
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
    
    private func findGame(id : Int) -> Game? {
        let fetchRequest : NSFetchRequest<Game> = Game.fetchRequest()
        let sortDesctiptor = NSSortDescriptor(key: "id", ascending: false)
        
        let predicate = NSPredicate(format: "id = %d", Int32(id))
        
        fetchRequest.sortDescriptors = [sortDesctiptor]
        fetchRequest.predicate = predicate
        
        if let result = try? dataController.viewContext.fetch(fetchRequest) {
            return result.first
        }
        
        return nil
    }
    
    internal func clearCache() {
        let fetchRequest : NSFetchRequest<Game> = Game.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        
        let sortDesctiptor = NSSortDescriptor(key: "id", ascending: false)
        
        let predicate = NSPredicate(format: "wishlisted = 0 && favorited == 0")
        
        fetchRequest.sortDescriptors = [sortDesctiptor]
        fetchRequest.predicate = predicate
        
        if let result = try? dataController.viewContext.fetch(fetchRequest) {
            for item in result {
                if currentState == .listing {
                    item.cached = false
                    item.filtered = false
                } else if currentState == .filtering {
                    item.filtered = false
                }
            }
            
            save()
        }
    }
    
    internal func updateItems(refresh : Bool) {
        if loadingData {
            return
        }
        
        if currentState == .wishlist || currentState == .favorites {
            loadingData = false
            return
        }
        
        loadingData = true
        // Do any additional setup after loading the view, typically from a nib.
        var filters : [String] = []
        
        var search : String?
        
        search = textSearch!.text
        
        if let genre = filterGenre {
            filters.append("genres = \(genre)")
        }
        
        if let platform = filterPlatform {
            filters.append("platforms = \(platform)")
        }
        
        IGDBClient.instance.getGames(limit: 50, offset: refresh ? 0 : itemCount, search: search!, filters: filters) { (result, error) in
            self.loadingData = false
            
            guard error == nil else {
                self.showMessage("Error", error!.localizedDescription)
                return
            }
            
            if refresh {
                self.clearCache()
            }
            
            let games = result ?? []
            
            for gameData in games {
                let game = self.createOrUpdateGame(gameData)
                game.cached = (self.currentState == .listing)
                game.filtered = (self.currentState == .filtering)
            }
            
            PersistedData.save()
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }    
}
