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
    func changeState(_ state : GamesViewState, showGenres : Bool = false, showPlatforms : Bool = false) {
        
        if currentState == state { return }
        
        currentState = state
        
        refresh()
        
        if showGenres {
            self.showGenres()
        } else if showPlatforms {
            self.showPlatforms()
        }
    }
    
    func refresh() {
        stackSearch.isHidden = (currentState == .favorites || currentState == .wishlist)
        updateData()
    }
    
    func showGenres() {
        self.performSegue(withIdentifier: "showGenres", sender: self)
    }
    
    func showPlatforms() {
        self.performSegue(withIdentifier: "showPlatforms", sender: self)
    }
}