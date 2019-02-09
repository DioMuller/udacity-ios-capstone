//
//  GamesViewController+ViewStates.swift
//  GameCollector
//
//  Created by Diogo Muller on 03/02/19.
//  Copyright © 2019 Diogo Muller. All rights reserved.
//

import Foundation

enum GamesViewState : Int {
    case listing
    case filtering
    case favorites
    case wishlist
}

extension GamesViewController {
    func changeState(_ state : GamesViewState, showGenres : Bool = false, showPlatforms : Bool = false, filterGenre : Int? = nil, filterPlatform : Int? = nil) {
        
        if currentState == state && currentState != .filtering { return }
                
        currentState = state
        shouldShowGenres = showGenres
        shouldShowPlatforms = showPlatforms
        
        self.filterGenre = filterGenre
        self.filterPlatform = filterPlatform
        
        refresh()
    }
    
    func refresh() {
        switch currentState {
            case .listing:
                title = "Games"
                stackSearch.isHidden = false
                break
            case .filtering:
                title = "Searching Games"
                stackSearch.isHidden = false
                break
            case .favorites:
                title = "My Collection"
                stackSearch.isHidden = true
                updateData()
                break
            case .wishlist:
                title = "Wishlist"
                stackSearch.isHidden = true
                updateData()
                break
        }
        
    }
    
    func showGenres() {
        self.performSegue(withIdentifier: "showGenres", sender: self)
    }
    
    func showPlatforms() {
        self.performSegue(withIdentifier: "showPlatforms", sender: self)
    }
    
    func clearSearch() {
        DispatchQueue.main.async {
            self.textSearch.text = ""
        }
    }
}
