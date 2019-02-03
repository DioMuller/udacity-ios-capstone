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
        currentState = state
        
        refresh()
    }
    
    func refresh() {
        updateData()
    }
}
