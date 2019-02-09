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
            
            DispatchQueue.main.async {
                self.hideLoading()
            }
            
            guard error == nil else {
                self.showMessage("Error", error!.localizedDescription)
                return
            }
            
            if refresh {
                PersistedData.clearCache(self.currentState == .listing)
            }
            
            let games = result ?? []
            
            for gameData in games {
                let game = PersistedData.createOrUpdateGame(gameData)
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
