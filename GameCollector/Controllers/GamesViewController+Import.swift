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
    internal func updateItems(refresh : Bool) {
        if loadingData {
            return
        }
        
        if currentState == .wishlist || currentState == .favorites {
            loadingData = false
            return
        }
        
        loadingData = true
        showLoading("Searching...")
        
        DispatchQueue.main.async { // Only done so we can access textSearch
            // Do any additional setup after loading the view, typically from a nib.
            var filters : [String] = []
            
            var search : String?
            
            search = self.textSearch!.text
            
            if let genre = self.filterGenre {
                filters.append("genres = \(genre)")
            }
            
            if let platform = self.filterPlatform {
                filters.append("platforms = \(platform)")
            }
            
            IGDBClient.instance.getGames(limit: 50, offset: refresh ? 0 : self.itemCount, search: search!, filters: filters) { (result, error) in
                self.loadingData = false
                
                DispatchQueue.main.async {
                    self.hideLoading()
                }
                
                guard error == nil else {
                    self.showMessage("Error", error!.localizedDescription)
                    return
                }
                
                if refresh {
                    self.clearCache()
                }
                
                let games = result ?? []
                
                for gameData in games {
                    let game = PersistedData.createOrUpdateGame(gameData)
                    game.cached = (self.currentState == .listing)
                    game.filtered = (self.currentState == .filtering)
                }
                
                self.save(useBackgroundContext: true)
                
                self.updateData()
            }
        }
    }
    
    func clearCache() {
        let fetchRequest : NSFetchRequest<Game> = Game.fetchRequest()
        fetchRequest.returnsObjectsAsFaults = false
        
        let sortDesctiptor = NSSortDescriptor(key: "id", ascending: false)
        
        let predicate = NSPredicate(format: "filtered = 1 || cached = 1")
        
        fetchRequest.sortDescriptors = [sortDesctiptor]
        fetchRequest.predicate = predicate
        
        if let result = try? dataController.backgroundContext.fetch(fetchRequest) {
            for item in result {
                item.cached = (item.cached && currentState != .listing)
                item.filtered = false
            }
            
            save(useBackgroundContext: true)
        }
    }

}
